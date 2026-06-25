# NautilusTrader Message Bus Handler Binding Matrix

## Overview
This document describes all possible message bus topics and their corresponding handlers in the NautilusTrader system, organized by component and message type.

---

## 1. Data Engine Topics & Handlers

### Static Endpoints (Point-to-Point)

| Endpoint Name | Endpoint Pattern | Handler Type | Handler Component | Priority |
|---------------|------------------|--------------|-------------------|----------|
| `DataEngine.queue_execute` | `DataEngine.queue_execute` | `DataCommand` | DataEngine | N/A (queued) |
| `DataEngine.execute` | `DataEngine.execute` | `DataCommand` | DataEngine | N/A (direct) |
| `DataEngine.process` | `DataEngine.process` | `Data` | DataEngine | N/A |
| `DataEngine.process_data` | `DataEngine.process_data` | Data objects | DataEngine | N/A |
| `DataEngine.response` | `DataEngine.response` | `DataResponse` | DataEngine | N/A |

### Publish/Subscribe Topics (Market Data)

| Topic Pattern | Message Type | Subscribers | Priority | Notes |
|---------------|--------------|-------------|----------|-------|
| `data.quotes.{venue}.{symbol}` | `QuoteTick` | BarAggregator (quotes), Portfolio, DataActor | 10 (Portfolio) | High-frequency quotes for bar aggregation |
| `data.trades.{venue}.{symbol}` | `TradeTick` | BarAggregator (trades), DataActor | None | Trades for bar aggregation |
| `data.bars.{bar_type}` | `Bar` | BarAggregator (bars), Portfolio (EXTERNAL) | 10 (Portfolio) | Bars for higher-level aggregation |
| `data.book.deltas.{venue}.{symbol}` | `OrderBookDeltas` | BookUpdater, BookSnapshotter, DataActor | None | Incremental book updates |
| `data.book.depth10.{venue}.{symbol}` | `OrderBookDepth10` | BookUpdater, DataActor | None | Normalized depth-10 snapshots |
| `data.book.snapshots.{venue}.{symbol}.{interval_ms}` | `OrderBook` | BookSnapshotter | None | Periodic book snapshots |
| `data.instrument.{venue}` | `InstrumentAny` | ExecutionEngine, DataActor | None | All instruments for a venue |
| `data.instrument.{venue}.{symbol}` | `InstrumentAny` | ExecutionEngine, DataActor | None | Specific instrument updates |
| `data.mark_prices.{venue}.{symbol}` | `MarkPriceUpdate` | Portfolio | 10 | Mark price for PnL calculation |
| `data.index_prices.{venue}.{symbol}` | `IndexPriceUpdate` | Portfolio | 10 | Index price for PnL calculation |
| `data.funding_rates.{venue}.{symbol}` | `FundingRateUpdate` | Portfolio | None | Funding rate updates |
| `data.status.{venue}.{symbol}` | `InstrumentStatus` | DataActor | None | Instrument status changes |
| `data.close.{venue}.{symbol}` | Close events | DataActor | None | Instrument close events |
| `data.option_greeks.{venue}.{symbol}` | `OptionGreeks` | Portfolio, DataActor | None | Option Greeks data |
| `data.option_chain.{series_id}` | `OptionChainSlice` | Portfolio, DataActor | None | Option chain data |

### Pipeline Topics (Processed Data)

| Topic Pattern | Message Type | Purpose | Notes |
|---------------|--------------|---------|-------|
| `data.pipeline.quotes.{venue}.{symbol}` | `QuoteTick` | Post-processed quotes | Used for data quality checks |
| `data.pipeline.trades.{venue}.{symbol}` | `TradeTick` | Post-processed trades | Used for data quality checks |
| `data.pipeline.bars.{bar_type}` | `Bar` | Post-processed bars | Used for data quality checks |
| `data.pipeline.book.deltas.{venue}.{symbol}` | `OrderBookDeltas` | Post-processed deltas | Used for data quality checks |
| `data.pipeline.mark_prices.{venue}.{symbol}` | `MarkPriceUpdate` | Post-processed mark prices | Used for data quality checks |

### Signal Topics (Custom User Data)

| Topic Pattern | Message Type | Purpose | Notes |
|---------------|--------------|---------|-------|
| `data.Signal{TitleName}` | Custom types | User-defined signals | Strategy indicators |
| `data.Signal*` | Custom types | All signals | Wildcard subscription |

