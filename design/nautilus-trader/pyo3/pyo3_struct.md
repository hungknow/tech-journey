# PyO3 Patterns in NautilusTrader

This document describes the common and specific patterns used in the NautilusTrader framework for exposing Rust structs, enums, functions, and memory transfers to Python using PyO3.

## Common Patterns

### Struct Definition Pattern

Basic struct definition with PyO3 methods:

```rust
#[pymethods]
#[pyo3_stub_gen::derive::gen_stub_pymethods]
impl Currency {
    #[new]
    fn py_new(
        code: &str,
        precision: u8,
        iso4217: u16,
        name: &str,
        currency_type: CurrencyType,
    ) -> PyResult<Self> {
        Self::new_checked(code, precision, iso4217, name, currency_type)
            .map_err(to_pyvalue_err)
    }
}
```

Standard dunder methods implementation:

```rust
fn __richcmp__(&self, other: &Self, op: CompareOp, py: Python<'_>) -> Py<PyAny> {
    match op {
        CompareOp::Eq => self.eq(other).into_py_any_unwrap(py),
        CompareOp::Ne => self.ne(other).into_py_any_unwrap(py),
        _ => py.NotImplemented(),
    }
}

fn __hash__(&self) -> isize {
    let mut h = DefaultHasher::new();
    self.hash(&mut h);
    h.finish() as isize
}

fn __repr__(&self) -> String {
    format!("{self:?}")
}

fn __str__(&self) -> String {
    self.to_string()
}
```

### Enum Definition Pattern

Standard enum with PyO3 methods:

```rust
#[pymethods]
#[pyo3_stub_gen::derive::gen_stub_pymethods]
impl OrderSide {
    #[new]
    fn py_new(py: Python<'_>, value: &Bound<'_, PyAny>) -> PyResult<Self> {
        let t = Self::type_object(py);
        Self::py_from_str(&t, value)
    }

    #[getter]
    pub fn name(&self) -> String {
        self.to_string()
    }

    #[getter]
    pub fn value(&self) -> u8 {
        *self as u8
    }

    #[classmethod]
    fn variants(_: &Bound<'_, PyType>, py: Python<'_>) -> EnumIterator {
        EnumIterator::new::<Self>(py)
    }

    #[classmethod]
    #[pyo3(name = "from_str")]
    fn py_from_str(_: &Bound<'_, PyType>, data: &Bound<'_, PyAny>) -> PyResult<Self> {
        let data_str: &str = data.extract()?;
        let tokenized = data_str.to_uppercase();
        Self::from_str(&tokenized).map_err(to_pyvalue_err)
    }
}
```

### Function Definition Pattern

Simple function with error handling:

```rust
#[pyfunction(name = "secs_to_nanos")]
#[gen_stub_pyfunction(module = "nautilus_trader.core")]
pub fn py_secs_to_nanos(secs: f64) -> PyResult<u64> {
    secs_to_nanos(secs).map_err(to_pyvalue_err)
}
```

Function with optional parameters:

```rust
#[pyfunction(
    name = "unix_nanos_to_iso8601",
    signature = (timestamp_ns, nanos_precision=Some(true))
)]
#[gen_stub_pyfunction(module = "nautilus_trader.core")]
pub fn py_unix_nanos_to_iso8601(
    timestamp_ns: u64,
    nanos_precision: Option<bool>,
) -> PyResult<String> {
    // Implementation
}
```

### Module Organization Pattern

Standard module definition:

```rust
#[pymodule]
pub fn core(_: Python<'_>, m: &Bound<'_, PyModule>) -> PyResult<()> {
    // Constants
    m.add(stringify!(NAUTILUS_VERSION), NAUTILUS_VERSION)?;
    m.add(stringify!(MILLISECONDS_IN_SECOND), MILLISECONDS_IN_SECOND)?;

    // Classes
    m.add_class::<UUID4>()?;

    // Functions
    m.add_function(wrap_pyfunction!(py_is_pycapsule, m)?)?;
    m.add_function(wrap_pyfunction!(casing::py_convert_to_snake_case, m)?)?;

    Ok(())
}
```

