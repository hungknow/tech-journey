# PostgreSQL Index Guide

## Table of Contents

### [Use Cases](#use-cases)
- [Primary Key and Unique Constraints](#1-primary-key-and-unique-constraints)
- [Range Queries and Sorting](#2-range-queries-and-sorting)
- [Full-Text Search](#3-full-text-search)
- [Array Operations](#4-array-operations)
- [JSONB Queries](#5-jsonb-queries)
- [Geospatial Data](#6-geospatial-data)
- [Range Data Types](#7-range-data-types)
- [Large Time-Series Tables](#8-large-time-series-tables)
- [Equality-Only Lookups](#9-equality-only-lookups)
- [Text Pattern Matching](#10-text-pattern-matching)
- [Case-Insensitive Search](#11-case-insensitive-search)
- [Soft-Delete Pattern](#12-soft-delete-pattern)
- [Index-Only Scans](#13-index-only-scans)
- [High-Writeload Tables](#14-high-writeload-tables)
- [Production Index Creation](#15-production-index-creation)
- [Multi-Column Filtering](#16-multi-column-filtering)
- [Skewed Boolean Distribution](#17-skewed-boolean-distribution)
- [Membership Testing with Multiple Columns](#18-membership-testing-with-multiple-columns)

### [Index Types](#index-types)
- [B-Tree](#b-tree)
- [Hash](#hash)
- [GiST](#gist)
- [SP-GiST](#sp-gist)
- [GIN](#gin)
- [BRIN](#brin)
- [Bloom](#bloom)

### [Index Features](#index-features)
- [Partial Indexes](#partial-indexes)
- [Unique Indexes](#unique-indexes)
- [Expression Indexes](#expression-indexes)
- [Covering Indexes (INCLUDE)](#covering-indexes-include)
- [Concurrent Index Creation](#concurrent-index-creation)
- [Multicolumn Indexes](#multicolumn-indexes)
- [Cluster](#cluster)
- [Fillfactor](#fillfactor)
- [NULLS DISTINCT / NULLS NOT DISTINCT](#nulls-distinct--nulls-not-distinct)
- [Descending Indexes](#descending-indexes)
- [Parallel Index Creation](#parallel-index-creation)

---

## Use Cases

### 1. Primary Key and Unique Constraints

**Recommended Index:** B-Tree (default)

**Why:** B-Tree is PostgreSQL's default index type and provides excellent performance for equality and range queries. It's the only index type that can enforce UNIQUE constraints without additional extensions.

```sql
CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  email VARCHAR(255) UNIQUE NOT NULL,
  username VARCHAR(100) UNIQUE
);

-- Automatically creates B-Tree indexes on id and email
```

**Use with Unique Feature:** When you need to enforce uniqueness across specific row subsets.

```sql
-- Only one active user per email
CREATE UNIQUE INDEX idx_active_email ON users (email) WHERE is_active = true;
```

### 2. Range Queries and Sorting

**Recommended Index:** B-Tree

**Why:** B-Tree naturally sorts data, making it ideal for range queries (`<`, `>`, `BETWEEN`) and `ORDER BY` operations.

```sql
CREATE INDEX idx_created_at ON orders (created_at);

-- Benefits queries like:
SELECT * FROM orders WHERE created_at BETWEEN '2024-01-01' AND '2024-12-31';
SELECT * FROM orders ORDER BY created_at DESC LIMIT 10;
```

**Use with Descending Feature:** For mixed sort orders.

```sql
CREATE INDEX idx_created_status ON orders (created_at DESC, status ASC);

-- Optimizes:
SELECT * FROM orders ORDER BY created_at DESC, status ASC;
```

### 3. Full-Text Search

**Recommended Index:** GIN

**Why:** GIN indexes each word in the text and supports efficient containment searches. It's the recommended choice for full-text search with `to_tsvector()`.

```sql
CREATE INDEX idx_fts ON articles USING GIN (to_tsvector('english', content));

-- Benefits queries like:
SELECT * FROM articles 
WHERE to_tsvector('english', content) @@ to_tsquery('english', 'postgresql & index');
```

**Use with Partial Feature:** Index only published articles.

```sql
CREATE INDEX idx_fts_published ON articles 
USING GIN (to_tsvector('english', content)) 
WHERE status = 'published';
```

### 4. Array Operations

**Recommended Index:** GIN

**Why:** GIN indexes each array element, enabling efficient array containment and overlap queries.

```sql
CREATE TABLE posts (
  id SERIAL PRIMARY KEY,
  tags TEXT[] NOT NULL
);

CREATE INDEX idx_tags ON posts USING GIN (tags);

-- Benefits queries like:
SELECT * FROM posts WHERE tags @> ARRAY['database', 'sql'];
SELECT * FROM posts WHERE tags && ARRAY['sql'];
```

**Use with Partial Feature:** Index only active posts.

```sql
CREATE INDEX idx_active_tags ON posts USING GIN (tags) WHERE is_active = true;
```

### 5. JSONB Queries

**Recommended Index:** GIN

**Why:** GIN supports `@>` containment operator for JSONB, making it perfect for querying nested JSON data.

```sql
CREATE TABLE products (
  id SERIAL PRIMARY KEY,
  metadata JSONB
);

CREATE INDEX idx_metadata ON products USING GIN (metadata);

-- Benefits queries like:
SELECT * FROM products WHERE metadata @> '{"category": "electronics", "stock": true}';
```

**Alternative:** Expression Index with B-Tree for specific JSONB paths.

```sql
CREATE INDEX idx_metadata_category ON products ((metadata->>'category'));

-- Benefits:
SELECT * FROM products WHERE metadata->>'category' = 'electronics';
```

### 6. Geospatial Data

**Recommended Index:** GiST

**Why:** GiST supports spatial operators like `&&` (overlaps), `@>` (contains), and `<@` (contained by), essential for GIS applications.

```sql
CREATE EXTENSION IF NOT EXISTS postgis;

CREATE TABLE locations (
  id SERIAL PRIMARY KEY,
  name VARCHAR(100),
  geom GEOMETRY(Point, 4326)
);

CREATE INDEX idx_geom ON locations USING GiST (geom);

-- Benefits queries like:
SELECT * FROM locations 
WHERE ST_DWithin(geom, ST_MakePoint(-71.06, 42.36), 1000);
```

**Use with Partial Feature:** Index only active locations.

```sql
CREATE INDEX idx_active_geom ON locations USING GiST (geom) WHERE is_active = true;
```

### 7. Range Data Types

**Recommended Index:** GiST or SP-GiST

**Why:** Both support range operators like `@>` (contains) and `&&` (overlaps). SP-GiST can be faster for certain distributions.

```sql
CREATE TABLE reservations (
  id SERIAL PRIMARY KEY,
  room_id INTEGER NOT NULL,
  during TSRANGE NOT NULL
);

CREATE INDEX idx_during ON reservations USING GiST (during);

-- Benefits queries like:
SELECT * FROM reservations 
WHERE during && '[2024-01-01 14:00, 2024-01-01 16:00)'::tsrange;
```

### 8. Large Time-Series Tables

**Recommended Index:** BRIN

**Why:** BRIN stores summary information per block range, making it extremely space-efficient for large tables with naturally ordered data like timestamps.

```sql
CREATE TABLE events (
  id BIGSERIAL PRIMARY KEY,
  created_at TIMESTAMP NOT NULL,
  event_type VARCHAR(50),
  data JSONB
);

CREATE INDEX idx_created_at ON events USING BRIN (created_at);

-- Benefits queries scanning large time ranges:
SELECT * FROM events 
WHERE created_at BETWEEN '2024-01-01' AND '2024-01-31';
```

**Use with Partial Feature:** Index only recent data.

```sql
CREATE INDEX idx_recent_events ON events 
USING BRIN (created_at) 
WHERE created_at >= CURRENT_DATE - INTERVAL '1 year';
```

### 9. Equality-Only Lookups

**Recommended Index:** Hash

**Why:** Hash indexes are faster for equality comparisons than B-Tree, but don't support range queries. Good for columns used only in `=` conditions.

```sql
CREATE INDEX idx_email_hash ON users USING HASH (email);

-- Benefits queries like:
SELECT * FROM users WHERE email = 'user@example.com';
```

**Use Case Warning:** Only use when you never query ranges on this column.

### 10. Text Pattern Matching

**Recommended Index:** SP-GiST

**Why:** SP-GiST provides efficient pattern matching for text, supporting operators like `~`, `~*`, `LIKE`, and `ILIKE`.

```sql
CREATE INDEX idx_text_pattern ON documents USING SP-GiST (title);

-- Benefits queries like:
SELECT * FROM documents WHERE title LIKE '%postgres%';
SELECT * FROM documents WHERE title ~ '^PostgreSQL';
```

### 11. Case-Insensitive Search

**Recommended Index:** Expression Index with B-Tree

**Why:** Expression indexes allow you to index the result of `LOWER()` or other functions, enabling case-insensitive search.

```sql
CREATE INDEX idx_lower_email ON users (LOWER(email));

-- Benefits queries like:
SELECT * FROM users WHERE LOWER(email) = LOWER('USER@EXAMPLE.COM');
```

**Use with Unique Feature:** Enforce case-insensitive uniqueness.

```sql
CREATE UNIQUE INDEX idx_unique_lower_email ON users (LOWER(email));
```

### 12. Soft-Delete Pattern

**Recommended Index:** Partial B-Tree

**Why:** Partial indexes exclude deleted rows, reducing index size and improving query performance for active records.

```sql
CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  email VARCHAR(255) NOT NULL,
  deleted_at TIMESTAMP
);

CREATE INDEX idx_active_email ON users (email) WHERE deleted_at IS NULL;

-- Benefits queries like:
SELECT * FROM users WHERE email = 'user@example.com' AND deleted_at IS NULL;
```

### 13. Index-Only Scans

**Recommended Index:** Covering Index (B-Tree with INCLUDE)

**Why:** INCLUDE adds non-key columns to the index, enabling index-only scans that avoid table lookups.

```sql
CREATE INDEX idx_order_status_covering ON orders (status) 
INCLUDE (customer_id, total, created_at);

-- Benefits queries like:
SELECT customer_id, total, created_at 
FROM orders 
WHERE status = 'completed';
```

### 14. High-Writeload Tables

**Recommended Index:** Lower Fillfactor B-Tree

**Why:** Lower fillfactor reserves space in index pages, reducing page splits and fragmentation during frequent updates.

```sql
CREATE INDEX idx_updated_at ON products (updated_at) WITH (fillfactor = 70);

-- Benefits tables with frequent updates, reduces index maintenance overhead
```

### 15. Production Index Creation

**Recommended Feature:** CONCURRENTLY

**Why:** Building indexes with CONCURRENTLY doesn't block writes, essential for production systems.

```sql
CREATE INDEX CONCURRENTLY idx_new_index ON users (email);

-- Allows application to continue writing while index is built
-- Takes longer than regular index creation
```

### 16. Multi-Column Filtering

**Recommended Index:** Multicolumn B-Tree

**Why:** Indexes on multiple columns optimize queries filtering on multiple conditions simultaneously.

```sql
CREATE TABLE orders (
  id SERIAL PRIMARY KEY,
  customer_id INTEGER NOT NULL,
  status VARCHAR(50) NOT NULL,
  created_at TIMESTAMP NOT NULL
);

CREATE INDEX idx_customer_status ON orders (customer_id, status);

-- Benefits queries like:
SELECT * FROM orders 
WHERE customer_id = 123 AND status = 'pending';

-- Also benefits queries on customer_id alone (leftmost prefix):
SELECT * FROM orders WHERE customer_id = 123;
```

### 17. Skewed Boolean Distribution

**Recommended Index:** Partial B-Tree

**Why:** When 99% of rows have the same boolean value, a partial index on the rare value is much smaller and faster.

```sql
CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  email VARCHAR(255) NOT NULL,
  is_admin BOOLEAN DEFAULT FALSE
);

CREATE INDEX idx_admins ON users (email) WHERE is_admin = true;

-- Benefits queries filtering for admins (rare case):
SELECT * FROM users WHERE is_admin = true;
```

### 18. Membership Testing with Multiple Columns

**Recommended Index:** Bloom

**Why:** Bloom indexes are probabilistic structures that efficiently test membership across multiple columns with minimal space.

```sql
CREATE EXTENSION bloom;

CREATE TABLE products (
  id SERIAL PRIMARY KEY,
  category VARCHAR(50),
  brand VARCHAR(50),
  color VARCHAR(50)
);

CREATE INDEX idx_bloom ON products USING bloom (category, brand, color);

-- Benefits queries like:
SELECT * FROM products 
WHERE category = 'electronics' AND brand = 'Apple' AND color = 'black';
```

---

## Index Types

### B-Tree

**Default index type** and most versatile option in PostgreSQL.

**Supports:**
- Equality operators: `=`, `!=`, `<>`
- Range operators: `<`, `>`, `<=`, `>=`, `BETWEEN`
- Pattern matching: `LIKE`, `ILIKE`, `~`, `~*`
- Sorting: `ORDER BY`, `GROUP BY`

**Best For:**
- Primary keys and unique constraints
- Range queries
- Sorting operations
- Most general-purpose indexing needs

**Example:**
```sql
-- Basic B-Tree index
CREATE INDEX idx_name ON users (name);

-- Multicolumn B-Tree
CREATE INDEX idx_name_email ON users (name, email);

-- Descending order
CREATE INDEX idx_created_desc ON events (created_at DESC);
```

**When to Use:**
- Default choice for most scenarios
- When you need both equality and range queries
- When enforcing UNIQUE constraints
- When you need to support sorting

---

### Hash

**Optimized for equality-only comparisons.**

**Supports:**
- Equality operators: `=`

**Does NOT Support:**
- Range operators: `<`, `>`, `<=`, `>=`
- Pattern matching: `LIKE`, `~`
- Sorting: `ORDER BY`

**Best For:**
- Columns queried only with `=`
- High-frequency equality lookups
- When index size matters

**Example:**
```sql
CREATE INDEX idx_email_hash ON users USING HASH (email);

-- Efficient for:
SELECT * FROM users WHERE email = 'user@example.com';

-- Inefficient for:
SELECT * FROM users WHERE email LIKE 'user%';
```

**When to Use:**
- When you never query ranges on the column
- When you need faster equality lookups than B-Tree
- When index size is a concern

**When to Avoid:**
- When you might need range queries in the future
- When you need sorting
- When you need pattern matching

---

### GiST (Generalized Search Tree)

**Supports complex data types and spatial searches.**

**Supports:**
- Geometric operators: `<<`, `&<`, `&>`, `>>`, `<<|`, `&<|`, `|&>`, `|>>`, `@>`, `<@`, `~=`, `&&`
- Range operators: `@>`, `<@`, `&&`, `<<`, `>>`
- Full-text search operators: `@@`

**Best For:**
- Geospatial data (PostGIS)
- Range types
- Full-text search (alternative to GIN)
- IP network types

**Example:**
```sql
-- PostGIS geometry
CREATE EXTENSION postgis;
CREATE INDEX idx_geom ON locations USING GiST (geom);

-- Range types
CREATE INDEX idx_during ON reservations USING GiST (during);

-- IP networks
CREATE INDEX idx_ip ON access_logs USING GiST (ip_range);
```

**When to Use:**
- Working with geometric/spatial data
- Using range data types
- Need complex containment queries
- Alternative to GIN for full-text search (better for updates)

---

### SP-GiST (Space-Partitioned GiST)

**Alternative to GiST for certain data types and distributions.**

**Supports:**
- Text pattern matching: `~`, `~*`, `LIKE`, `ILIKE`
- Range operators: `@>`, `<@`, `&&`, `<<`, `>>`
- Point data

**Best For:**
- Text pattern matching
- Highly skewed data distributions
- Points in space
- Some range queries

**Example:**
```sql
-- Text pattern matching
CREATE INDEX idx_text_pattern ON documents USING SP-GiST (title);

-- Points
CREATE INDEX idx_points ON locations USING SP-GiST (coordinates);
```

**When to Use:**
- Need efficient text pattern matching
- Data has highly non-uniform distribution
- Alternative to GiST for specific data types
- When GiST performance is suboptimal for your data

**When to Avoid:**
- When data distribution is uniform (GiST may be better)
- When you're unsure (start with GiST or GIN)

---

### GIN (Generalized Inverted Index)

**Best for array values and document search.**

**Supports:**
- Array operators: `@>` (contains), `&&` (overlaps), `@?` (contains elements), `@@` (GIN array queries)
- Full-text search: `@@` (tsquery)
- JSONB: `@>` (contains), `?` (key exists), `?|`, `?&`

**Best For:**
- Array operations
- Full-text search
- JSONB queries
- Any containment-based queries

**Example:**
```sql
-- Arrays
CREATE INDEX idx_tags ON articles USING GIN (tags);

-- Full-text search
CREATE INDEX idx_fts ON articles USING GIN (to_tsvector('english', content));

-- JSONB
CREATE INDEX idx_metadata ON products USING GIN (metadata);

-- HStore
CREATE INDEX idx_attributes ON products USING GIN (attributes);
```

**When to Use:**
- Querying array contents
- Full-text search with `@@`
- JSONB containment queries
- When you need to index composite values

**Performance Considerations:**
- Larger than B-Tree indexes
- Slower for writes than B-Tree
- Use `fastupdate = true` for write-heavy workloads (default)
- Use `fastupdate = false` for read-heavy workloads

---

### BRIN (Block Range Index)

**Extremely space-efficient for very large tables with ordered data.**

**Supports:**
- Equality operators: `=`, `!=`, `<>`
- Range operators: `<`, `>`, `<=`, `>=`, `BETWEEN`

**Best For:**
- Very large tables (millions/billions of rows)
- Naturally ordered data (timestamps, serial IDs)
- Queries that scan large portions of the table
- When index size is critical

**Example:**
```sql
-- Default pages_per_range (128)
CREATE INDEX idx_created_at ON events USING BRIN (created_at);

-- More granular (better query performance)
CREATE INDEX idx_created_at ON events USING BRIN (created_at) 
WITH (pages_per_range = 32);

-- Less granular (smaller index)
CREATE INDEX idx_created_at ON events USING BRIN (created_at) 
WITH (pages_per_range = 512);
```

**When to Use:**
- Tables with hundreds of millions of rows
- Data is naturally ordered (timestamps, sequences)
- Queries typically scan large ranges
- Storage space is a concern

**When to Avoid:**
- Small or medium-sized tables (use B-Tree)
- Randomly distributed data
- Queries that need precise individual row lookups

**Performance Note:** BRIN doesn't speed up point queries (single row lookups). It only helps when scanning ranges that span multiple block ranges.

---

### Bloom

**Probabilistic data structure for membership testing.**

**Supports:**
- Equality operators: `=`, `!=`, `<>`

**Does NOT Support:**
- Range operators
- Pattern matching
- Sorting

**Best For:**
- Testing membership across multiple columns
- Small, space-efficient indexes
- When false positives are acceptable

**Example:**
```sql
CREATE EXTENSION bloom;

CREATE TABLE products (
  id SERIAL PRIMARY KEY,
  category VARCHAR(50),
  brand VARCHAR(50),
  color VARCHAR(50)
);

CREATE INDEX idx_bloom ON products USING bloom (category, brand, color);

-- Queries benefit:
SELECT * FROM products 
WHERE category = 'electronics' AND brand = 'Apple' AND color = 'black';
```

**When to Use:**
- Need to filter on multiple columns simultaneously
- Index size is a critical concern
- Can tolerate occasional false positives (PostgreSQL rechecks)
- Alternative to multicolumn B-Tree when space is tight

**When to Avoid:**
- When you need range queries
- When you need sorting
- When false positives are unacceptable
- When you can afford a larger B-Tree index

**Important:** Requires the `bloom` extension to be installed.

---

## Index Features

### Partial Indexes

Create indexes that only include rows matching a `WHERE` clause condition.

**Benefits:**
- Smaller index size
- Faster index scans
- Reduced storage and memory usage
- Faster index creation

**Use Cases:**
- Filter frequently queried subsets of data
- Boolean columns with skewed distribution
- Soft-delete patterns
- Time-based filtering

**Examples:**
```sql
-- Basic partial index
CREATE INDEX idx_active_users ON users (email) WHERE is_active = true;

-- Partial unique index
CREATE UNIQUE INDEX idx_active_email ON users (email) WHERE is_active = true;

-- Multiple conditions
CREATE INDEX idx_priority_active ON tasks (priority) 
WHERE status = 'pending' AND is_active = true;

-- Time-based
CREATE INDEX idx_recent ON logs (created_at) 
WHERE created_at >= CURRENT_DATE - INTERVAL '30 days';
```

**When to Use:**
- Frequently query a subset of rows
- 90%+ of queries include the filter condition
- Boolean columns with highly uneven distribution
- Soft-delete pattern (only index non-deleted rows)
- Time-based queries on recent data

**When to Avoid:**
- When queries don't include the filter condition (index won't be used)
- When the subset is large (close to 100% of rows)

---

### Unique Indexes

Enforce uniqueness on column(s) to prevent duplicate values.

**Benefits:**
- Data integrity
- Automatic use for UNIQUE constraints
- Enables efficient lookups (B-Tree)

**Use Cases:**
- Primary keys
- Unique business identifiers (email, username)
- Enforcing uniqueness in subsets (with partial indexes)

**Examples:**
```sql
-- Basic unique index
CREATE UNIQUE INDEX idx_email ON users (email);

-- Multicolumn unique index
CREATE UNIQUE INDEX idx_name_email ON users (name, email);

-- Partial unique index (only one active per email)
CREATE UNIQUE INDEX idx_active_email ON users (email) WHERE is_active = true;

-- Expression unique index (case-insensitive)
CREATE UNIQUE INDEX idx_unique_lower_email ON users (LOWER(email));
```

**When to Use:**
- Enforcing business rules (unique emails, usernames)
- Preventing duplicate data
- Primary keys (automatically created)
- Enforcing uniqueness on specific row subsets

**When to Avoid:**
- When duplicates are allowed
- When you only need performance, not uniqueness (use regular index)

---

### Expression Indexes (Functional Indexes)

Index the result of an expression or function call, not raw column values.

**Benefits:**
- Enable index usage for computed values
- Support case-insensitive search
- Index complex transformations

**Use Cases:**
- Case-insensitive comparisons
- Indexing computed expressions
- Pattern matching with functions
- Complex WHERE conditions

**Examples:**
```sql
-- Case-insensitive search
CREATE INDEX idx_lower_name ON users (LOWER(name));

-- Computed expression
CREATE INDEX idx_full_name ON users ((first_name || ' ' || last_name));

-- Date extraction
CREATE INDEX idx_month ON events (EXTRACT(MONTH FROM created_at));

-- String manipulation
CREATE INDEX idx_email_domain ON users (SUBSTRING(email FROM POSITION('@' IN email) + 1));

-- Coalesce (handle NULLs)
CREATE INDEX idx_coalesce ON products (COALESCE(sku, 'default'));
```

**When to Use:**
- Frequently query with functions on indexed columns
- Need case-insensitive search
- Query computed expressions
- Pattern matching with transforms

**When to Avoid:**
- When you can query the raw column instead (simpler)
- When the expression is complex and rarely used

**Important:** The query must use the exact same expression for the index to be used.

---

### Covering Indexes (INCLUDE Clause)

Include non-key columns in the index for index-only scans (PostgreSQL 11+).

**Benefits:**
- Avoid table access (index-only scans)
- No table lookups for included columns
- Smaller than full index on all columns
- Performance improvement for common queries

**Use Cases:**
- Queries that need a few columns from filtered rows
- SELECT statements with limited columns
- Reducing I/O for frequent queries

**Examples:**
```sql
-- Basic covering index
CREATE INDEX idx_order_status_covering ON orders (status) 
INCLUDE (customer_id, total, created_at);

-- Query benefits:
SELECT customer_id, total, created_at 
FROM orders 
WHERE status = 'completed';

-- Multiple conditions with included columns
CREATE INDEX idx_user_created ON events (user_id, created_at) 
INCLUDE (event_type, data);

-- Query benefits:
SELECT user_id, created_at, event_type, data 
FROM events 
WHERE user_id = 123 AND created_at >= '2024-01-01';
```

**When to Use:**
- Frequently SELECT specific columns after filtering
- Queries that don't need all columns
- Want to eliminate table lookups for hot queries
- Common query patterns

**When to Avoid:**
- When you need many columns (index becomes large)
- When queries vary significantly in selected columns
- When table is small (not worth the overhead)

**Important:** Included columns cannot be used for filtering or sorting. They're only for retrieval.

---

### Concurrent Index Creation

Build indexes without blocking writes to the table (PostgreSQL 8.2+).

**Benefits:**
- No write locks during index creation
- Application continues working
- Essential for production systems

**Trade-offs:**
- Takes longer than regular index creation
- Cannot be used in a transaction
- If failed, leaves invalid index that must be cleaned up

**Use Cases:**
- Production deployments
- Large tables
- High-traffic systems
- Zero-downtime migrations

**Examples:**
```sql
-- Basic concurrent index
CREATE INDEX CONCURRENTLY idx_email ON users (email);

-- Concurrent unique index
CREATE UNIQUE INDEX CONCURRENTLY idx_email ON users (email);

-- Concurrent partial index
CREATE INDEX CONCURRENTLY idx_active_users ON users (email) WHERE is_active = true;

-- Clean up failed concurrent index
DROP INDEX CONCURRENTLY IF EXISTS idx_email;
```

**When to Use:**
- Production environments
- Anytime writes cannot be blocked
- Large tables (indexing takes time)
- Critical applications

**When to Avoid:**
- Development/testing (use regular CREATE INDEX for speed)
- Small tables where creation is instant
- Within a transaction block

**Important:** 
- Must be run outside transactions
- Requires more time than regular creation
- If it fails, you must clean up manually

---

### Multicolumn Indexes

Index on multiple columns to optimize queries filtering on multiple conditions.

**Benefits:**
- Optimize queries with multiple WHERE conditions
- Single index instead of multiple single-column indexes
- Better performance for specific query patterns

**Use Cases:**
- Queries filtering on multiple columns
- Composite business keys
- Specific query patterns

**Examples:**
```sql
-- Basic multicolumn index
CREATE INDEX idx_name_email ON users (name, email);

-- Benefits:
WHERE name = 'John'
WHERE name = 'John' AND email = 'john@example.com'
WHERE name LIKE 'J%' AND email LIKE 'john%'

-- Does NOT help:
WHERE email = 'john@example.com' (leftmost prefix rule)

-- Three columns
CREATE INDEX idx_customer_status_created ON orders (customer_id, status, created_at);

-- Benefits all these:
WHERE customer_id = 123
WHERE customer_id = 123 AND status = 'pending'
WHERE customer_id = 123 AND status = 'pending' AND created_at > '2024-01-01'

-- Does NOT help:
WHERE status = 'pending'
WHERE status = 'pending' AND created_at > '2024-01-01'
```

**When to Use:**
- Frequently query with multiple columns together
- The same combination appears in many queries
- Want to optimize specific query patterns

**When to Avoid:**
- When columns are queried independently
- When query patterns vary significantly
- When index becomes too wide (many columns)

**Best Practices:**
- Put most selective column first (most unique values)
- Put most commonly filtered column first
- Consider query patterns (what's always present?)
- Don't create more than 3-4 columns per index

**Leftmost Prefix Rule:** A multicolumn index (A, B, C) supports queries on A, (A, B), and (A, B, C), but NOT B, C, or (B, C).

---

### Cluster

Reorder the physical table storage based on index order.

**Benefits:**
- Improves sequential scan performance
- Better locality for range queries
- Can significantly speed up certain queries

**Trade-offs:**
- Takes time to complete (locks table)
- Performance degrades over time as table is updated
- Requires maintenance (re-cluster periodically)

**Use Cases:**
- Tables where data is mostly static
- Frequent range queries on ordered data
- Reports/analytical queries

**Examples:**
```sql
-- Cluster table by index
CLUSTER orders USING idx_customer_created;

-- Cluster verbose (shows progress)
CLUSTER VERBOSE users USING idx_name;

-- Re-cluster after updates
CLUSTER orders USING idx_customer_created;

-- Analyze after clustering
ANALYZE orders;
```

**When to Use:**
- Mostly static tables
- Frequent range scans on ordered data
- When query performance is critical
- Can afford downtime for clustering

**When to Avoid:**
- Highly dynamic tables (frequent updates/inserts)
- When data is frequently changing
- When you can't afford table locks
- When benefit doesn't outweigh cost

**Important:** 
- Locks the table during operation
- Must run ANALYZE after clustering
- Performance degrades with updates
- Consider automatic maintenance for re-clustering

---

### Fillfactor

Control how much space is reserved in index pages for updates (works for both indexes and tables).

**Benefits:**
- Reduces page splits during updates
- Lower index maintenance overhead
- Better performance for write-heavy workloads

**Trade-offs:**
- Larger index size (unused space)
- Slower scans (more pages to read)

**Use Cases:**
- Frequently updated tables/indexes
- High write throughput
- When reducing page splits is important

**Examples:**
```sql
-- High fillfactor (read-heavy, rare updates)
CREATE INDEX idx_name ON users (name) WITH (fillfactor = 100);

-- Medium fillfactor (moderate updates)
CREATE INDEX idx_email ON users (email) WITH (fillfactor = 90);

-- Low fillfactor (heavy updates)
CREATE INDEX idx_updated_at ON products (updated_at) WITH (fillfactor = 70);

-- Table fillfactor (for heaps)
ALTER TABLE users SET (fillfactor = 70);

-- Multicolumn with fillfactor
CREATE INDEX idx_name_email ON users (name, email) WITH (fillfactor = 85);
```

**When to Use:**
- Tables with frequent updates
- High write workloads
- When index maintenance is expensive
- Want to reduce page splits

**When to Avoid:**
- Read-only tables (use 100)
- Storage is expensive
- Query performance is more important than write performance

**Recommended Values:**
- `fillfactor = 100`: Read-only or rarely updated data
- `fillfactor = 90-95`: Moderate updates
- `fillfactor = 70-85`: Heavy updates, high write throughput

**Important:** Lower fillfactor means larger indexes but better write performance.

---

### NULLS DISTINCT / NULLS NOT DISTINCT

Control how NULLs are handled in unique indexes (PostgreSQL 15+).

**Benefits:**
- Enforce uniqueness including NULL values
- Customize uniqueness semantics
- Better control over data constraints

**Use Cases:**
- When NULL should be treated as a value for uniqueness
- Phone numbers, optional unique fields
- Custom business rules

**Examples:**
```sql
-- Default behavior (NULLs are distinct, multiple NULLs allowed)
CREATE UNIQUE INDEX idx_email ON users (email);
-- Allows: ('john@example.com', 'jane@example.com', NULL, NULL)

-- Treat NULLs as not distinct (only one NULL allowed)
CREATE UNIQUE INDEX idx_phone ON users (phone) NULLS NOT DISTINCT;
-- Allows: ('555-1234', '555-5678', NULL)
-- Prevents: ('555-1234', '555-1234', NULL, NULL)

-- Partial with NULL handling
CREATE UNIQUE INDEX idx_active_email ON users (email) 
WHERE is_active = true 
NULLS NOT DISTINCT;

-- Multiple columns
CREATE UNIQUE INDEX idx_name_email ON users (name, email) 
NULLS NOT DISTINCT;
```

**When to Use:**
- Want to enforce uniqueness on optional fields
- When NULL should be treated as a value
- Business rules require single NULL
- Custom uniqueness semantics

**When to Avoid:**
- When multiple NULLs should be allowed (default)
- When using PostgreSQL < 15 (not available)
- When you want standard SQL NULL behavior

**Important:** Only available in PostgreSQL 15 and later.

---

### Descending Indexes

Support descending order in indexes (PostgreSQL 8.3+).

**Benefits:**
- Optimize queries with ORDER BY DESC
- Support mixed ascending/descending sorts
- Better performance for specific sort orders

**Use Cases:**
- Queries with ORDER BY column_name DESC
- Mixed sort orders
- Frequently accessed sorted views

**Examples:**
```sql
-- Simple descending index
CREATE INDEX idx_created_desc ON events (created_at DESC);

-- Benefits:
SELECT * FROM events ORDER BY created_at DESC LIMIT 10;

-- Mixed ascending/descending
CREATE INDEX idx_status_created ON orders (status ASC, created_at DESC);

-- Benefits:
SELECT * FROM orders ORDER BY status ASC, created_at DESC;

-- Partial descending
CREATE INDEX idx_active_created ON users (created_at DESC) 
WHERE is_active = true;

-- Multicolumn with mixed order
CREATE INDEX idx_price_rating_desc ON products (price ASC, rating DESC);
```

**When to Use:**
- Frequent queries with ORDER BY DESC
- Mixed sort orders in same query
- Need to optimize specific sort patterns
- When sort order is consistent

**When to Avoid:**
- When sort order varies
- When data size is small
- When sorting is infrequent

**Important:** The index order must match the query's ORDER BY for it to be used.

---

### Parallel Index Creation

Build indexes using parallel workers (PostgreSQL 11+).

**Benefits:**
- Faster index creation on large tables
- Utilizes multiple CPU cores
- Reduced index creation time

**Trade-offs:**
- Higher CPU usage during creation
- More memory consumption
- Requires configuration tuning

**Use Cases:**
- Large tables (millions+ rows)
- Index creation time is critical
- Sufficient CPU resources available

**Examples:**
```sql
-- Set parallel workers
SET max_parallel_maintenance_workers = 4;
SET maintenance_work_mem = '1GB';

-- Create index (uses parallel workers)
CREATE INDEX idx_large_column ON large_table (column);

-- Set at session level
SET LOCAL max_parallel_maintenance_workers = 8;
SET LOCAL maintenance_work_mem = '2GB';

-- Create multiple indexes in parallel (requires multiple sessions)
-- Session 1:
CREATE INDEX CONCURRENTLY idx_1 ON large_table (column1);

-- Session 2:
CREATE INDEX CONCURRENTLY idx_2 ON large_table (column2);
```

**When to Use:**
- Creating indexes on large tables
- Have spare CPU capacity
- Want to minimize maintenance windows
- Index creation is time-sensitive

**When to Avoid:**
- Small tables (overhead not worth it)
- CPU is already at capacity
- Creating indexes on production during peak hours
- Limited memory available

**Configuration:**
```sql
-- Show current settings
SHOW max_parallel_maintenance_workers;
SHOW maintenance_work_mem;

-- Recommended settings for parallel index creation:
SET max_parallel_maintenance_workers = 4; -- Adjust based on CPU cores
SET maintenance_work_mem = '1GB'; -- Larger = faster, more memory
```

**Important:** 
- Works best with `maintenance_work_mem` set appropriately
- Number of workers should not exceed CPU cores
- Monitor CPU and memory during creation

---

## Additional Notes

### Index Maintenance

```sql
-- Reindex an index
REINDEX INDEX idx_name;

-- Reindex all indexes on a table
REINDEX TABLE users;

-- Reindex concurrently (PostgreSQL 12+)
REINDEX INDEX CONCURRENTLY idx_name;

-- Analyze after index changes
ANALYZE users;
```

### Monitoring Index Usage

```sql
-- Check index usage statistics
SELECT schemaname, tablename, indexname, idx_scan, idx_tup_read, idx_tup_fetch
FROM pg_stat_user_indexes
ORDER BY idx_scan DESC;

-- Find unused indexes
SELECT schemaname, tablename, indexname
FROM pg_stat_user_indexes
WHERE idx_scan = 0
AND indexname NOT LIKE '%_pkey';

-- Index size
SELECT pg_size_pretty(pg_relation_size('idx_name'));
```

### Common Pitfalls

1. **Too many indexes:** Each index slows down writes
2. **Unused indexes:** Waste space and maintenance time
3. **Duplicate indexes:** Multiple indexes on same columns
4. **Wrong index type:** Using GIN when B-Tree would work
5. **Ignoring partial indexes:** Missing optimization opportunities
6. **Not analyzing:** Query planner needs statistics

### Best Practices

1. Start with B-Tree, specialize when needed
2. Use partial indexes for common query filters
3. Consider covering indexes for frequent queries
4. Use CONCURRENTLY in production
5. Monitor index usage regularly
6. Remove unused indexes
7. Analyze tables after index changes
8. Test query performance before/after indexing

---

**Last Updated:** 2026-06-14