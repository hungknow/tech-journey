PostgreSQL JSON/JSONB operations in Go, TypeScript, Python.

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

## Golang
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

## TypeScript
```typescript
const data = { name: 'Alice', age: 30, tags: ['engineer', 'typescript'] };
await pool.query('INSERT INTO users (data) VALUES ($1)', [JSON.stringify(data)]);
```

## Python
```python
import json
data = {"name": "Alice", "age": 30, "tags": ["engineer", "python"]}
cur.execute("INSERT INTO users (data) VALUES (%s)", (json.dumps(data),))
```

# Query field with -> operator

## Golang
```go
type Result struct{ Name string }
var r Result
db.QueryRow("SELECT data->'name' FROM users WHERE id = $1", 1).Scan(&r.Name)
```

```go
// pgx reference
pool.QueryRow(ctx, "SELECT data->'name' FROM users WHERE id = $1", 1).Scan(&r.Name)
```

## TypeScript
```typescript
const { rows } = await pool.query<{ name: string }>('SELECT data->\'name\' FROM users WHERE id = $1', [1]);
const name = rows[0].name;
```

## Python
```python
cur.execute("SELECT data->'name' FROM users WHERE id = %s", (1,))
name = cur.fetchone()[0]
```

# Query field with ->> operator

The `->>` operator returns the value as **text**, which is often more convenient for string operations and comparisons, while `->` returns a **JSON value** that may need additional casting.

## Golang
```go
var name string
db.QueryRow("SELECT data->>'name' FROM users WHERE id = $1", 1).Scan(&name)
```

```go
// pgx reference
pool.QueryRow(ctx, "SELECT data->>'name' FROM users WHERE id = $1", 1).Scan(&name)
```

## TypeScript
```typescript
const { rows } = await pool.query('SELECT data->>\'name\' FROM users WHERE id = $1', [1]);
const name = rows[0].name;
```

## Python
```python
cur.execute("SELECT data->>'name' FROM users WHERE id = %s", (1,))
name = cur.fetchone()[0]
```

# Query nested field

## Golang
```go
var city string
db.QueryRow("SELECT data->'address'->>'city' FROM users WHERE id = $1", 1).Scan(&city)
```

```go
// pgx reference
pool.QueryRow(ctx, "SELECT data->'address'->>'city' FROM users WHERE id = $1", 1).Scan(&city)
```

## TypeScript
```typescript
const { rows } = await pool.query('SELECT data->\'address\'->>\'city\' FROM users WHERE id = $1', [1]);
const city = rows[0].city;
```

## Python
```python
cur.execute("SELECT data->'address'->>'city' FROM users WHERE id = %s", (1,))
city = cur.fetchone()[0]
```

# Query array element

## Golang
```go
var firstTag string
db.QueryRow("SELECT data->'tags'->0 FROM users WHERE id = $1", 1).Scan(&firstTag)
```

```go
// pgx reference
pool.QueryRow(ctx, "SELECT data->'tags'->0 FROM users WHERE id = $1", 1).Scan(&firstTag)
```

## TypeScript
```typescript
const { rows } = await pool.query('SELECT data->\'tags\'->0 FROM users WHERE id = $1', [1]);
const firstTag = rows[0].tags;
```

## Python
```python
cur.execute("SELECT data->'tags'->0 FROM users WHERE id = %s", (1,))
first_tag = cur.fetchone()[0]
```

# Contains key with ? operator

## Golang
```go
var hasName bool
db.QueryRow("SELECT data ? 'name' FROM users WHERE id = $1", 1).Scan(&hasName)
```

```go
// pgx reference
pool.QueryRow(ctx, "SELECT data ? 'name' FROM users WHERE id = $1", 1).Scan(&hasName)
```

## TypeScript
```typescript
const { rows } = await pool.query('SELECT data ? \'name\' FROM users WHERE id = $1', [1]);
const hasName = rows[0].exists;
```

## Python
```python
cur.execute("SELECT data ? 'name' FROM users WHERE id = %s", (1,))
has_name = cur.fetchone()[0]
```

# Contains value with @> operator

## Golang
```go
var contains bool
db.QueryRow("SELECT data @> '{\"name\":\"Alice\"}' FROM users WHERE id = $1", 1).Scan(&contains)
```