## Rc and Arc Wrapping Patterns

### Rc<UnsafeCell<T>> for High-Performance Shared State

The framework uses `Rc<UnsafeCell<T>>` for shared ownership between Python and Rust registries while maintaining performance. This pattern is used when:

- Shared ownership is required between Python wrapper and Rust registries
- Maximum performance is needed (avoiding RefCell runtime borrow checking)
- Access patterns are controlled and predictable

**Key Implementation - PyStrategy:**

```rust
/// Inner state of `PyStrategy`, shared between Python wrapper and Rust registries.
pub struct PyStrategyInner {
    core: StrategyCore,
    py_self: Option<Py<PyAny>>,  // Holds reference back to Python instance
    clock: PyClock,
    logger: PyLogger,
}

/// Python-facing wrapper for Strategy.
#[pyo3::pyclass(
    module = "nautilus_trader.trading",
    name = "Strategy",
    unsendable,  // Critical for safety!
    subclass
)]
pub struct PyStrategy {
    inner: Rc<UnsafeCell<PyStrategyInner>>,
}
```

**Unsafe Access Pattern with Safety Guarantees:**

```rust
impl PyStrategy {
    #[inline]
    #[allow(unsafe_code)]
    pub(crate) fn inner(&self) -> &PyStrategyInner {
        // SAFETY: `PyStrategy` is `unsendable` so access is single-threaded, and
        // callers never hold a mutable and shared reference simultaneously.
        unsafe { &*self.inner.get() }
    }

    #[inline]
    #[allow(unsafe_code, clippy::mut_from_ref)]
    pub(crate) fn inner_mut(&self) -> &mut PyStrategyInner {
        // SAFETY: `PyStrategy` is `unsendable` so access is single-threaded, and
        // callers never hold a mutable and shared reference simultaneously.
        unsafe { &mut *self.inner.get() }
    }
}
```

**Trait Registration Pattern:**

```rust
pub fn register_in_global_registries(&self) {
    let inner_ref: Rc<UnsafeCell<PyStrategyInner>> = self.inner.clone();

    let component_trait_ref: Rc<UnsafeCell<dyn Component>> = inner_ref.clone();
    with_component_registry(|registry| registry.insert(component_id, component_trait_ref));

    let actor_trait_ref: Rc<UnsafeCell<dyn Actor>> = inner_ref;
    with_actor_registry(|registry| registry.insert(actor_id, actor_trait_ref));
}
```

**Why This Pattern Is Safe:**

- The `unsendable` annotation prevents cross-thread sharing
- Single-threaded access guarantees ensure no data races
- Controlled borrowing patterns in the codebase prevent UB
- Rust registries hold shared references without mutability conflicts

### Rc<RefCell<T>> for General Shared Mutable State

For cases requiring runtime borrow checking, NautilusTrader uses `Rc<RefCell<T>>`:

```rust
/// Wrapper providing shared access to [`Cache`] from Python.
///
/// This wrapper holds an `Rc<RefCell<Cache>>` allowing actors to share
/// the same cache instance. All methods delegate to the underlying cache.
#[pyo3::pyclass(module = "nautilus_trader.core.nautilus_pyo3.common", name = "Cache", unsendable)]
#[derive(Debug, Clone)]
pub struct PyCache(Rc<RefCell<Cache>>);

impl PyCache {
    /// Creates a `PyCache` from an `Rc<RefCell<Cache>>`.
    pub fn from_rc(rc: Rc<RefCell<Cache>>) -> Self {
        Self(rc)
    }

    /// Gets the inner `Rc<RefCell<Cache>>` for use in Rust code.
    pub fn cache_rc(&self) -> Rc<RefCell<Cache>> {
        self.0.clone()
    }
}

#[pymethods]
impl PyCache {
    #[pyo3(name = "get")]
    fn py_get(&self, key: &str) -> PyResult<Option<Vec<u8>>> {
        match self.0.borrow().get(key).map_err(to_pyvalue_err)? {
            Some(bytes) => Ok(Some(bytes.to_vec())),
            None => Ok(None),
        }
    }

    #[pyo3(name = "add")]
    fn py_add_general(&mut self, key: &str, value: Vec<u8>) -> PyResult<()> {
        self.0.borrow_mut().add(key, Bytes::from(value))
    }
}
```

