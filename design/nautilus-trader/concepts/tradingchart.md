# TradingChart Aggregate Root

## Overview

The `TradingChart` is a Domain-Driven Design (DDD) aggregate root that manages trading chart data (primarily `Bar` structures) and coordinates chart rendering operations. It maintains the chart's state including zoom levels, scale factors, and viewport information, while delegating rendering to external components (e.g., D3.js in TypeScript).

This design follows the same DDD patterns used throughout NautilusTrader, similar to the `OrderBook` aggregate root, with clear separation between the domain model (Rust) and presentation layer (TypeScript/D3.js).

## Domain Model Structure

### Aggregate Root: TradingChart

The `TradingChart` aggregate root is responsible for:

1. **Data Management**: Storing and managing collections of `Bar` data
2. **Viewport State**: Managing visible time range and price range
3. **Zoom & Scale**: Maintaining X (time) and Y (price) scale factors
4. **Data Integrity**: Ensuring chart data consistency and validity
5. **Rendering Coordination**: Providing state to rendering components

### Core Data Structures

#### TradingChart Aggregate Root

```rust
pub struct TradingChart {
    /// Unique identifier for the chart instance
    pub chart_id: ChartId,
    /// The instrument this chart represents
    pub instrument_id: InstrumentId,
    /// Collection of bars sorted by timestamp
    pub bars: Vec<Bar>,
    /// Current viewport (visible time and price range)
    pub viewport: Viewport,
    /// X-axis (time) scale configuration
    pub x_scale: ScaleX,
    /// Y-axis (price) scale configuration
    pub y_scale: ScaleY,
    /// Zoom level (1.0 = no zoom, >1.0 = zoomed in, <1.0 = zoomed out)
    pub zoom_level: ZoomLevel,
    /// Timestamp of last update
    pub ts_last: UnixNanos,
    /// Update count for tracking changes
    pub update_count: u64,
}
```

#### Value Objects

**Viewport** - Represents the visible area of the chart:
```rust
pub struct Viewport {
    /// Start time of visible range
    pub time_start: UnixNanos,
    /// End time of visible range
    pub time_end: UnixNanos,
    /// Minimum price in visible range
    pub price_min: Price,
    /// Maximum price in visible range
    pub price_max: Price,
}
```

**ScaleX** - X-axis (time) scaling configuration:
```rust
pub struct ScaleX {
    /// Current scale factor (pixels per nanosecond)
    pub scale_factor: f64,
    /// Minimum scale factor (most zoomed out)
    pub min_scale: f64,
    /// Maximum scale factor (most zoomed in)
    pub max_scale: f64,
    /// Canvas width in pixels
    pub canvas_width: u32,
}
```

**ScaleY** - Y-axis (price) scaling configuration:
```rust
pub struct ScaleY {
    /// Current scale factor (pixels per price unit)
    pub scale_factor: f64,
    /// Minimum scale factor (most zoomed out)
    pub min_scale: f64,
    /// Maximum scale factor (most zoomed in)
    pub max_scale: f64,
    /// Canvas height in pixels
    pub canvas_height: u32,
}
```

**ZoomLevel** - Encapsulates zoom state:
```rust
pub struct ZoomLevel {
    /// Current zoom level (1.0 = no zoom)
    pub level: f64,
    /// Minimum zoom level
    pub min_level: f64,
    /// Maximum zoom level
    pub max_level: f64,
}
```

**ChartId** - Unique identifier for chart instances:
```rust
pub struct ChartId {
    pub value: String,
}
```

## Domain Services

### 1. ChartDataService

**Purpose**: Manages chart data operations (adding, removing, filtering bars)

**Key Functions**:
- `add_bar(chart: &mut TradingChart, bar: Bar)` - Add a new bar to the chart
- `add_bars(chart: &mut TradingChart, bars: Vec<Bar>)` - Bulk add bars
- `remove_bars_before(chart: &mut TradingChart, timestamp: UnixNanos)` - Remove bars before timestamp
- `remove_bars_after(chart: &mut TradingChart, timestamp: UnixNanos)` - Remove bars after timestamp
- `filter_bars_by_range(chart: &mut TradingChart, start: UnixNanos, end: UnixNanos)` - Filter bars to time range
- `get_visible_bars(chart: &TradingChart) -> Vec<&Bar>` - Get bars within current viewport
- `get_price_range(chart: &TradingChart, start: UnixNanos, end: UnixNanos) -> (Price, Price)` - Calculate price range for time period
- `validate_bar_sequence(chart: &TradingChart) -> Result<(), ChartError>` - Validate bar sequence integrity

