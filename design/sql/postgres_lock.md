# PostgreSQL Locks

## Table of Contents

- [Advisory Locks](#advisory-locks)
- [Table-level Locks](#table-level-locks)
  - [ACCESS SHARE](#access-share)
  - [ROW SHARE](#row-share)
  - [ROW EXCLUSIVE](#row-exclusive)
  - [SHARE UPDATE EXCLUSIVE](#share-update-exclusive)
  - [SHARE](#share)
  - [SHARE ROW EXCLUSIVE](#share-row-exclusive)
  - [EXCLUSIVE](#exclusive)
  - [ACCESS EXCLUSIVE](#access-exclusive)
- [Row-level Locks](#row-level-locks)
  - [FOR UPDATE](#for-update)
  - [FOR SHARE](#for-share)
  - [FOR NO KEY UPDATE](#for-no-key-update)
  - [FOR KEY SHARE](#for-key-share)
- [Explicit Locking](#explicit-locking)

## Advisory Locks

Advisory locks are application-level locks that provide a mechanism for coordinating access to resources without using the standard table/row lock mechanisms. They're useful for:

- Coordinating distributed workers
- Preventing duplicate job execution
- Implementing custom locking semantics

### Why use Advisory Locks

Advisory locks are ideal when you need to:
- Implement custom synchronization logic beyond what standard SQL operations provide
- Coordinate across multiple services or workers
- Prevent race conditions in job processing systems
- Implement rate limiting or mutex behavior in your application layer

### Go Code Example

```go
package main

import (
    "context"
    "database/sql"
    "fmt"
    "log"
    "time"

    _ "github.com/lib/pq"
)

type AdvisoryLockManager struct {
    db *sql.DB
}

func NewAdvisoryLockManager(db *sql.DB) *AdvisoryLockManager {
    return &AdvisoryLockManager{db: db}
}

// TryAcquireLock attempts to acquire an advisory lock
// Returns true if lock was acquired, false otherwise
func (m *AdvisoryLockManager) TryAcquireLock(ctx context.Context, lockID int64) (bool, error) {
    var acquired bool
    err := m.db.QueryRowContext(ctx, 
        "SELECT pg_try_advisory_lock($1)", lockID).Scan(&acquired)
    if err != nil {
        return false, fmt.Errorf("failed to acquire lock: %w", err)
    }
    return acquired, nil
}

// AcquireLock blocks until the lock is acquired
func (m *AdvisoryLockManager) AcquireLock(ctx context.Context, lockID int64) error {
    _, err := m.db.ExecContext(ctx, 
        "SELECT pg_advisory_lock($1)", lockID)
    if err != nil {
        return fmt.Errorf("failed to acquire lock: %w", err)
    }
    return nil
}

// ReleaseLock releases an advisory lock
func (m *AdvisoryLockManager) ReleaseLock(ctx context.Context, lockID int64) error {
    _, err := m.db.ExecContext(ctx, 
        "SELECT pg_advisory_unlock($1)", lockID)
    if err != nil {
        return fmt.Errorf("failed to release lock: %w", err)
    }
    return nil
}

// ProcessJobWithLock ensures only one worker processes a job at a time
func (m *AdvisoryLockManager) ProcessJobWithLock(ctx context.Context, jobID int64, processFunc func() error) error {
    // Try to acquire lock for this specific job
    locked, err := m.TryAcquireLock(ctx, jobID)
    if err != nil {
        return err
    }
    if !locked {
        return fmt.Errorf("job %d is already being processed", jobID)
    }
    defer m.ReleaseLock(ctx, jobID)

    // Process the job
    return processFunc()
}

func main() {
    db, err := sql.Open("postgres", "host=localhost user=postgres dbname=mydb sslmode=disable")
    if err != nil {
        log.Fatal(err)
    }
    defer db.Close()

    lockManager := NewAdvisoryLockManager(db)

    // Example: Prevent duplicate job processing
    jobID := int64(12345)
    
    ctx, cancel := context.WithTimeout(context.Background(), 30*time.Second)
    defer cancel()

    err = lockManager.ProcessJobWithLock(ctx, jobID, func() error {
        fmt.Printf("Processing job %d\n", jobID)
        // Simulate job processing
        time.Sleep(2 * time.Second)
        fmt.Printf("Job %d completed\n", jobID)
        return nil
    })

    if err != nil {
        log.Printf("Error processing job: %v", err)
    }
}
```

## Table-level Locks

Table-level locks control access to entire tables. They're acquired automatically by DDL operations and can be explicitly requested for custom synchronization.

### ACCESS SHARE

**Conflicts with:** ACCESS EXCLUSIVE

**Acquired by:** SELECT statements

**Why use ACCESS SHARE:**
- Allows concurrent reads while preventing table modifications
- Used when you need to ensure a table isn't dropped or modified during read operations
- Provides read consistency for complex reporting queries

```go
package main

import (
    "context"
    "database/sql"
    "fmt"
    "log"

    _ "github.com/lib/pq"
)

func SafeReadTable(ctx context.Context, db *sql.DB, tableName string) error {
    tx, err := db.BeginTx(ctx, nil)
    if err != nil {
        return fmt.Errorf("failed to begin transaction: %w", err)
    }
    defer tx.Rollback()

    // Explicitly lock table in ACCESS SHARE mode
    _, err = tx.ExecContext(ctx, fmt.Sprintf("LOCK TABLE %s IN ACCESS SHARE MODE", tableName))
    if err != nil {
        return fmt.Errorf("failed to lock table: %w", err)
    }

    // Now safe to perform read operations
    var count int
    err = tx.QueryRowContext(ctx, fmt.Sprintf("SELECT COUNT(*) FROM %s", tableName)).Scan(&count)
    if err != nil {
        return fmt.Errorf("query failed: %w", err)
    }

    fmt.Printf("Table %s has %d rows\n", tableName, count)

    return tx.Commit()
}

func main() {
    db, err := sql.Open("postgres", "host=localhost user=postgres dbname=mydb sslmode=disable")
    if err != nil {
        log.Fatal(err)
    }
    defer db.Close()

    ctx := context.Background()
    err = SafeReadTable(ctx, db, "users")
    if err != nil {
        log.Fatal(err)
    }
}
```

### ROW SHARE

**Conflicts with:** EXCLUSIVE, ACCESS EXCLUSIVE

**Acquired by:** SELECT FOR UPDATE/FOR SHARE

**Why use ROW SHARE:**
- Allows concurrent reads and row-level locks
- Prevents table-wide exclusive locks while maintaining row-level consistency
- Useful for scenarios where you need to update some rows but allow access to others

```go
package main

import (
    "context"
    "database/sql"
    "fmt"
    "log"

    _ "github.com/lib/pq"
)

func ProcessBatchWithRowShare(ctx context.Context, db *sql.DB, tableName string, batchIDs []int64) error {
    tx, err := db.BeginTx(ctx, nil)
    if err != nil {
        return fmt.Errorf("failed to begin transaction: %w", err)
    }
    defer tx.Rollback()

    // Lock table in ROW SHARE mode to allow other row-level operations
    _, err = tx.ExecContext(ctx, fmt.Sprintf("LOCK TABLE %s IN ROW SHARE MODE", tableName))
    if err != nil {
        return fmt.Errorf("failed to lock table: %w", err)
    }

    // Now perform SELECT FOR UPDATE on specific rows
    for _, id := range batchIDs {
        var value string
        err = tx.QueryRowContext(ctx, 
            fmt.Sprintf("SELECT value FROM %s WHERE id = $1 FOR UPDATE", tableName), id).Scan(&value)
        if err != nil {
            if err == sql.ErrNoRows {
                continue
            }
            return fmt.Errorf("failed to lock row: %w", err)
        }

        // Process the row
        fmt.Printf("Processing row %d with value %s\n", id, value)
    }

    return tx.Commit()
}
```

### ROW EXCLUSIVE

**Conflicts with:** SHARE, SHARE ROW EXCLUSIVE, EXCLUSIVE, ACCESS EXCLUSIVE

**Acquired by:** INSERT, UPDATE, DELETE, MERGE

**Why use ROW EXCLUSIVE:**
- Standard lock for write operations
- Allows concurrent writes to different rows
- Prevents table-level operations that would conflict with row modifications

```go
package main

import (
    "context"
    "database/sql"
    "fmt"
    "log"

    _ "github.com/lib/pq"
)

func BulkInsertWithRowExclusive(ctx context.Context, db *sql.DB, tableName string, values []string) error {
    tx, err := db.BeginTx(ctx, nil)
    if err != nil {
        return fmt.Errorf("failed to begin transaction: %w", err)
    }
    defer tx.Rollback()

    // Explicitly lock table in ROW EXCLUSIVE mode
    _, err = tx.ExecContext(ctx, fmt.Sprintf("LOCK TABLE %s IN ROW EXCLUSIVE MODE", tableName))
    if err != nil {
        return fmt.Errorf("failed to lock table: %w", err)
    }

    // Perform bulk insert
    stmt, err := tx.PrepareContext(ctx, fmt.Sprintf("INSERT INTO %s (value) VALUES ($1)", tableName))
    if err != nil {
        return fmt.Errorf("failed to prepare statement: %w", err)
    }
    defer stmt.Close()

    for _, value := range values {
        _, err = stmt.ExecContext(ctx, value)
        if err != nil {
            return fmt.Errorf("failed to insert value: %w", err)
        }
    }

    return tx.Commit()
}

func main() {
    db, err := sql.Open("postgres", "host=localhost user=postgres dbname=mydb sslmode=disable")
    if err != nil {
        log.Fatal(err)
    }
    defer db.Close()

    ctx := context.Background()
    values := []string{"value1", "value2", "value3"}
    err = BulkInsertWithRowExclusive(ctx, db, "items", values)
    if err != nil {
        log.Fatal(err)
    }
}
```

### SHARE UPDATE EXCLUSIVE

**Conflicts with:** SHARE UPDATE EXCLUSIVE, SHARE, SHARE ROW EXCLUSIVE, EXCLUSIVE, ACCESS EXCLUSIVE

**Acquired by:** VACUUM (without FULL), ANALYZE, CREATE INDEX CONCURRENTLY

**Why use SHARE UPDATE EXCLUSIVE:**
- Allows concurrent reads while preventing conflicting maintenance operations
- Used for schema changes and maintenance that don't require full table lock
- Ideal for online schema migrations and maintenance

```go
package main

import (
    "context"
    "database/sql"
    "fmt"
    "log"

    _ "github.com/lib/pq"
)

func CreateIndexConcurrently(ctx context.Context, db *sql.DB, tableName string, indexName string, columns []string) error {
    tx, err := db.BeginTx(ctx, nil)
    if err != nil {
        return fmt.Errorf("failed to begin transaction: %w", err)
    }
    defer tx.Rollback()

    // Lock table in SHARE UPDATE EXCLUSIVE mode
    _, err = tx.ExecContext(ctx, fmt.Sprintf("LOCK TABLE %s IN SHARE UPDATE EXCLUSIVE MODE", tableName))
    if err != nil {
        return fmt.Errorf("failed to lock table: %w", err)
    }

    // Create index concurrently to allow ongoing operations
    columnsStr := ""
    for i, col := range columns {
        if i > 0 {
            columnsStr += ", "
        }
        columnsStr += col
    }

    _, err = tx.ExecContext(ctx, 
        fmt.Sprintf("CREATE INDEX CONCURRENTLY %s ON %s (%s)", indexName, tableName, columnsStr))
    if err != nil {
        return fmt.Errorf("failed to create index: %w", err)
    }

    return tx.Commit()
}

func main() {
    db, err := sql.Open("postgres", "host=localhost user=postgres dbname=mydb sslmode=disable")
    if err != nil {
        log.Fatal(err)
    }
    defer db.Close()

    ctx := context.Background()
    err = CreateIndexConcurrently(ctx, db, "users", "idx_users_email", []string{"email"})
    if err != nil {
        log.Fatal(err)
    }
}
```

### SHARE

**Conflicts with:** ROW EXCLUSIVE, SHARE UPDATE EXCLUSIVE, SHARE ROW EXCLUSIVE, EXCLUSIVE, ACCESS EXCLUSIVE

**Acquired by:** CREATE INDEX (without CONCURRENTLY)

**Why use SHARE:**
- Prevents concurrent modifications while allowing reads
- Used when creating indexes that need consistent view of data
- Ensures index creation sees consistent snapshot of table data

```go
package main

import (
    "context"
    "database/sql"
    "fmt"
    "log"

    _ "github.com/lib/pq"
)

func CreateIndexWithShareLock(ctx context.Context, db *sql.DB, tableName string, indexName string, columns []string) error {
    tx, err := db.BeginTx(ctx, nil)
    if err != nil {
        return fmt.Errorf("failed to begin transaction: %w", err)
    }
    defer tx.Rollback()

    // Lock table in SHARE mode
    _, err = tx.ExecContext(ctx, fmt.Sprintf("LOCK TABLE %s IN SHARE MODE", tableName))
    if err != nil {
        return fmt.Errorf("failed to lock table: %w", err)
    }

    // Create index
    columnsStr := ""
    for i, col := range columns {
        if i > 0 {
            columnsStr += ", "
        }
        columnsStr += col
    }

    _, err = tx.ExecContext(ctx, 
        fmt.Sprintf("CREATE INDEX %s ON %s (%s)", indexName, tableName, columnsStr))
    if err != nil {
        return fmt.Errorf("failed to create index: %w", err)
    }

    return tx.Commit()
}
```

### SHARE ROW EXCLUSIVE

**Conflicts with:** ROW EXCLUSIVE, SHARE UPDATE EXCLUSIVE, SHARE, SHARE ROW EXCLUSIVE, EXCLUSIVE, ACCESS EXCLUSIVE

**Why use SHARE ROW EXCLUSIVE:**
- Protects table while allowing row-level operations
- Stronger than SHARE, prevents concurrent updates
- Used for scenarios needing read consistency with exclusive row updates

```go
package main

import (
    "context"
    "database/sql"
    "fmt"
    "log"

    _ "github.com/lib/pq"
)

func TableMaintenanceWithShareRowExclusive(ctx context.Context, db *sql.DB, tableName string, maintenanceFunc func(*sql.Tx) error) error {
    tx, err := db.BeginTx(ctx, nil)
    if err != nil {
        return fmt.Errorf("failed to begin transaction: %w", err)
    }
    defer tx.Rollback()

    // Lock table in SHARE ROW EXCLUSIVE mode
    _, err = tx.ExecContext(ctx, fmt.Sprintf("LOCK TABLE %s IN SHARE ROW EXCLUSIVE MODE", tableName))
    if err != nil {
        return fmt.Errorf("failed to lock table: %w", err)
    }

    // Perform maintenance operations
    err = maintenanceFunc(tx)
    if err != nil {
        return fmt.Errorf("maintenance failed: %w", err)
    }

    return tx.Commit()
}

func main() {
    db, err := sql.Open("postgres", "host=localhost user=postgres dbname=mydb sslmode=disable")
    if err != nil {
        log.Fatal(err)
    }
    defer db.Close()

    ctx := context.Background()
    err = TableMaintenanceWithShareRowExclusive(ctx, db, "users", func(tx *sql.Tx) error {
        // Perform data cleanup or reorganization
        _, err := tx.ExecContext(ctx, "UPDATE users SET status = 'active' WHERE last_login > NOW() - INTERVAL '30 days'")
        return err
    })
    if err != nil {
        log.Fatal(err)
    }
}
```

### EXCLUSIVE

**Conflicts with:** ROW SHARE, ROW EXCLUSIVE, SHARE UPDATE EXCLUSIVE, SHARE, SHARE ROW EXCLUSIVE, EXCLUSIVE, ACCESS EXCLUSIVE

**Why use EXCLUSIVE:**
- Prevents concurrent writes while allowing reads
- Used for data consistency during critical updates
- Stronger isolation than SHARE but allows SELECT operations

```go
package main

import (
    "context"
    "database/sql"
    "fmt"
    "log"

    _ "github.com/lib/pq"
)

func UpdateTableWithExclusiveLock(ctx context.Context, db *sql.DB, tableName string, updateFunc func(*sql.Tx) error) error {
    tx, err := db.BeginTx(ctx, nil)
    if err != nil {
        return fmt.Errorf("failed to begin transaction: %w", err)
    }
    defer tx.Rollback()

    // Lock table in EXCLUSIVE mode
    _, err = tx.ExecContext(ctx, fmt.Sprintf("LOCK TABLE %s IN EXCLUSIVE MODE", tableName))
    if err != nil {
        return fmt.Errorf("failed to lock table: %w", err)
    }

    // Perform critical updates
    err = updateFunc(tx)
    if err != nil {
        return fmt.Errorf("update failed: %w", err)
    }

    return tx.Commit()
}

func main() {
    db, err := sql.Open("postgres", "host=localhost user=postgres dbname=mydb sslmode=disable")
    if err != nil {
        log.Fatal(err)
    }
    defer db.Close()

    ctx := context.Background()
    err = UpdateTableWithExclusiveLock(ctx, db, "accounts", func(tx *sql.Tx) error {
        // Perform critical balance updates
        _, err := tx.ExecContext(ctx, 
            "UPDATE accounts SET balance = balance + 100 WHERE type = 'premium'")
        return err
    })
    if err != nil {
        log.Fatal(err)
    }
}
```

### ACCESS EXCLUSIVE

**Conflicts with:** All modes

**Acquired by:** DROP TABLE, TRUNCATE, REINDEX, CLUSTER, VACUUM FULL, ALTER TABLE (most forms)

**Why use ACCESS EXCLUSIVE:**
- Strongest table lock, prevents all concurrent access
- Used for DDL operations that change table structure
- Ensures no other transactions can access the table during modification

```go
package main

import (
    "context"
    "database/sql"
    "fmt"
    "log"

    _ "github.com/lib/pq"
)

func AlterTableWithAccessExclusive(ctx context.Context, db *sql.DB, tableName string, alterStatement string) error {
    tx, err := db.BeginTx(ctx, nil)
    if err != nil {
        return fmt.Errorf("failed to begin transaction: %w", err)
    }
    defer tx.Rollback()

    // Lock table in ACCESS EXCLUSIVE mode
    _, err = tx.ExecContext(ctx, fmt.Sprintf("LOCK TABLE %s IN ACCESS EXCLUSIVE MODE", tableName))
    if err != nil {
        return fmt.Errorf("failed to lock table: %w", err)
    }

    // Perform DDL operation
    _, err = tx.ExecContext(ctx, alterStatement)
    if err != nil {
        return fmt.Errorf("failed to alter table: %w", err)
    }

    return tx.Commit()
}

func main() {
    db, err := sql.Open("postgres", "host=localhost user=postgres dbname=mydb sslmode=disable")
    if err != nil {
        log.Fatal(err)
    }
    defer db.Close()

    ctx := context.Background()
    alterSQL := "ALTER TABLE users ADD COLUMN phone VARCHAR(20)"
    err = AlterTableWithAccessExclusive(ctx, db, "users", alterSQL)
    if err != nil {
        log.Fatal(err)
    }
}
```

## Row-level Locks

Row-level locks provide fine-grained concurrency control by locking specific rows rather than entire tables.

### FOR UPDATE

**Why use FOR UPDATE:**
- Locks selected rows for update within the same transaction
- Prevents other transactions from modifying or deleting these rows
- Essential for read-modify-write patterns to prevent lost updates

```go
package main

import (
    "context"
    "database/sql"
    "fmt"
    "log"

    _ "github.com/lib/pq"
)

type Account struct {
    ID      int64
    Balance float64
    Version int
}

func TransferFunds(ctx context.Context, db *sql.DB, fromID, toID int64, amount float64) error {
    tx, err := db.BeginTx(ctx, nil)
    if err != nil {
        return fmt.Errorf("failed to begin transaction: %w", err)
    }
    defer tx.Rollback()

    // Lock both accounts for update to prevent concurrent modifications
    var fromAccount, toAccount Account
    
    err = tx.QueryRowContext(ctx, 
        "SELECT id, balance, version FROM accounts WHERE id = $1 FOR UPDATE", fromID).Scan(
        &fromAccount.ID, &fromAccount.Balance, &fromAccount.Version)
    if err != nil {
        return fmt.Errorf("failed to lock from account: %w", err)
    }

    err = tx.QueryRowContext(ctx, 
        "SELECT id, balance, version FROM accounts WHERE id = $1 FOR UPDATE", toID).Scan(
        &toAccount.ID, &toAccount.Balance, &toAccount.Version)
    if err != nil {
        return fmt.Errorf("failed to lock to account: %w", err)
    }

    // Validate balance
    if fromAccount.Balance < amount {
        return fmt.Errorf("insufficient balance")
    }

    // Perform transfer
    fromAccount.Balance -= amount
    toAccount.Balance += amount

    // Update with optimistic locking
    result, err := tx.ExecContext(ctx, 
        "UPDATE accounts SET balance = $1, version = version + 1 WHERE id = $2 AND version = $3",
        fromAccount.Balance, fromAccount.ID, fromAccount.Version)
    if err != nil {
        return fmt.Errorf("failed to update from account: %w", err)
    }

    rows, err := result.RowsAffected()
    if err != nil {
        return fmt.Errorf("failed to get affected rows: %w", err)
    }
    if rows == 0 {
        return fmt.Errorf("concurrent modification detected")
    }

    result, err = tx.ExecContext(ctx, 
        "UPDATE accounts SET balance = $1, version = version + 1 WHERE id = $2 AND version = $3",
        toAccount.Balance, toAccount.ID, toAccount.Version)
    if err != nil {
        return fmt.Errorf("failed to update to account: %w", err)
    }

    rows, err = result.RowsAffected()
    if err != nil {
        return fmt.Errorf("failed to get affected rows: %w", err)
    }
    if rows == 0 {
        return fmt.Errorf("concurrent modification detected")
    }

    return tx.Commit()
}

func main() {
    db, err := sql.Open("postgres", "host=localhost user=postgres dbname=mydb sslmode=disable")
    if err != nil {
        log.Fatal(err)
    }
    defer db.Close()

    ctx := context.Background()
    err = TransferFunds(ctx, db, 1, 2, 100.0)
    if err != nil {
        log.Printf("Transfer failed: %v", err)
    } else {
        log.Println("Transfer successful")
    }
}
```

### FOR SHARE

**Why use FOR SHARE:**
- Locks rows for reading, preventing other transactions from modifying them
- Allows other transactions to also read the same rows with FOR SHARE
- Useful when you need read consistency without preventing other readers

```go
package main

import (
    "context"
    "database/sql"
    "fmt"
    "log"

    _ "github.com/lib/pq"
)

func SafeReportGeneration(ctx context.Context, db *sql.DB, reportIDs []int64) ([][]string, error) {
    tx, err := db.BeginTx(ctx, nil)
    if err != nil {
        return nil, fmt.Errorf("failed to begin transaction: %w", err)
    }
    defer tx.Rollback()

    // Lock rows for share to ensure consistent read during report generation
    var results [][]string
    for _, id := range reportIDs {
        var name, status string
        err = tx.QueryRowContext(ctx, 
            "SELECT name, status FROM reports WHERE id = $1 FOR SHARE", id).Scan(&name, &status)
        if err != nil {
            if err == sql.ErrNoRows {
                continue
            }
            return nil, fmt.Errorf("failed to read report: %w", err)
        }

        results = append(results, []string{fmt.Sprintf("%d", id), name, status})
    }

    return results, tx.Commit()
}

func main() {
    db, err := sql.Open("postgres", "host=localhost user=postgres dbname=mydb sslmode=disable")
    if err != nil {
        log.Fatal(err)
    }
    defer db.Close()

    ctx := context.Background()
    reports, err := SafeReportGeneration(ctx, db, []int64{1, 2, 3})
    if err != nil {
        log.Fatal(err)
    }

    for _, report := range reports {
        fmt.Printf("Report ID: %s, Name: %s, Status: %s\n", report[0], report[1], report[2])
    }
}
```

### FOR NO KEY UPDATE

**Why use FOR NO KEY UPDATE:**
- Similar to FOR UPDATE but weaker - doesn't block SELECT FOR KEY SHARE
- Allows other transactions to read the same rows with FOR KEY SHARE
- Useful when updating non-key columns while allowing referential integrity checks

```go
package main

import (
    "context"
    "database/sql"
    "fmt"
    "log"

    _ "github.com/lib/pq"
)

func UpdateUserMetadata(ctx context.Context, db *sql.DB, userID int64, updates map[string]interface{}) error {
    tx, err := db.BeginTx(ctx, nil)
    if err != nil {
        return fmt.Errorf("failed to begin transaction: %w", err)
    }
    defer tx.Rollback()

    // Lock row with FOR NO KEY UPDATE since we're not modifying primary key
    var existingUser struct {
        ID       int64
        Username string
    }

    err = tx.QueryRowContext(ctx, 
        "SELECT id, username FROM users WHERE id = $1 FOR NO KEY UPDATE", userID).Scan(
        &existingUser.ID, &existingUser.Username)
    if err != nil {
        return fmt.Errorf("failed to lock user: %w", err)
    }

    // Build update query dynamically based on provided updates
    if len(updates) == 0 {
        return fmt.Errorf("no updates provided")
    }

    setClause := ""
    args := []interface{}{}
    argPos := 2

    for key, value := range updates {
        if argPos > 2 {
            setClause += ", "
        }
        setClause += fmt.Sprintf("%s = $%d", key, argPos)
        args = append(args, value)
        argPos++
    }

    args = append(args, userID)

    query := fmt.Sprintf("UPDATE users SET %s WHERE id = $1", setClause)
    _, err = tx.ExecContext(ctx, query, args...)
    if err != nil {
        return fmt.Errorf("failed to update user: %w", err)
    }

    return tx.Commit()
}

func main() {
    db, err := sql.Open("postgres", "host=localhost user=postgres dbname=mydb sslmode=disable")
    if err != nil {
        log.Fatal(err)
    }
    defer db.Close()

    ctx := context.Background()
    updates := map[string]interface{}{
        "last_login": "NOW()",
        "login_count": 10,
    }
    err = UpdateUserMetadata(ctx, db, 1, updates)
    if err != nil {
        log.Fatal(err)
    }
}
```

### FOR KEY SHARE

**Why use FOR KEY SHARE:**
- Weakest lock, only prevents FOR UPDATE and FOR NO KEY UPDATE
- Allows other transactions to modify non-key columns
- Useful for foreign key validation and referential integrity checks

```go
package main

import (
    "context"
    "database/sql"
    "fmt"
    "log"

    _ "github.com/lib/pq"
)

func ValidateReferences(ctx context.Context, db *sql.DB, orderID int64) (bool, error) {
    tx, err := db.BeginTx(ctx, nil)
    if err != nil {
        return false, fmt.Errorf("failed to begin transaction: %w", err)
    }
    defer tx.Rollback()

    var userID, productID int64
    
    // Lock referenced rows with FOR KEY SHARE to check existence without blocking updates
    err = tx.QueryRowContext(ctx, 
        "SELECT user_id FROM orders WHERE id = $1 FOR KEY SHARE", orderID).Scan(&userID)
    if err != nil {
        return false, fmt.Errorf("failed to lock order: %w", err)
    }

    err = tx.QueryRowContext(ctx, 
        "SELECT product_id FROM order_items WHERE order_id = $1 FOR KEY SHARE", orderID).Scan(&productID)
    if err != nil {
        return false, fmt.Errorf("failed to lock order items: %w", err)
    }

    // Verify referenced records exist
    var userExists, productExists bool
    err = tx.QueryRowContext(ctx, 
        "SELECT EXISTS(SELECT 1 FROM users WHERE id = $1)", userID).Scan(&userExists)
    if err != nil {
        return false, fmt.Errorf("failed to check user existence: %w", err)
    }

    err = tx.QueryRowContext(ctx, 
        "SELECT EXISTS(SELECT 1 FROM products WHERE id = $1)", productID).Scan(&productExists)
    if err != nil {
        return false, fmt.Errorf("failed to check product existence: %w", err)
    }

    return userExists && productExists, tx.Commit()
}

func main() {
    db, err := sql.Open("postgres", "host=localhost user=postgres dbname=mydb sslmode=disable")
    if err != nil {
        log.Fatal(err)
    }
    defer db.Close()

    ctx := context.Background()
    valid, err := ValidateReferences(ctx, db, 123)
    if err != nil {
        log.Fatal(err)
    }

    if valid {
        fmt.Println("All references are valid")
    } else {
        fmt.Println("Some references are invalid")
    }
}
```

## Explicit Locking

Explicit locking gives you fine-grained control over concurrency by manually acquiring locks when needed.

### Why use Explicit Locking:

- Implement custom concurrency patterns beyond standard SQL semantics
- Ensure consistent ordering of lock acquisition to prevent deadlocks
- Implement complex multi-table operations with specific locking requirements

```go
package main

import (
    "context"
    "database/sql"
    "fmt"
    "log"
    "sort"

    _ "github.com/lib/pq"
)

type LockManager struct {
    db *sql.DB
}

func NewLockManager(db *sql.DB) *LockManager {
    return &LockManager{db: db}
}

// AcquireRowLocks acquires locks on multiple rows in a consistent order
// to prevent deadlocks when working with multiple tables/rows
func (m *LockManager) AcquireRowLocks(ctx context.Context, tx *sql.Tx, locks []RowLock) error {
    // Sort locks by table name and ID to ensure consistent acquisition order
    sort.Slice(locks, func(i, j int) bool {
        if locks[i].TableName != locks[j].TableName {
            return locks[i].TableName < locks[j].TableName
        }
        return locks[i].RowID < locks[j].RowID
    })

    // Acquire locks in sorted order
    for _, lock := range locks {
        var lockMode string
        switch lock.Mode {
        case LockModeUpdate:
            lockMode = "FOR UPDATE"
        case LockModeShare:
            lockMode = "FOR SHARE"
        case LockModeNoKeyUpdate:
            lockMode = "FOR NO KEY UPDATE"
        case LockModeKeyShare:
            lockMode = "FOR KEY SHARE"
        default:
            return fmt.Errorf("unknown lock mode: %s", lock.Mode)
        }

        _, err := tx.ExecContext(ctx, 
            fmt.Sprintf("SELECT 1 FROM %s WHERE id = $1 %s", lock.TableName, lockMode),
            lock.RowID)
        if err != nil {
            return fmt.Errorf("failed to acquire lock on %s:%d: %w", lock.TableName, lock.RowID, err)
        }
    }

    return nil
}

type RowLock struct {
    TableName string
    RowID     int64
    Mode      LockMode
}

type LockMode string

const (
    LockModeUpdate      LockMode = "FOR UPDATE"
    LockModeShare       LockMode = "FOR SHARE"
    LockModeNoKeyUpdate LockMode = "FOR NO KEY UPDATE"
    LockModeKeyShare    LockMode = "FOR KEY SHARE"
)

// ComplexTransfer demonstrates a multi-table operation with explicit locking
func (m *LockManager) ComplexTransfer(ctx context.Context, fromAccountID, toAccountID, orderID int64, amount float64) error {
    tx, err := m.db.BeginTx(ctx, nil)
    if err != nil {
        return fmt.Errorf("failed to begin transaction: %w", err)
    }
    defer tx.Rollback()

    // Acquire locks on all involved rows in consistent order
    locks := []RowLock{
        {TableName: "accounts", RowID: fromAccountID, Mode: LockModeUpdate},
        {TableName: "accounts", RowID: toAccountID, Mode: LockModeUpdate},
        {TableName: "orders", RowID: orderID, Mode: LockModeShare},
    }

    err = m.AcquireRowLocks(ctx, tx, locks)
    if err != nil {
        return fmt.Errorf("failed to acquire locks: %w", err)
    }

    // Verify order exists and is valid
    var orderStatus string
    err = tx.QueryRowContext(ctx, 
        "SELECT status FROM orders WHERE id = $1", orderID).Scan(&orderStatus)
    if err != nil {
        return fmt.Errorf("failed to verify order: %w", err)
    }

    if orderStatus != "pending" {
        return fmt.Errorf("order is not pending: %s", orderStatus)
    }

    // Perform transfer
    var fromBalance, toBalance float64
    err = tx.QueryRowContext(ctx, 
        "SELECT balance FROM accounts WHERE id = $1", fromAccountID).Scan(&fromBalance)
    if err != nil {
        return fmt.Errorf("failed to get from account balance: %w", err)
    }

    err = tx.QueryRowContext(ctx, 
        "SELECT balance FROM accounts WHERE id = $1", toAccountID).Scan(&toBalance)
    if err != nil {
        return fmt.Errorf("failed to get to account balance: %w", err)
    }

    if fromBalance < amount {
        return fmt.Errorf("insufficient balance")
    }

    fromBalance -= amount
    toBalance += amount

    _, err = tx.ExecContext(ctx, 
        "UPDATE accounts SET balance = $1 WHERE id = $2", fromBalance, fromAccountID)
    if err != nil {
        return fmt.Errorf("failed to update from account: %w", err)
    }

    _, err = tx.ExecContext(ctx, 
        "UPDATE accounts SET balance = $1 WHERE id = $2", toBalance, toAccountID)
    if err != nil {
        return fmt.Errorf("failed to update to account: %w", err)
    }

    // Update order status
    _, err = tx.ExecContext(ctx, 
        "UPDATE orders SET status = 'completed' WHERE id = $1", orderID)
    if err != nil {
        return fmt.Errorf("failed to update order status: %w", err)
    }

    return tx.Commit()
}

func main() {
    db, err := sql.Open("postgres", "host=localhost user=postgres dbname=mydb sslmode=disable")
    if err != nil {
        log.Fatal(err)
    }
    defer db.Close()

    lockManager := NewLockManager(db)

    ctx := context.Background()
    err = lockManager.ComplexTransfer(ctx, 1, 2, 123, 500.0)
    if err != nil {
        log.Printf("Complex transfer failed: %v", err)
    } else {
        log.Println("Complex transfer successful")
    }
}
```

## Best Practices

1. **Use the weakest lock that meets your needs** - Stronger locks reduce concurrency
2. **Keep transactions short** - Longer held locks increase contention
3. **Acquire locks in consistent order** - Prevents deadlocks in multi-table operations
4. **Use advisory locks for application-level coordination** - More flexible than table locks
5. **Consider isolation levels** - Sometimes proper isolation level eliminates need for explicit locks
6. **Monitor lock contention** - Use `pg_stat_activity` and `pg_locks` to identify bottlenecks
7. **Handle timeouts and errors** - Always implement proper error handling and timeout mechanisms
8. **Test under load** - Lock behavior changes dramatically under concurrent load