crates/model/src/
├── lib.rs
├── macros.rs
│
├── shared_kernel/                    # Shared Kernel
│   ├── mod.rs
│   ├── value_objects/                # Value Objects
│   │   ├── mod.rs
│   │   ├── identifiers/
│   │   │   ├── mod.rs
│   │   │   ├── account_id.rs
│   │   │   ├── actor_id.rs
│   │   │   ├── client_id.rs
│   │   │   ├── client_order_id.rs
│   │   │   ├── component_id.rs
│   │   │   ├── exec_algorithm_id.rs
│   │   │   ├── instrument_id.rs
│   │   │   ├── order_list_id.rs
│   │   │   ├── position_id.rs
│   │   │   ├── strategy_id.rs
│   │   │   ├── symbol.rs
│   │   │   ├── trade_id.rs
│   │   │   ├── trader_id.rs
│   │   │   ├── venue_order_id.rs
│   │   │   └── venue.rs
│   │   ├── types/
│   │   │   ├── mod.rs
│   │   │   ├── currency.rs
│   │   │   ├── money.rs
│   │   │   ├── price.rs
│   │   │   ├── quantity.rs
│   │   │   ├── balance.rs
│   │   │   └── fixed.rs
│   │   ├── currencies.rs
│   │   └── venues.rs
│   └── enums.rs                      # Domain enumerations
│
├── trading/                          # Trading Bounded Context
│   ├── mod.rs
│   │
│   ├── instrument/                  # Instrument Aggregate
│   │   ├── mod.rs
│   │   ├── entity/                   # Entities
│   │   │   ├── mod.rs
│   │   │   ├── instrument.rs         # Instrument trait & InstrumentAny
│   │   │   ├── currency_pair.rs
│   │   │   ├── equity.rs
│   │   │   ├── futures_contract.rs
│   │   │   ├── futures_spread.rs
│   │   │   ├── option_contract.rs
│   │   │   ├── option_spread.rs
│   │   │   ├── crypto_perpetual.rs
│   │   │   ├── crypto_future.rs
│   │   │   ├── crypto_option.rs
│   │   │   ├── betting.rs
│   │   │   ├── binary_option.rs
│   │   │   └── synthetic.rs
│   │   └── value_objects/            # Value Objects (if any)
│   │       └── mod.rs
│   │
│   ├── order/                        # Order Aggregate
│   │   ├── mod.rs
│   │   ├── entity/                   # Entities
│   │   │   ├── mod.rs
│   │   │   ├── order.rs              # Order trait & OrderAny
│   │   │   ├── order_core.rs         # OrderCore shared implementation
│   │   │   ├── limit.rs
│   │   │   ├── market.rs
│   │   │   ├── stop_limit.rs
│   │   │   ├── stop_market.rs
│   │   │   ├── limit_if_touched.rs
│   │   │   ├── market_if_touched.rs
│   │   │   ├── market_to_limit.rs
│   │   │   ├── trailing_stop_limit.rs
│   │   │   ├── trailing_stop_market.rs
│   │   │   └── list.rs               # OrderList aggregate
│   │   ├── value_objects/            # Value Objects
│   │   │   └── mod.rs
│   │   ├── domain_services/         # Domain Services
│   │   │   ├── mod.rs
│   │   │   └── builder.rs            # OrderTestBuilder
│   │   └── errors.rs                 # Domain Errors
│   │
│   ├── position/                     # Position Aggregate
│   │   ├── mod.rs
│   │   ├── entity/                   # Entities
│   │   │   ├── mod.rs
│   │   │   └── position.rs
│   │   └── value_objects/            # Value Objects (if any)
│   │       └── mod.rs
│   │
│   ├── orderbook/                    # OrderBook Aggregate
│   │   ├── mod.rs
│   │   ├── entity/                    # Entities
│   │   │   ├── mod.rs
│   │   │   ├── book.rs               # OrderBook aggregate root
│   │   │   └── ladder.rs            # BookLadder (internal entity)
│   │   ├── value_objects/            # Value Objects
│   │   │   ├── mod.rs
│   │   │   ├── level.rs             # BookLevel
│   │   │   └── own.rs               # OwnBookOrder, OwnOrderBook
│   │   ├── domain_services/         # Domain Services
│   │   │   ├── mod.rs
│   │   │   ├── aggregation.rs       # pre_process_order, etc.
│   │   │   ├── analysis.rs          # get_quantity_for_price, etc.
│   │   │   └── display.rs           # pprint_book, etc.
│   │   └── errors.rs                # Domain Errors
│   │
│   ├── market_data/                  # Market Data Value Objects
│   │   ├── mod.rs
│   │   ├── quote_tick.rs
│   │   ├── trade_tick.rs
│   │   ├── bar.rs
│   │   ├── delta.rs
│   │   ├── deltas.rs
│   │   ├── depth.rs
│   │   ├── order.rs                  # BookOrder
│   │   ├── prices.rs
│   │   ├── funding.rs
│   │   ├── greeks.rs
│   │   ├── status.rs
│   │   ├── close.rs
│   │   └── bet.rs
│   │
│   └── events/                       # Trading Domain Events
│       ├── mod.rs
│       ├── order/
│       │   ├── mod.rs
│       │   ├── order_event.rs        # Base event trait/type
│       │   ├── accepted.rs
│       │   ├── canceled.rs
│       │   ├── denied.rs
│       │   ├── emulated.rs
│       │   ├── expired.rs
│       │   ├── filled.rs
│       │   ├── initialized.rs
│       │   ├── modify_rejected.rs
│       │   ├── cancel_rejected.rs
│       │   ├── pending_cancel.rs
│       │   ├── pending_update.rs
│       │   ├── rejected.rs
│       │   ├── released.rs
│       │   ├── submitted.rs
│       │   ├── triggered.rs
│       │   ├── updated.rs
│       │   ├── snapshot.rs
│       │   └── any.rs
│       └── position/
│           ├── mod.rs
│           ├── position_event.rs     # Base event trait/type
│           ├── opened.rs
│           ├── closed.rs
│           ├── changed.rs
│           ├── adjusted.rs
│           └── snapshot.rs
│
├── account/                          # Account Management Bounded Context
│   ├── mod.rs
│   │
│   ├── account/                      # Account Aggregate
│   │   ├── mod.rs
│   │   ├── entity/                   # Entities
│   │   │   ├── mod.rs
│   │   │   ├── account.rs            # Account trait & AccountAny
│   │   │   ├── base.rs
│   │   │   ├── cash.rs
│   │   │   └── margin.rs
│   │   └── value_objects/            # Value Objects (if any)
│   │       └── mod.rs
│   │
│   └── events/                       # Account Domain Events
│       ├── mod.rs
│       ├── account_event.rs          # Base event trait/type
│       └── state.rs                  # AccountState
│
├── defi/                             # DeFi Bounded Context
│   ├── mod.rs
│   ├── entity/                       # Entities
│   │   ├── mod.rs
│   │   ├── chain.rs
│   │   ├── token.rs
│   │   ├── dex.rs
│   │   ├── amm.rs
│   │   └── wallet.rs
│   ├── value_objects/                # Value Objects
│   │   ├── mod.rs
│   │   └── types/
│   │       ├── mod.rs
│   │       ├── money.rs
│   │       ├── price.rs
│   │       └── quantity.rs
│   ├── domain_services/              # Domain Services
│   │   ├── mod.rs
│   │   ├── tick_map/
│   │   │   ├── mod.rs
│   │   │   ├── tick.rs
│   │   │   ├── tick_math.rs
│   │   │   ├── tick_bitmap.rs
│   │   │   ├── bit_math.rs
│   │   │   ├── full_math.rs
│   │   │   ├── liquidity_math.rs
│   │   │   └── sqrt_price_math.rs
│   │   └── pool_analysis/
│   │       ├── mod.rs
│   │       ├── position.rs
│   │       ├── quote.rs
│   │       ├── size_estimator.rs
│   │       ├── snapshot.rs
│   │       ├── swap_math.rs
│   │       ├── compare.rs
│   │       └── profiler.rs
│   ├── events/                       # DeFi Domain Events & Data
│   │   ├── mod.rs
│   │   ├── block.rs
│   │   ├── transaction.rs
│   │   ├── swap.rs
│   │   ├── swap_trade_info.rs
│   │   ├── collect.rs
│   │   ├── flash.rs
│   │   └── liquidity.rs
│   ├── hex.rs                        # Utility
│   ├── rpc.rs                        # Infrastructure (could move)
│   ├── reporting.rs                  # Application layer
│   └── validation.rs                 # Domain service
│
├── reporting/                        # Application/Query Layer
│   ├── mod.rs
│   ├── fill.rs
│   ├── order.rs
│   ├── position.rs
│   └── mass_status.rs
│
└── infrastructure/                   # Infrastructure Layer
    ├── ffi/                          # FFI bindings
    │   └── ... (same structure as before)
    └── python/                       # Python bindings
        └── ... (same structure as before)