**Location**: `crates/model/src/trading/chart/domain_services/data.rs`

### 2. ChartScaleService

**Purpose**: Calculates and manages scale factors for X and Y axes

**Key Functions**:
- `calculate_x_scale(chart: &TradingChart, canvas_width: u32) -> ScaleX` - Calculate X-axis scale
- `calculate_y_scale(chart: &TradingChart, canvas_height: u32) -> ScaleY` - Calculate Y-axis scale
- `update_x_scale(chart: &mut TradingChart, scale_factor: f64)` - Update X-axis scale
- `update_y_scale(chart: &mut TradingChart, scale_factor: f64)` - Update Y-axis scale
- `auto_fit_viewport(chart: &mut TradingChart, canvas_width: u32, canvas_height: u32)` - Auto-fit viewport to all data
- `normalize_scale(scale: f64, min: f64, max: f64) -> f64` - Normalize scale within bounds

**Location**: `crates/model/src/trading/chart/domain_services/scale.rs`

### 3. ChartViewportService

**Purpose**: Manages viewport (visible area) operations

**Key Functions**:
- `set_viewport(chart: &mut TradingChart, viewport: Viewport)` - Set viewport explicitly
- `pan_viewport(chart: &mut TradingChart, delta_time: TimeDelta, delta_price: Price)` - Pan viewport
- `zoom_to_range(chart: &mut TradingChart, start: UnixNanos, end: UnixNanos)` - Zoom to specific time range
- `zoom_to_price_range(chart: &mut TradingChart, min_price: Price, max_price: Price)` - Zoom to price range
- `zoom_in(chart: &mut TradingChart, factor: f64)` - Zoom in by factor
- `zoom_out(chart: &mut TradingChart, factor: f64)` - Zoom out by factor
- `reset_viewport(chart: &mut TradingChart)` - Reset to show all data
- `calculate_viewport_from_zoom(chart: &TradingChart) -> Viewport` - Calculate viewport from zoom level

**Location**: `crates/model/src/trading/chart/domain_services/viewport.rs`

### 4. ChartZoomService

**Purpose**: Manages zoom operations and zoom level calculations

**Key Functions**:
- `zoom_in(chart: &mut TradingChart, factor: f64)` - Zoom in
- `zoom_out(chart: &mut TradingChart, factor: f64)` - Zoom out
- `set_zoom_level(chart: &mut TradingChart, level: f64)` - Set zoom level
- `zoom_to_point(chart: &mut TradingChart, time: UnixNanos, price: Price, factor: f64)` - Zoom to specific point
- `zoom_to_rect(chart: &mut TradingChart, start_time: UnixNanos, end_time: UnixNanos, min_price: Price, max_price: Price)` - Zoom to rectangle
- `calculate_zoom_from_viewport(chart: &TradingChart) -> f64` - Calculate zoom level from viewport
- `constrain_zoom_level(level: f64, min: f64, max: f64) -> f64` - Constrain zoom level to bounds

**Location**: `crates/model/src/trading/chart/domain_services/zoom.rs`

### 5. ChartAnalysisService

**Purpose**: Provides analytical operations on chart data

**Key Functions**:
- `get_price_range(chart: &TradingChart, start: UnixNanos, end: UnixNanos) -> (Price, Price)` - Get price range
- `get_volume_range(chart: &TradingChart, start: UnixNanos, end: UnixNanos) -> (Quantity, Quantity)` - Get volume range
- `get_bar_at_time(chart: &TradingChart, time: UnixNanos) -> Option<&Bar>` - Get bar at specific time
- `get_bars_in_range(chart: &TradingChart, start: UnixNanos, end: UnixNanos) -> Vec<&Bar>` - Get bars in time range
- `calculate_visible_bar_count(chart: &TradingChart) -> usize` - Count visible bars
- `estimate_optimal_bar_density(chart: &TradingChart, canvas_width: u32) -> usize` - Estimate optimal bars to display

**Location**: `crates/model/src/trading/chart/domain_services/analysis.rs`

### 6. ChartRenderingService

**Purpose**: Coordinates rendering state and prepares data for rendering layer

