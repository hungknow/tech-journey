# Rust Arrow-Based CSV Data Processing

## Overview

This document describes the data flow for processing CSV data into domain objects using Apache Arrow as the intermediate format. The architecture is designed to be generic and extensible, with clear separation between Rust (data processing) and Python (data interface).

## Architecture

```
┌─────────────┐     ┌──────────────┐     ┌─────────────┐     ┌─────────────┐
│   CSV File  │ --> │   Pandas     │ --> │   Arrow     │ --> │    Rust     │ --> │  Domain    │
│             │     │  DataFrame   │     │  IPC Bytes  │     │  Decoder    │     │  Objects   │
└─────────────┘     └──────────────┘     └─────────────┘     └─────────────┘     └─────────────┘
```

## Rust Architecture

### Core Traits

The Rust implementation uses a trait-based design that allows any data type to be encoded/decoded from Arrow format.

#### 1. `ArrowSchemaProvider`

Defines the Arrow schema structure for a data type:

```rust
pub trait ArrowSchemaProvider {
    /// Returns the Arrow schema for this type with optional metadata
    fn get_schema(metadata: Option<HashMap<String, String>>) -> Schema;
    
    /// Returns a map of field names to their Arrow data types
    fn get_schema_map() -> HashMap<String, String>;
}
```

**Purpose**: Provides schema definition that describes the structure of data in Arrow format.

#### 2. `EncodeToRecordBatch`

Encodes domain objects into Arrow RecordBatch format:

```rust
pub trait EncodeToRecordBatch: Sized + ArrowSchemaProvider {
    /// Encodes a batch of values into an Arrow RecordBatch
    fn encode_batch(
        metadata: &HashMap<String, String>,
        data: &[Self],
    ) -> Result<RecordBatch, ArrowError>;
    
    /// Returns metadata for this data element
    fn metadata(&self) -> HashMap<String, String>;
}
```

**Purpose**: Converts a slice of domain objects into a columnar Arrow RecordBatch.

#### 3. `DecodeFromRecordBatch`

Decodes Arrow RecordBatch into domain objects:

```rust
pub trait DecodeFromRecordBatch: Sized + Into<Data> + ArrowSchemaProvider {
    /// Decodes a RecordBatch into a vector of domain objects
    fn decode_batch(
        metadata: &HashMap<String, String>,
        record_batch: RecordBatch,
    ) -> Result<Vec<Self>, EncodingError>;
}
```

**Purpose**: Converts an Arrow RecordBatch back into domain objects.

### Generic Implementation Pattern

For any data type `T`, the implementation follows this pattern:

```rust
impl ArrowSchemaProvider for T {
    fn get_schema(metadata: Option<HashMap<String, String>>) -> Schema {
        let fields = vec![
            Field::new("field1", DataType::FixedSizeBinary(BYTES), false),
            Field::new("field2", DataType::UInt64, false),
            // ... more fields
        ];
        
        match metadata {
            Some(metadata) => Schema::new_with_metadata(fields, metadata),
            None => Schema::new(fields),
        }
    }
}

impl EncodeToRecordBatch for T {
    fn encode_batch(
        metadata: &HashMap<String, String>,
        data: &[Self],
    ) -> Result<RecordBatch, ArrowError> {
        // 1. Create builders for each field
        let mut field1_builder = FixedSizeBinaryBuilder::with_capacity(data.len(), BYTES);
        let mut field2_builder = UInt64Array::builder(data.len());
        
        // 2. Populate builders from data
        for item in data {
            field1_builder.append_value(item.field1.raw.to_le_bytes())?;
            field2_builder.append_value(item.field2.as_u64());
        }
        
        // 3. Build arrays
        let field1_array = field1_builder.finish();
        let field2_array = field2_builder.finish();
        
        // 4. Create RecordBatch
        RecordBatch::try_new(
            Self::get_schema(Some(metadata.clone())).into(),
            vec![
                Arc::new(field1_array),
                Arc::new(field2_array),
            ],
        )
    }
}

impl DecodeFromRecordBatch for T {
    fn decode_batch(
        metadata: &HashMap<String, String>,
        record_batch: RecordBatch,
    ) -> Result<Vec<Self>, EncodingError> {
        let cols = record_batch.columns();
        
        // 1. Extract columns by type
        let field1_values = extract_column::<FixedSizeBinaryArray>(
            cols, "field1", 0, DataType::FixedSizeBinary(BYTES)
        )?;
        let field2_values = extract_column::<UInt64Array>(
            cols, "field2", 1, DataType::UInt64
        )?;
        
        // 2. Parse metadata
        let (param1, param2) = parse_metadata(metadata)?;
        
        // 3. Decode each row
        (0..record_batch.num_rows())
            .map(|i| {
                let field1 = Type1::from_raw(
                    get_raw_value(field1_values.value(i)),
                    param1
                );
                let field2 = field2_values.value(i).into();
                
                Ok(Self {
                    field1,
                    field2,
                })
            })
            .collect()
    }
}
```