```go
// pgx reference
pool.QueryRow(ctx, "SELECT data @> '{\"name\":\"Alice\"}' FROM users WHERE id = $1", 1).Scan(&contains)
```

## TypeScript
```typescript
const { rows } = await pool.query('SELECT data @> \'{\"name\":\"Alice\"}\' FROM users WHERE id = $1', [1]);
const contains = rows[0].exists;
```

## Python
```python
cur.execute("SELECT data @> '{\"name\":\"Alice\"}' FROM users WHERE id = %s", (1,))
contains = cur.fetchone()[0]
```

# Query where JSON contains key

## Golang
```go
id := 1
db.Query("SELECT id FROM users WHERE data ? 'name'")
```

```go
// pgx reference
rows, _ := pool.Query(ctx, "SELECT id FROM users WHERE data ? 'name'")
```

## TypeScript
```typescript
const { rows } = await pool.query('SELECT id FROM users WHERE data ? \'name\'');
```

## Python
```python
cur.execute("SELECT id FROM users WHERE data ? 'name'")
ids = cur.fetchall()
```

# Query where JSON contains value

## Golang
```go
db.Query("SELECT id FROM users WHERE data @> '{\"name\":\"Alice\"}'")
```

```go
// pgx reference
rows, _ := pool.Query(ctx, "SELECT id FROM users WHERE data @> '{\"name\":\"Alice\"}'")
```

## TypeScript
```typescript
const { rows } = await pool.query('SELECT id FROM users WHERE data @> \'{\"name\":\"Alice\"}\'');
```

## Python
```python
cur.execute("SELECT id FROM users WHERE data @> '{\"name\":\"Alice\"}'")
ids = cur.fetchall()
```

# Query where array contains element

## Golang
```go
db.Query("SELECT id FROM users WHERE data->'tags' ? 'engineer'")
```

```go
// pgx reference
rows, _ := pool.Query(ctx, "SELECT id FROM users WHERE data->'tags' ? 'engineer'")
```

## TypeScript
```typescript
const { rows } = await pool.query('SELECT id FROM users WHERE data->\'tags\' ? \'engineer\'');
```

## Python
```python
cur.execute("SELECT id FROM users WHERE data->'tags' ? 'engineer'")
ids = cur.fetchall()
```

# Update JSON field with jsonb_set

## Golang
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

## TypeScript
```typescript
const client = await pool.connect();
await client.query('BEGIN');
await client.query('UPDATE users SET data = jsonb_set(data, \'{name}\', \'\"Bob\"\') WHERE id = $1', [1]);
await client.query('COMMIT');
client.release();
```

## Python
```python
conn.autocommit = False
cur = conn.cursor()
cur.execute("UPDATE users SET data = jsonb_set(data, '{name}', '\"Bob\"') WHERE id = %s", (1,))
conn.commit()
```

# Add new field with jsonb_set

## Golang
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

## TypeScript
```typescript
const client = await pool.connect();
await client.query('BEGIN');
await client.query('UPDATE users SET data = jsonb_set(data, \'{email}\', \'\"alice@example.com\"\', true) WHERE id = $1', [1]);
await client.query('COMMIT');
client.release();
```

## Python
```python
conn.autocommit = False
cur = conn.cursor()
cur.execute("UPDATE users SET data = jsonb_set(data, '{email}', '\"alice@example.com\"', true) WHERE id = %s", (1,))
conn.commit()
```

# Delete field with - operator

## Golang
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

## TypeScript
```typescript
const client = await pool.connect();
await client.query('BEGIN');
await client.query('UPDATE users SET data = data - \'age\' WHERE id = $1', [1]);
await client.query('COMMIT');
client.release();
```

## Python
```python
conn.autocommit = False
cur = conn.cursor()
cur.execute("UPDATE users SET data = data - 'age' WHERE id = %s", (1,))
conn.commit()
```

# Delete multiple fields with - operator

## Golang
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

## TypeScript
```typescript
const client = await pool.connect();
await client.query('BEGIN');
await client.query('UPDATE users SET data = data - \'{age,email}\' WHERE id = $1', [1]);
await client.query('COMMIT');
client.release();
```

## Python
```python
conn.autocommit = False
cur = conn.cursor()
cur.execute("UPDATE users SET data = data - '{age,email}' WHERE id = %s", (1,))
conn.commit()
```

