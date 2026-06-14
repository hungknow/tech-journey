# SQLite Index Guide

## Table of Contents

### [Use Cases](#use-cases)
- [Primary Key and Unique Constraints](#1-primary-key-and-unique-constraints)
- [Range Queries and Sorting](#2-range-queries-and-sorting)
- [Full-Text Search](#3-full-text-search)
- [Prefix Searches and LIKE Queries](#4-prefix-searches-and-like-queries)
- [Case-Insensitive Search](#5-case-insensitive-search)
- [Soft-Delete Pattern](#6-soft-delete-pattern)
- [Multi-Column Filtering](#7-multi-column-filtering)
- [Skewed Boolean Distribution](#8-skewed-boolean-distribution)
- [Efficient Lookup on Large Tables](#9-efficient-lookup-on-large-tables)
- [Rowid Optimization](#10-rowid-optimization)
- [WITHOUT ROWID Tables](#11-without-rowid-tables)
- [Array Operations](#12-array-operations)
- [JSON Queries](#13-json-queries)
- [Geospatial Data](#14-geospatial-data)
- [Large Time-Series Tables](#15-large-time-series-tables)
- [Text Pattern Matching](#16-text-pattern-matching)
- [Index-Only Scans](#17-index-only-scans)
- [Membership Testing with Multiple Columns](#18-membership-testing-with-multiple-columns)

### [Index Types](#index-types)
- [B-Tree](#b-tree)
- [R-Tree (Spatial Index)](#r-tree-spatial-index)
- [Full-Text Search (FTS)](#full-text-search-fts)

### [Index Features](#index-features)
- [Unique Indexes](#unique-indexes)
- [Partial Indexes](#partial-indexes)
- [Expression Indexes](#expression-indexes)
- [Multicolumn Indexes](#multicolumn-indexes)
- [Descending Indexes](#descending-indexes)
- [Collation-Based Indexes](#collation-based-indexes)
- [WITHOUT ROWID Tables](#without-rowid-tables-1)
- [Partial Index with DESC](#partial-index-with-desc)

---

## Use Cases

### 1. Primary Key and Unique Constraints

**Recommended Index:** B-Tree (automatic)

**Why:** SQLite automatically creates B-Tree indexes for PRIMARY KEY and UNIQUE constraints. B-Tree provides excellent performance for equality and range queries and is SQLite's only built-in index type.

```sql
CREATE TABLE users (
  id INTEGER PRIMARY KEY,
  email TEXT UNIQUE NOT NULL,
  username TEXT UNIQUE
);

-- Automatically creates B-Tree indexes on id (rowid) and email
```

**Use with Unique Feature:** When you need to enforce uniqueness across specific row subsets.

```sql
CREATE TABLE users (
  id INTEGER PRIMARY KEY,
  email TEXT NOT NULL,
  is_active INTEGER DEFAULT 1
);

CREATE UNIQUE INDEX idx_active_email ON users (email) WHERE is_active = 1;
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

**Use with Descending Feature:** For queries with DESC order.

```sql
CREATE INDEX idx_created_desc ON orders (created_at DESC);

-- Optimizes:
SELECT * FROM orders ORDER BY created_at DESC LIMIT 10;
```

### 3. Full-Text Search

**Recommended Index:** FTS (Full-Text Search) Tables

**Why:** SQLite's FTS extension provides full-text search capabilities with powerful features like tokenization, ranking, and phrase searches.

```sql
CREATE VIRTUAL TABLE articles_fts USING fts5(
  title,
  content,
  content='articles',
  content_rowid='id'
);

CREATE TABLE articles (
  id INTEGER PRIMARY KEY,
  title TEXT NOT NULL,
  content TEXT NOT NULL
);

-- Benefits queries like:
SELECT articles.* 
FROM articles
JOIN articles_fts ON articles.id = articles_fts.rowid
WHERE articles_fts MATCH 'sqlite INDEX';

-- Phrase search:
SELECT articles.* 
FROM articles
JOIN articles_fts ON articles.id = articles_fts.rowid
WHERE articles_fts MATCH '"database index"';
```

### 4. Prefix Searches and LIKE Queries

**Recommended Index:** B-Tree with NOCASE collation

**Why:** B-Tree indexes can optimize LIKE queries when the pattern starts with a constant prefix (no leading wildcards).

```sql
CREATE INDEX idx_name ON users (name);

-- Benefits queries like:
SELECT * FROM users WHERE name LIKE 'John%';
SELECT * FROM users WHERE name LIKE 'John%';

-- Does NOT help:
SELECT * FROM users WHERE name LIKE '%John';
SELECT * FROM users WHERE name LIKE '%John%';
```

**Use with Collation Feature:** For case-insensitive prefix search.

```sql
CREATE INDEX idx_name_nocase ON users (name COLLATE NOCASE);

-- Benefits case-insensitive queries:
SELECT * FROM users WHERE name LIKE 'john%' COLLATE NOCASE;
```

### 5. Case-Insensitive Search

**Recommended Index:** B-Tree with NOCASE collation

**Why:** SQLite supports collation sequences like NOCASE that enable case-insensitive comparisons without needing function calls.

```sql
CREATE INDEX idx_email_nocase ON users (email COLLATE NOCASE);

-- Benefits queries like:
SELECT * FROM users WHERE email = 'USER@EXAMPLE.COM' COLLATE NOCASE;

-- Use with Unique Feature:
CREATE UNIQUE INDEX idx_unique_email_nocase ON users (email COLLATE NOCASE);
```

**Alternative:** Expression index with LOWER() function.

```sql
CREATE INDEX idx_lower_email ON users (LOWER(email));

-- Benefits:
SELECT * FROM users WHERE LOWER(email) = LOWER('USER@EXAMPLE.COM');
```

### 6. Soft-Delete Pattern

**Recommended Index:** Partial B-Tree

**Why:** Partial indexes exclude deleted rows, reducing index size and improving query performance for active records.

```sql
CREATE TABLE users (
  id INTEGER PRIMARY KEY,
  email TEXT NOT NULL,
  deleted_at INTEGER
);

CREATE INDEX idx_active_email ON users (email) WHERE deleted_at IS NULL;

-- Benefits queries like:
SELECT * FROM users WHERE email = 'user@example.com' AND deleted_at IS NULL;
```

### 7. Multi-Column Filtering

**Recommended Index:** Multicolumn B-Tree

**Why:** Indexes on multiple columns optimize queries filtering on multiple conditions simultaneously.

```sql
CREATE TABLE orders (
  id INTEGER PRIMARY KEY,
  customer_id INTEGER NOT NULL,
  status TEXT NOT NULL,
  created_at INTEGER NOT NULL
);

CREATE INDEX idx_customer_status ON orders (customer_id, status);

-- Benefits queries like:
SELECT * FROM orders 
WHERE customer_id = 123 AND status = 'pending';

-- Also benefits queries on customer_id alone (leftmost prefix):
SELECT * FROM orders WHERE customer_id = 123;
```

### 8. Skewed Boolean Distribution

**Recommended Index:** Partial B-Tree

**Why:** When 99% of rows have the same boolean value, a partial index on the rare value is much smaller and faster.

```sql
CREATE TABLE users (
  id INTEGER PRIMARY KEY,
  email TEXT NOT NULL,
  is_admin INTEGER DEFAULT 0
);

CREATE INDEX idx_admins ON users (email) WHERE is_admin = 1;

-- Benefits queries filtering for admins (rare case):
SELECT * FROM users WHERE is_admin = 1;
```

### 9. Efficient Lookup on Large Tables

**Recommended Index:** INTEGER PRIMARY KEY (rowid)

**Why:** SQLite's B-Tree storage engine uses rowid as the primary key by default, which provides O(1) lookups for INTEGER PRIMARY KEY columns.

```sql
CREATE TABLE users (
  id INTEGER PRIMARY KEY,
  name TEXT NOT NULL,
  email TEXT NOT NULL
);

-- Efficient lookups:
SELECT * FROM users WHERE id = 123;
```

**Alternative:** Use WITHOUT ROWID for better clustering.

```sql
CREATE TABLE users (
  id INTEGER PRIMARY KEY,
  name TEXT NOT NULL,
  email TEXT NOT NULL
) WITHOUT ROWID;

-- Better performance for range queries and clustering
```

### 10. Rowid Optimization

**Recommended Index:** Leverage implicit rowid

**Why:** Every SQLite table has an implicit 64-bit signed integer rowid (unless WITHOUT ROWID is used), which can be used for efficient lookups.

```sql
CREATE TABLE items (
  name TEXT NOT NULL,
  price REAL NOT NULL
);

-- Implicit rowid is automatically indexed
SELECT * FROM items WHERE rowid = 42;

-- Get rowid after INSERT
INSERT INTO items (name, price) VALUES ('Widget', 9.99);
SELECT last_insert_rowid();
```

### 11. WITHOUT ROWID Tables

**Recommended Feature:** WITHOUT ROWID

**Why:** WITHOUT ROWID tables use the primary key as the physical storage order, which can improve performance for certain queries and reduce storage space.

```sql
CREATE TABLE products (
  id INTEGER PRIMARY KEY,
  name TEXT NOT NULL,
  category TEXT NOT NULL,
  price REAL NOT NULL
) WITHOUT ROWID;

-- Benefits:
-- - Reduced storage (no separate rowid)
-- - Better clustering on primary key
-- - Faster primary key lookups
-- - Better cache locality

CREATE INDEX idx_category ON products (category);
```

### 12. Array Operations

**Recommended Index:** B-Tree with JSON or expression index

**Why:** SQLite doesn't have native array types like PostgreSQL, but you can use JSON, comma-separated strings, or separate tables with foreign keys.

**Option 1: JSON arrays**

```sql
CREATE TABLE posts (
  id INTEGER PRIMARY KEY,
  title TEXT NOT NULL,
  tags JSON NOT NULL
);

CREATE INDEX idx_tags ON posts (tags);

-- Query for posts with specific tag
SELECT * FROM posts 
WHERE json_extract(tags, '$') LIKE '%"database"%';

-- More efficient with expression index on extracted values
CREATE INDEX idx_tag_values ON posts (json_each.value);
```

**Option 2: Comma-separated strings (limited)**

```sql
CREATE TABLE posts (
  id INTEGER PRIMARY KEY,
  title TEXT NOT NULL,
  tags TEXT NOT NULL
);

-- Only works for prefix searches
CREATE INDEX idx_tags ON posts (tags);

-- Efficient:
SELECT * FROM posts WHERE tags LIKE 'database%';

-- Inefficient:
SELECT * FROM posts WHERE tags LIKE '%database%';
```

**Option 3: Junction table (recommended)**

```sql
CREATE TABLE posts (
  id INTEGER PRIMARY KEY,
  title TEXT NOT NULL
);

CREATE TABLE tags (
  id INTEGER PRIMARY KEY,
  name TEXT NOT NULL UNIQUE
);

CREATE TABLE post_tags (
  post_id INTEGER NOT NULL,
  tag_id INTEGER NOT NULL,
  PRIMARY KEY (post_id, tag_id),
  FOREIGN KEY (post_id) REFERENCES posts(id),
  FOREIGN KEY (tag_id) REFERENCES tags(id)
);

CREATE INDEX idx_post_tags_post ON post_tags (post_id);
CREATE INDEX idx_post_tags_tag ON post_tags (tag_id);

-- Efficient queries:
SELECT p.* 
FROM posts p
JOIN post_tags pt ON p.id = pt.post_id
JOIN tags t ON pt.tag_id = t.id
WHERE t.name = 'database';

-- Multiple tags:
SELECT p.*
FROM posts p
WHERE p.id IN (
  SELECT pt1.post_id
  FROM post_tags pt1
  JOIN tags t1 ON pt1.tag_id = t1.id
  WHERE t1.name = 'database'
) AND p.id IN (
  SELECT pt2.post_id
  FROM post_tags pt2
  JOIN tags t2 ON pt2.tag_id = t2.id
  WHERE t2.name = 'sql'
);
```

**When to Use:**
- Need flexible tagging or categorization
- Query by array elements frequently
- Want efficient array operations

**Recommended Approach:** Use junction table for best performance and flexibility. JSON for simple use cases or when you need document-style storage.

---

### 13. JSON Queries

**Recommended Index:** B-Tree with expression index or GIN-like pattern

**Why:** SQLite has built-in JSON support with functions to extract and query JSON data. You can create expression indexes on JSON paths.

```sql
CREATE TABLE products (
  id INTEGER PRIMARY KEY,
  name TEXT NOT NULL,
  metadata JSON NOT NULL
);

-- Index on specific JSON path
CREATE INDEX idx_metadata_category ON products (
  json_extract(metadata, '$.category')
);

-- Benefits queries:
SELECT * FROM products 
WHERE json_extract(metadata, '$.category') = 'electronics';

-- Index on JSON array element
CREATE INDEX idx_tags_array ON products (
  json_extract(metadata, '$.tags[0]')
);

-- Index on JSON object existence
CREATE INDEX idx_has_stock ON products (
  json_extract(metadata, '$.stock')
);

-- Benefits queries:
SELECT * FROM products 
WHERE json_extract(metadata, '$.stock') = 'true';

-- Full JSON indexing (limited)
CREATE INDEX idx_metadata_full ON products (metadata);

-- Only helps with exact matches or prefix searches on the JSON string
SELECT * FROM products WHERE metadata = '{"category": "electronics"}';
```

**Advanced: JSON path expressions**

```sql
-- Index nested values
CREATE INDEX idx_price ON products (
  json_extract(metadata, '$.pricing.amount')
);

-- Benefits queries:
SELECT * FROM products 
WHERE json_extract(metadata, '$.pricing.amount') > 100;

-- Index on computed JSON value
CREATE INDEX idx_discounted_price ON products (
  CAST(json_extract(metadata, '$.price') AS REAL) * (1 - CAST(json_extract(metadata, '$.discount') AS REAL))
);

-- Benefits:
SELECT * FROM products 
WHERE CAST(json_extract(metadata, '$.price') AS REAL) * (1 - CAST(json_extract(metadata, '$.discount') AS REAL)) < 50;
```

**When to Use:**
- Store structured data as JSON
- Query JSON fields frequently
- Need flexible schema
- Migrating from document databases

**When to Avoid:**
- When relational schema is simpler and more efficient
- When you need complex JSON array operations
- When JSON is only stored, not queried

**Important:**
- SQLite doesn't have PostgreSQL's JSONB or GIN indexes
- Expression indexes must match exact query pattern
- Consider denormalizing frequently queried JSON fields to separate columns

---

### 14. Geospatial Data

**Recommended Index:** R-Tree extension

**Why:** SQLite's R-Tree extension provides spatial indexing for 2D and 3D geometric operations, similar to PostgreSQL's PostGIS with GiST indexes.

```sql
-- Enable R*Tree extension
.load librtree

-- Create R*Tree index
CREATE VIRTUAL TABLE locations USING rtree(
  id,
  minX, maxX,
  minY, maxY
);

-- Insert spatial data
INSERT INTO locations VALUES(1, -80.0, -79.0, 35.0, 36.0);
INSERT INTO locations VALUES(2, -78.5, -78.0, 34.5, 35.0);

-- Join with data table
CREATE TABLE landmarks (
  id INTEGER PRIMARY KEY,
  name TEXT NOT NULL,
  x REAL NOT NULL,
  y REAL NOT NULL
);

-- Query landmarks within a bounding box
SELECT landmarks.*
FROM landmarks, locations
WHERE landmarks.x >= locations.minX 
  AND landmarks.x <= locations.maxX
  AND landmarks.y >= locations.minY 
  AND landmarks.y <= locations.maxY
  AND locations.id = 1;

-- Find overlapping rectangles
SELECT l1.id, l2.id
FROM locations l1, locations l2
WHERE l1.maxX > l2.minX 
  AND l1.minX < l2.maxX 
  AND l1.maxY > l2.minY 
  AND l1.minY < l2.maxY 
  AND l1.id < l2.id;
```

**Use with Partial Index:** Index only active locations.

```sql
CREATE TABLE locations_data (
  id INTEGER PRIMARY KEY,
  name TEXT NOT NULL,
  minX REAL NOT NULL,
  maxX REAL NOT NULL,
  minY REAL NOT NULL,
  maxY REAL NOT NULL,
  is_active INTEGER DEFAULT 1
);

-- R*Tree doesn't support partial indexes directly
-- Use separate tables or application-level filtering
CREATE VIRTUAL TABLE active_locations USING rtree(
  id,
  minX, maxX,
  minY, maxY
);

-- Maintain active_locations via triggers or application logic
```

**When to Use:**
- Working with geographic or spatial data
- Need to find objects within a bounding box
- Building mapping or location-based applications
- Spatial queries on 2D/3D coordinates

**When to Avoid:**
- When data is not spatial
- When you only need simple distance calculations
- When R*Tree extension is not available

**Important:**
- Requires the R*Tree extension to be loaded
- Supports 2D and 3D coordinate systems
- Designed for efficient range queries on spatial data
- Less feature-rich than PostgreSQL's PostGIS

---

### 15. Large Time-Series Tables

**Recommended Index:** B-Tree on timestamp (or WITHOUT ROWID for clustering)

**Why:** SQLite doesn't have BRIN indexes like PostgreSQL, but you can use B-Tree indexes optimized for time-series data with appropriate indexing strategies.

```sql
CREATE TABLE events (
  id INTEGER PRIMARY KEY,
  created_at INTEGER NOT NULL, -- Store as Unix timestamp
  event_type TEXT NOT NULL,
  data JSON
);

CREATE INDEX idx_created_at ON events (created_at);

-- Benefits queries scanning time ranges:
SELECT * FROM events 
WHERE created_at >= strftime('%s', '2024-01-01') 
  AND created_at <= strftime('%s', '2024-01-31');

-- More efficient with WITHOUT ROWID for clustering
CREATE TABLE events (
  id INTEGER PRIMARY KEY,
  created_at INTEGER NOT NULL,
  event_type TEXT NOT NULL,
  data JSON
) WITHOUT ROWID;

CREATE INDEX idx_created_at ON events (created_at);
```

**Partitioning Strategy:** Use separate tables for time periods.

```sql
-- Monthly tables for large datasets
CREATE TABLE events_2024_01 (
  id INTEGER PRIMARY KEY,
  created_at INTEGER NOT NULL,
  event_type TEXT NOT NULL,
  data JSON
) WITHOUT ROWID;

CREATE TABLE events_2024_02 (
  id INTEGER PRIMARY KEY,
  created_at INTEGER NOT NULL,
  event_type TEXT NOT NULL,
  data JSON
) WITHOUT ROWID;

-- Query specific month
SELECT * FROM events_2024_01 
WHERE created_at BETWEEN strftime('%s', '2024-01-01') AND strftime('%s', '2024-01-31');

-- Union query across months
SELECT * FROM events_2024_01 WHERE created_at >= strftime('%s', '2024-01-15')
UNION ALL
SELECT * FROM events_2024_02 WHERE created_at <= strftime('%s', '2024-02-15');
```

**Use with Partial Index:** Index only recent data.

```sql
CREATE INDEX idx_recent_events ON events (created_at) 
WHERE created_at >= strftime('%s', 'now') - 31536000; -- 1 year ago

-- Benefits queries on recent data:
SELECT * FROM events 
WHERE created_at >= strftime('%s', 'now') - 86400 -- 1 day ago
ORDER BY created_at DESC;
```

**When to Use:**
- Large time-series datasets (millions+ rows)
- Data is naturally ordered by timestamp
- Queries typically scan time ranges
- Storage space is a concern

**When to Avoid:**
- Small or medium-sized tables
- Randomly distributed timestamps
- When BRIN is needed (SQLite doesn't have it)

**Performance Note:** SQLite doesn't have BRIN, so for very large tables, consider partitioning by time or using WITHOUT ROWID for better clustering.

---

### 16. Text Pattern Matching

**Recommended Index:** B-Tree with LIKE prefix searches or FTS5

**Why:** SQLite B-Tree indexes can optimize LIKE queries when the pattern starts with a constant prefix (no leading wildcards). For complex pattern matching, use FTS5.

**Option 1: LIKE prefix searches**

```sql
CREATE INDEX idx_name ON users (name);

-- Benefits queries like:
SELECT * FROM users WHERE name LIKE 'John%';
SELECT * FROM users WHERE name LIKE 'John%';

-- Does NOT help:
SELECT * FROM users WHERE name LIKE '%John';
SELECT * FROM users WHERE name LIKE '%John%';

-- Case-insensitive prefix
CREATE INDEX idx_name_nocase ON users (name COLLATE NOCASE);

SELECT * FROM users WHERE name LIKE 'john%' COLLATE NOCASE;
```

**Option 2: Expression index for suffix searches**

```sql
CREATE INDEX idx_email_reverse ON users (substr(email, -(length(email) - instr(email, '@'))));

-- Benefits email domain searches:
SELECT * FROM users 
WHERE substr(email, -(length(email) - instr(email, '@'))) LIKE 'example.com%';
```

**Option 3: FTS5 for complex pattern matching**

```sql
CREATE VIRTUAL TABLE documents_fts USING fts5(
  title,
  content
);

CREATE TABLE documents (
  id INTEGER PRIMARY KEY,
  title TEXT NOT NULL,
  content TEXT NOT NULL
);

-- Populate FTS
INSERT INTO documents_fts(rowid, title, content)
SELECT id, title, content FROM documents;

-- Benefits complex searches:
SELECT documents.*
FROM documents
JOIN documents_fts ON documents.id = documents_fts.rowid
WHERE documents_fts MATCH 'document*'; -- prefix search
```

**When to Use:**
- Prefix searches (pattern%)
- Case-insensitive text search
- Simple pattern matching
- When FTS5 is overkill

**When to Avoid:**
- Leading wildcards (%pattern) - B-Tree cannot help
- Complex regex-like patterns
- When full-text search features are needed

**Important:**
- LIKE only uses index with prefix patterns
- Leading wildcards prevent index usage
- Use FTS5 for advanced text search capabilities

---

### 17. Index-Only Scans

**Recommended Index:** B-Tree (implicit covering)

**Why:** SQLite can perform index-only scans when all columns needed are in the index, similar to PostgreSQL's INCLUDE clause but implicit.

```sql
CREATE TABLE orders (
  id INTEGER PRIMARY KEY,
  customer_id INTEGER NOT NULL,
  status TEXT NOT NULL,
  total REAL NOT NULL,
  created_at INTEGER NOT NULL
);

-- Create index with all needed columns
CREATE INDEX idx_order_status_covering ON orders (status, customer_id, total, created_at);

-- Benefits queries like:
SELECT customer_id, total, created_at 
FROM orders 
WHERE status = 'completed';

-- SQLite performs index-only scan, no table lookup needed
```

**Multiple query patterns:**

```sql
-- Index for different query patterns
CREATE INDEX idx_customer_status ON orders (customer_id, status, total);

-- Query 1: Index-only scan
SELECT customer_id, status, total 
FROM orders 
WHERE customer_id = 123 AND status = 'pending';

-- Query 2: Index-only scan
SELECT customer_id, status, total 
FROM orders 
WHERE customer_id = 123;
```

**Performance Benefits:**
- Avoids table access
- No row lookups for covered columns
- Reduced I/O
- Faster query execution

**When to Use:**
- Frequently SELECT specific columns after filtering
- Queries that don't need all columns
- Want to eliminate table lookups for hot queries
- Common query patterns

**When to Avoid:**
- When you need many columns (index becomes large)
- When queries vary significantly in selected columns
- When table is small (not worth the overhead)

**Important:**
- SQLite doesn't have explicit INCLUDE clause like PostgreSQL
- All indexed columns are "included"
- Covering happens implicitly when query only uses indexed columns
- Use EXPLAIN QUERY PLAN to verify index-only scans

---

### 18. Membership Testing with Multiple Columns

**Recommended Index:** Multicolumn B-Tree (SQLite doesn't have Bloom)

**Why:** SQLite doesn't have probabilistic indexes like PostgreSQL's Bloom, but multicolumn B-Tree indexes can optimize membership testing across multiple columns.

```sql
CREATE TABLE products (
  id INTEGER PRIMARY KEY,
  category TEXT NOT NULL,
  brand TEXT NOT NULL,
  color TEXT NOT NULL
);

-- Multicolumn index for combined filters
CREATE INDEX idx_category_brand_color ON products (category, brand, color);

-- Benefits queries like:
SELECT * FROM products 
WHERE category = 'electronics' AND brand = 'Apple' AND color = 'black';

-- Also benefits partial matches (leftmost prefix):
SELECT * FROM products WHERE category = 'electronics';
SELECT * FROM products WHERE category = 'electronics' AND brand = 'Apple';
```

**Alternative: Separate indexes with query planner optimization**

```sql
-- Individual indexes
CREATE INDEX idx_category ON products (category);
CREATE INDEX idx_brand ON products (brand);
CREATE INDEX idx_color ON products (color);

-- Query planner may use index intersection
SELECT * FROM products 
WHERE category = 'electronics' AND brand = 'Apple' AND color = 'black';
```

**When to Use:**
- Need to filter on multiple columns simultaneously
- The same combination appears in many queries
- Want to optimize specific query patterns

**When to Avoid:**
- When columns are queried independently
- When query patterns vary significantly
- When index becomes too wide (many columns)

**Important:**
- SQLite doesn't have Bloom indexes
- Use multicolumn B-Tree for multi-column filtering
- Leftmost prefix rule applies
- Query planner can use index intersection with separate indexes

---

## Index Types

### B-Tree

**SQLite's only built-in index type** and default option for all indexing needs.

**Supports:**
- Equality operators: `=`, `!=`, `<>`, `IS`, `IS NOT`
- Range operators: `<`, `>`, `<=`, `>=`, `BETWEEN`
- Pattern matching: `LIKE` (prefix only), `GLOB`, `REGEXP` (with extensions)
- Sorting: `ORDER BY`, `GROUP BY`
- NULL handling

**Best For:**
- Primary keys and unique constraints
- Range queries
- Sorting operations
- All general-purpose indexing needs

**Example:**
```sql
-- Basic B-Tree index
CREATE INDEX idx_name ON users (name);

-- Unique index
CREATE UNIQUE INDEX idx_email ON users (email);

-- Multicolumn B-Tree
CREATE INDEX idx_name_email ON users (name, email);

-- Descending order (SQLite 3.30.0+)
CREATE INDEX idx_created_desc ON events (created_at DESC);

-- With collation
CREATE INDEX idx_name_nocase ON users (name COLLATE NOCASE);
```

**When to Use:**
- Default choice for all scenarios
- When you need both equality and range queries
- When enforcing UNIQUE constraints
- When you need to support sorting

**Important:**
- B-Tree is SQLite's only built-in index type
- All other index types (R-Tree, FTS) are extensions
- Optimized for embedded, mobile, and desktop use cases
- Extremely efficient for single-user or low-concurrency scenarios

---

### R-Tree (Spatial Index)

**Extension for spatial data** that supports 2D and 3D geometric operations.

**Supports:**
- Contains: `@>` (contains)
- Contained by: `<@`
- Overlaps: `&&`
- Touches: `~`
- Distance queries

**Best For:**
- Geospatial data
- Rectangle-based queries
- 2D and 3D spatial operations
- Location-based applications

**Example:**
```sql
-- Enable R*Tree extension
.load librtree

-- Create R*Tree index
CREATE VIRTUAL TABLE locations USING rtree(
  id,
  minX, maxX,
  minY, maxY
);

-- Insert spatial data
INSERT INTO locations VALUES(1, -80.0, -79.0, 35.0, 36.0);
INSERT INTO locations VALUES(2, -78.5, -78.0, 34.5, 35.0);

-- Query overlapping rectangles
SELECT * FROM locations 
WHERE minX >= -79.5 AND maxX <= -77.5
  AND minY >= 34.0 AND maxY <= 36.0;

-- Spatial join example
CREATE TABLE landmarks (
  id INTEGER PRIMARY KEY,
  name TEXT NOT NULL,
  x REAL NOT NULL,
  y REAL NOT NULL
);

-- Query landmarks within a bounding box
SELECT landmarks.*
FROM landmarks, locations
WHERE landmarks.x >= locations.minX 
  AND landmarks.x <= locations.maxX
  AND landmarks.y >= locations.minY 
  AND landmarks.y <= locations.maxY;
```

**When to Use:**
- Working with geographic or spatial data
- Need to find objects within a bounding box
- Building mapping or location-based applications
- Spatial queries on 2D/3D coordinates

**When to Avoid:**
- When data is not spatial
- When you only need simple distance calculations
- When R*Tree extension is not available

**Important:**
- Requires the R*Tree extension to be loaded
- Supports 2D and 3D coordinate systems
- Designed for efficient range queries on spatial data
- Can be used with or WITHOUT ROWID tables

---

### Full-Text Search (FTS)

**Extension for full-text search** with powerful text search capabilities.

**Supports:**
- Token-based search: `MATCH`
- Phrase search: `"phrase"`
- Boolean operators: `AND`, `OR`, `NOT`
- Prefix searches: `prefix*`
- NEAR queries: `term1 NEAR term2`
- Ranking and scoring
- Tokenizers: unicode61, porter, simple, etc.

**Best For:**
- Document search
- Full-text search on large text columns
- Content management systems
- Search applications

**Example:**
```sql
-- Create FTS5 virtual table
CREATE VIRTUAL TABLE articles_fts USING fts5(
  title,
  content,
  tokenize='porter unicode61'
);

-- Insert data
INSERT INTO articles_fts(title, content) VALUES(
  'SQLite Index Guide',
  'SQLite supports B-Tree indexes for efficient data retrieval...'
);

-- Simple search
SELECT * FROM articles_fts 
WHERE articles_fts MATCH 'sqlite';

-- Phrase search
SELECT * FROM articles_fts 
WHERE articles_fts MATCH '"efficient data"';

-- Boolean search
SELECT * FROM articles_fts 
WHERE articles_fts MATCH 'sqlite AND (index OR indexing)';

-- Prefix search
SELECT * FROM articles_fts 
WHERE articles_fts MATCH 'eff*';

-- Ranking with bm25
SELECT *, bm25(articles_fts) as score
FROM articles_fts 
WHERE articles_fts MATCH 'database index'
ORDER BY score;

-- External content table (more common pattern)
CREATE TABLE articles (
  id INTEGER PRIMARY KEY,
  title TEXT NOT NULL,
  content TEXT NOT NULL,
  created_at INTEGER
);

CREATE VIRTUAL TABLE articles_fts USING fts5(
  title,
  content,
  content='articles',
  content_rowid='id'
);

-- Populate FTS table
INSERT INTO articles_fts(rowid, title, content)
SELECT id, title, content FROM articles;

-- Search with JOIN
SELECT articles.*
FROM articles
JOIN articles_fts ON articles.id = articles_fts.rowid
WHERE articles_fts MATCH 'sqlite index'
ORDER BY articles.created_at DESC;
```

**When to Use:**
- Need full-text search capabilities
- Searching large text documents
- Building search functionality
- When simple LIKE is insufficient

**When to Avoid:**
- When simple pattern matching suffices
- When you only need prefix searches (B-Tree with LIKE is faster)
- When text data is small

**Important:**
- Requires FTS3, FTS4, or FTS5 extension (FTS5 is recommended)
- FTS5 is the latest and most efficient version
- Supports multiple tokenizers for different languages
- Can be used with external content tables for better data management

---

## Index Features

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
CREATE UNIQUE INDEX idx_active_email ON users (email) WHERE is_active = 1;

-- Unique with collation (case-insensitive)
CREATE UNIQUE INDEX idx_email_nocase ON users (email COLLATE NOCASE);
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

### Partial Indexes

Create indexes that only include rows matching a `WHERE` clause condition (SQLite 3.8.0+).

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
CREATE INDEX idx_active_users ON users (email) WHERE is_active = 1;

-- Partial unique index
CREATE UNIQUE INDEX idx_active_email ON users (email) WHERE is_active = 1;

-- Multiple conditions
CREATE INDEX idx_priority_active ON tasks (priority) 
WHERE status = 'pending' AND is_active = 1;

-- Time-based
CREATE INDEX idx_recent ON logs (created_at) 
WHERE created_at >= strftime('%s', 'now') - 2592000; -- 30 days

-- NULL filtering
CREATE INDEX idx_valid_phone ON users (phone) WHERE phone IS NOT NULL;
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

**Important:** Available in SQLite 3.8.0 and later.

---

### Expression Indexes

Index the result of an expression or function call, not raw column values (SQLite 3.9.0+).

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
CREATE INDEX idx_full_name ON users (first_name || ' ' || last_name);

-- Date extraction (store as unix timestamp)
CREATE INDEX idx_year ON events (strftime('%Y', created_at, 'unixepoch'));

-- String manipulation
CREATE INDEX idx_email_domain ON users (
  substr(email, instr(email, '@') + 1)
);

-- Coalesce (handle NULLs)
CREATE INDEX idx_coalesce ON products (coalesce(sku, 'default'));

-- Mathematical expression
CREATE INDEX idx_discounted_price ON products (price * (1 - discount));
```

**When to Use:**
- Frequently query with functions on indexed columns
- Need case-insensitive search
- Query computed expressions
- Pattern matching with transforms

**When to Avoid:**
- When you can query the raw column instead (simpler)
- When the expression is complex and rarely used

**Important:** 
- Available in SQLite 3.9.0 and later
- The query must use the exact same expression for the index to be used
- Consider using collation (NOCASE) for case-insensitive search instead of LOWER()

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
WHERE customer_id = 123 AND status = 'pending' AND created_at > 0

-- Does NOT help:
WHERE status = 'pending'
WHERE status = 'pending' AND created_at > 0

-- With descending order
CREATE INDEX idx_status_created_desc ON orders (status, created_at DESC);
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

### Descending Indexes

Support descending order in indexes (SQLite 3.30.0+).

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
CREATE INDEX idx_status_created_desc ON orders (status ASC, created_at DESC);

-- Benefits:
SELECT * FROM orders ORDER BY status ASC, created_at DESC LIMIT 10;

-- Partial descending
CREATE INDEX idx_active_created ON users (created_at DESC) 
WHERE is_active = 1;

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

**Important:** 
- Available in SQLite 3.30.0 and later
- The index order must match the query's ORDER BY for it to be used

---

### Collation-Based Indexes

Use collation sequences for custom sorting and comparison behavior.

**Benefits:**
- Case-insensitive search without function calls
- Locale-specific sorting
- Custom comparison logic

**Use Cases:**
- Case-insensitive comparisons
- Unicode-aware text search
- Locale-specific sorting
- Custom comparison behavior

**Examples:**
```sql
-- Case-insensitive index
CREATE INDEX idx_name_nocase ON users (name COLLATE NOCASE);

-- Benefits case-insensitive queries:
SELECT * FROM users WHERE name = 'john' COLLATE NOCASE;
SELECT * FROM users WHERE name LIKE 'john%' COLLATE NOCASE;

-- Case-insensitive unique constraint
CREATE UNIQUE INDEX idx_email_nocase ON users (email COLLATE NOCASE);

-- Binary collation (case-sensitive, default)
CREATE INDEX idx_name_binary ON users (name COLLATE BINARY);

-- RTRIM collation (ignore trailing spaces)
CREATE INDEX idx_name_rtrim ON users (name COLLATE RTRIM);

-- Create custom collation
SELECT icu_load_collation('en_US', 'en_US');
CREATE INDEX idx_name_locale ON users (name COLLATE en_US);
```

**Built-in Collations:**
- `BINARY`: Case-sensitive, byte-by-byte comparison (default)
- `NOCASE`: Case-insensitive for ASCII characters
- `RTRIM`: Ignores trailing spaces

**When to Use:**
- Need case-insensitive search (NOCASE)
- Need locale-specific sorting (ICU collations)
- Need custom comparison behavior
- Want to avoid function calls for case-insensitivity

**When to Avoid:**
- When default binary comparison is sufficient
- When you need full Unicode case-insensitivity (use LOWER())

**Important:**
- NOCASE only works for ASCII characters (A-Z, a-z)
- For full Unicode case-insensitivity, use LOWER() in expression index
- ICU collations require the ICU extension to be loaded

---

### WITHOUT ROWID Tables

Use primary key as physical storage order instead of separate rowid.

**Benefits:**
- Reduced storage space (no separate rowid)
- Better clustering on primary key
- Faster primary key lookups
- Better cache locality

**Trade-offs:**
- Slightly slower for non-primary key lookups
- Cannot use INTEGER PRIMARY KEY (must define explicit primary key)
- Less flexible for inserts (must maintain primary key order)

**Use Cases:**
- Tables with meaningful primary keys
- Frequent primary key lookups
- When storage space is critical
- When clustering on primary key is beneficial

**Examples:**
```sql
-- Basic WITHOUT ROWID table
CREATE TABLE products (
  sku TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  price REAL NOT NULL
) WITHOUT ROWID;

-- Multicolumn primary key
CREATE TABLE order_items (
  order_id INTEGER NOT NULL,
  product_id INTEGER NOT NULL,
  quantity INTEGER NOT NULL,
  PRIMARY KEY (order_id, product_id)
) WITHOUT ROWID;

-- With indexes
CREATE TABLE users (
  id INTEGER PRIMARY KEY,
  email TEXT NOT NULL,
  name TEXT NOT NULL
) WITHOUT ROWID;

CREATE INDEX idx_email ON users (email);
CREATE INDEX idx_name ON users (name);

-- Query benefits
-- Fast primary key lookup
SELECT * FROM products WHERE sku = 'SKU-12345';

-- Clustered on primary key, good for range queries
SELECT * FROM order_items WHERE order_id = 123;
```

**When to Use:**
- Primary key is meaningful and frequently queried
- Want to optimize primary key lookups
- Storage space is critical (embedded devices)
- Table has many columns (reduces overhead)

**When to Avoid:**
- When you need AUTOINCREMENT behavior
- When rowid is useful for other purposes
- When inserts are random (can cause fragmentation)
- When non-primary key queries are more common

**Important:**
- Available in SQLite 3.8.2 and later
- Cannot have AUTOINCREMENT (use INTEGER PRIMARY KEY without AUTOINCREMENT)
- Must have an explicit PRIMARY KEY (not implicit)
- Particularly beneficial for tables with many columns

---

### Partial Index with DESC

Combine partial indexes with descending order for specific query patterns.

**Benefits:**
- Optimized for specific sort patterns on subsets of data
- Smaller index size
- Better performance for targeted queries

**Use Cases:**
- Frequently sort a subset of data
- Time-based sorting of recent records
- Status-based sorting

**Examples:**
```sql
-- Recent items sorted by date DESC
CREATE INDEX idx_recent_created ON items (created_at DESC) 
WHERE created_at >= strftime('%s', 'now') - 604800; -- 7 days

-- Benefits queries:
SELECT * FROM items 
WHERE created_at >= strftime('%s', 'now') - 604800
ORDER BY created_at DESC
LIMIT 10;

-- Active users sorted by name
CREATE INDEX idx_active_name ON users (name) 
WHERE is_active = 1;

-- Benefits:
SELECT * FROM users 
WHERE is_active = 1 
ORDER BY name;

-- Pending tasks sorted by priority
CREATE INDEX idx_pending_priority ON tasks (priority DESC) 
WHERE status = 'pending';

-- Benefits:
SELECT * FROM tasks 
WHERE status = 'pending' 
ORDER BY priority DESC;
```

**When to Use:**
- Frequently sort a specific subset of data
- Want to optimize both filtering and sorting
- Query patterns combine WHERE and ORDER BY

**When to Avoid:**
- When query patterns vary
- When subset is large (close to all rows)
- When descending order is not needed

---

## Additional Notes

### Index Maintenance

```sql
-- Reindex an index
REINDEX idx_name;

-- Reindex all indexes in a table
REINDEX users;

-- Reindex all indexes in the database
REINDEX;

-- Analyze statistics for query planner
ANALYZE;

-- Analyze specific table
ANALYZE users;

-- Force statistics update
PRAGMA optimize;
```

### Monitoring Index Usage

```sql
-- Check if indexes are being used (EXPLAIN QUERY PLAN)
EXPLAIN QUERY PLAN SELECT * FROM users WHERE email = 'user@example.com';

-- Output example:
-- SCAN TABLE users USING INDEX idx_email

-- Check all indexes on a table
PRAGMA index_list('users');

-- Check index columns
PRAGMA index_info('idx_email');

-- Check table info
PRAGMA table_info('users');

-- Get database size
PRAGMA page_count;
PRAGMA page_size;
SELECT page_count * page_size as database_size FROM pragma_page_count(), pragma_page_size();
```

### Query Optimization Tips

```sql
-- Use EXPLAIN QUERY PLAN to see if index is used
EXPLAIN QUERY PLAN SELECT * FROM orders WHERE customer_id = 123;

-- Use covering queries (SELECT only indexed columns)
CREATE INDEX idx_covering ON orders (customer_id, status, total);
SELECT customer_id, status, total FROM orders WHERE customer_id = 123;

-- Use LIMIT to reduce result set
SELECT * FROM orders WHERE customer_id = 123 LIMIT 100;

-- Use appropriate data types (INTEGER vs TEXT)
CREATE TABLE events (
  id INTEGER PRIMARY KEY,
  created_at INTEGER NOT NULL, -- Use INTEGER for timestamps
  event_type TEXT NOT NULL
);

-- Use prepared statements
PREPARE stmt(int) AS SELECT * FROM users WHERE id = ?;
EXECUTE stmt(123);
```

### Common Pitfalls

1. **Too many indexes:** Each index slows down writes
2. **Unused indexes:** Waste space and maintenance time
3. **Duplicate indexes:** Multiple indexes on same columns
4. **Leading wildcards in LIKE:** `LIKE '%pattern'` cannot use index
5. **Function calls on indexed columns:** Prevents index usage
6. **Not analyzing:** Query planner needs statistics
7. **Wrong collation:** Collation must match in query

### Best Practices

1. Start with B-Tree, use extensions when needed
2. Use partial indexes for common query filters
3. Consider WITHOUT ROWID for primary key optimization
4. Use collation (NOCASE) instead of LOWER() for case-insensitive
5. Monitor index usage with EXPLAIN QUERY PLAN
6. Remove unused indexes
7. Analyze tables after schema changes
8. Test query performance before/after indexing
9. Use LIMIT to reduce unnecessary work
10. Use INTEGER for timestamps and numeric IDs

### SQLite-Specific Considerations

1. **Embedded nature:** Optimized for single-user or low-concurrency
2. **Storage efficiency:** Smaller indexes than PostgreSQL
3. **No cluster command:** Use WITHOUT ROWID for clustering
4. **No CONCURRENTLY:** Index creation locks the database
5. **Extension-based advanced features:** R-Tree, FTS require extensions
6. **Collation-based optimization:** Use NOCASE for case-insensitive
7. **Explicit rowid control:** Use WITHOUT ROWID to optimize storage
8. **Simpler maintenance:** Fewer tuning options than PostgreSQL

### Performance Comparison: SQLite vs PostgreSQL

| Feature | SQLite | PostgreSQL |
|---------|--------|------------|
| Index Types | B-Tree + Extensions | B-Tree, Hash, GiST, SP-GiST, GIN, BRIN, Bloom |
| Partial Indexes | ✓ (3.8.0+) | ✓ |
| Expression Indexes | ✓ (3.9.0+) | ✓ |
| Covering Indexes | ✓ (implicit) | ✓ (explicit INCLUDE) |
| Concurrent Creation | ✗ | ✓ |
| Descending Indexes | ✓ (3.30.0+) | ✓ |
| Full-Text Search | FTS5 extension | GIN/GiST |
| Spatial Index | R-Tree extension | GiST/PostGIS |
| Collation Support | Built-in | Built-in |
| WITHOUT ROWID | ✓ | ✗ |
| Target Use Case | Embedded, Mobile | Server, High-concurrency |

---

**Last Updated:** 2026-06-14