PostgreSQL JSON/JSONB operations in Go.

- [Create JSON](#create-json)
- [Query field with -> operator](#query-field-with---operator)
- [Query field with ->> operator](#query-field-with-->-operator)
- [Query nested field](#query-nested-field)
- [Query array element](#query-array-element)
- [Contains key with ? operator](#contains-key-with--operator)
- [Contains value with @> operator](#contains-value-with--operator)
- [Query where JSON contains key](#query-where-json-contains-key)
- [Query where JSON contains value](#query-where-json-contains-value)
- [Query where array contains element](#query-where-array-contains-element)
- [Update JSON field with jsonb_set](#update-json-field-with-jsonb_set)
- [Add new field with jsonb_set](#add-new-field-with-jsonb_set)
- [Delete field with - operator](#delete-field-with---operator)
- [Delete multiple fields with - operator](#delete-multiple-fields-with---operator)
- [Delete nested field with #- operator](#delete-nested-field-with-#--operator)
- [Append to array with jsonb_set](#append-to-array-with-jsonb_set)
- [Concatenate JSON with || operator](#concatenate-json-with---operator)
- [Get JSON keys with jsonb_object_keys](#get-json-keys-with-jsonb_object_keys)
- [Get all keys with jsonb_keys](#get-all-keys-with-jsonb_keys)
- [Check if any key exists with ?| operator](#check-if-any-key-exists-with-|-operator)
- [Check if all keys exist with ?& operator](#check-if-all-keys-exist-with-&-operator)
- [Aggregate JSON array with jsonb_agg](#aggregate-json-array-with-jsonb_agg)
- [Merge JSONB with jsonb_merge_patch](#merge-jsonb-with-jsonb_merge_patch)
- [Search text in JSON with @? operator](#search-text-in-json-with--operator)
- [Extract all matching values with jsonb_path_query](#extract-all-matching-values-with-jsonb_path_query)
- [Query nested array with jsonb_path_query](#query-nested-array-with-jsonb_path_query)
- [Get path to value with jsonb_path_query_first](#get-path-to-value-with-jsonb_path_query_first)

# Create JSON

```go
import "encoding/json"

data := map[string]any{
    "name": "Alice",
    "age": 30,
    "tags": []string{"engineer", "golang"},
}
jsonBytes, _ := json.Marshal(data)
db.Exec("INSERT INTO users (data) VALUES ($1)", jsonBytes)
```

```go
// pgx reference
import "github.com/jackc/pgx/v5/pgtype"
data := pgtype.JSONB{Bytes: []byte(`{"name":"Alice","age":30}`), Valid: true}
pool.Exec(ctx, "INSERT INTO users (data) VALUES ($1)", data)
```

# Query field with -> operator

Returns JSON value at specified key. Use -> when you need the result as JSON.

```go
type Result struct{ Name string }
var r Result
db.QueryRow("SELECT data->'name' FROM users WHERE id = $1", 1).Scan(&r.Name)
```

```go
// pgx reference
pool.QueryRow(ctx, "SELECT data->'name' FROM users WHERE id = $1", 1).Scan(&r.Name)
```

# Query field with ->> operator

Returns text value at specified key. Use ->> for string comparisons, filtering, or when you need text output.

```go
var name string
db.QueryRow("SELECT data->>'name' FROM users WHERE id = $1", 1).Scan(&name)
```

```go
// pgx reference
pool.QueryRow(ctx, "SELECT data->>'name' FROM users WHERE id = $1", 1).Scan(&name)
```

# Query nested field

Chain -> and ->> operators to navigate nested objects. Returns text at the final key.

```go
var city string
db.QueryRow("SELECT data->'address'->>'city' FROM users WHERE id = $1", 1).Scan(&city)
```

```go
// pgx reference
pool.QueryRow(ctx, "SELECT data->'address'->>'city' FROM users WHERE id = $1", 1).Scan(&city)
```

# Query array element

Access array elements using -> with zero-based index. Returns JSON value at index.

```go
var firstTag string
db.QueryRow("SELECT data->'tags'->0 FROM users WHERE id = $1", 1).Scan(&firstTag)
```

```go
// pgx reference
pool.QueryRow(ctx, "SELECT data->'tags'->0 FROM users WHERE id = $1", 1).Scan(&firstTag)
```

# Contains key with ? operator

Check if JSON contains a specific top-level key. Returns boolean.

```go
var hasName bool
db.QueryRow("SELECT data ? 'name' FROM users WHERE id = $1", 1).Scan(&hasName)
```

```go
// pgx reference
pool.QueryRow(ctx, "SELECT data ? 'name' FROM users WHERE id = $1", 1).Scan(&hasName)
```

# Contains value with @> operator

Check if JSON contains a specific key-value pair. Returns boolean.

```go
var contains bool
db.QueryRow("SELECT data @> '{\"name\":\"Alice\"}' FROM users WHERE id = $1", 1).Scan(&contains)
```

```go
// pgx reference
pool.QueryRow(ctx, "SELECT data @> '{\"name\":\"Alice\"}' FROM users WHERE id = $1", 1).Scan(&contains)
```

# Query where JSON contains key

Filter rows where JSON contains a specific top-level key.

```go
id := 1
db.Query("SELECT id FROM users WHERE data ? 'name'")
```

```go
// pgx reference
rows, _ := pool.Query(ctx, "SELECT id FROM users WHERE data ? 'name'")
```

# Query where JSON contains value

Filter rows where JSON contains a specific key-value pair.

```go
db.Query("SELECT id FROM users WHERE data @> '{\"name\":\"Alice\"}'")
```

```go
// pgx reference
rows, _ := pool.Query(ctx, "SELECT id FROM users WHERE data @> '{\"name\":\"Alice\"}'")
```

# Query where array contains element

Filter rows where a JSON array contains a specific element.

```go
db.Query("SELECT id FROM users WHERE data->'tags' ? 'engineer'")
```

```go
// pgx reference
rows, _ := pool.Query(ctx, "SELECT id FROM users WHERE data->'tags' ? 'engineer'")
```

# Update JSON field with jsonb_set

Updates an existing field value. Does NOT create the field if it doesn't exist (use `true` as 4th param to create).

```go
tx, _ := db.Begin()
tx.Exec("UPDATE users SET data = jsonb_set(data, '{name}', '\"Bob\"') WHERE id = $1", 1)
tx.Commit()
```

```go
// pgx reference
tx, _ := pool.Begin(ctx)
tx.Exec(ctx, "UPDATE users SET data = jsonb_set(data, '{name}', '\"Bob\"') WHERE id = $1", 1)
tx.Commit(ctx)
```

# Add new field with jsonb_set

Adds a new field to JSON. Uses `true` as the 4th parameter to create the field if it doesn't exist. If field exists, updates it.

```go
tx, _ := db.Begin()
tx.Exec("UPDATE users SET data = jsonb_set(data, '{email}', '\"alice@example.com\"', true) WHERE id = $1", 1)
tx.Commit()
```

```go
// pgx reference
tx, _ := pool.Begin(ctx)
tx.Exec(ctx, "UPDATE users SET data = jsonb_set(data, '{email}', '\"alice@example.com\"', true) WHERE id = $1", 1)
tx.Commit(ctx)
```

# Delete field with - operator

Removes a top-level key from JSON. Ignores if key doesn't exist.

```go
tx, _ := db.Begin()
tx.Exec("UPDATE users SET data = data - 'age' WHERE id = $1", 1)
tx.Commit()
```

```go
// pgx reference
tx, _ := pool.Begin(ctx)
tx.Exec(ctx, "UPDATE users SET data = data - 'age' WHERE id = $1", 1)
tx.Commit(ctx)
```

# Delete multiple fields with - operator

Removes multiple top-level keys at once. Ignores non-existent keys.

```go
tx, _ := db.Begin()
tx.Exec("UPDATE users SET data = data - '{age,email}' WHERE id = $1", 1)
tx.Commit()
```

```go
// pgx reference
tx, _ := pool.Begin(ctx)
tx.Exec(ctx, "UPDATE users SET data = data - '{age,email}' WHERE id = $1", 1)
tx.Commit(ctx)
```

# Delete nested field with #- operator

Removes a nested key using path notation. Ignores if path doesn't exist.

```go
tx, _ := db.Begin()
tx.Exec("UPDATE users SET data = data #- '{address,city}' WHERE id = $1", 1)
tx.Commit()
```

```go
// pgx reference
tx, _ := pool.Begin(ctx)
tx.Exec(ctx, "UPDATE users SET data = data #- '{address,city}' WHERE id = $1", 1)
tx.Commit(ctx)
```

# Append to array with jsonb_set

Adds element to array at specified index. Creates new element if index doesn't exist, pads array with nulls.

```go
tx, _ := db.Begin()
tx.Exec("UPDATE users SET data = jsonb_set(data, '{tags,999}', '\"newtag\"') WHERE id = $1", 1)
tx.Commit()
```

```go
// pgx reference
tx, _ := pool.Begin(ctx)
tx.Exec(ctx, "UPDATE users SET data = jsonb_set(data, '{tags,999}', '\"newtag\"') WHERE id = $1", 1)
tx.Commit(ctx)
```

# Concatenate JSON with || operator

Merges two JSON objects. Right side values override left side for matching keys. Adds new keys from right side.

```go
tx, _ := db.Begin()
tx.Exec("UPDATE users SET data = data || '{\"email\":\"alice@example.com\"}' WHERE id = $1", 1)
tx.Commit()
```

```go
// pgx reference
tx, _ := pool.Begin(ctx)
tx.Exec(ctx, "UPDATE users SET data = data || '{\"email\":\"alice@example.com\"}' WHERE id = $1", 1)
tx.Commit(ctx)
```

# Get JSON keys with jsonb_object_keys

Returns set of all top-level keys. Use for iterating over object properties.

```go
var key string
rows, _ := db.Query("SELECT jsonb_object_keys(data) FROM users WHERE id = $1", 1)
defer rows.Close()
var keys []string
for rows.Next() {
    rows.Scan(&key)
    keys = append(keys, key)
}
```

```go
// pgx reference
rows, _ := pool.Query(ctx, "SELECT jsonb_object_keys(data) FROM users WHERE id = $1", 1)
keys, _ := pgx.CollectRows(rows, pgx.RowTo[string])
```

# Get all keys with jsonb_keys

Collects all top-level keys into an array for batch processing.

```go
var keys []string
db.QueryRow("SELECT jsonb_object_keys(data) FROM users WHERE id = $1", 1).Scan((*pq.StringArray)(&keys))
```

```go
// pgx reference
var keys []string
pool.QueryRow(ctx, "SELECT array_agg(jsonb_object_keys(data)) FROM users WHERE id = $1", 1).Scan(&keys)
```

# Check if any key exists with ?| operator

Returns true if JSON contains ANY of the specified keys.

```go
var exists bool
db.QueryRow("SELECT data ?| ARRAY['name','email'] FROM users WHERE id = $1", 1).Scan(&exists)
```

```go
// pgx reference
pool.QueryRow(ctx, "SELECT data ?| ARRAY['name','email'] FROM users WHERE id = $1", 1).Scan(&exists)
```

# Check if all keys exist with ?& operator

Returns true only if JSON contains ALL of the specified keys.

```go
var exists bool
db.QueryRow("SELECT data ?& ARRAY['name','age'] FROM users WHERE id = $1", 1).Scan(&exists)
```

```go
// pgx reference
pool.QueryRow(ctx, "SELECT data ?& ARRAY['name','age'] FROM users WHERE id = $1", 1).Scan(&exists)
```

# Aggregate JSON array with jsonb_agg

Combines multiple JSON values into a single JSON array.

```go
var result string
db.QueryRow("SELECT jsonb_agg(data) FROM users WHERE id IN ($1, $2, $3)", 1, 2, 3).Scan(&result)
```

```go
// pgx reference
var result string
pool.QueryRow(ctx, "SELECT jsonb_agg(data) FROM users WHERE id IN ($1, $2, $3)", 1, 2, 3).Scan(&result)
```

# Merge JSONB with jsonb_merge_patch

Deep merges two JSON objects. null values in patch remove keys. Works recursively for nested objects.

```go
tx, _ := db.Begin()
tx.Exec("UPDATE users SET data = jsonb_merge_patch(data, '{\"age\":31}') WHERE id = $1", 1)
tx.Commit()
```

```go
// pgx reference
tx, _ := pool.Begin(ctx)
tx.Exec(ctx, "UPDATE users SET data = jsonb_merge_patch(data, '{\"age\":31}') WHERE id = $1", 1)
tx.Commit(ctx)
```

# Search text in JSON with @? operator

JSONPath query to search for text patterns anywhere in JSON. Returns boolean.

```go
var found bool
db.QueryRow("SELECT data @? '$.name ? (@ == \"Alice\")' FROM users WHERE id = $1", 1).Scan(&found)
```

```go
// pgx reference
pool.QueryRow(ctx, "SELECT data @? '$.name ? (@ == \"Alice\")' FROM users WHERE id = $1", 1).Scan(&found)
```

# Extract all matching values with jsonb_path_query

JSONPath query to extract all values matching a condition. Returns set of matching values.

```go
var values []string
rows, _ := db.Query("SELECT jsonb_path_query(data, '$.tags[*] ? (@ == \"engineer\")') FROM users WHERE id = $1", 1)
defer rows.Close()
for rows.Next() {
    var value string
    rows.Scan(&value)
    values = append(values, value)
}
```

```go
// pgx reference
rows, _ := pool.Query(ctx, "SELECT jsonb_path_query(data, '$.tags[*] ? (@ == \"engineer\")') FROM users WHERE id = $1", 1)
values, _ := pgx.CollectRows(rows, pgx.RowTo[string])
```

# Query nested array with jsonb_path_query

JSONPath query to extract values from nested arrays using path notation.

```go
var values []string
rows, _ := db.Query("SELECT jsonb_path_query(data, '$.items[*].name') FROM users WHERE id = $1", 1)
defer rows.Close()
for rows.Next() {
    var value string
    rows.Scan(&value)
    values = append(values, value)
}
```

```go
// pgx reference
rows, _ := pool.Query(ctx, "SELECT jsonb_path_query(data, '$.items[*].name') FROM users WHERE id = $1", 1)
values, _ := pgx.CollectRows(rows, pgx.RowTo[string])
```

# Get path to value with jsonb_path_query_first

JSONPath query to extract the first matching value. Returns single value or null.

```go
var value string
db.QueryRow("SELECT jsonb_path_query_first(data, '$.name') FROM users WHERE id = $1", 1).Scan(&value)
```

```go
// pgx reference
pool.QueryRow(ctx, "SELECT jsonb_path_query_first(data, '$.name') FROM users WHERE id = $1", 1).Scan(&value)
```