# Delete nested field with #- operator

## Golang
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

## TypeScript
```typescript
const client = await pool.connect();
await client.query('BEGIN');
await client.query('UPDATE users SET data = data #- \'{address,city}\' WHERE id = $1', [1]);
await client.query('COMMIT');
client.release();
```

## Python
```python
conn.autocommit = False
cur = conn.cursor()
cur.execute("UPDATE users SET data = data #- '{address,city}' WHERE id = %s", (1,))
conn.commit()
```

# Append to array with jsonb_set

## Golang
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

## TypeScript
```typescript
const client = await pool.connect();
await client.query('BEGIN');
await client.query('UPDATE users SET data = jsonb_set(data, \'{tags,999}\', \'\"newtag\"\') WHERE id = $1', [1]);
await client.query('COMMIT');
client.release();
```

## Python
```python
conn.autocommit = False
cur = conn.cursor()
cur.execute("UPDATE users SET data = jsonb_set(data, '{tags,999}', '\"newtag\"') WHERE id = %s", (1,))
conn.commit()
```

# Concatenate JSON with || operator

## Golang
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

## TypeScript
```typescript
const client = await pool.connect();
await client.query('BEGIN');
await client.query('UPDATE users SET data = data || \'{\"email\":\"alice@example.com\"}\' WHERE id = $1', [1]);
await client.query('COMMIT');
client.release();
```

## Python
```python
conn.autocommit = False
cur = conn.cursor()
cur.execute("UPDATE users SET data = data || '{\"email\":\"alice@example.com\"}' WHERE id = %s", (1,))
conn.commit()
```

# Get JSON keys with jsonb_object_keys

## Golang
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

## TypeScript
```typescript
const { rows } = await pool.query('SELECT jsonb_object_keys(data) FROM users WHERE id = $1', [1]);
const keys = rows.map(r => r.jsonb_object_keys);
```

## Python
```python
cur.execute("SELECT jsonb_object_keys(data) FROM users WHERE id = %s", (1,))
keys = [row[0] for row in cur.fetchall()]
```

# Get all keys with jsonb_keys

## Golang
```go
var keys []string
db.QueryRow("SELECT jsonb_object_keys(data) FROM users WHERE id = $1", 1).Scan((*pq.StringArray)(&keys))
```

```go
// pgx reference
var keys []string
pool.QueryRow(ctx, "SELECT array_agg(jsonb_object_keys(data)) FROM users WHERE id = $1", 1).Scan(&keys)
```

## TypeScript
```typescript
const { rows } = await pool.query('SELECT array_agg(jsonb_object_keys(data)) FROM users WHERE id = $1', [1]);
const keys = rows[0].array_agg;
```

## Python
```python
cur.execute("SELECT array_agg(jsonb_object_keys(data)) FROM users WHERE id = %s", (1,))
keys = cur.fetchone()[0]
```

# Check if any key exists with ?| operator

## Golang
```go
var exists bool
db.QueryRow("SELECT data ?| ARRAY['name','email'] FROM users WHERE id = $1", 1).Scan(&exists)
```

```go
// pgx reference
pool.QueryRow(ctx, "SELECT data ?| ARRAY['name','email'] FROM users WHERE id = $1", 1).Scan(&exists)
```

## TypeScript
```typescript
const { rows } = await pool.query('SELECT data ?| ARRAY[\'name\',\'email\'] FROM users WHERE id = $1', [1]);
const exists = rows[0].exists;
```

## Python
```python
cur.execute("SELECT data ?| ARRAY['name','email'] FROM users WHERE id = %s", (1,))
exists = cur.fetchone()[0]
```

# Check if all keys exist with ?& operator

## Golang
```go
var exists bool
db.QueryRow("SELECT data ?& ARRAY['name','age'] FROM users WHERE id = $1", 1).Scan(&exists)
```

```go
// pgx reference
pool.QueryRow(ctx, "SELECT data ?& ARRAY['name','age'] FROM users WHERE id = $1", 1).Scan(&exists)
```

## TypeScript
```typescript
const { rows } = await pool.query('SELECT data ?& ARRAY[\'name\',\'age\'] FROM users WHERE id = $1', [1]);
const exists = rows[0].exists;
```