**Why `Rc<RefCell<T>>` vs `Rc<UnsafeCell<T>>`:**

- RefCell: Used when multiple immutable borrows or complex borrowing patterns are needed
- UnsafeCell: Used for maximum performance when borrowing patterns are controlled and predictable

### Arc<T> Pattern for Thread-Safe Sharing

For truly thread-safe scenarios, NautilusTrader uses `Arc<_>`:

```rust
// WebSocket handler pattern
let message_handler: MessageHandler = Arc::new(move |msg: Message| {
    Python::attach(|py| {
        let data = match msg {
            Message::Binary(data) | Message::Text(data) => data.to_vec(),
            _ => return,
        };
        let py_bytes = PyBytes::new(py, &data);
        if let Err(e) = handler_clone.call1(py, (py_bytes,)) {
            log::error!("Error calling handler: {e}");
        }
    });
});

// Thread-safe state sharing
let instruments_map = Arc::new(AtomicMap::<InstrumentId, InstrumentAny>::new());
let book_sequence = Arc::new(AtomicU64::new(0));
```

### Reference Cycle Prevention

NautilusTrader implements sophisticated reference cycle prevention to avoid memory leaks between Rust and Python:

```rust
/// Safely clones a Python object by acquiring the GIL and properly managing reference counts.
///
/// This function exists to break reference cycles between Rust and Python that can occur
/// when using `Arc<Py<PyAny>>` in callback-holding structs. The original design wrapped
/// Python callbacks in `Arc` for thread-safe sharing, but this created circular references:
///
/// 1. Rust `Arc` holds Python objects → increases Python reference count.
/// 2. Python objects might reference Rust objects → creates cycles.
/// 3. Neither side can be garbage collected → memory leak.
///
/// By using plain `Py<PyAny>` with GIL-based cloning instead of `Arc<Py<PyAny>>`, we:
/// - Avoid circular references between Rust and Python memory management.
/// - Ensure proper Python reference counting under the GIL.
/// - Allow both Rust and Python garbage collectors to work correctly.
#[must_use]
pub fn clone_py_object(obj: &Py<PyAny>) -> Py<PyAny> {
    Python::attach(|py| obj.clone_ref(py))
}
```

**Usage Pattern:**

```rust
// Instead of Arc<Py<PyAny>> (which would create cycles)
// Use Py<PyAny> with clone_py_object for callback storage
struct PyActorIndicator {
    indicator: Py<PyAny>,  // Not Arc<Py<PyAny>>!
    key: usize,
}

impl PyActorIndicator {
    fn clone_ref(&self, py: Python<'_>) -> Py<PyAny> {
        self.indicator.clone_ref(py)  // Proper GIL-based cloning
    }
}
```

## Error Handling Patterns

### Standard Error Conversion Functions

NautilusTrader provides comprehensive error conversion from Rust to Python exceptions:

```rust
/// Converts any type that implements `Display` to a Python `ValueError`.
pub fn to_pyvalue_err(e: impl Display) -> PyErr {
    PyValueError::new_err(e.to_string())
}

/// Converts a correctness check failure to a Python `ValueError`.
pub fn correctness_error_to_pyvalue_err(e: CorrectnessError) -> PyErr {
    PyValueError::new_err(e.to_string())
}

/// Converts any type that implements `Display` to a Python `TypeError`.
pub fn to_pytype_err(e: impl Display) -> PyErr {
    PyTypeError::new_err(e.to_string())
}

/// Converts any type that implements `Display` to a Python `RuntimeError`.
pub fn to_pyruntime_err(e: impl Display) -> PyErr {
    PyRuntimeError::new_err(e.to_string())
}

/// Converts any type that implements `Display` to a Python `KeyError`.
pub fn to_pykey_err(e: impl Display) -> PyErr {
    PyKeyError::new_err(e.to_string())
}

/// Converts any type that implements `Display` to a Python `Exception`.
pub fn to_pyexception(e: impl Display) -> PyErr {
    PyException::new_err(e.to_string())
}

/// Converts any type that implements `Display` to a Python `NotImplementedError`.
pub fn to_pynotimplemented_err(e: impl Display) -> PyErr {
    PyNotImplementedError::new_err(e.to_string())
}
```