**Key Functions**:
- `prepare_rendering_data(chart: &TradingChart) -> RenderingData` - Prepare data for rendering
- `get_visible_bars_for_rendering(chart: &TradingChart) -> Vec<BarRenderInfo>` - Get bars formatted for rendering
- `calculate_candlestick_positions(chart: &TradingChart) -> Vec<CandlestickPosition>` - Calculate candlestick positions
- `get_axis_labels(chart: &TradingChart) -> (Vec<TimeLabel>, Vec<PriceLabel>)` - Get axis labels
- `validate_rendering_state(chart: &TradingChart) -> Result<(), ChartError>` - Validate rendering state

**Location**: `crates/model/src/trading/chart/domain_services/rendering.rs`

## Aggregate Root Methods

### Core Operations

```rust
impl TradingChart {
    /// Creates a new TradingChart instance
    pub fn new(chart_id: ChartId, instrument_id: InstrumentId) -> Self;
    
    /// Adds a bar to the chart
    pub fn add_bar(&mut self, bar: Bar);
    
    /// Adds multiple bars to the chart
    pub fn add_bars(&mut self, bars: Vec<Bar>);
    
    /// Removes all bars
    pub fn clear(&mut self);
    
    /// Gets the number of bars
    pub fn bar_count(&self) -> usize;
    
    /// Gets the time range of all bars
    pub fn time_range(&self) -> Option<(UnixNanos, UnixNanos)>;
    
    /// Gets the price range of all bars
    pub fn price_range(&self) -> Option<(Price, Price)>;
    
    /// Updates the canvas dimensions
    pub fn set_canvas_size(&mut self, width: u32, height: u32);
    
    /// Resets viewport to show all data
    pub fn reset_viewport(&mut self);
    
    /// Zooms in by a factor
    pub fn zoom_in(&mut self, factor: f64);
    
    /// Zooms out by a factor
    pub fn zoom_out(&mut self, factor: f64);
    
    /// Sets zoom level
    pub fn set_zoom_level(&mut self, level: f64);
    
    /// Pans the viewport
    pub fn pan(&mut self, delta_time: TimeDelta, delta_price: Price);
    
    /// Zooms to a specific time range
    pub fn zoom_to_time_range(&mut self, start: UnixNanos, end: UnixNanos);
    
    /// Zooms to a specific price range
    pub fn zoom_to_price_range(&mut self, min_price: Price, max_price: Price);
}
```

## Rendering Layer (TypeScript/D3.js)

The rendering layer is separate from the domain model and communicates with the Rust backend through:

1. **Serialization**: TradingChart state is serialized to JSON/MessagePack
2. **API Interface**: REST or WebSocket API exposes chart state
3. **Rendering Components**: TypeScript classes consume chart state and render using D3.js

### TypeScript Structure

```typescript
// Chart rendering using D3.js
class TradingChartRenderer {
    private chart: TradingChartState;
    private svg: d3.Selection<SVGSVGElement, unknown, null, undefined>;
    private xScale: d3.ScaleTime<number, number>;
    private yScale: d3.ScaleLinear<number, number>;
    
    constructor(container: HTMLElement, chartState: TradingChartState) {
        this.chart = chartState;
        this.initializeD3(container);
    }
    
    render(): void {
        this.updateScales();
        this.renderCandlesticks();
        this.renderAxes();
        this.renderGrid();
    }
    
    private updateScales(): void {
        // Update D3 scales based on TradingChart viewport
    }
    
    private renderCandlesticks(): void {
        // Render candlestick chart using D3
    }
    
    private renderAxes(): void {
        // Render time and price axes
    }
    
    private renderGrid(): void {
        // Render grid lines
    }
}
```

## Implementation Phases

### Phase 1: Core Domain Model (Rust)
1. Implement value objects (Viewport, ScaleX, ScaleY, ZoomLevel, ChartId)
2. Implement TradingChart aggregate root
3. Implement basic domain services (ChartDataService, ChartScaleService)
4. Add unit tests

### Phase 2: Advanced Features (Rust)
1. Implement ChartViewportService
2. Implement ChartZoomService
3. Implement ChartAnalysisService
4. Add integration tests

### Phase 3: Rendering Coordination (Rust)
1. Implement ChartRenderingService
2. Add serialization support
3. Create API endpoints (if needed)