### DeFi Topics (Conditional)

| Topic Pattern | Message Type | Subscribers | Priority |
|---------------|--------------|-------------|----------|
| `data.defi.blocks` | `Block` | DeFiPoolUpdater | None |
| `data.defi.pools` | `Pool` | DeFiPoolUpdater | None |
| `data.defi.swaps.{venue}.{symbol}` | `PoolSwap` | DeFiPoolUpdater | None |
| `data.defi.liquidity.{venue}.{symbol}` | `PoolLiquidityUpdate` | DeFiPoolUpdater | None |
| `data.defi.collects.{venue}.{symbol}` | `PoolFeeCollect` | DeFiPoolUpdater | None |
| `data.defi.flash.{venue}.{symbol}` | `PoolFlash` | DeFiPoolUpdater | None |

---

## 2. Execution Engine Topics & Handlers

### Static Endpoints (Point-to-Point)

| Endpoint Name | Endpoint Pattern | Handler Type | Handler Component | Priority |
|---------------|------------------|--------------|-------------------|----------|
| `ExecEngine.execute` | `ExecEngine.execute` | `TradingCommand` | ExecutionEngine | N/A (direct) |
| `ExecEngine.queue_execute` | `ExecEngine.queue_execute` | `TradingCommand` | ExecutionEngine | N/A (queued) |
| `ExecEngine.process` | `ExecEngine.process` | `OrderEventAny` | ExecutionEngine, RiskEngine | N/A |
| `ExecEngine.reconcile_execution_report` | `ExecEngine.reconcile_execution_report` | `ExecutionReport` | ExecutionEngine | N/A |

### Publish/Subscribe Topics (Order Events)

| Topic Pattern | Message Type | Subscribers | Priority | Notes |
|---------------|--------------|-------------|----------|-------|
| `events.order.{strategy_id}` | `OrderEventAny` | Strategy, Portfolio, RiskEngine | None | Strategy-specific order events |
| `events.order.*` | `OrderEventAny` | Portfolio, RiskEngine | 10 (Portfolio) | All order events |

### Reconciliation Topics (Event Store)

| Topic Pattern | Message Type | Purpose | Notes |
|---------------|--------------|---------|-------|
| `reconciliation.raw.OrderStatusReport` | `OrderStatusReport` | EventStore | None | Raw order status for forensic replay |
| `reconciliation.raw.FillReport` | `FillReport` | EventStore | None | Raw fill reports for forensic replay |
| `reconciliation.raw.PositionStatusReport` | `PositionStatusReport` | EventStore | None | Raw position reports for forensic replay |

---

## 3. Risk Engine Topics & Handlers

### Static Endpoints (Point-to-Point)

| Endpoint Name | Endpoint Pattern | Handler Type | Handler Component | Priority |
|---------------|------------------|--------------|-------------------|----------|
| `RiskEngine.execute` | `RiskEngine.execute` | `TradingCommand` | RiskEngine | N/A (direct) |
| `RiskEngine.queue_execute` | `RiskEngine.queue_execute` | `TradingCommand` | RiskEngine | N/A (queued) |
| `RiskEngine.process` | `RiskEngine.process` | `OrderEventAny` | RiskEngine | N/A |

### Publish/Subscribe Topics (Risk Events)

| Topic Pattern | Message Type | Subscribers | Priority | Notes |
|---------------|--------------|-------------|----------|-------|
| `events.risk` | `RiskEvent` | Trader, EventStore | None | Risk engine events |

---

## 4. Portfolio Topics & Handlers

### Static Endpoints (Point-to-Point)

| Endpoint Name | Endpoint Pattern | Handler Type | Handler Component | Priority |
|---------------|------------------|--------------|-------------------|----------|
| `Portfolio.update_account` | `Portfolio.update_account` | `AccountState` | Portfolio | N/A |
| `Portfolio.update_order` | `Portfolio.update_order` | `OrderAny` | Portfolio | N/A |

### Publish/Subscribe Topics (Portfolio Events)