### Custom Error Conversion Functions

Domain-specific error conversion functions:

```rust
/// Converts an instrument ID validation failure to a Python `ValueError`.
pub fn instrument_id_error_to_pyvalue_err(e: InstrumentIdError) -> PyErr {
    to_pyvalue_err(e)
}

/// Converts an option series ID validation failure to a Python `ValueError`.
pub fn option_series_id_error_to_pyvalue_err(e: OptionSeriesIdError) -> PyErr {
    to_pyvalue_err(e)
}

/// Converts a currency lookup failure to a Python `ValueError`.
pub fn currency_lookup_error_to_pyvalue_err(e: CurrencyLookupError) -> PyErr {
    to_pyvalue_err(e)
}
```

### Custom Exception Types

Creating custom Python exception types:

```rust
// In websocket.rs
create_exception!(network, WebSocketClientError, PyException);

#[expect(clippy::needless_pass_by_value)]
fn to_websocket_pyerr(e: TransportError) -> PyErr {
    PyErr::new::<WebSocketClientError, _>(e.to_string())
}
```

### Error Handling in Practice

```rust
// Configuration validation
config.validate().map_err(config_error_to_pyvalue_err)?;

// Data access errors
fn py_clock(&self) -> PyResult<PyClock> {
    let inner = self.inner();
    if inner.core.actor.is_registered() {
        Ok(inner.clock.clone())
    } else {
        Err(to_pyruntime_err(
            "Strategy must be registered with a trader before accessing clock",
        ))
    }
}

// Component lifecycle errors
fn py_start(&mut self) -> PyResult<()> {
    Component::start(self.inner_mut()).map_err(to_pyruntime_err)
}

// Construction with error handling
fn py_new(
    instrument_id: InstrumentId,
    bid_price: Price,
    ask_price: Price,
    bid_size: Quantity,
    ask_size: Quantity,
    ts_event: u64,
    ts_init: u64,
) -> PyResult<Self> {
    Self::new_checked(
        instrument_id,
        bid_price,
        ask_price,
        bid_size,
        ask_size,
        ts_event.into(),
        ts_init.into(),
    )
    .map_err(to_pyvalue_err)
}
```

## Memory Transfer Patterns

### PyCapsule for Zero-Copy Transfer

Creating PyCapsules for efficient data transfer between Rust and Python:

```rust
/// Creates a Python `PyCapsule` object containing a Rust `Data` instance.
///
/// This function takes ownership of the `Data` instance and encapsulates it within
/// a `PyCapsule` object, allowing the Rust data to be passed into the Python runtime.
pub fn data_to_pycapsule(py: Python, data: Data) -> Py<PyAny> {
    #[cfg(feature = "cython-compat")]
    {
        // For Cython compatibility, we convert to DataFFI if possible.
        if let Ok(ffi_data) = DataFFI::try_from(data.clone()) {
            let capsule = PyCapsule::new_with_destructor(py, ffi_data, None, |_, _| {})
                .expect("Error creating `PyCapsule` for `DataFFI` ");
            return capsule.into_any().unbind();
        }
    }

    // Default case for PyO3 or when conversion fails (e.g. Custom data)
    let capsule = PyCapsule::new_with_destructor(py, data, None, |_, _| {})
        .expect("Error creating `PyCapsule` for `Data` ");
    capsule.into_any().unbind()
}
```

**Usage in Data Types:**

```rust
#[pymethods]
impl QuoteTick {
    /// Creates a `PyCapsule` containing a raw pointer to a `Data::Quote` object.
    #[pyo3(name = "as_pycapsule")]
    fn py_as_pycapsule(&self, py: Python<'_>) -> Py<PyAny> {
        data_to_pycapsule(py, Data::Quote(*self))
    }
}
```

