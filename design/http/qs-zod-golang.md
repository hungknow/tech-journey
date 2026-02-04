# Query String Parsing with qs (Go)

Parse complex URL query strings (filters, sort, pagination) into a typed structure in a Go backend using [github.com/zaytracom/qs](https://pkg.go.dev/github.com/zaytracom/qs@v1.0.2).

---

## Data flow

**URL:**  
`GET /users?age[gte]=21&role=admin&name[like]=john&sort=age:desc,name:asc`

**After qs:**  
Parsed into nested maps/structs, e.g. `age: { gte: 21 }`, `role: "admin"`, `name: { like: "john" }`, `sort: "age:desc,name:asc"` or `sort[]=age:desc&sort[]=name:asc` → `sort: ["age:desc", "name:asc"]`.

**Handler / middleware:** Coerce numbers and dates, validate enums, interpret `like` as substring match, parse `sort` as `column:direction` (default `asc`), apply defaults for `page`/`limit`.

**Attached to request/context:**

```go
SearchQuery[UserFilters]{
    Pagination: Pagination{Page: 1, Limit: 10},
    Filters: UserFilters{
        Age:     &IntFilter{Gte: ptr(21)},
        Role:    &StringFilter{Eq: ptr("admin")},
        Name:    &StringFilter{Like: ptr("john")},
    },
    Sort: []SortSpec{
        {Field: "age", Order: "desc"},
        {Field: "name", Order: "asc"},
    },
}
```

Use `SearchQuery.Sort` for multi-column `ORDER BY` (e.g. `ORDER BY age DESC, name ASC`). The generic `SearchQuery[T]` lets you pass the concrete filter type to child methods without type assertions.

---

## Install

```bash
go get github.com/zaytracom/qs/v1
```

---

## Types & helpers — `search_types.go`

Filter config is defined with **structs** and **query tags**. Operator structs (eq, gte, like, etc.) match the shape produced by qs so `qs.Unmarshal` can fill them. Validation is done after unmarshaling (e.g. enum allowlist, pagination bounds).

```go
package search

import "time"

// SearchQuery is the typed search payload attached to the request.
// Use a concrete type for T (e.g. UserFilters) so Filters is typed and can be passed to child methods without assertions.
type SearchQuery[T any] struct {
	Filters     T
	Pagination  Pagination
	Sort        []SortSpec
}

type Pagination struct {
	Page  int
	Limit int
}

type SortSpec struct {
	Field string
	Order string // "asc" | "desc"
}

// String filters: eq, ne, like, in
type StringFilter struct {
	Eq   *string  `query:"eq"`
	Ne   *string  `query:"ne"`
	Like *string  `query:"like"`
	In   []string `query:"in"`
}

// Number filters: eq, ne, gt, lt, gte, lte, in
type IntFilter struct {
	Eq  *int  `query:"eq"`
	Ne  *int  `query:"ne"`
	Gt  *int  `query:"gt"`
	Lt  *int  `query:"lt"`
	Gte *int  `query:"gte"`
	Lte *int  `query:"lte"`
	In  []int `query:"in"`
}

// Float filters (same operators as IntFilter)
type FloatFilter struct {
	Eq  *float64  `query:"eq"`
	Ne  *float64  `query:"ne"`
	Gt  *float64  `query:"gt"`
	Lt  *float64  `query:"lt"`
	Gte *float64  `query:"gte"`
	Lte *float64  `query:"lte"`
	In  []float64 `query:"in"`
}

// Date filters: eq, ne, gt, lt, gte, lte, in (RFC3339 or Unix)
type DateFilter struct {
	Eq  *time.Time  `query:"eq"`
	Ne  *time.Time  `query:"ne"`
	Gt  *time.Time  `query:"gt"`
	Lt  *time.Time  `query:"lt"`
	Gte *time.Time  `query:"gte"`
	Lte *time.Time  `query:"lte"`
	In  []time.Time `query:"in"`
}

// Boolean filter: eq only ("true" / "false")
type BoolFilter struct {
	Eq *bool `query:"eq"`
}

// Enum filter: use StringFilter (eq, ne, in) and validate against allowed values in middleware.
type EnumFilter = StringFilter

func ptr[T any](v T) *T { return &v }
```

- **Enum:** Reuse `StringFilter` and validate `Eq` / `In` against an allowlist in your handler or middleware.
- **Coercion:** qs and `Unmarshal` will coerce string query values into `int`, `float64`, `bool`, and `time.Time` when target fields are typed accordingly; you can add custom validation (e.g. min/max, date range) after unmarshal.

---

## Sort: use the official library

The qs library parses `sort` for you. Use **`Sort []string`** in your query struct with the `query:"sort"` tag:

- **Array form** `sort[]=age:desc&sort[]=name:asc` → qs fills `Sort` with `[]string{"age:desc", "name:asc"}`.
- **Single string** `sort=age:desc,name:asc` → qs stores one value, and `Unmarshal` into `[]string` yields one element `"age:desc,name:asc"`.

So you **do not need a custom “ParseSort”** for query parsing—only a small helper that turns `[]string` into `[]SortSpec` by splitting each element on `,` (for the single-string form) and then parsing `"field:order"` (default order `asc`).

```go
package search

import "strings"

// SortSpecsFromStrings converts qs-parsed sort strings to []SortSpec.
// Handles both array form (one spec per element) and single comma-separated string.
// Each part is "field", "field:asc", or "field:desc".
func SortSpecsFromStrings(parts []string) []SortSpec {
	var expanded []string
	for _, s := range parts {
		for _, p := range strings.Split(s, ",") {
			if t := strings.TrimSpace(p); t != "" {
				expanded = append(expanded, t)
			}
		}
	}
	if len(expanded) == 0 {
		return nil
	}
	out := make([]SortSpec, 0, len(expanded))
	for _, p := range expanded {
		field, order := p, "asc"
		if idx := strings.Index(p, ":"); idx >= 0 {
			field = strings.TrimSpace(p[:idx])
			o := strings.TrimSpace(p[idx+1:])
			if o == "desc" {
				order = "desc"
			}
		}
		if field != "" {
			out = append(out, SortSpec{Field: field, Order: order})
		}
	}
	return out
}
```

Parsing the query string itself is done entirely by **qs**; this helper only interprets your application’s sort format (`field:order`).

---

## Middleware — `search_middleware.go`

Middleware parses the raw query with **qs**, unmarshals into a query struct that includes **filters + page, limit, sort**, then validates pagination (e.g. page ≥ 1, limit 1–100), optionally enums, and attaches a typed **SearchQuery** to the context (or request in Gin/Echo).

Example using **Gin** and a generic “query struct” type:

```go
package search

import (
	"net/http"

	"github.com/gin-gonic/gin"
	qs "github.com/zaytracom/qs/v1"
)

// QueryBinderFor is the shape of the raw query struct that includes pagination and sort.
// T is the concrete filter type (e.g. UserFilters) so SearchQuery[T] is fully typed.
type QueryBinderFor[T any] interface {
	GetPage() int
	GetLimit() int
	GetSort() []string
	SetPagination(page, limit int)
	SetSort(sort []SortSpec)
	Filters() T
}

// CreateSearchMiddleware returns a Gin handler that parses query with qs, validates,
// and sets SearchQuery[T] on context. key is the context key. Use the same T in the handler when reading (e.g. *SearchQuery[UserFilters]).
// For concurrent safety, allocate a new query struct per request inside the handler
// (see getUsers example) or use a sync.Pool of query structs instead of a shared q.
func CreateSearchMiddleware[T any](q QueryBinderFor[T], key string) gin.HandlerFunc {
	return func(c *gin.Context) {
		rawQuery := c.Request.URL.RawQuery
		if err := qs.Unmarshal(rawQuery, q); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid query", "details": err.Error()})
			c.Abort()
			return
		}
		page, limit := q.GetPage(), q.GetLimit()
		if page < 1 {
			page = 1
		}
		if limit < 1 {
			limit = 10
		}
		if limit > 100 {
			limit = 100
		}
		q.SetPagination(page, limit)
		sort := SortSpecsFromStrings(q.GetSort())
		q.SetSort(sort)
		c.Set(key, &SearchQuery[T]{
			Filters:    q.Filters(),
			Pagination: Pagination{Page: page, Limit: limit},
			Sort:       sort,
		})
		c.Next()
	}
}
```

Using a **concrete query struct** per resource (no interface) keeps the middleware simpler. Example pattern:

```go
// UserQuery is the raw query struct for GET /users (matches qs shape).
type UserQuery struct {
	// Filters (nested objects from e.g. age[gte]=21&name[like]=john)
	Age      *IntFilter     `query:"age"`
	Role     *StringFilter  `query:"role"`
	Name     *StringFilter  `query:"name"`
	IsActive *BoolFilter    `query:"isActive"`
	JoinedAt *DateFilter    `query:"joinedAt"`
	// Pagination & sort (top-level); qs fills Sort for sort[]=... or sort=...
	Page  int      `query:"page"`
	Limit int      `query:"limit"`
	Sort  []string `query:"sort"`
}

// UserFilters groups filter fields for type-safe access in handlers.
type UserFilters struct {
	Age      *IntFilter
	Role     *StringFilter
	Name     *StringFilter
	IsActive *BoolFilter
	JoinedAt *DateFilter
}

func (q *UserQuery) ToSearchQuery() SearchQuery[UserFilters] {
	page, limit := q.Page, q.Limit
	if page < 1 {
		page = 1
	}
	if limit < 1 {
		limit = 10
	}
	if limit > 100 {
		limit = 100
	}
	return SearchQuery[UserFilters]{
		Filters: UserFilters{
			Age:      q.Age,
			Role:     q.Role,
			Name:     q.Name,
			IsActive: q.IsActive,
			JoinedAt: q.JoinedAt,
		},
		Pagination: Pagination{Page: page, Limit: limit},
		Sort:       SortSpecsFromStrings(q.Sort),
	}
}

// Implement QueryBinderFor[UserFilters] so *UserQuery can be used with CreateSearchMiddleware[UserFilters].
func (q *UserQuery) GetPage() int   { return q.Page }
func (q *UserQuery) GetLimit() int { return q.Limit }
func (q *UserQuery) GetSort() []string { return q.Sort }
func (q *UserQuery) SetPagination(page, limit int) { q.Page, q.Limit = page, limit }
func (q *UserQuery) SetSort(sort []SortSpec)      { /* optional: store for reuse */ }
func (q *UserQuery) Filters() UserFilters {
	return UserFilters{Age: q.Age, Role: q.Role, Name: q.Name, IsActive: q.IsActive, JoinedAt: q.JoinedAt}
}
```

---

## Usage — handler with Gin

You can either **parse in the handler** (recommended for per-request structs and concurrency) or **use CreateSearchMiddleware** so the handler only reads from context.

### Option A: Parse in the handler (no middleware)

1. Define the **query struct** with qs `query` tags (filters + page, limit, sort).
2. In the handler, call **qs.Unmarshal(c.Request.URL.RawQuery, &query)**, then **query.ToSearchQuery()**.
3. Read **SearchQuery** (typed filters, pagination, sort) and build DB query (e.g. ORDER BY, WHERE).

```go
package main

import (
	"net/http"

	"github.com/gin-gonic/gin"
	qs "github.com/zaytracom/qs/v1"
	"yourmodule/search"
)

func getUsers(c *gin.Context) {
	var q search.UserQuery
	if err := qs.Unmarshal(c.Request.URL.RawQuery, &q); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid search parameters", "details": err.Error()})
		return
	}
	sq := q.ToSearchQuery()
	filters := sq.Filters // type search.UserFilters; no assertion needed

	// Optional: validate enum for role
	if filters.Role != nil {
		allowed := map[string]bool{"admin": true, "user": true, "guest": true}
		if filters.Role.Eq != nil && !allowed[*filters.Role.Eq] {
			c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid role"})
			return
		}
	}

	// Use sq.Pagination, sq.Sort, filters.* in DB layer. Pass typed filters to child:
	// buildWhereClause(filters) or fetchUsers(c.Request.Context(), sq.Pagination, sq.Sort, filters)
	c.JSON(http.StatusOK, gin.H{
		"meta": gin.H{"pagination": sq.Pagination, "sort": sq.Sort},
		"data": "Mock data based on filters",
	})
}

// Child method receives concrete type; no interface{} or type assertion.
func buildWhereClause(f search.UserFilters) string { /* ... */ return "" }

func main() {
	r := gin.Default()
	// GET /users?age[gte]=18&name[like]=john&role=admin&sort=age:desc,name:asc
	r.GET("/users", getUsers)
	r.Run()
}
```

### Option B: Use CreateSearchMiddleware

Wire the middleware so the handler receives a ready-made **SearchQuery[T]** from context. The binder must implement **QueryBinderFor[T]** (e.g. `*UserQuery` with the methods above for T = UserFilters). Specify the type parameter when calling the middleware so the context carries `*SearchQuery[UserFilters]`.

```go
const searchQueryKey = "searchQuery"

func main() {
	r := gin.Default()
	var q search.UserQuery
	// Middleware parses query, normalizes pagination/sort, sets SearchQuery[UserFilters] on context
	r.GET("/users", search.CreateSearchMiddleware[search.UserFilters](&q, searchQueryKey), getUsersWithSearch)
	r.Run()
}

func getUsersWithSearch(c *gin.Context) {
	sq, _ := c.Get(searchQueryKey)
	searchQuery := sq.(*search.SearchQuery[search.UserFilters]) // concrete type, no filter assertion
	filters := searchQuery.Filters                              // type search.UserFilters

	// Optional: validate enum for role, etc.
	// Use searchQuery.Pagination, searchQuery.Sort, filters.* in DB layer
	c.JSON(http.StatusOK, gin.H{
		"meta": gin.H{"pagination": searchQuery.Pagination, "sort": searchQuery.Sort},
		"data": "Mock data based on filters",
	})
}
```

**Note:** The example above reuses a single `UserQuery` for every request, which is not safe under concurrent access. For production, use Option A (parse in handler with a new `var q search.UserQuery` per request) or make the middleware allocate a new binder per request (e.g. via a `func() search.QueryBinderFor[T]` factory or `sync.Pool`).

---

## Query string formats (qs behavior)

- **Nested:** `age[gte]=21` → `age: { gte: 21 }` (struct field `Age.Gte`).
- **Array:** `sort[]=age:desc&sort[]=name:asc` or `sort=age:desc,name:asc`; use **SortSpecsFromStrings** to convert to `[]SortSpec`.
- **Ignore prefix:** qs accepts a leading `?`; use `ParseOptions{IgnoreQueryPrefix: true}` if you pass the full URL query string.

Example with options:

```go
opts := &qs.ParseOptions{IgnoreQueryPrefix: true}
err := qs.Unmarshal(c.Request.URL.RawQuery, &q, opts)
```

---

## Summary

| Concept        | TypeScript (Zod)     | Go (qs)                                              |
|----------------|----------------------|------------------------------------------------------|
| Parse query    | qs → object          | `qs.Unmarshal(rawQuery, &struct)`                    |
| Filter shape   | Zod schema           | Structs with `query:"..."` tags; `SearchQuery[T]` for typed filters |
| Validation     | Zod `.safeParse()`   | Post-unmarshal checks                            |
| Attach to req  | `req.searchQuery`    | Context key or handler variable                 |
| Sort parsing   | Zod transform        | qs fills `Sort []string`; `SortSpecsFromStrings(Sort)` → `[]SortSpec` |

Using [github.com/zaytracom/qs](https://pkg.go.dev/github.com/zaytracom/qs@v1.0.2) you get qs-compatible parsing (nested objects and arrays); combine it with the types and helpers above for a typed search API in Go similar to the qs + Zod flow in TypeScript.