| Topic Pattern | Message Type | Subscribers | Priority | Notes |
|---------------|--------------|-------------|----------|-------|
| `events.account.{account_id}` | `AccountState` | Portfolio, Trader | 10 (Portfolio) | Account state changes |
| `events.account.*` | `AccountState` | Portfolio, Trader | 10 (Portfolio) | All account state changes |
| `events.position.{strategy_id}` | `PositionEvent` | Strategy, Portfolio, Trader | None | Strategy-specific position events |
| `events.position.*` | `PositionEvent` | Portfolio, Trader | 10 (Portfolio) | All position events |
| `portfolio.snapshots` | `PortfolioSnapshot` | Portfolio, Trader | None | Portfolio snapshots for analysis |

---

## 5. Strategy Topics & Handlers

### Static Endpoints (Point-to-Point)

| Endpoint Name | Endpoint Pattern | Handler Type | Handler Component | Priority |
|---------------|------------------|--------------|-------------------|----------|
| `Strategy.{strategy_id}.execute` | `Strategy.{strategy_id}.execute` | `TradingCommand` | Strategy | N/A |
| `Strategy.{strategy_id}.orders` | `Strategy.{strategy_id}.orders` | `OrderEventAny` | Strategy | N/A |
| `Strategy.{strategy_id}.positions` | `Strategy.{strategy_id}.positions` | `PositionEvent` | Strategy | N/A |

### Publish/Subscribe Topics (Strategy Data)

| Topic Pattern | Message Type | Subscribers | Priority | Notes |
|---------------|--------------|-------------|----------|-------|
| `events.order.{strategy_id}` | `OrderEventAny` | Strategy | None | Strategy's order events |
| `events.position.{strategy_id}` | `PositionEvent` | Strategy | None | Strategy's position events |
| `data.quotes.{venue}.{symbol}` | `QuoteTick` | Strategy | None | Market data for strategies |
| `data.trades.{venue}.{symbol}` | `TradeTick` | Strategy | None | Market data for strategies |
| `data.bars.{bar_type}` | `Bar` | Strategy | None | Market data for strategies |
| `data.book.deltas.{venue}.{symbol}` | `OrderBookDeltas` | Strategy | None | Market data for strategies |
| `data.book.depth10.{venue}.{symbol}` | `OrderBookDepth10` | Strategy | None | Market data for strategies |
| `data.Signal*` | Custom signals | Strategy | None | User-defined signals |

---

## 6. Trader Topics & Handlers

### Static Endpoints (Point-to-Point)

| Endpoint Name | Endpoint Pattern | Handler Type | Handler Component | Priority |
|---------------|------------------|--------------|-------------------|----------|
| `Trader.command` | `Trader.command` | `TraderCommand` | Trader | N/A |

### Publish/Subscribe Topics (System Events)

| Topic Pattern | Message Type | Subscribers | Priority | Notes |
|---------------|--------------|-------------|----------|-------|
| `events.order.{strategy_id}` | `OrderEventAny` | Trader | None | Order events for trader monitoring |
| `events.position.{strategy_id}` | `PositionEvent` | Trader | None | Position events for trader monitoring |
| `commands.system.shutdown` | `ShutdownSystem` | Kernel, System components | None | System shutdown signal |

---

## 7. Order Emulator Topics & Handlers

### Static Endpoints (Point-to-Point)

| Endpoint Name | Endpoint Pattern | Handler Type | Handler Component | Priority |
|---------------|------------------|--------------|-------------------|----------|
| `OrderEmulator.execute` | `OrderEmulator.execute` | `TradingCommand` | OrderEmulator | N/A |

---

## 8. Event Store Topics & Handlers

### Publish/Subscribe Topics (Event Capture)

| Topic Pattern | Message Type | Subscribers | Priority | Notes |
|---------------|--------------|-------------|----------|-------|
| `*` | All types | EventStore | None | Wildcard capture for persistence |
| `reconciliation.raw.OrderStatusReport` | `OrderStatusReport` | EventStore | None | Raw order status for replay |
| `reconciliation.raw.FillReport` | `FillReport` | EventStore | None | Raw fill reports for replay |
| `reconciliation.raw.PositionStatusReport` | `PositionStatusReport` | EventStore | None | Raw position reports for replay |

---

## 9. System Topics & Handlers

### Static Endpoints (Point-to-Point)

| Endpoint Name | Endpoint Pattern | Handler Type | Handler Component | Priority |
|---------------|------------------|--------------|-------------------|----------|
| `Clock.time_event` | `clock.time_event` | `TimeEvent` | TimeEvent handlers | N/A |