### PyCapsule Destruction

Safe cleanup of PyCapsules containing C structures:

```rust
/// Drops a `PyCapsule` containing a `CVec` structure.
///
/// This function safely extracts and drops the `CVec` instance encapsulated within
/// a `PyCapsule` object. It is intended for cleaning up after the `Data` instances
/// have been transferred into Python (e.g. via `capsule_to_list`) and are no longer needed.
#[cfg(feature = "ffi")]
#[pyfunction]
pub fn drop_cvec_pycapsule(capsule: &Bound<'_, PyAny>) -> PyResult<()> {
    let capsule: &Bound<'_, PyCapsule> = capsule
        .cast::<PyCapsule>()
        .map_err(|e| to_pyvalue_err(format!("Expected DataFFI CVec PyCapsule: {e}")))?;
    let cvec_ptr = capsule
        .pointer_checked(Some(DATA_FFI_CVEC_CAPSULE_NAME))
        .map_err(|e| to_pyvalue_err(format!("Invalid DataFFI CVec PyCapsule: {e}")))?
        .as_ptr()
        .cast::<CVec>();

    // SAFETY: The capsule name check above verifies this is a DataFfiCVec
    let cvec = unsafe { *cvec_ptr };

    if cvec.len == 0 && cvec.cap == 0 {
        unsafe {
            *cvec_ptr = CVec::empty();
        }
        return Ok(());
    }

    if cvec.len > cvec.cap {
        return Err(to_pyvalue_err(format!(
            "Invalid DataFFI CVec metadata: len ({}) > cap ({})",
            cvec.len, cvec.cap
        )));
    }

    if cvec.ptr.is_null() {
        return Err(to_pyvalue_err(format!(
            "Invalid DataFFI CVec metadata: null ptr with len ({}) and cap ({})",
            cvec.len, cvec.cap
        )));
    }

    // Reset it before reconstructing the Vec so repeated calls do not double free.
    unsafe {
        *cvec_ptr = CVec::empty();
    }

    // Reconstruct the Vec to properly deallocate memory
    let data: Vec<DataFFI> =
        unsafe { Vec::from_raw_parts(cvec.ptr.cast::<DataFFI>(), cvec.len, cvec.cap) };
    drop(data);
    Ok(())
}
```

### Pickling and Serialization

Support for Python pickling through custom reduce methods:

```rust
#[pymethods]
impl Bar {
    fn __reduce__(&self, py: Python) -> PyResult<Py<PyAny>> {
        let safe_constructor = py.get_type::<Self>().getattr("_safe_constructor")?;
        let state = self.__getstate__(py)?;
        (safe_constructor, PyTuple::empty(py), state).into_py_any(py)
    }

    fn __getstate__(&self, py: Python) -> PyResult<Py<PyAny>> {
        (
            self.bar_type.to_string(),
            self.open.raw,
            self.open.precision,
            self.high.raw,
            self.low.raw,
            self.close.raw,
            self.volume.raw,
            self.volume.precision,
            self.ts_event.as_u64(),
            self.ts_init.as_u64(),
        )
            .into_py_any(py)
    }

    fn __setstate__(&mut self, state: &Bound<'_, PyAny>) -> PyResult<()> {
        let py_tuple: &Bound<'_, PyTuple> = state.cast::<PyTuple>()?;
        let bar_type_str: String = py_tuple.get_item(0)?.extract()?;
        let open_raw: PriceRaw = py_tuple.get_item(1)?.extract()?;
        let open_prec: u8 = py_tuple.get_item(2)?.extract()?;

        self.bar_type = BarType::from_str(&bar_type_str).map_err(to_pyvalue_err)?;
        self.open = Price::from_raw(open_raw, open_prec);
        // ... restore other fields
        Ok(())
    }

    #[staticmethod]
    fn _safe_constructor() -> Self {
        Self::new(
            BarType::from("NULL.NULL-1-TICK-LAST-EXTERNAL"),
            Price::zero(0),
            Price::zero(0),
            Price::zero(0),
            Price::zero(0),
            Quantity::from(1),
            0.into(),
            0.into(),
        )
    }
}
```