### Phase 4: Frontend Rendering (TypeScript)
1. Create TypeScript types matching Rust structures
2. Implement D3.js rendering components
3. Implement zoom/pan interactions
4. Connect to Rust backend via API

## File Tree Structure

```
crates/model/src/trading/chart/
├── mod.rs                              # Module exports
│
├── entity/                             # Aggregate Root
│   ├── mod.rs
│   └── trading_chart.rs               # TradingChart aggregate root
│
├── value_objects/                      # Value Objects
│   ├── mod.rs
│   ├── chart_id.rs                    # ChartId
│   ├── viewport.rs                    # Viewport
│   ├── scale_x.rs                     # ScaleX
│   ├── scale_y.rs                     # ScaleY
│   └── zoom_level.rs                  # ZoomLevel
│
├── domain_services/                    # Domain Services
│   ├── mod.rs
│   ├── data.rs                        # ChartDataService
│   ├── scale.rs                       # ChartScaleService
│   ├── viewport.rs                    # ChartViewportService
│   ├── zoom.rs                        # ChartZoomService
│   ├── analysis.rs                    # ChartAnalysisService
│   └── rendering.rs                   # ChartRenderingService
│
└── errors.rs                           # Domain Errors

# TypeScript/Frontend (separate repository or directory)
frontend/trading-chart/
├── src/
│   ├── types/
│   │   ├── TradingChartState.ts      # TypeScript types matching Rust
│   │   ├── Viewport.ts
│   │   ├── Scale.ts
│   │   └── Bar.ts
│   ├── services/
│   │   ├── ChartApiService.ts        # API communication
│   │   └── ChartStateService.ts      # State management
│   ├── components/
│   │   ├── TradingChartRenderer.ts   # D3.js renderer
│   │   ├── CandlestickChart.ts      # Candlestick rendering
│   │   ├── AxisRenderer.ts          # Axis rendering
│   │   └── GridRenderer.ts          # Grid rendering
│   ├── interactions/
│   │   ├── ZoomHandler.ts           # Zoom interactions
│   │   ├── PanHandler.ts            # Pan interactions
│   │   └── SelectionHandler.ts      # Selection interactions
│   └── utils/
│       ├── d3Helpers.ts              # D3.js utilities
│       └── formatters.ts             # Data formatters
├── package.json
└── tsconfig.json
```

## Usage Example

### Rust (Backend)

```rust
use nautilus_trader::model::trading::chart::{TradingChart, ChartId};
use nautilus_trader::model::trading::chart::domain_services::*;

// Create chart
let mut chart = TradingChart::new(
    ChartId::new("chart_001"),
    instrument_id,
);

// Add bars
chart.add_bars(bars);

// Set canvas size
chart.set_canvas_size(1200, 800);

// Auto-fit viewport
ChartViewportService::auto_fit_viewport(&mut chart, 1200, 800);

// Zoom in
chart.zoom_in(1.5);

// Pan
chart.pan(TimeDelta::hours(1), Price::zero());

// Prepare for rendering
let rendering_data = ChartRenderingService::prepare_rendering_data(&chart);
```

### TypeScript (Frontend)

```typescript
// Fetch chart state from API
const chartState = await chartApiService.getChartState('chart_001');

// Create renderer
const renderer = new TradingChartRenderer(containerElement, chartState);

// Render chart
renderer.render();

// Handle zoom
renderer.onZoom((factor) => {
    chartApiService.updateZoom('chart_001', factor);
});

// Handle pan
renderer.onPan((deltaTime, deltaPrice) => {
    chartApiService.updatePan('chart_001', deltaTime, deltaPrice);
});
```

## Design Principles

1. **Separation of Concerns**: Domain logic (Rust) is separate from presentation (TypeScript)
2. **Single Source of Truth**: TradingChart aggregate root is the authoritative state
3. **Immutability Where Possible**: Value objects are immutable
4. **Service Layer**: Complex operations delegated to domain services
5. **Performance**: Efficient data structures for large bar collections
6. **Extensibility**: Easy to add new chart types and rendering options

## References

- TradingView Charting Library: https://www.tradingview.com/charting-library/
- D3.js Documentation: https://d3js.org/
- Domain-Driven Design: https://www.domainlanguage.com/
- NautilusTrader OrderBook Implementation: `crates/model/src/orderbook/`

