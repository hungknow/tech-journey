SQLite JSON operations in Go, TypeScript, Python.

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
- [Update JSON field with json_set](#update-json-field-with-json_set)
- [Add new field with json_insert](#add-new-field-with-json_insert)
- [Delete field with json_remove](#delete-field-with-json_remove)
- [Delete multiple fields](#delete-multiple-fields)
- [Delete nested field](#delete-nested-field)
- [Append to array with json_insert](#append-to-array-with-json_insert)
- [Concatenate JSON with json_patch](#concatenate-json-with-json_patch)
- [Get JSON keys with json_each](#get-json-keys-with-json_each)
- [Get all keys with json_each](#get-all-keys-with-json_each)
- [Check if any key exists](#check-if-any-key-exists)
- [Check if all keys exist](#check-if-all-keys-exist)
- [Aggregate JSON array with json_group_array](#aggregate-json-array-with-json_group_array)
- [Merge JSON with json_patch](#merge-json-with-json_patch)
- [Search text in JSON with json_each](#search-text-in-json-with-json_each)
- [Extract all matching values with json_each](#extract-all-matching-values-with-json_each)
- [Query nested array with json_each](#query-nested-array-with-json_each)
- [Get path to value with json_each](#get-path-to-value-with-json_each)

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
db.Exec("INSERT INTO users (data) VALUES (?)", string(jsonBytes))
```

```go
// modernc.org/sqlite reference
import "database/sql"
data := `{"name":"Alice","age":30,"tags":["engineer","golang"]}`
_, err := db.Exec("INSERT INTO users (data) VALUES (?)", data)
```

## TypeScript
```typescript
const data = { name: 'Alice', age: 30, tags: ['engineer', 'typescript'] };
await db.run('INSERT INTO users (data) VALUES (?)', JSON.stringify(data));
```

```typescript
// node-postgres reference
const data = { name: 'Alice', age: 30, tags: ['engineer', 'typescript'] };
await pool.query('INSERT INTO users (data) VALUES ($1)', [JSON.stringify(data)]);
```

## Python
```python
import json
data = {"name": "Alice", "age": 30, "tags": ["engineer", "python"]}
cur.execute("INSERT INTO users (data) VALUES (?)", (json.dumps(data),))
```

# Query field with -> operator

**SQLite equivalent**: `json_extract(data, '$.name')` or `data->'name'` (SQLite 3.38.0+)

## Golang
```go
var name string
db.QueryRow("SELECT json_extract(data, '$.name') FROM users WHERE id = ?", 1).Scan(&name)
```

```go
// SQLite 3.38.0+ with arrow syntax
db.QueryRow("SELECT data->'$.name' FROM users WHERE id = ?", 1).Scan(&name)
```

## TypeScript
```typescript
const row = await db.get<{ name: string }>('SELECT json_extract(data, \'$.name\') as name FROM users WHERE id = ?', [1]);
const name = row.name;
```

```typescript
// SQLite 3.38.0+ with arrow syntax
const row = await db.get<{ name: string }>('SELECT data->\'$.name\' as name FROM users WHERE id = ?', [1]);
```

## Python
```python
cur.execute("SELECT json_extract(data, '$.name') FROM users WHERE id = ?", (1,))
name = cur.fetchone()[0]
```

# Query field with ->> operator

**SQLite equivalent**: `json_extract(data, '$.name')` returns text in SQLite

## Golang
```go
var name string
db.QueryRow("SELECT json_extract(data, '$.name') FROM users WHERE id = ?", 1).Scan(&name)
```

## TypeScript
```typescript
const row = await db.get<{ name: string }>('SELECT json_extract(data, \'$.name\') as name FROM users WHERE id = ?', [1]);
const name = row.name;
```

## Python
```python
cur.execute("SELECT json_extract(data, '$.name') FROM users WHERE id = ?", (1,))
name = cur.fetchone()[0]
```

# Query nested field

## Golang
```go
var city string
db.QueryRow("SELECT json_extract(data, '$.address.city') FROM users WHERE id = ?", 1).Scan(&city)
```

## TypeScript
```typescript
const row = await db.get<{ city: string }>('SELECT json_extract(data, \'$.address.city\') as city FROM users WHERE id = ?', [1]);
const city = row.city;
```

## Python
```python
cur.execute("SELECT json_extract(data, '$.address.city') FROM users WHERE id = ?", (1,))
city = cur.fetchone()[0]
```

# Query array element

## Golang
```go
var firstTag string
db.QueryRow("SELECT json_extract(data, '$.tags[0]') FROM users WHERE id = ?", 1).Scan(&firstTag)
```

## TypeScript
```typescript
const row = await db.get<{ tags: string }>('SELECT json_extract(data, \'$.tags[0]\') as tags FROM users WHERE id = ?', [1]);
const firstTag = row.tags;
```

## Python
```python
cur.execute("SELECT json_extract(data, '$.tags[0]') FROM users WHERE id = ?", (1,))
first_tag = cur.fetchone()[0]
```

# Contains key with ? operator

**SQLite equivalent**: No direct operator, use `json_extract()` and check for NULL

## Golang
```go
var hasName bool
db.QueryRow("SELECT json_extract(data, '$.name') IS NOT NULL FROM users WHERE id = ?", 1).Scan(&hasName)
```

## TypeScript
```typescript
const row = await db.get<{ hasName: number }>('SELECT json_extract(data, \'$.name\') IS NOT NULL as hasName FROM users WHERE id = ?', [1]);
const hasName = Boolean(row.hasName);
```

## Python
```python
cur.execute("SELECT json_extract(data, '$.name') IS NOT NULL FROM users WHERE id = ?", (1,))
has_name = bool(cur.fetchone()[0])
```

# Contains value with @> operator

**SQLite equivalent**: No direct operator, use `json_each()` to check values

## Golang
```go
var contains bool
db.QueryRow("SELECT EXISTS(SELECT 1 FROM json_each(data) WHERE value = '\"Alice\"') FROM users WHERE id = ?", 1).Scan(&contains)
```

## TypeScript
```typescript
const row = await db.get<{ contains: number }>('SELECT EXISTS(SELECT 1 FROM json_each(data) WHERE value = \'\"Alice\"\') as contains FROM users WHERE id = ?', [1]);
const contains = Boolean(row.contains);
```

## Python
```python
cur.execute("SELECT EXISTS(SELECT 1 FROM json_each(data) WHERE value = '\"Alice\"') FROM users WHERE id = ?", (1,))
contains = bool(cur.fetchone()[0])
```

# Query where JSON contains key

## Golang
```go
rows, _ := db.Query("SELECT id FROM users WHERE json_extract(data, '$.name') IS NOT NULL")
```

## TypeScript
```typescript
const rows = await db.all('SELECT id FROM users WHERE json_extract(data, \'$.name\') IS NOT NULL');
```

## Python
```python
cur.execute("SELECT id FROM users WHERE json_extract(data, '$.name') IS NOT NULL")
ids = cur.fetchall()
```

# Query where JSON contains value

## Golang
```go
rows, _ := db.Query("SELECT id FROM users WHERE EXISTS(SELECT 1 FROM json_each(data) WHERE value = '\"Alice\"')")
```

## TypeScript
```typescript
const rows = await db.all('SELECT id FROM users WHERE EXISTS(SELECT 1 FROM json_each(data) WHERE value = \'\"Alice\"\')');
```

## Python
```python
cur.execute("SELECT id FROM users WHERE EXISTS(SELECT 1 FROM json_each(data) WHERE value = '\"Alice\"')")
ids = cur.fetchall()
```

# Query where array contains element

## Golang
```go
rows, _ := db.Query("SELECT id FROM users WHERE EXISTS(SELECT 1 FROM json_each(data, '$.tags') WHERE value = '\"engineer\"')")
```

## TypeScript
```typescript
const rows = await db.all('SELECT id FROM users WHERE EXISTS(SELECT 1 FROM json_each(data, \'$.tags\') WHERE value = \'\"engineer\"\')');
```

## Python
```python
cur.execute("SELECT id FROM users WHERE EXISTS(SELECT 1 FROM json_each(data, '$.tags') WHERE value = '\"engineer\"')")
ids = cur.fetchall()
```

# Update JSON field with json_set

## Golang
```go
tx, _ := db.Begin()
tx.Exec("UPDATE users SET data = json_set(data, '$.name', '\"Bob\"') WHERE id = ?", 1)
tx.Commit()
```

## TypeScript
```typescript
await db.run('BEGIN TRANSACTION');
await db.run('UPDATE users SET data = json_set(data, \'$.name\', \'\"Bob\"\') WHERE id = ?', [1]);
await db.run('COMMIT');
```

## Python
```python
conn.execute("BEGIN")
conn.execute("UPDATE users SET data = json_set(data, '$.name', '\"Bob\"') WHERE id = ?", (1,))
conn.commit()
```

# Add new field with json_insert

**SQLite equivalent**: Use `json_insert()` instead of `jsonb_set()` with create_if_missing

## Golang
```go
tx, _ := db.Begin()
tx.Exec("UPDATE users SET data = json_insert(data, '$.email', '\"alice@example.com\"') WHERE id = ?", 1)
tx.Commit()
```

## TypeScript
```typescript
await db.run('BEGIN TRANSACTION');
await db.run('UPDATE users SET data = json_insert(data, \'$.email\', \'\"alice@example.com\"\') WHERE id = ?', [1]);
await db.run('COMMIT');
```

## Python
```python
conn.execute("BEGIN")
conn.execute("UPDATE users SET data = json_insert(data, '$.email', '\"alice@example.com\"') WHERE id = ?", (1,))
conn.commit()
```

# Delete field with json_remove

**SQLite equivalent**: Use `json_remove()` instead of `-` operator

## Golang
```go
tx, _ := db.Begin()
tx.Exec("UPDATE users SET data = json_remove(data, '$.age') WHERE id = ?", 1)
tx.Commit()
```

## TypeScript
```typescript
await db.run('BEGIN TRANSACTION');
await db.run('UPDATE users SET data = json_remove(data, \'$.age\') WHERE id = ?', [1]);
await db.run('COMMIT');
```

## Python
```python
conn.execute("BEGIN")
conn.execute("UPDATE users SET data = json_remove(data, '$.age') WHERE id = ?", (1,))
conn.commit()
```

# Delete multiple fields

**SQLite equivalent**: Use `json_remove()` with multiple paths

## Golang
```go
tx, _ := db.Begin()
tx.Exec("UPDATE users SET data = json_remove(data, '$.age', '$.email') WHERE id = ?", 1)
tx.Commit()
```

## TypeScript
```typescript
await db.run('BEGIN TRANSACTION');
await db.run('UPDATE users SET data = json_remove(data, \'$.age\', \'$.email\') WHERE id = ?', [1]);
await db.run('COMMIT');
```

## Python
```python
conn.execute("BEGIN")
conn.execute("UPDATE users SET data = json_remove(data, '$.age', '$.email') WHERE id = ?", (1,))
conn.commit()
```

# Delete nested field

## Golang
```go
tx, _ := db.Begin()
tx.Exec("UPDATE users SET data = json_remove(data, '$.address.city') WHERE id = ?", 1)
tx.Commit()
```

## TypeScript
```typescript
await db.run('BEGIN TRANSACTION');
await db.run('UPDATE users SET data = json_remove(data, \'$.address.city\') WHERE id = ?', [1]);
await db.run('COMMIT');
```

## Python
```python
conn.execute("BEGIN")
conn.execute("UPDATE users SET data = json_remove(data, '$.address.city') WHERE id = ?", (1,))
conn.commit()
```

# Append to array with json_insert

## Golang
```go
tx, _ := db.Begin()
tx.Exec("UPDATE users SET data = json_set(data, '$.tags', json_extract(data, '$.tags') || '\"newtag\"') WHERE id = ?", 1)
tx.Commit()
```

## TypeScript
```typescript
await db.run('BEGIN TRANSACTION');
await db.run('UPDATE users SET data = json_set(data, \'$.tags\', json_extract(data, \'$.tags\') || \'\"newtag\"\') WHERE id = ?', [1]);
await db.run('COMMIT');
```

## Python
```python
conn.execute("BEGIN")
conn.execute("UPDATE users SET data = json_set(data, '$.tags', json_extract(data, '$.tags') || '\"newtag\"') WHERE id = ?", (1,))
conn.commit()
```

# Concatenate JSON with json_patch

**SQLite equivalent**: Use `json_patch()` instead of `||` operator

## Golang
```go
tx, _ := db.Begin()
tx.Exec("UPDATE users SET data = json_patch(data, '{\"email\":\"alice@example.com\"}') WHERE id = ?", 1)
tx.Commit()
```

## TypeScript
```typescript
await db.run('BEGIN TRANSACTION');
await db.run('UPDATE users SET data = json_patch(data, \'{"email":"alice@example.com"}\') WHERE id = ?', [1]);
await db.run('COMMIT');
```

## Python
```python
conn.execute("BEGIN")
conn.execute("UPDATE users SET data = json_patch(data, '{\"email\":\"alice@example.com\"}') WHERE id = ?", (1,))
conn.commit()
```

# Get JSON keys with json_each

**SQLite equivalent**: Use `json_each()` table-valued function

## Golang
```go
var key string
rows, _ := db.Query("SELECT key FROM json_each(data) WHERE id = ?", 1)
defer rows.Close()
var keys []string
for rows.Next() {
    rows.Scan(&key)
    keys = append(keys, key)
}
```

## TypeScript
```typescript
const rows = await db.all<{ key: string }>('SELECT key FROM json_each(data) WHERE id = ?', [1]);
const keys = rows.map(r => r.key);
```

## Python
```python
cur.execute("SELECT key FROM json_each(data) WHERE id = ?", (1,))
keys = [row[0] for row in cur.fetchall()]
```

# Get all keys with json_each

## Golang
```go
var keys string
db.QueryRow("SELECT group_concat(key) FROM json_each(data) WHERE id = ?", 1).Scan(&keys)
```

## TypeScript
```typescript
const row = await db.get<{ keys: string }>('SELECT group_concat(key) as keys FROM json_each(data) WHERE id = ?', [1]);
const keys = row.keys.split(',');
```

## Python
```python
cur.execute("SELECT group_concat(key) FROM json_each(data) WHERE id = ?", (1,))
keys = cur.fetchone()[0].split(',')
```

# Check if any key exists

**SQLite equivalent**: Use subquery with `json_each()`

## Golang
```go
var exists bool
db.QueryRow("SELECT EXISTS(SELECT 1 FROM json_each(data) WHERE key IN ('name', 'email')) FROM users WHERE id = ?", 1).Scan(&exists)
```

## TypeScript
```typescript
const row = await db.get<{ exists: number }>('SELECT EXISTS(SELECT 1 FROM json_each(data) WHERE key IN (\'name\', \'email\')) as exists FROM users WHERE id = ?', [1]);
const exists = Boolean(row.exists);
```

## Python
```python
cur.execute("SELECT EXISTS(SELECT 1 FROM json_each(data) WHERE key IN ('name', 'email')) FROM users WHERE id = ?", (1,))
exists = bool(cur.fetchone()[0])
```

# Check if all keys exist

**SQLite equivalent**: Use subquery with `json_each()` and count

## Golang
```go
var exists bool
db.QueryRow("SELECT (SELECT COUNT(*) FROM json_each(data) WHERE key IN ('name', 'age')) = 2 FROM users WHERE id = ?", 1).Scan(&exists)
```

## TypeScript
```typescript
const row = await db.get<{ exists: number }>('SELECT (SELECT COUNT(*) FROM json_each(data) WHERE key IN (\'name\', \'age\')) = 2 as exists FROM users WHERE id = ?', [1]);
const exists = Boolean(row.exists);
```

## Python
```python
cur.execute("SELECT (SELECT COUNT(*) FROM json_each(data) WHERE key IN ('name', 'age')) = 2 FROM users WHERE id = ?", (1,))
exists = bool(cur.fetchone()[0])
```

# Aggregate JSON array with json_group_array

**SQLite equivalent**: Use `json_group_array()` aggregation function

## Golang
```go
var result string
db.QueryRow("SELECT json_group_array(data) FROM users WHERE id IN (?, ?, ?)", 1, 2, 3).Scan(&result)
```

## TypeScript
```typescript
const row = await db.get<{ result: string }>('SELECT json_group_array(data) as result FROM users WHERE id IN (?, ?, ?)', [1, 2, 3]);
const aggregated = row.result;
```

## Python
```python
cur.execute("SELECT json_group_array(data) FROM users WHERE id IN (?, ?, ?)", (1, 2, 3))
result = cur.fetchone()[0]
```

# Merge JSON with json_patch

**SQLite equivalent**: Use `json_patch()` instead of `jsonb_merge_patch()`

## Golang
```go
tx, _ := db.Begin()
tx.Exec("UPDATE users SET data = json_patch(data, '{\"age\":31}') WHERE id = ?", 1)
tx.Commit()
```

## TypeScript
```typescript
await db.run('BEGIN TRANSACTION');
await db.run('UPDATE users SET data = json_patch(data, \'{"age":31}\') WHERE id = ?', [1]);
await db.run('COMMIT');
```

## Python
```python
conn.execute("BEGIN")
conn.execute("UPDATE users SET data = json_patch(data, '{\"age\":31}') WHERE id = ?", (1,))
conn.commit()
```

# Search text in JSON with json_each

**SQLite equivalent**: No direct JSONPath support, use `json_each()` to search

## Golang
```go
var found bool
db.QueryRow("SELECT EXISTS(SELECT 1 FROM json_each(data) WHERE value = '\"Alice\"') FROM users WHERE id = ?", 1).Scan(&found)
```

## TypeScript
```typescript
const row = await db.get<{ found: number }>('SELECT EXISTS(SELECT 1 FROM json_each(data) WHERE value = \'\"Alice\"\') as found FROM users WHERE id = ?', [1]);
const found = Boolean(row.found);
```

## Python
```python
cur.execute("SELECT EXISTS(SELECT 1 FROM json_each(data) WHERE value = '\"Alice\"') FROM users WHERE id = ?", (1,))
found = bool(cur.fetchone()[0])
```

# Extract all matching values with json_each

**SQLite equivalent**: Use `json_each()` with path and filter

## Golang
```go
var values []string
rows, _ := db.Query("SELECT value FROM json_each(data, '$.tags') WHERE value = '\"engineer\"' AND id = ?", 1)
defer rows.Close()
for rows.Next() {
    var value string
    rows.Scan(&value)
    values = append(values, value)
}
```

## TypeScript
```typescript
const rows = await db.all<{ value: string }>('SELECT value FROM json_each(data, \'$.tags\') WHERE value = \'\"engineer"\' AND id = ?', [1]);
const values = rows.map(r => r.value);
```

## Python
```python
cur.execute("SELECT value FROM json_each(data, '$.tags') WHERE value = '\"engineer\"' AND id = ?", (1,))
values = [row[0] for row in cur.fetchall()]
```

# Query nested array with json_each

**SQLite equivalent**: Use `json_each()` with recursive CTE for nested structures

## Golang
```go
var values []string
rows, _ := db.Query(`
    WITH RECURSIVE items AS (
        SELECT value FROM json_each(data, '$.items')
    )
    SELECT json_extract(value, '$.name') FROM items WHERE id = ?
`, 1)
defer rows.Close()
for rows.Next() {
    var value string
    rows.Scan(&value)
    values = append(values, value)
}
```

## TypeScript
```typescript
const rows = await db.all<{ name: string }>(`
    WITH RECURSIVE items AS (
        SELECT value FROM json_each(data, '$.items')
    )
    SELECT json_extract(value, '$.name') as name FROM items WHERE id = ?
`, [1]);
const values = rows.map(r => r.name);
```

## Python
```python
cur.execute("""
    WITH RECURSIVE items AS (
        SELECT value FROM json_each(data, '$.items')
    )
    SELECT json_extract(value, '$.name') FROM items WHERE id = ?
""", (1,))
values = [row[0] for row in cur.fetchall()]
```

# Get path to value with json_each

**SQLite equivalent**: Use `json_each()` table-valued function with `path` column

## Golang
```go
var value, path string
db.QueryRow("SELECT value, path FROM json_each(data) WHERE key = 'name' AND id = ?", 1).Scan(&value, &path)
```

## TypeScript
```typescript
const row = await db.get<{ value: string, path: string }>('SELECT value, path FROM json_each(data) WHERE key = \'name\' AND id = ?', [1]);
const value = row.value;
const path = row.path;
```

## Python
```python
cur.execute("SELECT value, path FROM json_each(data) WHERE key = 'name' AND id = ?", (1,))
value, path = cur.fetchone()
```