### JSON and Dict Serialization

Using JSON as an intermediate format for serialization:

```rust
/// Convert a Rust type that implements `Serialize` to a Python dictionary.
pub fn to_dict_pyo3<T>(py: Python<'_>, value: &T) -> PyResult<Py<PyDict>>
where
    T: Serialize,
{
    let py_object = to_pyobject_pyo3(py, value)?;
    let py_dict = py_object
        .bind(py)
        .cast::<PyDict>()
        .map_err(Into::<PyErr>::into)?
        .clone()
        .unbind();
    Ok(py_dict)
}

/// Convert a Rust type that implements `Serialize` to a Python object.
pub fn to_pyobject_pyo3<T>(py: Python<'_>, value: &T) -> PyResult<Py<PyAny>>
where
    T: Serialize,
{
    let json_str = serde_json::to_string(value).map_err(to_pyvalue_err)?;
    let py_object = PyModule::import(py, "json")?
        .call_method("loads", (json_str,), None)?
        .extract()?;
    Ok(py_object)
}

/// Convert a Python dictionary to a Rust type that implements `DeserializeOwned`.
pub fn from_dict_pyo3<T>(py: Python<'_>, values: Py<PyDict>) -> Result<T, PyErr>
where
    T: DeserializeOwned,
{
    let values = values.into_any();
    from_pyobject_pyo3(py, values.bind(py))
}

/// Convert a Python object to a Rust type that implements `DeserializeOwned`.
pub fn from_pyobject_pyo3<T>(py: Python<'_>, value: &Bound<'_, PyAny>) -> Result<T, PyErr>
where
    T: DeserializeOwned,
{
    let kwargs = PyDict::new(py);
    kwargs.set_item("ensure_ascii", false)?;
    let json_str: String = PyModule::import(py, "json")?
        .call_method("dumps", (value,), Some(&kwargs))?
        .extract()?;

    let instance = serde_json::from_str(&json_str).map_err(to_pyvalue_err)?;
    Ok(instance)
}
```

**Usage in Structs:**

```rust
#[pymethods]
impl QuoteTick {
    #[pyo3(name = "to_dict")]
    fn py_to_dict(&self, py: Python<'_>) -> PyResult<Py<PyDict>> {
        to_dict_pyo3(py, self)
    }

    #[staticmethod]
    #[pyo3(name = "from_dict")]
    fn py_from_dict(py: Python<'_>, values: Py<PyDict>) -> PyResult<Self> {
        from_dict_pyo3(py, values)
    }
}
```

### Type-Specific Object Conversion

Custom conversion from Python objects back to Rust types:

```rust
impl QuoteTick {
    /// Creates a new [`QuoteTick`] from a Python object.
    pub fn from_pyobject(obj: &Bound<'_, PyAny>) -> PyResult<Self> {
        let instrument_id_obj: Bound<'_, PyAny> = obj.getattr("instrument_id")?.extract()?;
        let instrument_id_str: String = instrument_id_obj.getattr("value")?.extract()?;
        let instrument_id =
            InstrumentId::from_str(instrument_id_str.as_str()).map_err(to_pyvalue_err)?;

        let bid_price_py: Bound<'_, PyAny> = obj.getattr("bid_price")?.extract()?;
        let bid_price_raw: PriceRaw = bid_price_py.getattr("raw")?.extract()?;
        let bid_price_prec: u8 = bid_price_py.getattr("precision")?.extract()?;
        let bid_price = Price::from_raw(bid_price_raw, bid_price_prec);

        // ... extract other fields

        Self::new_checked(
            instrument_id,
            bid_price,
            ask_price,
            bid_size,
            ask_size,
            ts_event.into(),
            ts_init.into(),
        )
        .map_err(to_pyvalue_err)
    }
}
```

## Advanced Patterns

### Enum Iterator for Enum Variants

Custom iterator for enum variants:

