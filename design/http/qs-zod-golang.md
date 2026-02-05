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
        Role:    &RoleFilter{Eq: ptr("admin")},
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
go get github.com/go-playground/validator/v10
```

---

## Types & helpers — `search_types.go`

Filter config is defined with **structs** and **query tags**. Operator structs (eq, gte, like, etc.) match the shape produced by qs so `qs.Unmarshal` can fill them. Add **`validate`** tags ([go-playground/validator](https://github.com/go-playground/validator)) for rules like enum, min/max—the Go counterpart to Zod schemas.

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

// Enum filter: use a dedicated struct with validate:"oneof=..." so validator enforces allowed values.
type EnumFilter = StringFilter

func ptr[T any](v T) *T { return &v }
```

- **Enum:** Use a filter struct with the same `query` shape as `StringFilter` but add `validate:"omitempty,oneof=admin user guest"` on `Eq` and `validate:"omitempty,dive,oneof=..."` on `In` (see RoleFilter below).
- **Coercion:** qs and `Unmarshal` coerce query strings into `int`, `float64`, `bool`, `time.Time`; add `validate` tags (e.g. `min`, `max`) for bounds.

---

## Validation with go-playground/validator

[go-playground/validator](https://github.com/go-playground/validator) is the usual Go replacement for Zod: struct tags declare rules and `validate.Struct()` runs them after unmarshaling. Use it **after** `qs.Unmarshal` (and optionally after `ToSearchQuery`) to return 400 with field errors when invalid.

**Typical flow:** Unmarshal query → `validate.Struct(&q)` → on error, translate `validator.ValidationErrors` to a JSON response.

```go
package search

import (
	"errors"
	"net/http"

	"github.com/gin-gonic/gin"
	validator "github.com/go-playground/validator/v10"
)

// Validate is the shared validator instance (export so handlers can call Validate.Struct).
var Validate = validator.New()

// ValidationErrorsToMap converts validator.ValidationErrors to a map suitable for 400 JSON.
func ValidationErrorsToMap(err error) map[string]string {
	if err == nil {
		return nil
	}
	out := make(map[string]string)
	var valErr validator.ValidationErrors
	if !errors.As(err, &valErr) {
		out["_"] = err.Error()
		return out
	}
	for _, e := range valErr {
		out[e.Field()] = e.Tag() // or e.Translate(translator) for messages
	}
	return out
}

// In a handler after qs.Unmarshal:
func getUsers(c *gin.Context) {
	var q search.UserQuery
	if err := qs.Unmarshal(c.Request.URL.RawQuery, &q); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid query", "details": err.Error()})
		return
	}
	if err := Validate.Struct(&q); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Validation failed", "details": ValidationErrorsToMap(err)})
		return
	}
	// ... ToSearchQuery(&q), use filters
}
```

**Useful tags:** `oneof=admin user guest`, `min=1`, `max=100`, `dive` (for slices), `omitempty` (skip when zero). See [baked-in validations](https://github.com/go-playground/validator#baked-in-validations) for the full list.

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

// ToSearchQuery builds SearchQuery[T] from any QueryBinderFor[T]. Use this instead of
// implementing ToSearchQuery on every query type. Applies default page/limit and parses sort.
func ToSearchQuery[T any](q QueryBinderFor[T]) SearchQuery[T] {
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
	return SearchQuery[T]{
		Filters:    q.Filters(),
		Pagination: Pagination{Page: page, Limit: limit},
		Sort:       SortSpecsFromStrings(q.GetSort()),
	}
}

// CreateSearchMiddleware returns a Gin handler that parses query with qs, optionally validates (when Validate is set),
// and sets SearchQuery[T] on context. newBinder is called once per request so each request gets its own struct—safe for concurrent use.
// key is the context key. Use the same T in the handler when reading (e.g. *SearchQuery[UserFilters]).
func CreateSearchMiddleware[T any](newBinder func() QueryBinderFor[T], key string) gin.HandlerFunc {
	return func(c *gin.Context) {
		q := newBinder() // fresh binder per request
		rawQuery := c.Request.URL.RawQuery
		if err := qs.Unmarshal(rawQuery, q); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid query", "details": err.Error()})
			c.Abort()
			return
		}
		if Validate != nil {
			if err := Validate.Struct(q); err != nil {
				c.JSON(http.StatusBadRequest, gin.H{"error": "Validation failed", "details": ValidationErrorsToMap(err)})
				c.Abort()
				return
			}
		}
		sq := ToSearchQuery(q)
		c.Set(key, &sq)
		c.Next()
	}
}
```

You only implement **QueryBinderFor[T]** (getters + `Filters()`); no per-type `ToSearchQuery` method. Add **`validate`** tags so [go-playground/validator](https://github.com/go-playground/validator) enforces enums and bounds (Zod-style). Example:

```go
// RoleFilter is StringFilter with enum validation (oneof).
type RoleFilter struct {
	Eq   *string  `query:"eq"  validate:"omitempty,oneof=admin user guest"`
	Ne   *string  `query:"ne"  validate:"omitempty,oneof=admin user guest"`
	Like *string  `query:"like"`
	In   []string `query:"in"  validate:"omitempty,dive,oneof=admin user guest"`
}

// UserQuery is the raw query struct for GET /users (matches qs shape).
type UserQuery struct {
	// Filters (nested objects from e.g. age[gte]=21&name[like]=john)
	Age      *IntFilter    `query:"age"`
	Role     *RoleFilter   `query:"role"`
	Name     *StringFilter `query:"name"`
	IsActive *BoolFilter   `query:"isActive"`
	JoinedAt *DateFilter   `query:"joinedAt"`
	// Pagination & sort; omitempty allows missing (ToSearchQuery defaults); when present, bounds enforced
	Page  int      `query:"page"  validate:"omitempty,min=1"`
	Limit int      `query:"limit" validate:"omitempty,min=1,max=100"`
	Sort  []string `query:"sort"`
}

// UserFilters groups filter fields for type-safe access in handlers.
type UserFilters struct {
	Age      *IntFilter
	Role     *RoleFilter
	Name     *StringFilter
	IsActive *BoolFilter
	JoinedAt *DateFilter
}

// Implement QueryBinderFor[UserFilters] so *UserQuery works with ToSearchQuery and CreateSearchMiddleware[UserFilters].
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
2. In the handler, call **qs.Unmarshal(c.Request.URL.RawQuery, &query)**, then **search.ToSearchQuery(&query)**.
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
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid query", "details": err.Error()})
		return
	}
	if err := search.Validate.Struct(&q); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Validation failed", "details": search.ValidationErrorsToMap(err)})
		return
	}
	sq := search.ToSearchQuery(&q)
	filters := sq.Filters // type search.UserFilters; role enum already validated

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