### Publish/Subscribe Topics (System Events)

| Topic Pattern | Message Type | Subscribers | Priority | Notes |
|---------------|--------------|-------------|----------|-------|
| `clock.time_event` | `TimeEvent` | All time event subscribers | None | Time events for timers |
| `commands.system.shutdown` | `ShutdownSystem` | Kernel, System components | None | Graceful shutdown signal |

---

## 10. Data Actor Topics & Handlers

### Publish/Subscribe Topics (Data Forwarding)

| Topic Pattern | Message Type | Subscribers | Priority | Notes |
|---------------|--------------|-------------|----------|-------|
| `data.instrument.{venue}.{symbol}` | `InstrumentAny` | DataActor | None | Instrument updates |
| `data.quotes.{venue}.{symbol}` | `QuoteTick` | DataActor | None | Market data forwarding |
| `data.trades.{venue}.{symbol}` | `TradeTick` | DataActor | None | Market data forwarding |
| `data.bars.{bar_type}` | `Bar` | DataActor | None | Market data forwarding |
| `data.book.deltas.{venue}.{symbol}` | `OrderBookDeltas` | DataActor | None | Market data forwarding |
| `data.book.depth10.{venue}.{symbol}` | `OrderBookDepth10` | DataActor | None | Market data forwarding |
| `data.book.snapshots.{venue}.{symbol}.{interval_ms}` | `OrderBook` | DataActor | None | Market data forwarding |
| `data.mark_prices.{venue}.{symbol}` | `MarkPriceUpdate` | DataActor | None | Market data forwarding |
| `data.index_prices.{venue}.{symbol}` | `IndexPriceUpdate` | DataActor | None | Market data forwarding |
| `data.funding_rates.{venue}.{symbol}` | `FundingRateUpdate` | DataActor | None | Market data forwarding |
| `data.option_greeks.{venue}.{symbol}` | `OptionGreeks` | DataActor | None | Market data forwarding |
| `data.option_chain.{series_id}` | `OptionChainSlice` | DataActor | None | Market data forwarding |

---

## 11. Option Chain Manager Topics & Handlers

### Publish/Subscribe Topics (Option Chain Data)

| Topic Pattern | Message Type | Subscribers | Priority | Notes |
|---------------|--------------|-------------|----------|-------|
| `data.quotes.{venue}.{symbol}` | `QuoteTick` | OptionChainManager | Configured | Quote data for option chains |
| `data.option_greeks.{venue}.{symbol}` | `OptionGreeks` | OptionChainManager | Configured | Greeks data for option chains |

---

## Component-to-Topic Mapping Summary

### Data Engine
- **Subscribes to**: Various data client responses
- **Publishes to**: All `data.*` topics, `data.pipeline.*` topics
- **Handles via endpoints**: `DataEngine.*` endpoints

### Execution Engine
- **Subscribes to**: `data.instrument.*` (for venue instruments)
- **Publishes to**: `events.order.*`, reconciliation topics
- **Handles via endpoints**: `ExecEngine.*` endpoints

### Risk Engine
- **Subscribes to**: `events.order.*`, `events.position.*`
- **Publishes to**: `events.risk`, forwarded commands to `ExecEngine`
- **Handles via endpoints**: `RiskEngine.*` endpoints

### Portfolio
- **Subscribes to**: `data.quotes.*`, `data.bars.*EXTERNAL`, `data.mark_prices.*`, `events.order.*`, `events.position.*`, `events.account.*`
- **Publishes to**: `portfolio.snapshots`
- **Handles via endpoints**: `Portfolio.*` endpoints

### Strategy
- **Subscribes to**: `events.order.{strategy_id}`, `events.position.{strategy_id}`, market data topics
- **Publishes to**: None (consumes only)
- **Handles via endpoints**: `Strategy.{strategy_id}.*` endpoints

### Event Store
- **Subscribes to**: `*` (wildcard), reconciliation topics
- **Publishes to**: None (consumer only)
- **Handles via endpoints**: None (consumer only)

---

## Priority Levels

| Priority | Usage | Components |
|----------|-------|------------|
| 10 | High priority (early processing) | Portfolio, RiskEngine |
| 5-9 | Medium priority | OptionChainManager |
| 1-4 | Low priority | Data quality checks |
| None | Default (last) | Most components |

---