```rust
/// Python iterator over the variants of an enum.
#[allow(missing_debug_implementations)]
#[pyclass]
pub struct EnumIterator {
    // Type erasure for code reuse, generic types can't be exposed to Python
    iter: Box<dyn Iterator<Item = Py<PyAny>> + Send + Sync>,
}

#[pymethods]
impl EnumIterator {
    fn __iter__(slf: PyRef<'_, Self>) -> PyRef<'_, Self> {
        slf
    }

    fn __next__(mut slf: PyRefMut<'_, Self>) -> Option<Py<PyAny>> {
        slf.iter.next()
    }
}

impl EnumIterator {
    /// Creates a new Python iterator over the variants of an enum.
    #[must_use]
    pub fn new<'py, E>(py: Python<'py>) -> Self
    where
        E: strum::IntoEnumIterator + IntoPyObjectExt<'py>,
        <E as IntoEnumIterator>::Iterator: Send,
    {
        Self {
            iter: Box::new(
                E::iter()
                    .map(|var| var.into_py_any_unwrap(py))
                    // Force eager evaluation because `py` isn't `Send`
                    .collect::<Vec<_>>()
                    .into_iter(),
            ),
        }
    }
}
```

### Trait Extensions for Python Interop

Custom trait extensions for ergonomic Python conversions:

```rust
/// Extend `IntoPyObjectExt` helper trait to unwrap `Py<PyAny>` after conversion.
pub trait IntoPyObjectNautilusExt<'py>: IntoPyObjectExt<'py> {
    /// Convert `self` into a [`Py<PyAny>`] while *panicking* if the conversion fails.
    ///
    /// This is a convenience wrapper that avoids cumbersome `Result` handling
    /// when we are certain that the conversion cannot fail.
    #[inline]
    fn into_py_any_unwrap(self, py: Python<'py>) -> Py<PyAny> {
        self.into_py_any(py)
            .expect("Failed to convert type to Py<PyAny>")
    }
}

impl<'py, T> IntoPyObjectNautilusExt<'py> for T where T: IntoPyObjectExt<'py> {}
```

**Usage:**

```rust
fn dispatch_on_quote(&mut self, quote: QuoteTick) -> PyResult<()> {
    if let Some(ref py_self) = self.py_self {
        Python::attach(|py| {
            py_self.call_method1(py, "on_quote", (quote.into_py_any_unwrap(py),))
        })?;
    }
    Ok(())
}
```

### Mathematical Operations with Type Coercion

Rich arithmetic operations supporting multiple Python numeric types:

```rust
fn __add__(&self, other: &Bound<'_, PyAny>, py: Python) -> PyResult<Py<PyAny>> {
    if other.is_instance_of::<PyFloat>() {
        let other_float: f64 = other.extract()?;
        (self.as_f64() + other_float).into_py_any(py)
    } else if let Ok(other_price) = other.extract::<Self>() {
        (*self + other_price).into_py_any(py)
    } else if let Ok(other_dec) = other.extract::<Decimal>() {
        (self.as_decimal() + other_dec).into_py_any(py)
    } else {
        let pytype_name = get_pytype_name(other)?;
        Err(to_pytype_err(format!(
            "Unsupported type for __add__, was `{pytype_name}`"
        )))
    }
}
```

### Flexible Parameter Handling

Parameters with optional values and complex signatures:

```rust
#[new]
#[pyo3(signature = (
    series_id,
    strike_range,
    instruments,
    snapshot_interval_ms=None,
    initial_atm_price=None
))]
fn py_new(
    series_id: OptionSeriesId,
    strike_range: PyStrikeRange,
    instruments: HashMap<InstrumentId, (Price, u8)>,
    snapshot_interval_ms: Option<u64>,
    initial_atm_price: Option<Price>,
) -> PyResult<Self> {
    // Implementation
}
```

## Performance Optimization Patterns

### Zero-Copy Operations

Efficient data transfer avoiding unnecessary copies:

```rust
#[pymethods]
impl Bar {
    /// Return JSON encoded bytes representation of the object.
    #[pyo3(name = "to_json_bytes")]
    fn py_to_json_bytes(&self, py: Python<'_>) -> Py<PyAny> {
        self.to_json_bytes().unwrap().into_py_any_unwrap(py)
    }

    /// Return `MsgPack` encoded bytes representation of the object.
    #[pyo3(name = "to_msgpack_bytes")]
    fn py_to_msgpack_bytes(&self, py: Python<'_>) -> Py<PyAny> {
        self.to_msgpack_bytes().unwrap().into_py_any_unwrap(py)
    }
}
```

