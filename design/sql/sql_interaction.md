Connect to SQL, query, and run transactions in Go, TypeScript, Python.

# Connect & pool

## Golang
```go
import "database/sql"
import _ "github.com/lib/pq"
import "time"
db, err := sql.Open("postgres", "postgres://user:pass@localhost/db?sslmode=disable")
db.SetMaxOpenConns(10)
db.SetMaxIdleConns(5)
db.SetConnMaxLifetime(time.Hour)
```

```go
import (
    "github.com/jackc/pgx/v5/pgxpool"
    "time"
)

cfg, _ := pgxpool.ParseConfig("postgres://user:pass@localhost/db")
cfg.MaxConns = 10
cfg.MinConns = 2
cfg.MaxConnLifetime = time.Hour
pool, _ := pgxpool.NewWithConfig(ctx, cfg)
```

## TypeScript
```typescript
import pg from 'pg';
const pool = new pg.Pool({
  connectionString: 'postgres://user:pass@localhost/db',
  max: 10,
  idleTimeoutMillis: 30000,
});
```

## Python
```python
import psycopg2.pool
pool = psycopg2.pool.ThreadedConnectionPool(minconn=1, maxconn=10, dsn="postgresql://user:pass@localhost/db")
conn = pool.getconn()   # use
pool.putconn(conn)      # return
```


# Query one row

## Golang
```go
// Scan is by position — no struct tag needed
type User struct{ Id int; Name string }
var u User
id, name := 1, "alice"
db.QueryRow("SELECT id, name FROM users WHERE id = $1 AND name = $2", id, name).Scan(&u.Id, &u.Name)
```

```go
// pgx reference
pool.QueryRow(ctx, "SELECT id, name FROM users WHERE id = $1 AND name = $2", id, name).Scan(&u.Id, &u.Name)
```

## TypeScript
```typescript
type User = { id: number; name: string };
const id = 1, name = 'alice';  // values you provide
const r = await pool.query<User>('SELECT id, name FROM users WHERE id = $1 AND name = $2', [id, name]);
const u: User = r.rows[0];
```

## Python
```python
from dataclasses import dataclass
@dataclass
class User: id: int; name: str
id, name = 1, 'alice'  # values you provide
with conn.cursor() as cur:
    cur.execute("SELECT id, name FROM users WHERE id = %s AND name = %s", (id, name))
    u = User(*cur.fetchone())
```

# Query many rows

## Golang
```go
type User struct {
  Id   int    `db:"user_id"`
  Name string `db:"full_name"`
}
id, name := 1, "alice"
rows, err := db.Query("SELECT user_id, full_name FROM users WHERE user_id = $1 AND full_name = $2", id, name)
defer rows.Close()
var users []User
for rows.Next() {
  var u User
  rows.Scan(&u.Id, &u.Name)
  users = append(users, u)
}
```

```go
// pgx reference: RowToStructByName maps by db tag
rows, _ := pool.Query(ctx, "SELECT user_id, full_name FROM users WHERE user_id = $1 AND full_name = $2", id, name)
users, _ := pgx.CollectRows(rows, pgx.RowToStructByName[User])
```

## TypeScript
```typescript
// pg has no native column→field mapping. Use SQL AS or .map():
type User = { id: number; name: string };
type Row = { user_id: number; full_name: string };
const id = 1, name = 'alice';
const r = await pool.query<Row>('SELECT user_id, full_name FROM users WHERE user_id = $1 AND full_name = $2', [id, name]);
const users: User[] = r.rows.map(row => ({ id: row.user_id, name: row.full_name }));
// alternative: SELECT user_id AS id, full_name AS name — then r.rows is User[]
```

## Python
```python
from dataclasses import dataclass
@dataclass
class User: id: int; name: str
id, name = 1, 'alice'  # values you provide
cur.execute("SELECT id, name FROM users WHERE id = %s AND name = %s", (id, name))
users = [User(*row) for row in cur.fetchall()]
```

# Submit with transaction

## Golang
```go
tx, _ := db.Begin()
tx.Exec("INSERT INTO users (name) VALUES ($1)", "a")
tx.Exec("UPDATE users SET name = $1 WHERE id = $2", "b", 1)
tx.Commit() // or tx.Rollback()
```

```go
// pgx reference
tx, _ := pool.Begin(ctx)
tx.Exec(ctx, "INSERT INTO users (name) VALUES ($1)", "a")
tx.Exec(ctx, "UPDATE users SET name = $1 WHERE id = $2", "b", 1)
tx.Commit(ctx) // or tx.Rollback(ctx)
```

## TypeScript
```typescript
const client = await pool.connect();
await client.query('BEGIN');
await client.query('INSERT INTO users (name) VALUES ($1)', ['a']);
await client.query('UPDATE users SET name = $1 WHERE id = $2', ['b', 1]);
await client.query('COMMIT'); // or ROLLBACK
client.release();
```

## Python
```python
conn.autocommit = False
cur = conn.cursor()
cur.execute("INSERT INTO users (name) VALUES (%s)", ("a",))
cur.execute("UPDATE users SET name = %s WHERE id = %s", ("b", 1))
conn.commit()  # or conn.rollback()
```