### PyO3 Wrangler Interface

The PyO3 interface provides a generic wrapper for processing Arrow IPC data:

```rust
#[pyclass]
pub struct DataWrangler {
    // Type-specific configuration
    metadata: HashMap<String, String>,
    // ... other fields
}

#[pymethods]
impl DataWrangler {
    #[new]
    fn py_new(/* configuration params */) -> PyResult<Self> {
        // Initialize metadata from configuration
        let metadata = DataType::get_metadata(/* params */);
        Ok(Self { metadata, /* ... */ })
    }
    
    fn process_record_batch_bytes(&self, data: &[u8]) -> PyResult<Vec<DataType>> {
        // 1. Create StreamReader from Arrow IPC bytes
        let cursor = Cursor::new(data);
        let reader = StreamReader::try_new(cursor, None)?;
        
        // 2. Decode each RecordBatch
        let mut results = Vec::new();
        for maybe_batch in reader {
            let record_batch = maybe_batch?;
            let batch_results = DataType::decode_batch(
                &self.metadata,
                record_batch
            )?;
            results.extend(batch_results);
        }
        
        Ok(results)
    }
}
```

**Key Points**:
- Accepts raw bytes (Arrow IPC format)
- Uses `StreamReader` to handle multiple RecordBatches
- Returns `Vec<DataType>` which PyO3 automatically converts to Python list
- Metadata is stored in the wrangler to avoid passing it repeatedly

## Memory Layout

### Arrow RecordBatch Structure

Arrow uses a columnar memory layout for efficient processing:

```
RecordBatch
├── Schema (with metadata)
│   ├── Field: "open" -> FixedSizeBinary(8)
│   ├── Field: "high" -> FixedSizeBinary(8)
│   ├── Field: "low" -> FixedSizeBinary(8)
│   ├── Field: "close" -> FixedSizeBinary(8)
│   ├── Field: "volume" -> FixedSizeBinary(8)
│   ├── Field: "ts_event" -> UInt64
│   ├── Field: "ts_init" -> UInt64
│   └── Metadata: HashMap<String, String>
│
└── Columns (Arc<dyn Array>)
    ├── Column 0: FixedSizeBinaryArray (open)
    │   ├── Length: num_rows
    │   ├── Byte width: 8 bytes per element
    │   └── Data: [u8; num_rows * 8] (contiguous)
    ├── Column 1-4: FixedSizeBinaryArray (high, low, close, volume)
    └── Column 5-6: UInt64Array (ts_event, ts_init)
        └── Data: [u64; num_rows] (contiguous)
```

**Memory Layout for a Bar RecordBatch**:
```
RecordBatch (7 columns, N rows)
├── open:   FixedSizeBinary(8) [N * 8 bytes]
├── high:   FixedSizeBinary(8) [N * 8 bytes]
├── low:    FixedSizeBinary(8) [N * 8 bytes]
├── close:  FixedSizeBinary(8) [N * 8 bytes]
├── volume: FixedSizeBinary(8) [N * 8 bytes]
├── ts_event: UInt64 [N * 8 bytes]
└── ts_init:  UInt64 [N * 8 bytes]

Total data payload: N * (5 * 8 + 2 * 8) = N * 56 bytes
```

### Fixed-Point Binary Encoding

For financial data, values are encoded as fixed-point integers in little-endian format:

```
Price/Quantity Value: 100.50
    ↓
Scaled: 100.50 * FIXED_SCALAR = 100_500_000_000
    ↓
Binary: [0x00, 0xE8, 0x76, 0x48, 0x17, 0x00, 0x00, 0x00]  (8 bytes, little-endian)
    ↓
Arrow: FixedSizeBinary(8) array element
```

