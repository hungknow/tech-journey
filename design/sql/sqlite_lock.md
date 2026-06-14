# SQLite Locks

## Table of Contents

- [SQLite Locking Overview](#sqlite-locking-overview)
- [File-level Lock States](#file-level-lock-states)
  - [UNLOCKED](#unlocked)
  - [SHARED](#shared)
  - [RESERVED](#reserved)
  - [PENDING](#pending)
  - [EXCLUSIVE](#exclusive)
- [Transaction Locking Modes](#transaction-locking-modes)
  - [BEGIN DEFERRED](#begin-deferred)
  - [BEGIN IMMEDIATE](#begin-immediate)
  - [BEGIN EXCLUSIVE](#begin-exclusive)
- [Write-Ahead Logging (WAL) Mode](#write-ahead-logging-wal-mode)
  - [WAL Read Locking](#wal-read-locking)
  - [WAL Write Locking](#wal-write-locking)
- [Lock Timeout and Retry](#lock-timeout-and-retry)
- [Advanced Locking Strategies](#advanced-locking-strategies)
  - [Busy Handler](#busy-handler)
  - [Application-level Locking](#application-level-locking)

## SQLite Locking Overview

SQLite uses a file-level locking mechanism that differs significantly from PostgreSQL. Instead of multiple lock types on tables and rows, SQLite operates at the database file level with progressive locking states.

### Why SQLite Locking is Different

- **File-based architecture**: SQLite locks the entire database file
- **Progressive locking**: Locks escalate from weaker to stronger states
- **Writer starvation prevention**: Uses PENDING state to allow new readers
- **Simple model**: Easier to understand but less granular than PostgreSQL

## File-level Lock States

### UNLOCKED

**Description**: No locks are held on the database file.

**When used**: Connection is idle or not in a transaction.

**Why use UNLOCKED:**
- Allows maximum concurrency when not actively using the database
- Automatic state that connections return to after completing operations
- Base state for all locking operations

### Go Code Example

```go
package main

import (
    "database/sql"
    "fmt"
    "log"

    _ "github.com/mattn/go-sqlite3"
)

type ConnectionManager struct {
    db *sql.DB
}

func NewConnectionManager(dbPath string) (*ConnectionManager, error) {
    db, err := sql.Open("sqlite3", dbPath)
    if err != nil {
        return nil, fmt.Errorf("failed to open database: %w", err)
    }

    // Configure connection pool for better management of unlocked states
    db.SetMaxOpenConns(1) // SQLite typically uses single writer
    db.SetMaxIdleConns(1)

    return &ConnectionManager{db: db}, nil
}

func (m *ConnectionManager) Close() error {
    return m.db.Close()
}

// ExecuteInUnlockedState demonstrates operations that leave the database unlocked
func (m *ConnectionManager) ExecuteInUnlockedState() error {
    // Quick read operation - database returns to UNLOCKED after completion
    var count int
    err := m.db.QueryRow("SELECT COUNT(*) FROM users").Scan(&count)
    if err != nil {
        return fmt.Errorf("query failed: %w", err)
    }

    fmt.Printf("User count: %d (database now UNLOCKED)\n", count)

    // Connection is now in UNLOCKED state, ready for next operation
    return nil
}

func main() {
    connMgr, err := NewConnectionManager("test.db")
    if err != nil {
        log.Fatal(err)
    }
    defer connMgr.Close()

    err = connMgr.ExecuteInUnlockedState()
    if err != nil {
        log.Fatal(err)
    }
}
```

### SHARED

**Description**: Multiple readers can hold SHARED locks simultaneously.

**When used**: During SELECT operations and read transactions.

**Why use SHARED:**
- Allows concurrent reads from multiple connections
- Foundation for read scalability in SQLite
- Prevents writers while allowing multiple readers

**Conflicts with**: RESERVED, PENDING, EXCLUSIVE

```go
package main

import (
    "context"
    "database/sql"
    "fmt"
    "log"
    "sync"

    _ "github.com/mattn/go-sqlite3"
)

type ConcurrentReader struct {
    db      *sql.DB
    readerID int
}

func NewConcurrentReader(dbPath string, readerID int) (*ConcurrentReader, error) {
    db, err := sql.Open("sqlite3", dbPath)
    if err != nil {
        return nil, fmt.Errorf("failed to open database: %w", err)
    }
    return &ConcurrentReader{db: db, readerID: readerID}, nil
}

func (r *ConcurrentReader) ReadData(ctx context.Context, tableName string) error {
    // Begin transaction (automatically acquires SHARED lock)
    tx, err := r.db.BeginTx(ctx, nil)
    if err != nil {
        return fmt.Errorf("failed to begin transaction: %w", err)
    }
    defer tx.Rollback()

    // Perform read operation while holding SHARED lock
    rows, err := tx.QueryContext(ctx, fmt.Sprintf("SELECT id, name FROM %s", tableName))
    if err != nil {
        return fmt.Errorf("query failed: %w", err)
    }
    defer rows.Close()

    fmt.Printf("Reader %d reading data:\n", r.readerID)
    for rows.Next() {
        var id int
        var name string
        if err := rows.Scan(&id, &name); err != nil {
            return fmt.Errorf("scan failed: %w", err)
        }
        fmt.Printf("  Reader %d: ID=%d, Name=%s\n", r.readerID, id, name)
    }

    return tx.Commit()
}

func (r *ConcurrentReader) Close() error {
    return r.db.Close()
}

// Demonstrate concurrent readers with SHARED locks
func main() {
    dbPath := "test.db"
    numReaders := 5

    var wg sync.WaitGroup
    errs := make(chan error, numReaders)

    for i := 0; i < numReaders; i++ {
        wg.Add(1)
        go func(readerID int) {
            defer wg.Done()

            reader, err := NewConcurrentReader(dbPath, readerID)
            if err != nil {
                errs <- err
                return
            }
            defer reader.Close()

            ctx := context.Background()
            err = reader.ReadData(ctx, "users")
            if err != nil {
                errs <- fmt.Errorf("reader %d failed: %w", readerID, err)
                return
            }

            fmt.Printf("Reader %d completed successfully\n", readerID)
        }(i)
    }

    wg.Wait()
    close(errs)

    for err := range errs {
        if err != nil {
            log.Printf("Error: %v", err)
        }
    }
}
```

### RESERVED

**Description**: Indicates intention to write, allows other readers but prevents new writers.

**When used**: During BEGIN IMMEDIATE transaction before writing.

**Why use RESERVED:**
- Signals write intent without blocking existing readers
- Prevents write starvation while allowing read operations
- Intermediate state before escalating to PENDING

**Conflicts with**: EXCLUSIVE

```go
package main

import (
    "context"
    "database/sql"
    "fmt"
    "log"
    "time"

    _ "github.com/mattn/go-sqlite3"
)

type ReservedLockWriter struct {
    db *sql.DB
}

func NewReservedLockWriter(dbPath string) (*ReservedLockWriter, error) {
    db, err := sql.Open("sqlite3", dbPath)
    if err != nil {
        return nil, fmt.Errorf("failed to open database: %w", err)
    }

    // Set busy timeout to handle lock conflicts
    db.SetMaxOpenConns(1)
    return &ReservedLockWriter{db: db}, nil
}

func (w *ReservedLockWriter) WriteWithReservedLock(ctx context.Context, data string) error {
    // Begin IMMEDIATE transaction - acquires RESERVED lock
    // This allows existing readers to continue but prevents new writers
    tx, err := w.db.BeginTx(ctx, &sql.TxOptions{Isolation: sql.LevelSerializable})
    if err != nil {
        return fmt.Errorf("failed to begin transaction: %w", err)
    }
    defer tx.Rollback()

    fmt.Println("Acquired RESERVED lock - allowing existing readers, blocking new writers")

    // Simulate preparation time while holding RESERVED lock
    time.Sleep(100 * time.Millisecond)

    // Perform the write operation
    _, err = tx.ExecContext(ctx, 
        "INSERT INTO logs (message, created_at) VALUES (?, ?)", 
        data, time.Now())
    if err != nil {
        return fmt.Errorf("insert failed: %w", err)
    }

    fmt.Println("Write operation completed")
    return tx.Commit()
}

func (w *ReservedLockWriter) Close() error {
    return w.db.Close()
}

func main() {
    writer, err := NewReservedLockWriter("test.db")
    if err != nil {
        log.Fatal(err)
    }
    defer writer.Close()

    ctx := context.Background()
    err = writer.WriteWithReservedLock(ctx, "Test message with RESERVED lock")
    if err != nil {
        log.Fatal(err)
    }
}
```

### PENDING

**Description**: Prevents new readers while allowing existing readers to finish.

**When used**: During transition from RESERVED to EXCLUSIVE state.

**Why use PENDING:**
- Prevents writer starvation by blocking new readers
- Allows existing readers to complete their operations
- Ensures writer can eventually acquire EXCLUSIVE lock

**Conflicts with**: SHARED, EXCLUSIVE

```go
package main

import (
    "context"
    "database/sql"
    "fmt"
    "log"
    "time"

    _ "github.com/mattn/go-sqlite3"
)

type PendingLockManager struct {
    db *sql.DB
}

func NewPendingLockManager(dbPath string) (*PendingLockManager, error) {
    db, err := sql.Open("sqlite3", dbPath+"?_journal_mode=WAL")
    if err != nil {
        return nil, fmt.Errorf("failed to open database: %w", err)
    }

    // Configure for proper lock management
    db.SetMaxOpenConns(1)
    db.SetMaxIdleConns(1)
    
    // Set busy timeout to handle lock conflicts gracefully
    _, err = db.Exec("PRAGMA busy_timeout = 5000")
    if err != nil {
        return nil, fmt.Errorf("failed to set busy timeout: %w", err)
    }

    return &PendingLockManager{db: db}, nil
}

// WriteWithPendingLock demonstrates the transition through PENDING state
func (m *PendingLockManager) WriteWithPendingLock(ctx context.Context, updateData string) error {
    // Begin IMMEDIATE transaction (RESERVED lock)
    tx, err := m.db.BeginTx(ctx, &sql.TxOptions{Isolation: sql.LevelSerializable})
    if err != nil {
        return fmt.Errorf("failed to begin transaction: %w", err)
    }
    defer tx.Rollback()

    fmt.Println("Step 1: Acquired RESERVED lock")

    // Perform some read operations while in RESERVED state
    var count int
    err = tx.QueryRowContext(ctx, "SELECT COUNT(*) FROM data").Scan(&count)
    if err != nil {
        return fmt.Errorf("read failed: %w", err)
    }
    fmt.Printf("Step 2: Read %d rows in RESERVED state\n", count)

    // When we attempt to write, SQLite transitions to PENDING state
    // This prevents new readers but allows existing readers to finish
    fmt.Println("Step 3: Transitioning to PENDING state for write")

    _, err = tx.ExecContext(ctx, 
        "UPDATE data SET content = ?, updated_at = ?", 
        updateData, time.Now())
    if err != nil {
        return fmt.Errorf("update failed: %w", err)
    }

    fmt.Println("Step 4: Write completed, committing (will transition to EXCLUSIVE briefly)")

    // Commit will briefly escalate to EXCLUSIVE lock
    return tx.Commit()
}

func (m *PendingLockManager) MonitorLockState(ctx context.Context) error {
    // SQLite doesn't expose lock state directly through SQL
    // But we can monitor lock contention through pragma statements
    var journalMode, lockingMode string
    
    err := m.db.QueryRowContext(ctx, "PRAGMA journal_mode").Scan(&journalMode)
    if err != nil {
        return fmt.Errorf("failed to get journal mode: %w", err)
    }

    err = m.db.QueryRowContext(ctx, "PRAGMA locking_mode").Scan(&lockingMode)
    if err != nil {
        return fmt.Errorf("failed to get locking mode: %w", err)
    }

    fmt.Printf("Lock configuration: Journal Mode=%s, Locking Mode=%s\n", 
        journalMode, lockingMode)
    
    return nil
}

func (m *PendingLockManager) Close() error {
    return m.db.Close()
}

func main() {
    manager, err := NewPendingLockManager("test.db")
    if err != nil {
        log.Fatal(err)
    }
    defer manager.Close()

    ctx := context.Background()

    // Monitor current lock configuration
    err = manager.MonitorLockState(ctx)
    if err != nil {
        log.Printf("Warning: %v", err)
    }

    // Perform write operation that goes through PENDING state
    err = manager.WriteWithPendingLock(ctx, "Updated content via PENDING lock")
    if err != nil {
        log.Fatal(err)
    }
}
```

### EXCLUSIVE

**Description**: Only one connection can hold this lock, preventing all other access.

**When used**: During actual write operations and commits.

**Why use EXCLUSIVE:**
- Ensures data integrity during writes
- Prevents all concurrent access during critical operations
- Necessary for database modifications

**Conflicts with**: SHARED, RESERVED, PENDING, EXCLUSIVE

```go
package main

import (
    "context"
    "database/sql"
    "fmt"
    "log"
    "os"
    "time"

    _ "github.com/mattn/go-sqlite3"
)

type ExclusiveLockWriter struct {
    db *sql.DB
}

func NewExclusiveLockWriter(dbPath string) (*ExclusiveLockWriter, error) {
    db, err := sql.Open("sqlite3", dbPath)
    if err != nil {
        return nil, fmt.Errorf("failed to open database: %w", err)
    }

    // Configure for exclusive operations
    db.SetMaxOpenConns(1)
    db.SetMaxIdleConns(1)
    
    // Set busy timeout
    _, err = db.Exec("PRAGMA busy_timeout = 10000")
    if err != nil {
        return nil, fmt.Errorf("failed to set busy timeout: %w", err)
    }

    return &ExclusiveLockWriter{db: db}, nil
}

// CriticalOperation performs operations that require exclusive access
func (w *ExclusiveLockWriter) CriticalOperation(ctx context.Context, operationName string) error {
    // Begin EXCLUSIVE transaction - acquires EXCLUSIVE lock immediately
    // This blocks all other operations
    tx, err := w.db.BeginTx(ctx, &sql.TxOptions{
        Isolation: sql.LevelSerializable,
        ReadOnly:  false,
    })
    if err != nil {
        return fmt.Errorf("failed to begin exclusive transaction: %w", err)
    }
    defer tx.Rollback()

    fmt.Printf("EXCLUSIVE lock acquired for operation: %s\n", operationName)

    // Perform critical operation - no other access allowed
    start := time.Now()
    
    // Example: Database backup or schema modification
    _, err = tx.ExecContext(ctx, 
        "CREATE TABLE IF NOT EXISTS backup_logs AS SELECT * FROM logs")
    if err != nil {
        return fmt.Errorf("backup failed: %w", err)
    }

    // Perform data cleanup or migration
    _, err = tx.ExecContext(ctx, 
        "DELETE FROM logs WHERE created_at < datetime('now', '-30 days')")
    if err != nil {
        return fmt.Errorf("cleanup failed: %w", err)
    }

    duration := time.Since(start)
    fmt.Printf("Critical operation completed in %v\n", duration)

    return tx.Commit()
}

// BatchWrite demonstrates exclusive lock for batch operations
func (w *ExclusiveLockWriter) BatchWrite(ctx context.Context, records []Record) error {
    tx, err := w.db.BeginTx(ctx, &sql.TxOptions{Isolation: sql.LevelSerializable})
    if err != nil {
        return fmt.Errorf("failed to begin transaction: %w", err)
    }
    defer tx.Rollback()

    fmt.Println("Starting batch write with EXCLUSIVE lock")

    // Prepare statement for batch operations
    stmt, err := tx.PrepareContext(ctx, 
        "INSERT INTO records (name, value, timestamp) VALUES (?, ?, ?)")
    if err != nil {
        return fmt.Errorf("failed to prepare statement: %w", err)
    }
    defer stmt.Close()

    // Execute batch inserts
    for i, record := range records {
        _, err = stmt.ExecContext(ctx, record.Name, record.Value, record.Timestamp)
        if err != nil {
            return fmt.Errorf("failed to insert record %d: %w", i, err)
        }
    }

    fmt.Printf("Successfully inserted %d records\n", len(records))
    return tx.Commit()
}

type Record struct {
    Name      string
    Value     float64
    Timestamp time.Time
}

func (w *ExclusiveLockWriter) Close() error {
    return w.db.Close()
}

func main() {
    dbPath := "test.db"
    
    // Initialize database
    os.Remove(dbPath) // Clean up for demo
    db, err := sql.Open("sqlite3", dbPath)
    if err != nil {
        log.Fatal(err)
    }
    defer db.Close()

    // Create test tables
    _, err = db.Exec(`
        CREATE TABLE IF NOT EXISTS logs (id INTEGER PRIMARY KEY, message TEXT, created_at DATETIME);
        CREATE TABLE IF NOT EXISTS records (id INTEGER PRIMARY KEY, name TEXT, value REAL, timestamp DATETIME);
    `)
    if err != nil {
        log.Fatal(err)
    }

    writer, err := NewExclusiveLockWriter(dbPath)
    if err != nil {
        log.Fatal(err)
    }
    defer writer.Close()

    ctx := context.Background()

    // Perform critical operation
    err = writer.CriticalOperation(ctx, "database_backup")
    if err != nil {
        log.Fatal(err)
    }

    // Perform batch write
    records := []Record{
        {"record1", 1.0, time.Now()},
        {"record2", 2.0, time.Now()},
        {"record3", 3.0, time.Now()},
    }
    err = writer.BatchWrite(ctx, records)
    if err != nil {
        log.Fatal(err)
    }

    fmt.Println("All exclusive operations completed successfully")
}
```

## Transaction Locking Modes

### BEGIN DEFERRED

**Description**: Default transaction mode, doesn't acquire any locks until first operation.

**When used**: Standard transactions where locking behavior is determined by first operation.

**Why use BEGIN DEFERRED:**
- Default SQLite transaction mode
- Efficient - no lock acquisition until needed
- Allows read operations to use SHARED locks automatically

```go
package main

import (
    "context"
    "database/sql"
    "fmt"
    "log"

    _ "github.com/mattn/go-sqlite3"
)

type DeferredTransactionManager struct {
    db *sql.DB
}

func NewDeferredTransactionManager(dbPath string) (*DeferredTransactionManager, error) {
    db, err := sql.Open("sqlite3", dbPath)
    if err != nil {
        return nil, fmt.Errorf("failed to open database: %w", err)
    }

    db.SetMaxOpenConns(1)
    return &DeferredTransactionManager{db: db}, nil
}

// ConditionalOperation demonstrates deferred transaction behavior
func (m *DeferredTransactionManager) ConditionalOperation(ctx context.Context, shouldUpdate bool) error {
    // BEGIN DEFERRED - no lock acquired yet
    tx, err := m.db.BeginTx(ctx, nil)
    if err != nil {
        return fmt.Errorf("failed to begin transaction: %w", err)
    }
    defer tx.Rollback()

    fmt.Println("Transaction started (DEFERRED mode - no lock yet)")

    // First read operation will acquire SHARED lock
    var currentValue int
    err = tx.QueryRowContext(ctx, "SELECT value FROM settings WHERE key = 'counter'").Scan(&currentValue)
    if err != nil {
        return fmt.Errorf("read failed: %w", err)
    }

    fmt.Printf("Current value: %d (now holding SHARED lock)\n", currentValue)

    if shouldUpdate {
        // This write operation will escalate locks: SHARED -> RESERVED -> PENDING -> EXCLUSIVE
        newValue := currentValue + 1
        _, err = tx.ExecContext(ctx, 
            "UPDATE settings SET value = ? WHERE key = 'counter'", newValue)
        if err != nil {
            return fmt.Errorf("update failed: %w", err)
        }

        fmt.Printf("Updated value to: %d (escalated to EXCLUSIVE lock)\n", newValue)
    } else {
        fmt.Println("No update needed, will commit with SHARED lock")
    }

    return tx.Commit()
}

// ReadOptimizedOperation demonstrates read-only deferred transactions
func (m *DeferredTransactionManager) ReadOptimizedOperation(ctx context.Context) error {
    tx, err := m.db.BeginTx(ctx, &sql.TxOptions{ReadOnly: true})
    if err != nil {
        return fmt.Errorf("failed to begin read-only transaction: %w", err)
    }
    defer tx.Rollback()

    fmt.Println("Read-only transaction started (DEFERRED mode)")

    // All operations will use SHARED lock only
    rows, err := tx.QueryContext(ctx, "SELECT name, email FROM users LIMIT 10")
    if err != nil {
        return fmt.Errorf("query failed: %w", err)
    }
    defer rows.Close()

    for rows.Next() {
        var name, email string
        if err := rows.Scan(&name, &email); err != nil {
            return fmt.Errorf("scan failed: %w", err)
        }
        fmt.Printf("User: %s (%s)\n", name, email)
    }

    fmt.Println("Read-only transaction completed with SHARED lock")
    return tx.Commit()
}

func (m *DeferredTransactionManager) Close() error {
    return m.db.Close()
}

func main() {
    manager, err := NewDeferredTransactionManager("test.db")
    if err != nil {
        log.Fatal(err)
    }
    defer manager.Close()

    ctx := context.Background()

    // Test conditional operation
    err = manager.ConditionalOperation(ctx, true)
    if err != nil {
        log.Printf("Conditional operation failed: %v", err)
    }

    // Test read-optimized operation
    err = manager.ReadOptimizedOperation(ctx)
    if err != nil {
        log.Printf("Read operation failed: %v", err)
    }
}
```

### BEGIN IMMEDIATE

**Description**: Acquires RESERVED lock immediately upon transaction start.

**When used**: Transactions that will definitely perform writes.

**Why use BEGIN IMMEDIATE:**
- Prevents write contention by early lock acquisition
- Allows readers to continue while signaling write intent
- Reduces likelihood of "database is locked" errors

```go
package main

import (
    "context"
    "database/sql"
    "fmt"
    "log"
    "time"

    _ "github.com/mattn/go-sqlite3"
)

type ImmediateTransactionManager struct {
    db *sql.DB
}

func NewImmediateTransactionManager(dbPath string) (*ImmediateTransactionManager, error) {
    db, err := sql.Open("sqlite3", dbPath)
    if err != nil {
        return nil, fmt.Errorf("failed to open database: %w", err)
    }

    // Set busy timeout for graceful handling of conflicts
    db.SetMaxOpenConns(1)
    _, err = db.Exec("PRAGMA busy_timeout = 5000")
    if err != nil {
        return nil, fmt.Errorf("failed to set busy timeout: %w", err)
    }

    return &ImmediateTransactionManager{db: db}, nil
}

// WriteOperation uses IMMEDIATE mode to prevent write conflicts
func (m *ImmediateTransactionManager) WriteOperation(ctx context.Context, operationID string) error {
    // BEGIN IMMEDIATE - acquires RESERVED lock immediately
    // This prevents other writers but allows existing readers
    tx, err := m.db.BeginTx(ctx, &sql.TxOptions{Isolation: sql.LevelSerializable})
    if err != nil {
        return fmt.Errorf("failed to begin immediate transaction: %w", err)
    }
    defer tx.Rollback()

    fmt.Printf("Operation %s: Acquired RESERVED lock (IMMEDIATE mode)\n", operationID)

    // Read current state (still in RESERVED state, readers can continue)
    var currentBalance float64
    err = tx.QueryRowContext(ctx, "SELECT balance FROM accounts WHERE id = 1").Scan(&currentBalance)
    if err != nil {
        return fmt.Errorf("read failed: %w", err)
    }

    fmt.Printf("Operation %s: Current balance: %.2f\n", operationID, currentBalance)

    // Perform write operation
    newBalance := currentBalance + 100.0
    _, err = tx.ExecContext(ctx, 
        "UPDATE accounts SET balance = ?, last_updated = ? WHERE id = 1",
        newBalance, time.Now())
    if err != nil {
        return fmt.Errorf("update failed: %w", err)
    }

    fmt.Printf("Operation %s: Updated balance to: %.2f\n", operationID, newBalance)

    return tx.Commit()
}

// AtomicTransfer demonstrates IMMEDIATE mode for multi-step operations
func (m *ImmediateTransactionManager) AtomicTransfer(ctx context.Context, fromID, toID int64, amount float64) error {
    tx, err := m.db.BeginTx(ctx, &sql.TxOptions{Isolation: sql.LevelSerializable})
    if err != nil {
        return fmt.Errorf("failed to begin immediate transaction: %w", err)
    }
    defer tx.Rollback()

    fmt.Printf("Starting transfer: %d -> %d, amount: %.2f\n", fromID, toID, amount)

    // Read both accounts
    var fromBalance, toBalance float64
    err = tx.QueryRowContext(ctx, "SELECT balance FROM accounts WHERE id = ?", fromID).Scan(&fromBalance)
    if err != nil {
        return fmt.Errorf("failed to read from account: %w", err)
    }

    err = tx.QueryRowContext(ctx, "SELECT balance FROM accounts WHERE id = ?", toID).Scan(&toBalance)
    if err != nil {
        return fmt.Errorf("failed to read to account: %w", err)
    }

    // Validate balance
    if fromBalance < amount {
        return fmt.Errorf("insufficient balance: %.2f", fromBalance)
    }

    // Perform transfer
    fromBalance -= amount
    toBalance += amount

    _, err = tx.ExecContext(ctx, "UPDATE accounts SET balance = ? WHERE id = ?", fromBalance, fromID)
    if err != nil {
        return fmt.Errorf("failed to update from account: %w", err)
    }

    _, err = tx.ExecContext(ctx, "UPDATE accounts SET balance = ? WHERE id = ?", toBalance, toID)
    if err != nil {
        return fmt.Errorf("failed to update to account: %w", err)
    }

    // Log the transfer
    _, err = tx.ExecContext(ctx, 
        "INSERT INTO transfers (from_id, to_id, amount, timestamp) VALUES (?, ?, ?, ?)",
        fromID, toID, amount, time.Now())
    if err != nil {
        return fmt.Errorf("failed to log transfer: %w", err)
    }

    fmt.Printf("Transfer completed successfully\n")
    return tx.Commit()
}

func (m *ImmediateTransactionManager) Close() error {
    return m.db.Close()
}

func main() {
    manager, err := NewImmediateTransactionManager("test.db")
    if err != nil {
        log.Fatal(err)
    }
    defer manager.Close()

    ctx := context.Background()

    // Test write operation
    err = manager.WriteOperation(ctx, "op1")
    if err != nil {
        log.Printf("Write operation failed: %v", err)
    }

    // Test atomic transfer
    err = manager.AtomicTransfer(ctx, 1, 2, 50.0)
    if err != nil {
        log.Printf("Atomic transfer failed: %v", err)
    }
}
```

### BEGIN EXCLUSIVE

**Description**: Acquires EXCLUSIVE lock immediately, blocking all other operations.

**When used:** Critical operations requiring exclusive access, schema modifications, VACUUM.

**Why use BEGIN EXCLUSIVE:**
- Ensures no other operations can interfere
- Necessary for schema changes and maintenance operations
- Prevents any concurrent access during critical operations

```go
package main

import (
    "context"
    "database/sql"
    "fmt"
    "log"
    "time"

    _ "github.com/mattn/go-sqlite3"
)

type ExclusiveTransactionManager struct {
    db *sql.DB
}

func NewExclusiveTransactionManager(dbPath string) (*ExclusiveTransactionManager, error) {
    db, err := sql.Open("sqlite3", dbPath)
    if err != nil {
        return nil, fmt.Errorf("failed to open database: %w", err)
    }

    db.SetMaxOpenConns(1)
    _, err = db.Exec("PRAGMA busy_timeout = 10000")
    if err != nil {
        return nil, fmt.Errorf("failed to set busy timeout: %w", err)
    }

    return &ExclusiveTransactionManager{db: db}, nil
}

// PerformSchemaChange uses EXCLUSIVE mode for schema modifications
func (m *ExclusiveTransactionManager) PerformSchemaChange(ctx context.Context, changeSQL string) error {
    // Execute BEGIN EXCLUSIVE explicitly
    _, err := m.db.ExecContext(ctx, "BEGIN EXCLUSIVE")
    if err != nil {
        return fmt.Errorf("failed to begin exclusive transaction: %w", err)
    }

    fmt.Println("EXCLUSIVE lock acquired for schema change")

    // Perform schema modification
    _, err = m.db.ExecContext(ctx, changeSQL)
    if err != nil {
        m.db.ExecContext(ctx, "ROLLBACK")
        return fmt.Errorf("schema change failed: %w", err)
    }

    _, err = m.db.ExecContext(ctx, "COMMIT")
    if err != nil {
        return fmt.Errorf("commit failed: %w", err)
    }

    fmt.Println("Schema change completed successfully")
    return nil
}

// DatabaseMaintenance performs maintenance operations
func (m *ExclusiveTransactionManager) DatabaseMaintenance(ctx context.Context, maintenanceType string) error {
    _, err := m.db.ExecContext(ctx, "BEGIN EXCLUSIVE")
    if err != nil {
        return fmt.Errorf("failed to begin exclusive transaction: %w", err)
    }

    fmt.Printf("Starting maintenance: %s (EXCLUSIVE lock)\n", maintenanceType)
    start := time.Now()

    var err error
    switch maintenanceType {
    case "vacuum":
        _, err = m.db.ExecContext(ctx, "VACUUM")
    case "analyze":
        _, err = m.db.ExecContext(ctx, "ANALYZE")
    case "reindex":
        _, err = m.db.ExecContext(ctx, "REINDEX")
    default:
        err = fmt.Errorf("unknown maintenance type: %s", maintenanceType)
    }

    if err != nil {
        m.db.ExecContext(ctx, "ROLLBACK")
        return fmt.Errorf("maintenance failed: %w", err)
    }

    duration := time.Since(start)
    fmt.Printf("Maintenance completed in %v\n", duration)

    _, err = m.db.ExecContext(ctx, "COMMIT")
    return err
}

// CriticalDataOperation performs operations requiring complete isolation
func (m *ExclusiveTransactionManager) CriticalDataOperation(ctx context.Context, operation func(*sql.Tx) error) error {
    tx, err := m.db.BeginTx(ctx, &sql.TxOptions{Isolation: sql.LevelSerializable})
    if err != nil {
        return fmt.Errorf("failed to begin transaction: %w", err)
    }
    defer tx.Rollback()

    // Force exclusive mode
    _, err = tx.ExecContext(ctx, "PRAGMA locking_mode = EXCLUSIVE")
    if err != nil {
        return fmt.Errorf("failed to set exclusive mode: %w", err)
    }

    fmt.Println("Critical operation started with EXCLUSIVE lock")

    // Perform the critical operation
    err = operation(tx)
    if err != nil {
        return fmt.Errorf("operation failed: %w", err)
    }

    fmt.Println("Critical operation completed")
    return tx.Commit()
}

func (m *ExclusiveTransactionManager) Close() error {
    return m.db.Close()
}

func main() {
    manager, err := NewExclusiveTransactionManager("test.db")
    if err != nil {
        log.Fatal(err)
    }
    defer manager.Close()

    ctx := context.Background()

    // Perform schema change
    schemaChange := `
        CREATE TABLE IF NOT EXISTS audit_log (
            id INTEGER PRIMARY KEY,
            operation TEXT,
            table_name TEXT,
            record_id INTEGER,
            timestamp DATETIME
        )
    `
    err = manager.PerformSchemaChange(ctx, schemaChange)
    if err != nil {
        log.Printf("Schema change failed: %v", err)
    }

    // Perform database maintenance
    err = manager.DatabaseMaintenance(ctx, "analyze")
    if err != nil {
        log.Printf("Maintenance failed: %v", err)
    }

    // Perform critical data operation
    err = manager.CriticalDataOperation(ctx, func(tx *sql.Tx) error {
        // Create backup table
        _, err := tx.ExecContext(ctx, "CREATE TABLE IF NOT EXISTS data_backup AS SELECT * FROM data")
        if err != nil {
            return err
        }

        // Perform data migration
        _, err = tx.ExecContext(ctx, "UPDATE data SET processed = 1 WHERE status = 'completed'")
        if err != nil {
            return err
        }

        return nil
    })
    if err != nil {
        log.Printf("Critical operation failed: %v", err)
    }
}
```

## Write-Ahead Logging (WAL) Mode

WAL mode significantly changes SQLite's locking behavior, allowing better concurrency.

### WAL Read Locking

**Description**: Readers do not block writers in WAL mode.

**When used**: Read operations in databases with WAL journaling enabled.

**Why use WAL Read Locking:**
- Eliminates reader-writer blocking
- Allows concurrent reads and writes
- Provides better performance for read-heavy workloads

```go
package main

import (
    "context"
    "database/sql"
    "fmt"
    "log"
    "sync"
    "time"

    _ "github.com/mattn/go-sqlite3"
)

type WALReader struct {
    db       *sql.DB
    readerID int
}

func NewWALReader(dbPath string, readerID int) (*WALReader, error) {
    // Enable WAL mode
    db, err := sql.Open("sqlite3", dbPath+"?_journal_mode=WAL")
    if err != nil {
        return nil, fmt.Errorf("failed to open database: %w", err)
    }

    // Verify WAL mode is active
    var journalMode string
    err = db.QueryRow("PRAGMA journal_mode").Scan(&journalMode)
    if err != nil {
        return nil, fmt.Errorf("failed to check journal mode: %w", err)
    }

    if journalMode != "wal" {
        return nil, fmt.Errorf("WAL mode not active, got: %s", journalMode)
    }

    return &WALReader{db: db, readerID: readerID}, nil
}

func (r *WALReader) ContinuousRead(ctx context.Context, tableName string, duration time.Duration) {
    fmt.Printf("Reader %d starting continuous read for %v\n", r.readerID, duration)
    
    startTime := time.Now()
    readCount := 0
    
    for time.Since(startTime) < duration {
        select {
        case <-ctx.Done():
            return
        default:
            // In WAL mode, readers don't block writers
            var count int
            err := r.db.QueryRowContext(ctx, 
                fmt.Sprintf("SELECT COUNT(*) FROM %s", tableName)).Scan(&count)
            if err != nil {
                log.Printf("Reader %d: query failed: %v", r.readerID, err)
                continue
            }
            
            readCount++
            if readCount%10 == 0 {
                fmt.Printf("Reader %d: performed %d reads, current count: %d\n", 
                    r.readerID, readCount, count)
            }
            
            time.Sleep(100 * time.Millisecond)
        }
    }
    
    fmt.Printf("Reader %d completed %d reads\n", r.readerID, readCount)
}

func (r *WALReader) Close() error {
    return r.db.Close()
}

type WALWriter struct {
    db *sql.DB
}

func NewWALWriter(dbPath string) (*WALWriter, error) {
    db, err := sql.Open("sqlite3", dbPath+"?_journal_mode=WAL")
    if err != nil {
        return nil, fmt.Errorf("failed to open database: %w", err)
    }

    // Configure for write operations
    db.SetMaxOpenConns(1)
    
    return &WALWriter{db: db}, nil
}

func (w *WALWriter) ContinuousWrite(ctx context.Context, tableName string, duration time.Duration) {
    fmt.Printf("Writer starting continuous write for %v\n", duration)
    
    startTime := time.Now()
    writeCount := 0
    
    for time.Since(startTime) < duration {
        select {
        case <-ctx.Done():
            return
        default:
            // In WAL mode, writers don't block readers
            _, err := w.db.ExecContext(ctx,
                fmt.Sprintf("INSERT INTO %s (data, created_at) VALUES (?, ?)", tableName),
                fmt.Sprintf("data_%d", writeCount), time.Now())
            if err != nil {
                log.Printf("Writer: insert failed: %v", err)
                continue
            }
            
            writeCount++
            if writeCount%5 == 0 {
                fmt.Printf("Writer: performed %d writes\n", writeCount)
            }
            
            time.Sleep(200 * time.Millisecond)
        }
    }
    
    fmt.Printf("Writer completed %d writes\n", writeCount)
}

func (w *WALWriter) Close() error {
    return w.db.Close()
}

// Demonstrate WAL mode concurrency
func main() {
    dbPath := "test_wal.db"
    numReaders := 3
    duration := 5 * time.Second

    // Initialize database
    db, err := sql.Open("sqlite3", dbPath)
    if err != nil {
        log.Fatal(err)
    }
    defer db.Close()

    // Enable WAL mode and create test table
    _, err = db.Exec(`
        PRAGMA journal_mode = WAL;
        CREATE TABLE IF NOT EXISTS concurrent_data (
            id INTEGER PRIMARY KEY,
            data TEXT,
            created_at DATETIME
        )
    `)
    if err != nil {
        log.Fatal(err)
    }

    ctx, cancel := context.WithTimeout(context.Background(), duration+time.Second)
    defer cancel()

    var wg sync.WaitGroup

    // Start writer
    writer, err := NewWALWriter(dbPath)
    if err != nil {
        log.Fatal(err)
    }
    defer writer.Close()

    wg.Add(1)
    go func() {
        defer wg.Done()
        writer.ContinuousWrite(ctx, "concurrent_data", duration)
    }()

    // Start readers
    for i := 0; i < numReaders; i++ {
        reader, err := NewWALReader(dbPath, i+1)
        if err != nil {
            log.Fatal(err)
        }
        defer reader.Close()

        wg.Add(1)
        go func(r *WALReader) {
            defer wg.Done()
            r.ContinuousRead(ctx, "concurrent_data", duration)
        }(reader)
    }

    wg.Wait()
    fmt.Println("WAL mode concurrency test completed")
}
```

### WAL Write Locking

**Description:** Writers use checkpoint locks instead of exclusive file locks.

**When used:** Write operations in WAL mode databases.

**Why use WAL Write Locking:**
- Multiple readers can proceed while writing
- Checkpoint operations manage WAL file size
- Better overall throughput for mixed workloads

```go
package main

import (
    "context"
    "database/sql"
    "fmt"
    "log"
    "time"

    _ "github.com/mattn/go-sqlite3"
)

type WALLockManager struct {
    db *sql.DB
}

func NewWALLockManager(dbPath string) (*WALLockManager, error) {
    db, err := sql.Open("sqlite3", dbPath+"?_journal_mode=WAL")
    if err != nil {
        return nil, fmt.Errorf("failed to open database: %w", err)
    }

    // Configure WAL settings
    db.SetMaxOpenConns(1)

    // Configure WAL checkpoint behavior
    settings := []string{
        "PRAGMA wal_autocheckpoint = 1000",  // Auto-checkpoint every 1000 pages
        "PRAGMA synchronous = NORMAL",       // Balance performance and safety
        "PRAGMA cache_size = -10000",        // 10MB cache
        "PRAGMA page_size = 4096",           // 4KB pages
    }

    for _, setting := range settings {
        _, err = db.Exec(setting)
        if err != nil {
            return nil, fmt.Errorf("failed to set WAL setting: %s: %w", setting, err)
        }
    }

    return &WALLockManager{db: db}, nil
}

// WriteWithWAL demonstrates write operations in WAL mode
func (m *WALLockManager) WriteWithWAL(ctx context.Context, data string) error {
    tx, err := m.db.BeginTx(ctx, &sql.TxOptions{Isolation: sql.LevelSerializable})
    if err != nil {
        return fmt.Errorf("failed to begin transaction: %w", err)
    }
    defer tx.Rollback()

    // Write operation doesn't block readers in WAL mode
    _, err = tx.ExecContext(ctx, 
        "INSERT INTO wal_data (content, created_at) VALUES (?, ?)",
        data, time.Now())
    if err != nil {
        return fmt.Errorf("insert failed: %w", err)
    }

    fmt.Printf("Wrote data: %s (readers can continue)\n", data)
    return tx.Commit()
}

// ManualCheckpoint demonstrates explicit checkpoint control
func (m *WALLockManager) ManualCheckpoint(ctx context.Context, checkpointMode string) error {
    // WAL checkpoint modes: PASSIVE, FULL, RESTART, TRUNCATE
    var checkpointSQL string
    switch checkpointMode {
    case "PASSIVE":
        checkpointSQL = "PRAGMA wal_checkpoint(PASSIVE)"
    case "FULL":
        checkpointSQL = "PRAGMA wal_checkpoint(FULL)"
    case "RESTART":
        checkpointSQL = "PRAGMA wal_checkpoint(RESTART)"
    case "TRUNCATE":
        checkpointSQL = "PRAGMA wal_checkpoint(TRUNCATE)"
    default:
        return fmt.Errorf("unknown checkpoint mode: %s", checkpointMode)
    }

    fmt.Printf("Performing WAL checkpoint: %s\n", checkpointMode)
    
    result, err := m.db.ExecContext(ctx, checkpointSQL)
    if err != nil {
        return fmt.Errorf("checkpoint failed: %w", err)
    }

    // Checkpoint returns 3 values: busy, log, checkpointed
    rowsAffected, _ := result.RowsAffected()
    fmt.Printf("Checkpoint completed, pages: %d\n", rowsAffected)

    return nil
}

// MonitorWALStatus monitors WAL file status
func (m *WALLockManager) MonitorWALStatus(ctx context.Context) (WALStatus, error) {
    var status WALStatus

    // Get WAL status
    err := m.db.QueryRowContext(ctx, "PRAGMA wal_status").Scan(&status.WalStatus)
    if err != nil {
        return status, fmt.Errorf("failed to get WAL status: %w", err)
    }

    // Get checkpoint status
    var busy, log, checkpointed int
    err = m.db.QueryRowContext(ctx, "PRAGMA wal_checkpoint(PASSIVE)").Scan(&busy, &log, &checkpointed)
    if err != nil {
        return status, fmt.Errorf("failed to get checkpoint status: %w", err)
    }

    status.Busy = busy
    status.Log = log
    status.Checkpointed = checkpointed

    return status, nil
}

type WALStatus struct {
    WalStatus    string
    Busy         int
    Log          int
    Checkpointed int
}

func (m *WALLockManager) Close() error {
    // Perform final checkpoint before closing
    ctx := context.Background()
    err := m.ManualCheckpoint(ctx, "TRUNCATE")
    if err != nil {
        log.Printf("Warning: final checkpoint failed: %v", err)
    }
    
    return m.db.Close()
}

func main() {
    manager, err := NewWALLockManager("test_wal_lock.db")
    if err != nil {
        log.Fatal(err)
    }
    defer manager.Close()

    ctx := context.Background()

    // Initialize database
    _, err = manager.db.Exec(`
        CREATE TABLE IF NOT EXISTS wal_data (
            id INTEGER PRIMARY KEY,
            content TEXT,
            created_at DATETIME
        )
    `)
    if err != nil {
        log.Fatal(err)
    }

    // Perform writes
    for i := 0; i < 10; i++ {
        data := fmt.Sprintf("sample_data_%d", i)
        err = manager.WriteWithWAL(ctx, data)
        if err != nil {
            log.Printf("Write failed: %v", err)
        }
        time.Sleep(100 * time.Millisecond)
    }

    // Monitor WAL status
    status, err := manager.MonitorWALStatus(ctx)
    if err != nil {
        log.Printf("Status check failed: %v", err)
    } else {
        fmt.Printf("WAL Status: %+v\n", status)
    }

    // Perform manual checkpoint
    err = manager.ManualCheckpoint(ctx, "TRUNCATE")
    if err != nil {
        log.Printf("Checkpoint failed: %v", err)
    }
}
```

## Lock Timeout and Retry

SQLite provides mechanisms to handle lock conflicts gracefully.

### Why use Lock Timeout and Retry:

- Handle temporary lock conflicts without application failure
- Implement backoff strategies for high-contention scenarios
- Provide better user experience during concurrent operations

```go
package main

import (
    "context"
    "database/sql"
    "fmt"
    "log"
    "time"

    _ "github.com/mattn/go-sqlite3"
)

type LockRetryManager struct {
    db                *sql.DB
    busyTimeout      time.Duration
    maxRetries       int
    retryDelay       time.Duration
    exponentialBackoff bool
}

func NewLockRetryManager(dbPath string, config LockRetryConfig) (*LockRetryManager, error) {
    db, err := sql.Open("sqlite3", dbPath)
    if err != nil {
        return nil, fmt.Errorf("failed to open database: %w", err)
    }

    // Set busy timeout (SQLite's built-in retry mechanism)
    timeoutMs := int(config.BusyTimeout / time.Millisecond)
    _, err = db.Exec(fmt.Sprintf("PRAGMA busy_timeout = %d", timeoutMs))
    if err != nil {
        return nil, fmt.Errorf("failed to set busy timeout: %w", err)
    }

    db.SetMaxOpenConns(1)

    return &LockRetryManager{
        db:                db,
        busyTimeout:      config.BusyTimeout,
        maxRetries:       config.MaxRetries,
        retryDelay:       config.RetryDelay,
        exponentialBackoff: config.ExponentialBackoff,
    }, nil
}

type LockRetryConfig struct {
    BusyTimeout        time.Duration
    MaxRetries         int
    RetryDelay         time.Duration
    ExponentialBackoff bool
}

// ExecuteWithRetry executes a database operation with retry logic
func (m *LockRetryManager) ExecuteWithRetry(ctx context.Context, operation func(*sql.Tx) error) error {
    var lastErr error
    
    for attempt := 0; attempt < m.maxRetries; attempt++ {
        if attempt > 0 {
            delay := m.calculateRetryDelay(attempt)
            fmt.Printf("Retry attempt %d after %v (previous error: %v)\n", attempt, delay, lastErr)
            
            select {
            case <-time.After(delay):
            case <-ctx.Done():
                return ctx.Err()
            }
        }

        tx, err := m.db.BeginTx(ctx, &sql.TxOptions{Isolation: sql.LevelSerializable})
        if err != nil {
            if isLockError(err) {
                lastErr = err
                continue
            }
            return fmt.Errorf("failed to begin transaction: %w", err)
        }

        err = operation(tx)
        if err != nil {
            tx.Rollback()
            if isLockError(err) {
                lastErr = err
                continue
            }
            return fmt.Errorf("operation failed: %w", err)
        }

        return tx.Commit()
    }

    return fmt.Errorf("operation failed after %d attempts: %w", m.maxRetries, lastErr)
}

func (m *LockRetryManager) calculateRetryDelay(attempt int) time.Duration {
    if m.exponentialBackoff {
        return m.retryDelay * time.Duration(1<<uint(attempt-1))
    }
    return m.retryDelay
}

func isLockError(err error) bool {
    errStr := err.Error()
    return contains(errStr, "database is locked") || 
           contains(errStr, "database is busy") ||
           contains(errStr, "SQLITE_BUSY")
}

func contains(s, substr string) bool {
    return len(s) >= len(substr) && (s == substr || len(s) > len(substr) && 
           (s[:len(substr)] == substr || s[len(s)-len(substr):] == substr || 
            indexOfSubstring(s, substr) >= 0))
}

func indexOfSubstring(s, substr string) int {
    for i := 0; i <= len(s)-len(substr); i++ {
        if s[i:i+len(substr)] == substr {
            return i
        }
    }
    return -1
}

// OptimisticUpdate demonstrates retry logic for update operations
func (m *LockRetryManager) OptimisticUpdate(ctx context.Context, recordID int64, updateFunc func(currentValue interface{}) (interface{}, error)) error {
    return m.ExecuteWithRetry(ctx, func(tx *sql.Tx) error {
        // Read current value
        var currentValue string
        err := tx.QueryRowContext(ctx, 
            "SELECT value FROM records WHERE id = ?", recordID).Scan(&currentValue)
        if err != nil {
            return fmt.Errorf("read failed: %w", err)
        }

        // Apply update function
        newValue, err := updateFunc(currentValue)
        if err != nil {
            return fmt.Errorf("update function failed: %w", err)
        }

        // Write new value
        _, err = tx.ExecContext(ctx, 
            "UPDATE records SET value = ?, updated_at = ? WHERE id = ?",
            newValue, time.Now(), recordID)
        if err != nil {
            return fmt.Errorf("write failed: %w", err)
        }

        return nil
    })
}

func (m *LockRetryManager) Close() error {
    return m.db.Close()
}

func main() {
    config := LockRetryConfig{
        BusyTimeout:        5 * time.Second,
        MaxRetries:         3,
        RetryDelay:         100 * time.Millisecond,
        ExponentialBackoff: true,
    }

    manager, err := NewLockRetryManager("test_retry.db", config)
    if err != nil {
        log.Fatal(err)
    }
    defer manager.Close()

    ctx := context.Background()

    // Initialize database
    _, err = manager.db.Exec(`
        CREATE TABLE IF NOT EXISTS records (
            id INTEGER PRIMARY KEY,
            value TEXT,
            updated_at DATETIME
        )
    `)
    if err != nil {
        log.Fatal(err)
    }

    // Test retry logic
    err = manager.OptimisticUpdate(ctx, 1, func(currentValue interface{}) (interface{}, error) {
        currentStr := currentValue.(string)
        return currentStr + "_updated", nil
    })
    if err != nil {
        log.Printf("Update failed: %v", err)
    } else {
        fmt.Println("Update completed successfully")
    }
}
```

## Advanced Locking Strategies

### Busy Handler

**Description:** Custom callback function for handling lock conflicts.

**When used:** Applications needing custom lock conflict resolution.

**Why use Busy Handler:**
- Implement custom retry logic beyond simple timeouts
- Log lock conflicts for monitoring
- Implement application-specific backoff strategies

```go
package main

import (
    "database/sql"
    "fmt"
    "log"
    "time"

    _ "github.com/mattn/go-sqlite3"
)

/*
Note: The SQLite Go driver (github.com/mattn/go-sqlite3) provides 
busy timeout via PRAGMA busy_timeout, but for custom busy handlers,
you need to use the CGo interface directly or implement retry logic 
at the application level as shown in the previous section.

This example demonstrates application-level busy handler simulation.
*/

type BusyHandler struct {
    maxAttempts    int
    baseDelay      time.Duration
    onLockConflict func(attempt int, err error) bool
}

func NewBusyHandler(maxAttempts int, baseDelay time.Duration) *BusyHandler {
    return &BusyHandler{
        maxAttempts: maxAttempts,
        baseDelay:   baseDelay,
        onLockConflict: func(attempt int, err error) bool {
            // Default: retry for all lock errors
            return true
        },
    }
}

func (h *BusyHandler) SetLockConflictHandler(handler func(attempt int, err error) bool) {
    h.onLockConflict = handler
}

func (h *BusyHandler) ExecuteWithBusyHandler(db *sql.DB, operation func() error) error {
    var lastErr error
    
    for attempt := 1; attempt <= h.maxAttempts; attempt++ {
        err := operation()
        if err == nil {
            return nil
        }

        if !isLockError(err) {
            return err
        }

        lastErr = err
        
        // Call custom conflict handler
        shouldRetry := h.onLockConflict(attempt, err)
        if !shouldRetry {
            return fmt.Errorf("lock conflict on attempt %d: %w", attempt, lastErr)
        }

        // Calculate delay with exponential backoff
        delay := h.baseDelay * time.Duration(1<<uint(attempt-1))
        fmt.Printf("Lock conflict detected, attempt %d/%d, retrying after %v\n", 
            attempt, h.maxAttempts, delay)
        
        time.Sleep(delay)
    }

    return fmt.Errorf("operation failed after %d attempts: %w", h.maxAttempts, lastErr)
}

// LoggingBusyHandler creates a handler that logs lock conflicts
type LoggingBusyHandler struct {
    *BusyHandler
    logFile *log.Logger
}

func NewLoggingBusyHandler(maxAttempts int, baseDelay time.Duration, logger *log.Logger) *LoggingBusyHandler {
    base := NewBusyHandler(maxAttempts, baseDelay)
    
    return &LoggingBusyHandler{
        BusyHandler: base,
        logFile:    logger,
    }
}

func (h *LoggingBusyHandler) SetLoggingHandler() {
    h.onLockConflict = func(attempt int, err error) bool {
        h.logFile.Printf("Lock conflict at attempt %d: %v", attempt, err)
        return true
    }
}

// AdaptiveBusyHandler creates a handler that adapts retry strategy
type AdaptiveBusyHandler struct {
    *BusyHandler
    recentConflicts []time.Time
    windowSize      int
    windowDuration  time.Duration
}

func NewAdaptiveBusyHandler(maxAttempts int, baseDelay time.Duration) *AdaptiveBusyHandler {
    base := NewBusyHandler(maxAttempts, baseDelay)
    
    return &AdaptiveBusyHandler{
        BusyHandler:     base,
        recentConflicts: make([]time.Time, 0),
        windowSize:      10,
        windowDuration:  30 * time.Second,
    }
}

func (h *AdaptiveBusyHandler) SetAdaptiveHandler() {
    h.onLockConflict = func(attempt int, err error) bool {
        now := time.Now()
        
        // Clean up old conflicts
        h.recentConflicts = h.filterRecentConflicts(now)
        h.recentConflicts = append(h.recentConflicts, now)
        
        // If many recent conflicts, increase delay
        if len(h.recentConflicts) > h.windowSize/2 {
            h.baseDelay *= 2
            fmt.Printf("High contention detected, increased delay to %v\n", h.baseDelay)
        }
        
        return true
    }
}

func (h *AdaptiveBusyHandler) filterRecentConflicts(now time.Time) []time.Time {
    var recent []time.Time
    for _, t := range h.recentConflicts {
        if now.Sub(t) <= h.windowDuration {
            recent = append(recent, t)
        }
    }
    return recent
}

func main() {
    db, err := sql.Open("sqlite3", "test_busy.db")
    if err != nil {
        log.Fatal(err)
    }
    defer db.Close()

    // Create test table
    _, err = db.Exec(`
        CREATE TABLE IF NOT EXISTS test_table (
            id INTEGER PRIMARY KEY,
            value TEXT
        )
    `)
    if err != nil {
        log.Fatal(err)
    }

    // Test with different busy handlers
    logger := log.New(log.Writer(), "BUSY: ", log.LstdFlags)
    loggingHandler := NewLoggingBusyHandler(5, 100*time.Millisecond, logger)
    loggingHandler.SetLoggingHandler()

    err = loggingHandler.ExecuteWithBusyHandler(db, func() error {
        _, err := db.Exec("INSERT INTO test_table (value) VALUES ('test')")
        return err
    })
    
    if err != nil {
        log.Printf("Operation with logging handler failed: %v", err)
    }

    // Test adaptive handler
    adaptiveHandler := NewAdaptiveBusyHandler(5, 50*time.Millisecond)
    adaptiveHandler.SetAdaptiveHandler()

    err = adaptiveHandler.ExecuteWithBusyHandler(db, func() error {
        _, err := db.Exec("UPDATE test_table SET value = 'updated' WHERE id = 1")
        return err
    })
    
    if err != nil {
        log.Printf("Operation with adaptive handler failed: %v", err)
    }
}
```

### Application-level Locking

**Description:** Implement custom locking mechanisms using SQLite tables or other coordination services.

**When used:** Complex coordination patterns beyond SQLite's built-in locking.

**Why use Application-level Locking:**
- Implement distributed locking across multiple databases
- Create custom lock semantics (fairness, priority, etc.)
- Coordinate operations across multiple services

```go
package main

import (
    "context"
    "database/sql"
    "fmt"
    "log"
    "time"

    _ "github.com/mattn/go-sqlite3"
)

type AppLockManager struct {
    db *sql.DB
    clientID string
}

func NewAppLockManager(dbPath string, clientID string) (*AppLockManager, error) {
    db, err := sql.Open("sqlite3", dbPath)
    if err != nil {
        return nil, fmt.Errorf("failed to open database: %w", err)
    }

    // Create lock table
    _, err = db.Exec(`
        CREATE TABLE IF NOT EXISTS app_locks (
            lock_name TEXT PRIMARY KEY,
            client_id TEXT NOT NULL,
            acquired_at DATETIME NOT NULL,
            expires_at DATETIME NOT NULL
        )
    `)
    if err != nil {
        return nil, fmt.Errorf("failed to create lock table: %w", err)
    }

    return &AppLockManager{db: db, clientID: clientID}, nil
}

// AcquireLock attempts to acquire an application-level lock
func (m *AppLockManager) AcquireLock(ctx context.Context, lockName string, ttl time.Duration) (bool, error) {
    now := time.Now()
    expiresAt := now.Add(ttl)

    // Clean up expired locks
    _, err := m.db.ExecContext(ctx, 
        "DELETE FROM app_locks WHERE expires_at < ?", now)
    if err != nil {
        return false, fmt.Errorf("failed to cleanup expired locks: %w", err)
    }

    // Try to acquire lock
    result, err := m.db.ExecContext(ctx, `
        INSERT INTO app_locks (lock_name, client_id, acquired_at, expires_at)
        VALUES (?, ?, ?, ?)
    `, lockName, m.clientID, now, expiresAt)
    
    if err != nil {
        return false, fmt.Errorf("failed to acquire lock: %w", err)
    }

    rowsAffected, _ := result.RowsAffected()
    acquired := rowsAffected > 0

    if acquired {
        fmt.Printf("Lock '%s' acquired by client %s\n", lockName, m.clientID)
    }

    return acquired, nil
}

// ReleaseLock releases an application-level lock
func (m *AppLockManager) ReleaseLock(ctx context.Context, lockName string) error {
    result, err := m.db.ExecContext(ctx, 
        "DELETE FROM app_locks WHERE lock_name = ? AND client_id = ?",
        lockName, m.clientID)
    
    if err != nil {
        return fmt.Errorf("failed to release lock: %w", err)
    }

    rowsAffected, _ := result.RowsAffected()
    if rowsAffected == 0 {
        return fmt.Errorf("lock not owned by this client")
    }

    fmt.Printf("Lock '%s' released by client %s\n", lockName, m.clientID)
    return nil
}

// ExtendLock extends the TTL of an existing lock
func (m *AppLockManager) ExtendLock(ctx context.Context, lockName string, additionalTTL time.Duration) error {
    now := time.Now()
    newExpiry := now.Add(additionalTTL)

    result, err := m.db.ExecContext(ctx, `
        UPDATE app_locks 
        SET expires_at = ?
        WHERE lock_name = ? AND client_id = ?
    `, newExpiry, lockName, m.clientID)
    
    if err != nil {
        return fmt.Errorf("failed to extend lock: %w", err)
    }

    rowsAffected, _ := result.RowsAffected()
    if rowsAffected == 0 {
        return fmt.Errorf("lock not owned by this client or expired")
    }

    fmt.Printf("Lock '%s' extended by client %s\n", lockName, m.clientID)
    return nil
}

// ExecuteWithLock executes a function while holding a lock
func (m *AppLockManager) ExecuteWithLock(ctx context.Context, lockName string, ttl time.Duration, operation func() error) error {
    // Try to acquire lock
    acquired, err := m.AcquireLock(ctx, lockName, ttl)
    if err != nil {
        return fmt.Errorf("failed to acquire lock: %w", err)
    }
    if !acquired {
        return fmt.Errorf("lock '%s' is already held", lockName)
    }

    // Ensure lock is released
    defer func() {
        releaseCtx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
        defer cancel()
        if err := m.ReleaseLock(releaseCtx, lockName); err != nil {
            log.Printf("Warning: failed to release lock: %v", err)
        }
    }()

    // Start lock extension goroutine
    extensionCtx, extensionCancel := context.WithCancel(ctx)
    extensionDone := make(chan error)

    go func() {
        ticker := time.NewTicker(ttl / 2)
        defer ticker.Stop()
        
        for {
            select {
            case <-ticker.C:
                if err := m.ExtendLock(extensionCtx, lockName, ttl); err != nil {
                    extensionDone <- err
                    return
                }
            case <-extensionCtx.Done():
                extensionDone <- nil
                return
            }
        }
    }()

    // Execute operation
    err = operation()
    
    // Stop extension goroutine
    extensionCancel()
    <-extensionDone

    return err
}

// CheckLockStatus checks if a lock is held and by whom
func (m *AppLockManager) CheckLockStatus(ctx context.Context, lockName string) (LockStatus, error) {
    var status LockStatus
    
    err := m.db.QueryRowContext(ctx, `
        SELECT client_id, acquired_at, expires_at 
        FROM app_locks 
        WHERE lock_name = ?
    `, lockName).Scan(&status.ClientID, &status.AcquiredAt, &status.ExpiresAt)
    
    if err == sql.ErrNoRows {
        status.Held = false
        return status, nil
    }
    if err != nil {
        return status, fmt.Errorf("failed to check lock status: %w", err)
    }

    status.Held = true
    status.IsOwned = (status.ClientID == m.clientID)
    status.IsExpired = time.Now().After(status.ExpiresAt)

    return status, nil
}

type LockStatus struct {
    Held       bool
    ClientID   string
    AcquiredAt time.Time
    ExpiresAt  time.Time
    IsOwned    bool
    IsExpired  bool
}

func (m *AppLockManager) Close() error {
    return m.db.Close()
}

func main() {
    manager1, err := NewAppLockManager("test_app_lock.db", "client1")
    if err != nil {
        log.Fatal(err)
    }
    defer manager1.Close()

    manager2, err := NewAppLockManager("test_app_lock.db", "client2")
    if err != nil {
        log.Fatal(err)
    }
    defer manager2.Close()

    ctx := context.Background()
    lockName := "important_resource"
    ttl := 10 * time.Second

    // Client 1 acquires lock
    acquired1, err := manager1.AcquireLock(ctx, lockName, ttl)
    if err != nil {
        log.Fatal(err)
    }
    fmt.Printf("Client 1 acquired lock: %v\n", acquired1)

    // Check lock status
    status, err := manager1.CheckLockStatus(ctx, lockName)
    if err != nil {
        log.Printf("Failed to check status: %v", err)
    } else {
        fmt.Printf("Lock status: %+v\n", status)
    }

    // Client 2 tries to acquire lock
    acquired2, err := manager2.AcquireLock(ctx, lockName, ttl)
    if err != nil {
        log.Printf("Client 2 error: %v", err)
    }
    fmt.Printf("Client 2 acquired lock: %v\n", acquired2)

    // Execute operation with lock
    err = manager1.ExecuteWithLock(ctx, lockName, ttl, func() error {
        fmt.Println("Executing critical operation...")
        time.Sleep(2 * time.Second)
        fmt.Println("Operation completed")
        return nil
    })
    if err != nil {
        log.Printf("Operation failed: %v", err)
    }

    // Client 2 tries again after client 1 releases
    acquired2, err = manager2.AcquireLock(ctx, lockName, ttl)
    if err != nil {
        log.Printf("Client 2 error: %v", err)
    }
    fmt.Printf("Client 2 acquired lock after release: %v\n", acquired2)
}
```

## Best Practices

1. **Use WAL mode for better concurrency** - Eliminates reader-writer blocking in most cases
2. **Keep transactions short** - Long-held locks increase contention
3. **Use appropriate transaction modes** - BEGIN IMMEDIATE for writes, BEGIN DEFERRED for reads
4. **Implement retry logic** - Handle lock conflicts gracefully with exponential backoff
5. **Monitor lock contention** - Use busy handlers and logging to identify bottlenecks
6. **Consider application-level locking** - For complex coordination patterns
7. **Configure busy timeout appropriately** - Balance between responsiveness and patience
8. **Regular checkpointing in WAL mode** - Prevent WAL file growth and manage disk space
9. **Use connection pooling wisely** - SQLite typically works best with limited connections
10. **Test under load** - Lock behavior changes dramatically under concurrent load

## SQLite vs PostgreSQL Locking Comparison

| Feature | SQLite | PostgreSQL |
|---------|--------|------------|
| Lock Granularity | File-level | Table and row-level |
| Lock Modes | 5 progressive states | Multiple lock types with conflict matrices |
| Concurrent Writes | Limited (1 writer) | Multiple writers with row locking |
| Reader Blocking | Writers block readers (default) | Readers don't block writers (MVCC) |
| WAL Support | Yes (improves concurrency) | Yes (default) |
| Advisory Locks | No (but can implement app-level) | Yes |
| Lock Timeout | PRAGMA busy_timeout | lock_timeout parameter |
| Deadlock Detection | Limited | Yes |