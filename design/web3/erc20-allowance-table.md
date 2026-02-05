# Erc20 and Erc721 Allowance Table Structure and Model

Structure and data model of the allowance table in `components/allowances/dashboard/` (AllowanceDashboard and related components).

---

## 1. Data Model

**Row data:** `TokenAllowanceData` = `TokenData` + optional `AllowancePayload`.

```typescript
interface TokenData {
  contract: Erc20TokenContract | Erc721TokenContract;
  metadata: TokenMetadata;  // symbol, decimals, price, icon
  chainId: number;
  owner: Address;
  balance: TokenBalance;
}

type AllowancePayload =
  | Erc721SingleAllowance | Erc721AllAllowance
  | Erc20Allowance | Permit2Erc20Allowance;

interface BaseAllowance {
  type: AllowanceType;
  spender: Address;
  spenderData?: Nullable<SpenderRiskData>;
  lastUpdated: TimeLog;
  revokeError?: string;
  preparedRevoke?: WriteContractParameters;
}
```

**Row ID:** `${chainId}-${contract.address}-${spender}-${tokenId}`.

---

## 2. Table and Columns (TanStack Table v8)

- **Framework:** `@tanstack/react-table`
- **Features:** Row selection (rows with `revokeError` disabled), sorting (default: LAST_UPDATED desc), column filters, column visibility (Balance hidden by default). Sort/filter state in localStorage.

| Column        | Cell           | Behavior |
|---------------|----------------|----------|
| SELECT        | SelectCell     | Checkbox; footer has global select |
| SYMBOL        | AssetCell      | Sortable; footer has batch revoke |
| ASSET_TYPE    | AssetTypeCell  | Filterable (Token/NFT) |
| BALANCE       | —              | Filterable (Zero/Non-Zero), hidden by default |
| ALLOWANCE     | AllowanceCell  | Sortable, filterable, editable (ERC20) |
| VALUE_AT_RISK| ValueAtRiskCell| Sortable (USD value) |
| SPENDER       | SpenderCell    | Sortable, filterable (text search) |
| LAST_UPDATED  | LastUpdatedCell| Sortable (timestamp) |
| ACTIONS       | ControlsCell   | Revoke/update |

**Accessors:** Custom accessors in `columns.tsx` map each row to a single value per column for sorting/filtering. Cells get `info.row.original` (full `TokenAllowanceData`) and/or `info.getValue()` (accessor result); `info.table.options.meta.onUpdate` is the shared update callback.

**Sorting:** allowance (Unlimited handling), spender (named first), timestamp. **Filtering:** assetType (Token/NFT), balance (Zero/Non-Zero), allowance (Unlimited/Limited/None), spender (text search).

---

## 3. Controls and Component Tree

**Top bar (AllowanceTableControls):** SortSelect, FilterSelect, AllowanceSearchBox (debounced spender search), WalletHealthSection (allowance count, value at risk, risk factors).

**Row/Footer:** SelectCell (checkbox + tooltip on revokeError), AllowanceCell (formatted value + ERC20 edit + Permit2 expiry), ControlsCell (revoke/update via useRevoke), GlobalSelectCell in footer (select all, indeterminate state).

```
AllowanceDashboard
├── AllowanceTableControls → SortSelect, FilterSelect, AllowanceSearchBox, WalletHealthSection
└── Table
    ├── Header
    ├── Body → Rows → SelectCell, AssetCell, AssetTypeCell, AllowanceCell, ValueAtRiskCell, SpenderCell, LastUpdatedCell, ControlsCell
    └── Footer → GlobalSelectCell, RevokeSelectedButton
```

---

## 4. Data Flow

```
AddressPageContext → useAddressAllowances() → TokenAllowanceData[]
    → AllowanceDashboard → useReactTable → Columns/Cells
    → User actions → onUpdate → AddressPageContext → refetch
```

- **AddressPageContext:** Holds address, selectedChainId, eventContext, allowanceContext; composes useEvents + useAllowances.
- **useEvents:** React Query `['events', address, chainId]` → `TokenEvent[]`; input to getAllowancesFromEvents.
- **useAllowances:** Builds `TokenAllowanceData[]` from events (getAllowancesFromEvents) and enriches with tokenPrice + spenderData. Keeps mutable `baseAllowances`; **onUpdate** / **onRevoke** are the only mutations. Returns `allowances` (with price/spender merged).
- **AllowanceDashboard:** Passes allowances as table data and `onUpdate` in table meta. Holds rowSelection; syncs selection when data changes.
- **Controls (Sort/Filter/Search):** Drive table state only; no effect on row data. Filters: AND within groups, OR between groups.
- **Update:** onUpdate (in meta) updates/removes rows in baseAllowances after revoke/update and invalidates blockNumber/walletHealthScore for refetch.

---

## 5. State and Behaviors

- **Table state:** TanStack Table (sorting, filtering, selection); persistence in localStorage for sort and filters.
- **Data:** React Query in useAllowances; context exposes loading/error.
- **Row ID:** chain + contract + spender + tokenId. **Selection:** Synced when data changes; revokeError rows disabled.
- **Empty:** NoAllowancesFound (no data vs filtered out). **Errors:** ErrorDisplay for fetch errors; revokeError rows visible but disabled.