### Arrow IPC Format

Arrow IPC (Inter-Process Communication) format serializes RecordBatches:

```
IPC Stream Format:
┌─────────────────┐
│ Schema Message  │  (defines structure)
├─────────────────┤
│ RecordBatch 1   │  (data chunk 1)
├─────────────────┤
│ RecordBatch 2   │  (data chunk 2)
├─────────────────┤
│      ...        │
└─────────────────┘
```

**Memory Transfer**:
- Python creates Arrow IPC bytes: `bytes` object
- PyO3 receives: `&[u8]` (zero-copy view)
- Rust deserializes: `StreamReader` reads from bytes
- Decoded: `RecordBatch` (owned by Rust)
- Returned: `Vec<DataType>` converted to Python list by PyO3

## Python Interface

### Arrow IPC Serialization

Python prepares data in Arrow format:

```python
import pyarrow as pa

# 1. Convert DataFrame columns to Arrow-compatible format
# Prices/quantities: float -> int -> bytes (fixed-point)
open_price = (
    df["open"]
    .apply(lambda x: int(x * FIXED_SCALAR))
    .apply(lambda x: x.to_bytes(FIXED_PRECISION_BYTES, byteorder="little", signed=True))
)

# Timestamps: datetime -> int64 -> uint64
ts_event = (
    pd.to_datetime(df["ts_event"], utc=True)
    .dt.tz_localize(None)
    .astype("int64")
).to_numpy(dtype="uint64")

# 2. Define Arrow schema
fields = [
    pa.field("open", pa.binary(FIXED_PRECISION_BYTES), nullable=False),
    pa.field("ts_event", pa.uint64(), nullable=False),
    # ... more fields
]

# 3. Create Arrow arrays
arrays = [
    pa.array(open_price, type=pa.binary(FIXED_PRECISION_BYTES)),
    pa.array(ts_event, type=pa.uint64()),
    # ... more arrays
]

# 4. Create Arrow Table
table = pa.Table.from_arrays(arrays, schema=pa.schema(fields))

# 5. Serialize to Arrow IPC bytes
sink = pa.BufferOutputStream()
writer = pa.ipc.new_stream(sink, table.schema)
writer.write_table(table)
writer.close()

ipc_bytes = sink.getvalue().to_pybytes()  # Python bytes object
```

### PyO3 Wrangler Usage

```python
from nautilus_trader.core import nautilus_pyo3

# 1. Create wrangler with configuration
wrangler = nautilus_pyo3.BarDataWrangler(
    bar_type="GBP/USD.SIM-1-MINUTE-BID-EXTERNAL",
    price_precision=5,
    size_precision=0,
)

# 2. Process Arrow IPC bytes
bars = wrangler.process_record_batch_bytes(ipc_bytes)
# Returns: list[nautilus_pyo3.Bar]
```

### High-Level Python Wrapper

The `wranglers_v2.py` module provides a convenient wrapper:

```python
from nautilus_trader.persistence.wranglers_v2 import BarDataWranglerV2

# 1. Create wrangler
wrangler = BarDataWranglerV2(
    bar_type="GBP/USD.SIM-1-MINUTE-BID-EXTERNAL",
    price_precision=5,
    size_precision=0,
)

# 2. Process from pandas DataFrame
bars = wrangler.from_pandas(
    df=df,
    default_volume=1_000_000.0,
    ts_init_delta=0,
)
# Internally:
#   - Converts DataFrame to Arrow format
#   - Serializes to Arrow IPC bytes
#   - Calls Rust wrangler.process_record_batch_bytes()
#   - Returns list of Bar objects
```

## Complete Data Flow

### Step-by-Step Process

1. **CSV → DataFrame** (Python)
   ```python
   df = pd.read_csv("data.csv", index_col="timestamp", parse_dates=True)
   # Result: pandas DataFrame with columns [open, high, low, close, volume]
   ```

2. **DataFrame → Arrow Arrays** (Python)
   ```python
   # Convert each column to Arrow-compatible format
   # Fixed-point encoding for prices/quantities
   # Timestamp conversion for events
   ```