### Collection Conversions with Type Preference

Smart collection conversion that prefers typed extraction over JSON:

```rust
/// Convert a Python mapping to an [`IndexMap`] using typed PyO3 objects when possible.
///
/// Falls back to the generic JSON bridge when the input is not a Python dict. Individual dict
/// keys and values first try typed PyO3 extraction, then JSON/Serde extraction.
pub fn indexmap_from_pyobject_pyo3<K, V>(
    py: Python<'_>,
    value: &Bound<'_, PyAny>,
) -> PyResult<IndexMap<K, V>>
where
    K: for<'py> FromPyObjectOwned<'py> + DeserializeOwned + Eq + Hash,
    V: for<'py> FromPyObjectOwned<'py> + DeserializeOwned,
    IndexMap<K, V>: DeserializeOwned,
{
    let Ok(dict) = value.cast::<PyDict>() else {
        return from_pyobject_pyo3(py, value);
    };

    let mut map = IndexMap::with_capacity(dict.len());
    for (key, value) in dict.iter() {
        map.insert(
            extract_typed_or_json_pyo3(py, &key)?,
            extract_typed_or_json_pyo3(py, &value)?,
        );
    }
    Ok(map)
}

fn extract_typed_or_json_pyo3<T>(py: Python<'_>, value: &Bound<'_, PyAny>) -> PyResult<T>
where
    T: for<'py> FromPyObjectOwned<'py> + DeserializeOwned,
{
    value.extract::<T>().or_else(|typed_err| {
        let typed_err: PyErr = typed_err.into();
        from_pyobject_pyo3(py, value).map_err(|json_err| {
            to_pyvalue_err(format!(
                "typed extraction failed: {typed_err}; JSON extraction failed: {json_err}"
            ))
        })
    })
}
```

## Best Practices

### Memory Safety Guarantees

The framework achieves safety through:

- **Unsendable Annotation**: Prevents cross-thread sharing of `Rc<UnsafeCell<T>>`
- **Single-threaded Access**: Ensures no data races through architectural guarantees
- **Controlled Borrowing**: Prevents UB through careful code organization
- **Reference Cycle Prevention**: Uses GIL-based cloning instead of `Arc<Py<PyAny>>`
- **Proper Capsule Management**: Safe cleanup of C structures through validated destructors

### Error Handling Patterns

Comprehensive error handling with proper Python exception mapping:

- Domain-specific error conversion functions
- Custom exception types for specific error scenarios
- Preserved error context through proper error messages
- Type-safe error propagation from Rust to Python
- Validation errors mapped to appropriate Python exception types

### Performance Optimization

Performance optimization strategies:

- `UnsafeCell` for zero-overhead mutable access when borrowing patterns are controlled
- `RefCell` only when runtime borrow checking is needed
- Zero-copy data transfer via PyCapsule for high-throughput scenarios
- Eager evaluation of iterators when Python GIL constraints require it
- Smart collection conversion preferring typed extraction over JSON serialization
- Custom trait extensions to avoid unnecessary Result handling

## Summary

NautilusTrader's PyO3 patterns demonstrate sophisticated techniques for:

- Shared state management between Rust and Python through `Rc<UnsafeCell<T>>` and `Rc<RefCell<T>>`
- Thread-safe data sharing using `Arc<T>` when truly needed
- Comprehensive error conversion from Rust to Python exceptions
- Zero-copy memory transfer via PyCapsule for performance-critical paths
- Reference cycle prevention through proper GIL-based object cloning
- Type-safe interop with flexible parameter handling and type coercion
- Performance optimization through unsafe patterns backed by architectural guarantees

The key insight is that the framework achieves high performance while maintaining safety through careful use of unsafe patterns backed by architectural guarantees (single-threaded access via `unsendable`) and comprehensive error handling that provides good Python ergonomics.