## Message Flow Patterns

### 1. Market Data Flow
```
DataClient → DataEngine → data.quotes.* → BarAggregator → data.bars.* → Strategy
                                     ↘ Portfolio (PnL updates)
```

### 2. Order Flow
```
Strategy → TradingCommand → RiskEngine (check) → ExecEngine (execute)
                                       ↓
                                 events.order.* → Portfolio, Strategy
```

### 3. Risk Flow
```
ExecEngine → events.order.* → RiskEngine → Deny/Forward
                                           ↓
                                     events.risk
```

### 4. Position Flow
```
ExecEngine → events.position.* → Portfolio → portfolio.snapshots
```

---

## Type Mapping

| Message Type | Routing Mechanisms | Handler Routes |
|--------------|-------------------|----------------|
| QuoteTick | ✓ (router_quotes), ✓ (endpoints_quotes), Any-based | BarAggregator (quotes), Portfolio, DataActor, Strategy, OptionChainManager |
| TradeTick | ✓ (router_trades), ✓ (endpoints_trades), Any-based | BarAggregator (trades), DataActor, Strategy |
| Bar | ✓ (router_bars), ✓ (endpoints_bars), Any-based | BarAggregator (bars), Portfolio (EXTERNAL), Strategy |
| OrderBookDeltas | ✓ (router_deltas), Any-based | BookUpdater, BookSnapshotter, DataActor |
| OrderBookDepth10 | ✓ (router_depth10), Any-based | BookUpdater, DataActor |
| OrderBook | ✓ (router_book_snapshots), Any-based | BookSnapshotter |
| OrderEventAny | ✓ (router_order_events), ✓ (endpoints_order_events), Any-based | Strategy, Portfolio, RiskEngine, Trader |
| PositionEvent | ✓ (router_position_events), Any-based | Strategy, Portfolio, Trader |
| AccountState | ✓ (router_account_state), ✓ (endpoints_account_state), Any-based | Portfolio, Trader |
| PortfolioSnapshot | ✓ (router_portfolio), Any-based | Portfolio, Trader |
| InstrumentAny | ✓ (router_instruments), Any-based | ExecutionEngine, DataActor |
| TradingCommand | ✓ (endpoints_trading_commands), Any-based | ExecutionEngine (direct & queue), RiskEngine (direct & queue), OrderEmulator |
| DataCommand | ✓ (endpoints_data_commands), Any-based | DataEngine (direct & queue) |
| DataResponse | ✓ (endpoints_data_responses), Any-based | DataEngine |
| ExecutionReport | ✓ (endpoints_exec_reports), Any-based | ExecutionEngine (reconciliation) |
| Data | ✓ (endpoints_data), Any-based | DataEngine (processed data) |
| MarkPriceUpdate | ✓ (router_mark_prices), Any-based | Portfolio, DataActor |
| IndexPriceUpdate | ✓ (router_index_prices), Any-based | Portfolio, DataActor |
| FundingRateUpdate | ✓ (router_funding_rates), Any-based | Portfolio, DataActor |
| OptionGreeks | ✓ (router_option_greeks), Any-based | Portfolio, DataActor |
| OptionChainSlice | ✓ (router_option_chain), Any-based | Portfolio, DataActor |
| Position | ✓ (router_positions), Any-based | (internal position routing) |
| OrderAny | ✓ (router_orders), Any-based | (internal order routing) |
| GreeksData | ✓ (router_greeks), Any-based | (internal greeks routing) |

---

## Notes

1. **Wildcards**: Topics support `*` (multi-character) and `?` (single-character) wildcards
2. **Priority**: Higher priority handlers receive messages before lower priority ones
3. **Routing**: Two separate routing paths exist (typed vs Any-based) for performance and flexibility
4. **Caching**: The switchboard caches topic strings to avoid repeated allocations
5. **Patterns**: Composite instruments use wildcard patterns (e.g., `data.book.deltas.{venue}.ES*`)
6. **Re-entrancy**: Queued endpoints support re-entrant handler calls

---

## Future Improvements

1. **Static validation**: Generate compile-time verification of critical subscriptions
2. **Visualization**: Create directed graphs showing message flow
3. **Metrics**: Track subscription counts and handler performance
4. **Testing**: Add tests to verify handler registration completeness
5. **Documentation**: Auto-generate API docs from this matrix