3. **Arrow Arrays → Arrow Table** (Python)
   ```python
   table = pa.Table.from_arrays(arrays, schema=schema)
   ```

4. **Arrow Table → IPC Bytes** (Python)
   ```python
   sink = pa.BufferOutputStream()
   writer = pa.ipc.new_stream(sink, table.schema)
   writer.write_table(table)
   ipc_bytes = sink.getvalue().to_pybytes()
   ```

5. **IPC Bytes → Rust** (PyO3 boundary)
   ```rust
   // PyO3 automatically converts Python bytes to &[u8]
   fn process_record_batch_bytes(&self, data: &[u8]) -> PyResult<Vec<Bar>>
   ```

6. **IPC Bytes → RecordBatch** (Rust)
   ```rust
   let cursor = Cursor::new(data);  // Zero-copy view
   let reader = StreamReader::try_new(cursor, None)?;
   let record_batch = reader.next()?;
   ```

7. **RecordBatch → Domain Objects** (Rust)
   ```rust
   let bars = Bar::decode_batch(&metadata, record_batch)?;
   // Returns: Vec<Bar>
   ```

8. **Domain Objects → Python** (PyO3)
   ```rust
   Ok(bars)  // PyO3 converts Vec<Bar> to Python list[Bar]
   ```

### Memory Ownership and Transfer

**Configuration**: `PRECISION_BYTES = 8`, `FIXED_SCALAR = 1_000_000_000.0`

**Memory Sizes (per bar, 10,000 bars example):**

| Stage | Component | Size per Bar | Total (10K bars) | Ownership |
|-------|-----------|--------------|-----------------|-----------|
| **DataFrame** | 5 float64 + index + overhead | ~250-350 bytes | ~2.5-3.5 MB | Python heap |
| **Arrow Table** | 5 FixedSizeBinary(8) + 2 UInt64 + overhead | ~160-260 bytes | ~1.6-2.6 MB | Python heap |
| **IPC Bytes** | 56 bytes data + schema/overhead | ~256-556 bytes | ~560 KB | Python → Rust (copied) |
| **RecordBatch** | Column arrays + Arc pointers | ~156-206 bytes | ~1.6-2.1 MB | Rust heap |
| **Vec<Bar>** | Bar structs (bar_type, prices, volume, timestamps) | ~111-162 bytes | ~1.1-1.6 MB | Rust heap |
| **Python list[Bar]** | PyObject wrappers (pointers to Rust) | ~56 bytes | ~560 KB | Python heap |

**Memory Transfer Summary:**

```
┌─────────────────────────────────────────────────────────────┐
│ Python → Rust Transfer                                       │
├─────────────────────────────────────────────────────────────┤
│ Arrow IPC Bytes: ~560 KB (10,000 bars)                      │
│   - Full copy: Yes (Python bytes → Rust &[u8])              │
│   - Transfer method: PyO3 copies bytes across FFI boundary  │
│   - Zero-copy: No (FFI boundary requires copy)              │
└─────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────┐
│ Rust → Python Transfer                                       │
├─────────────────────────────────────────────────────────────┤
│ Vec<Bar> → list[Bar]: ~560 KB (wrapper objects)            │
│   - Full copy: No (only wrappers)                            │
│   - Transfer method: PyO3 creates Python objects             │
│   - Zero-copy: Yes (data stays in Rust heap)                │
│   - Rust memory: ~1.1-1.6 MB (actual Bar structs)         │
│   - Python memory: ~560 KB (wrapper objects only)           │
└─────────────────────────────────────────────────────────────┘
```

**Memory Lifecycle:**

```
1. Python: DataFrame created (2.5-3.5 MB)
   ↓
2. Python: Arrow Table created (1.6-2.6 MB)
   [DataFrame can be GC'd here]
   ↓
3. Python: Arrow IPC bytes serialized (560 KB)
   [Arrow Table can be GC'd here]
   ↓
4. Transfer: IPC bytes copied to Rust (560 KB copied)
   ↓
5. Rust: RecordBatch deserialized (1.6-2.1 MB allocated)
   [IPC bytes view dropped, Python bytes can be GC'd]
   ↓
6. Rust: Vec<Bar> decoded (1.1-1.6 MB allocated)
   [RecordBatch dropped]
   ↓
7. PyO3: Python list created (560 KB wrappers)
   [Vec<Bar> ownership transferred to Python]
   ↓
8. Python: list[Bar] available
   [Rust Bar objects remain in Rust heap, managed by PyO3]
```