Wire the middleware so the handler receives a ready-made **SearchQuery[T]** from context. Pass a **factory** that returns a new binder per request so the middleware is safe for concurrent use.

```go
const searchQueryKey = "searchQuery"

func main() {
	r := gin.Default()
	// New binder per request (concurrent-safe); middleware runs qs.Unmarshal, Validate.Struct, ToSearchQuery
	r.GET("/users", search.CreateSearchMiddleware[search.UserFilters](
		func() search.QueryBinderFor[search.UserFilters] { return &search.UserQuery{} },
		searchQueryKey,
	), getUsersWithSearch)
	r.Run()
}

func getUsersWithSearch(c *gin.Context) {
	sq, _ := c.Get(searchQueryKey)
	searchQuery := sq.(*search.SearchQuery[search.UserFilters])
	filters := searchQuery.Filters

	// Use searchQuery.Pagination, searchQuery.Sort, filters.* in DB layer
	c.JSON(http.StatusOK, gin.H{
		"meta": gin.H{"pagination": searchQuery.Pagination, "sort": searchQuery.Sort},
		"data": "Mock data based on filters",
	})
}
```

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
| Validation     | Zod `.safeParse()`   | `validate.Struct()` + struct tags ([go-playground/validator](https://github.com/go-playground/validator)) |
| Attach to req  | `req.searchQuery`    | Context key or handler variable                 |
| Sort parsing   | Zod transform        | qs fills `Sort []string`; `SortSpecsFromStrings(Sort)` → `[]SortSpec` |

Using [github.com/zaytracom/qs](https://pkg.go.dev/github.com/zaytracom/qs@v1.0.2) you get qs-compatible parsing (nested objects and arrays); combine it with the types and helpers above for a typed search API in Go similar to the qs + Zod flow in TypeScript.