## Python
```python
cur.execute("SELECT data ?& ARRAY['name','age'] FROM users WHERE id = %s", (1,))
exists = cur.fetchone()[0]
```

# Aggregate JSON array with jsonb_agg

## Golang
```go
var result string
db.QueryRow("SELECT jsonb_agg(data) FROM users WHERE id IN ($1, $2, $3)", 1, 2, 3).Scan(&result)
```

```go
// pgx reference
var result string
pool.QueryRow(ctx, "SELECT jsonb_agg(data) FROM users WHERE id IN ($1, $2, $3)", 1, 2, 3).Scan(&result)
```

## TypeScript
```typescript
const { rows } = await pool.query('SELECT jsonb_agg(data) FROM users WHERE id IN ($1, $2, $3)', [1, 2, 3]);
const aggregated = rows[0].jsonb_agg;
```

## Python
```python
cur.execute("SELECT jsonb_agg(data) FROM users WHERE id IN (%s, %s, %s)", (1, 2, 3))
result = cur.fetchone()[0]
```

# Merge JSONB with jsonb_merge_patch

## Golang
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

## TypeScript
```typescript
const client = await pool.connect();
await client.query('BEGIN');
await client.query('UPDATE users SET data = jsonb_merge_patch(data, \'{\"age\":31}\') WHERE id = $1', [1]);
await client.query('COMMIT');
client.release();
```

## Python
```python
conn.autocommit = False
cur = conn.cursor()
cur.execute("UPDATE users SET data = jsonb_merge_patch(data, '{\"age\":31}') WHERE id = %s", (1,))
conn.commit()
```

# Search text in JSON with @? operator

## Golang
```go
var found bool
db.QueryRow("SELECT data @? '$.name ? (@ == \"Alice\")' FROM users WHERE id = $1", 1).Scan(&found)
```

```go
// pgx reference
pool.QueryRow(ctx, "SELECT data @? '$.name ? (@ == \"Alice\")' FROM users WHERE id = $1", 1).Scan(&found)
```

## TypeScript
```typescript
const { rows } = await pool.query('SELECT data @? \'$.name ? (@ == \"Alice\")\' FROM users WHERE id = $1', [1]);
const found = rows[0].exists;
```

## Python
```python
cur.execute("SELECT data @? '$.name ? (@ == \"Alice\")' FROM users WHERE id = %s", (1,))
found = cur.fetchone()[0]
```

# Extract all matching values with jsonb_path_query

## Golang
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

## TypeScript
```typescript
const { rows } = await pool.query('SELECT jsonb_path_query(data, \'$.tags[*] ? (@ == \"engineer\")\') FROM users WHERE id = $1', [1]);
const values = rows.map(r => r.jsonb_path_query);
```

## Python
```python
cur.execute("SELECT jsonb_path_query(data, '$.tags[*] ? (@ == \"engineer\")') FROM users WHERE id = %s", (1,))
values = [row[0] for row in cur.fetchall()]
```

# Query nested array with jsonb_path_query

## Golang
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

## TypeScript
```typescript
const { rows } = await pool.query('SELECT jsonb_path_query(data, \'$.items[*].name\') FROM users WHERE id = $1', [1]);
const values = rows.map(r => r.jsonb_path_query);
```

## Python
```python
cur.execute("SELECT jsonb_path_query(data, '$.items[*].name') FROM users WHERE id = %s", (1,))
values = [row[0] for row in cur.fetchall()]
```

# Get path to value with jsonb_path_query_first

## Golang
```go
var value string
db.QueryRow("SELECT jsonb_path_query_first(data, '$.name') FROM users WHERE id = $1", 1).Scan(&value)
```

```go
// pgx reference
pool.QueryRow(ctx, "SELECT jsonb_path_query_first(data, '$.name') FROM users WHERE id = $1", 1).Scan(&value)
```

## TypeScript
```typescript
const { rows } = await pool.query('SELECT jsonb_path_query_first(data, \'$.name\') FROM users WHERE id = $1', [1]);
const value = rows[0].jsonb_path_query_first;
```

## Python
```python
cur.execute("SELECT jsonb_path_query_first(data, '$.name') FROM users WHERE id = %s", (1,))
value = cur.fetchone()[0]
```