**Key Points:**
- **Python → Rust**: ~560 KB copied (only significant FFI copy)
- **Rust → Python**: ~560 KB wrappers (data stays in Rust heap)
- **Peak Memory**: ~7.7 MB total (~4 MB Python + ~3.7 MB Rust) for 10,000 bars
- **Efficiency**: Columnar Arrow format reduces memory vs row-based DataFrame

### Memory Optimization: Iterator-Based Streaming

**Current Memory Duplication Issues:**

The current flow creates multiple copies of data:
1. **DataFrame** (2.5-3.5 MB) → **Arrow Table** (1.6-2.6 MB) → **IPC Bytes** (560 KB) → **RecordBatch** (1.6-2.1 MB) → **Vec<Bar>** (1.1-1.6 MB)

**Solution: Iterator-Based Chunked Streaming**

Process data in chunks using iterators to minimize memory footprint. Each stage processes one chunk at a time, allowing garbage collection between chunks.

#### Rust Implementation: Iterator-Based Wrangler

```rust
use pyo3::{PyResult, Python};
use pyo3::types::PyIterator;
use std::io::Cursor;
use datafusion::arrow::ipc::reader::StreamReader;

#[pyclass]
pub struct BarDataWrangler {
    bar_type: BarType,
    price_precision: u8,
    size_precision: u8,
    metadata: HashMap<String, String>,
}

#[pymethods]
impl BarDataWrangler {
    // Existing methods...
    
    /// Process Arrow IPC bytes and return an iterator over Bar objects
    fn process_record_batch_bytes_iter<'py>(
        &self,
        py: Python<'py>,
        data: &[u8],
    ) -> PyResult<Bound<'py, PyIterator>> {
        let cursor = Cursor::new(data);
        let reader = StreamReader::try_new(cursor, None)
            .map_err(to_pyvalue_err)?;
        
        let metadata = self.metadata.clone();
        
        // Create iterator that yields one Bar at a time
        let iter = BarIterator::new(reader, metadata);
        Ok(PyIterator::from_iter(py, iter))
    }
}

// Iterator that yields Bar objects one at a time
struct BarIterator {
    reader: StreamReader<Cursor<Vec<u8>>>,
    current_batch: Option<std::vec::IntoIter<Bar>>,
    metadata: HashMap<String, String>,
}

impl BarIterator {
    fn new(reader: StreamReader<Cursor<Vec<u8>>>, metadata: HashMap<String, String>) -> Self {
        Self {
            reader,
            current_batch: None,
            metadata,
        }
    }
}

impl Iterator for BarIterator {
    type Item = Bar;
    
    fn next(&mut self) -> Option<Self::Item> {
        // If current batch is exhausted, load next RecordBatch
        loop {
            if let Some(ref mut batch_iter) = self.current_batch {
                if let Some(bar) = batch_iter.next() {
                    return Some(bar);
                }
            }
            
            // Load next RecordBatch
            match self.reader.next() {
                Some(Ok(record_batch)) => {
                    match Bar::decode_batch(&self.metadata, record_batch) {
                        Ok(bars) => {
                            self.current_batch = Some(bars.into_iter());
                            continue;
                        }
                        Err(_) => return None,
                    }
                }
                Some(Err(_)) => return None,
                None => return None, // No more batches
            }
        }
    }
}
```

#### Python Implementation: Chunked DataFrame Iterator

```python
from typing import Iterator
import pandas as pd
import pyarrow as pa

class BarDataWranglerV2(WranglerBase):
    # Existing methods...
    
    def from_pandas_iter(
        self,
        df: pd.DataFrame,
        chunk_size: int = 10_000,
        default_volume: float = 1_000_000.0,
        ts_init_delta: int = 0,
    ) -> Iterator[nautilus_pyo3.Bar]:
        """
        Process DataFrame in chunks and return iterator of Bar objects.
        
        Memory efficient: Only one chunk in memory at a time.
        """
        # Process DataFrame in chunks
        for i in range(0, len(df), chunk_size):
            chunk_df = df.iloc[i:i+chunk_size]
            
            # Convert chunk to Arrow IPC bytes
            ipc_bytes = self._chunk_to_ipc_bytes(
                chunk_df, default_volume, ts_init_delta
            )
            
            # Process chunk and yield bars one at a time
            for bar in self._inner.process_record_batch_bytes_iter(ipc_bytes):
                yield bar
            
            # Chunk can be GC'd after processing
            del chunk_df, ipc_bytes
    
    def from_csv_iter(
        self,
        file_path: str,
        chunk_size: int = 10_000,
        default_volume: float = 1_000_000.0,
        ts_init_delta: int = 0,
    ) -> Iterator[nautilus_pyo3.Bar]:
        """
        Read CSV file in chunks and return iterator of Bar objects.
        
        Memory efficient: Never loads full file into memory.
        """
        # Read CSV in chunks using pandas
        chunk_reader = pd.read_csv(
            file_path,
            index_col="timestamp",
            parse_dates=True,
            chunksize=chunk_size,
        )
        
        for chunk_df in chunk_reader:
            # Process each chunk
            for bar in self.from_pandas_iter(
                chunk_df,
                chunk_size=len(chunk_df),  # Process entire chunk
                default_volume=default_volume,
                ts_init_delta=ts_init_delta,
            ):
                yield bar
    
    def _chunk_to_ipc_bytes(
        self,
        df: pd.DataFrame,
        default_volume: float,
        ts_init_delta: int,
    ) -> bytes:
        """Convert DataFrame chunk to Arrow IPC bytes."""
        # Rename columns
        df = df.rename(columns={"timestamp": "ts_event"})
        
        # Handle default volume
        if "volume" not in df.columns:
            df["volume"] = default_volume
        
        # Process timestamps
        ts_event = (
            pd.to_datetime(df["ts_event"], utc=True, format="mixed")
            .dt.tz_localize(None)
            .astype("int64")
        ).to_numpy(dtype="uint64")
        
        ts_init = ts_event + ts_init_delta
        
        # Convert prices to fixed binary
        open_price = (
            df["open"]
            .apply(lambda x: int(x * FIXED_SCALAR))
            .apply(lambda x: x.to_bytes(FIXED_PRECISION_BYTES, byteorder="little", signed=True))
        )
        high_price = (
            df["high"]
            .apply(lambda x: int(x * FIXED_SCALAR))
            .apply(lambda x: x.to_bytes(FIXED_PRECISION_BYTES, byteorder="little", signed=True))
        )
        low_price = (
            df["low"]
            .apply(lambda x: int(x * FIXED_SCALAR))
            .apply(lambda x: x.to_bytes(FIXED_PRECISION_BYTES, byteorder="little", signed=True))
        )
        close_price = (
            df["close"]
            .apply(lambda x: int(x * FIXED_SCALAR))
            .apply(lambda x: x.to_bytes(FIXED_PRECISION_BYTES, byteorder="little", signed=True))
        )
        volume = (
            df["volume"]
            .apply(lambda x: int(x * FIXED_SCALAR))
            .apply(lambda x: x.to_bytes(FIXED_PRECISION_BYTES, byteorder="little", signed=False))
        )
        
        # Create Arrow arrays
        fields = [
            pa.field("open", pa.binary(FIXED_PRECISION_BYTES), nullable=False),
            pa.field("high", pa.binary(FIXED_PRECISION_BYTES), nullable=False),
            pa.field("low", pa.binary(FIXED_PRECISION_BYTES), nullable=False),
            pa.field("close", pa.binary(FIXED_PRECISION_BYTES), nullable=False),
            pa.field("volume", pa.binary(FIXED_PRECISION_BYTES), nullable=False),
            pa.field("ts_event", pa.uint64(), nullable=False),
            pa.field("ts_init", pa.uint64(), nullable=False),
        ]
        
        arrays = [
            pa.array(open_price, type=pa.binary(FIXED_PRECISION_BYTES)),
            pa.array(high_price, type=pa.binary(FIXED_PRECISION_BYTES)),
            pa.array(low_price, type=pa.binary(FIXED_PRECISION_BYTES)),
            pa.array(close_price, type=pa.binary(FIXED_PRECISION_BYTES)),
            pa.array(volume, type=pa.binary(FIXED_PRECISION_BYTES)),
            pa.array(ts_event, type=pa.uint64()),
            pa.array(ts_init, type=pa.uint64()),
        ]
        
        # Create Arrow Table and serialize to IPC
        table = pa.Table.from_arrays(arrays, schema=pa.schema(fields))
        sink = pa.BufferOutputStream()
        writer = pa.ipc.new_stream(sink, table.schema)
        writer.write_table(table)
        writer.close()
        
        return sink.getvalue().to_pybytes()
```

#### Usage Examples

**1. Process CSV file with iterator (memory efficient):**

```python
wrangler = BarDataWranglerV2(
    bar_type="GBP/USD.SIM-1-MINUTE-BID-EXTERNAL",
    price_precision=5,
    size_precision=0,
)

# Process CSV file in chunks, yield bars one at a time
for bar in wrangler.from_csv_iter("large_file.csv", chunk_size=10_000):
    # Process each bar immediately
    process_bar(bar)
    # Memory: Only one chunk + one bar in memory at a time
```

**2. Process DataFrame with iterator:**

```python
df = pd.read_csv("data.csv", index_col="timestamp", parse_dates=True)

# Process DataFrame in chunks
for bar in wrangler.from_pandas_iter(df, chunk_size=10_000):
    process_bar(bar)
```

**3. Process Arrow IPC bytes with iterator:**

```python
# If you already have IPC bytes
ipc_bytes = get_arrow_ipc_bytes()

# Process and get iterator
bars_iter = wrangler._inner.process_record_batch_bytes_iter(ipc_bytes)

for bar in bars_iter:
    process_bar(bar)
```

#### Memory Benefits

**Memory Flow (Chunked Iterator Approach):**

```
CSV File (on disk)
    ↓
Chunk 1 (10K rows) → Arrow Table → IPC Bytes → RecordBatch → Bar Iterator
    ↓ (chunk GC'd)
Chunk 2 (10K rows) → Arrow Table → IPC Bytes → RecordBatch → Bar Iterator
    ↓ (chunk GC'd)
...
```

**Memory Comparison:**

| Approach | Peak Memory (1M bars) | Memory Pattern |
|----------|----------------------|----------------|
| **Current (Full Load)** | ~770 MB | All data in memory |
| **Chunked Iterator** | ~1.5-2 MB | One chunk at a time |
| **Memory Reduction** | **~99.7%** | Constant memory usage |

**Key Benefits:**
- **Constant Memory**: Peak memory is independent of dataset size
- **Lazy Evaluation**: Bars are created only when needed
- **Early GC**: Each chunk can be garbage collected immediately after processing
- **Scalable**: Can process datasets of any size with fixed memory footprint

**Summary:**
- **For small datasets (<100K bars)**: Current approach is fine
- **For medium datasets (100K-1M bars)**: Use chunked processing
- **For large datasets (>1M bars)**: Use streaming + lazy evaluation
- **For very large files**: Use memory-mapped files + chunked processing

## Benefits of This Architecture

1. **Zero-Copy Transfer**: Arrow IPC format allows efficient memory transfer
2. **Type Safety**: Rust enforces correct data types at compile time
3. **Batch Processing**: Columnar format enables efficient batch operations
4. **Generic Design**: Traits allow easy extension to new data types
5. **Language Interop**: PyO3 provides seamless Python-Rust integration
6. **Memory Efficiency**: Columnar layout reduces memory overhead
7. **Streaming Support**: Arrow IPC supports streaming multiple batches

## Extending to New Data Types

To add support for a new data type:

1. **Implement Traits** (Rust):
   ```rust
   impl ArrowSchemaProvider for NewType { /* ... */ }
   impl EncodeToRecordBatch for NewType { /* ... */ }
   impl DecodeFromRecordBatch for NewType { /* ... */ }
   ```

2. **Create PyO3 Wrangler** (Rust):
   ```rust
   #[pyclass]
   pub struct NewTypeDataWrangler { /* ... */ }
   ```

3. **Add Python Wrapper** (Python):
   ```python
   class NewTypeDataWranglerV2(WranglerBase):
       def from_pandas(self, df: pd.DataFrame) -> list[NewType]:
           # Convert DataFrame to Arrow format
           # Call Rust wrangler
   ```

The generic trait design ensures consistency across all data types.

