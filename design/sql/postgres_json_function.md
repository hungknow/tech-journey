# PostgreSQL JSON Functions - Practical Guide

This guide provides practical use cases for PostgreSQL JSON functions. Start with the reference table below, then jump to specific use cases to see how to combine functions effectively.

## Table of Contents

- [Quick Reference Table](#quick-reference-table)
- [Use Cases](#use-cases)
  - [1. Extract Specific Field from JSON Object](#1-extract-specific-field-from-json-object)
  - [2. Extract Nested JSON Values](#2-extract-nested-json-values)
  - [3. Filter Array Elements Based on Conditions](#3-filter-array-elements-based-on-conditions)
  - [4. Check if JSON Contains Specific Data](#4-check-if-json-contains-specific-data)
  - [5. Update Specific JSON Field Value](#5-update-specific-json-field-value)
  - [6. Insert Value into JSON Array](#6-insert-value-into-json-array)
  - [7. Delete Fields or Elements from JSON](#7-delete-fields-or-elements-from-json)
  - [8. Convert SQL Data to JSON](#8-convert-sql-data-to-json)
  - [9. Query JSON Data with Complex Conditions](#9-query-json-data-with-complex-conditions)
  - [10. Remove Null Values from JSON](#10-remove-null-values-from-json)
  - [11. Validate JSON Structure](#11-validate-json-structure)
  - [12. Convert JSON to SQL Rows](#12-convert-json-to-sql-rows)
  - [13. Count Array Elements](#13-count-array-elements)
  - [14. Merge JSON Objects](#14-merge-json-objects)
  - [15. Get All Keys from JSON Object](#15-get-all-keys-from-json-object)
  - [16. Search in JSON Arrays](#16-search-in-json-arrays)
  - [17. Aggregate JSON Data](#17-aggregate-json-data)
  - [18. Handle Null Values in JSON Updates](#18-handle-null-values-in-json-updates)
  - [19. Pretty Print JSON for Display](#19-pretty-print-json-for-display)
  - [20. Extract Array Elements by Index](#20-extract-array-elements-by-index)
  - [21. Validate and Test JSON Paths](#21-validate-and-test-json-paths)
  - [22. Convert Between JSON and SQL Types](#22-convert-between-json-and-sql-types)
  - [23. Search JSON Data by Type](#23-search-json-data-by-type)
  - [24. Build Complex JSON Structures](#24-build-complex-json-structures)
  - [25. Compare JSON Values](#25-compare-json-values)
  - [26. Extract and Transform JSON Data](#26-extract-and-transform-json-data)
  - [27. Handle Missing JSON Fields Gracefully](#27-handle-missing-json-fields-gracefully)
  - [28. Query JSON Arrays with Conditions](#28-query-json-arrays-with-conditions)
  - [29. Update JSON Arrays Conditionally](#29-update-json-arrays-conditionally)
  - [30. Generate JSON from Query Results](#30-generate-json-from-query-results)
- [Summary](#summary)

## Quick Reference Table

| Category | Function/Operator | Return Type | Purpose |
|----------|-------------------|-------------|---------|
| **Extraction** | `->` (int) | json/jsonb | Get array element by index |
| | `->` (text) | json/jsonb | Get object field by key |
| | `->>` (int) | text | Get array element as text |
| | `->>` (text) | text | Get object field as text |
| | `#>` | json/jsonb | Get nested value by path |
| | `#>>` | text | Get nested value as text |
| **Containment** | `@>` | boolean | Does JSON contain another? |
| | `<@` | boolean | Is JSON contained in another? |
| **Existence** | `?` | boolean | Does key/element exist? |
| | `?|` | boolean | Do any keys/elements exist? |
| | `?&` | boolean | Do all keys/elements exist? |
| **Modification** | `\|\|` | jsonb | Concatenate JSON values |
| | `-` (text) | jsonb | Delete key/element |
| | `-` (text[]) | jsonb | Delete multiple keys |
| | `-` (int) | jsonb | Delete array element |
| | `#-` | jsonb | Delete at path |
| | `jsonb_set` | jsonb | Set value at path |
| | `jsonb_set_lax` | jsonb | Set value with null handling |
| | `jsonb_insert` | jsonb | Insert value at path |
| | `json_strip_nulls` | json/jsonb | Remove null values |
| **Path Queries** | `@?` | boolean | Does path match exist? |
| | `@@` | boolean | Path predicate check |
| | `jsonb_path_exists` | boolean | Check path exists |
| | `jsonb_path_match` | boolean | Path predicate result |
| | `jsonb_path_query` | setof jsonb | Query path results |
| | `jsonb_path_query_array` | jsonb | Query results as array |
| | `jsonb_path_query_first` | jsonb | Get first path result |
| **Creation** | `to_json` | json | Convert SQL to JSON |
| | `to_jsonb` | jsonb | Convert SQL to JSONB |
| | `array_to_json` | json | Convert array to JSON |
| | `json_array` | json | Build JSON array |
| | `row_to_json` | json | Convert row to JSON |
| | `json_build_array` | json | Build array from args |
| | `json_build_object` | json | Build object from args |
| | `json_object` | json | Build JSON object |
| | `json_scalar` | json | Convert to JSON scalar |
| | `json_serialize` | text/bytea | Serialize JSON to string |
| **Expansion** | `json_array_elements` | setof json | Expand array to rows |
| | `json_array_elements_text` | setof text | Expand array to text rows |
| | `json_each` | setof record | Expand object to key/value |
| | `json_each_text` | setof record | Expand object to text pairs |
| | `json_object_keys` | setof text | Get object keys |
| **Conversion** | `json_extract_path` | json | Extract at path |
| | `json_extract_path_text` | text | Extract at path as text |
| | `json_to_record` | record | JSON to typed record |
| | `json_to_recordset` | setof record | JSON array to records |
| | `json_populate_record` | anyelement | JSON to composite type |
| | `json_populate_recordset` | setof anyelement | JSON array to composite set |
| **Testing** | `IS JSON` | boolean | Test if valid JSON |
| | `json_typeof` | text | Get JSON value type |
| | `jsonb_pretty` | text | Pretty print JSON |
| | `json_array_length` | integer | Get array length |

---

## Use Cases

### 1. Extract Specific Field from JSON Object

**Problem:** You have a JSON object and need to extract a specific field value.

**Solution:** Use the `->>` operator to get the field as text.

```sql
-- Sample data
CREATE TABLE users (id INT, data JSON);
INSERT INTO users VALUES
(1, '{"name": "John Doe", "email": "john@example.com", "age": 30}');

-- Extract email field
SELECT id, data->>'email' as email
FROM users
WHERE id = 1;
-- Result: john@example.com

-- Extract age field (as text)
SELECT id, data->>'age' as age
FROM users
WHERE id = 1;
-- Result: 30 (as text)

-- Extract nested field
SELECT id, data->>'name' as name
FROM users
WHERE id = 1;
-- Result: John Doe
```

**Alternative:** Use `->` to get the field as JSON type.

```sql
-- Get field as JSON
SELECT data->'email' as email_json
FROM users
WHERE id = 1;
-- Result: "john@example.com" (with quotes)
```

---

### 2. Extract Nested JSON Values

**Problem:** Extract values from deeply nested JSON structures.

**Solution:** Use the `#>>` operator for path-based extraction.

```sql
-- Sample data with nested structure
CREATE TABLE products (id INT, details JSON);
INSERT INTO products VALUES
(1, '{
  "product": {
    "name": "Laptop",
    "specs": {
      "cpu": "Intel i7",
      "ram": "16GB",
      "storage": {"type": "SSD", "size": "512GB"}
    }
  }
}');

-- Extract nested cpu value
SELECT id, details #>> '{product,specs,cpu}' as cpu
FROM products
WHERE id = 1;
-- Result: Intel i7

-- Extract deeply nested storage size
SELECT id, details #>> '{product,specs,storage,size}' as storage_size
FROM products
WHERE id = 1;
-- Result: 512GB

-- Extract intermediate object
SELECT details #> '{product,specs}' as specs
FROM products
WHERE id = 1;
-- Result: {"cpu": "Intel i7", "ram": "16GB", "storage": {"type": "SSD", "size": "512GB"}}
```

---

### 3. Filter Array Elements Based on Conditions

**Problem:** Filter elements in a JSON array based on specific criteria.

**Solution:** Combine `json_array_elements` with WHERE clauses.

```sql
-- Sample data with array
CREATE TABLE orders (id INT, items JSON);
INSERT INTO orders VALUES
(1, '[
  {"product": "Laptop", "price": 999.99, "in_stock": true},
  {"product": "Mouse", "price": 29.99, "in_stock": true},
  {"product": "Monitor", "price": 299.99, "in_stock": false},
  {"product": "Keyboard", "price": 79.99, "in_stock": true}
]');

-- Get all in-stock items
SELECT item->>'product' as product, (item->>'price')::numeric as price
FROM orders,
     json_array_elements(items) as item
WHERE item->>'in_stock' = 'true';
-- Results:
// product  | price
// ---------+----------
// Laptop   | 999.99
// Mouse    | 29.99
// Keyboard | 79.99

-- Get items above certain price
SELECT item->>'product' as product, (item->>'price')::numeric as price
FROM orders,
     json_array_elements(items) as item
WHERE (item->>'price')::numeric > 50;
-- Results:
// product  | price
// ---------+----------
// Laptop   | 999.99
// Monitor  | 299.99
// Keyboard | 79.99
```

---

### 4. Check if JSON Contains Specific Data

**Problem:** Check if a JSON object contains certain keys or values.

**Solution:** Use containment operators `@>`, `<@`, `?`, `?|`, `?&`.

```sql
-- Check if object contains specific key-value pair
SELECT '{"name": "John", "age": 30}'::jsonb @> '{"age": 30}'::jsonb;
-- Result: t

-- Check if object contains multiple keys
SELECT '{"name": "John", "age": 30, "city": "NYC"}'::jsonb ?& ARRAY['name', 'age'];
-- Result: t

-- Check if array contains specific element
SELECT '["apple", "banana", "cherry"]'::jsonb ? 'banana';
-- Result: t

-- Check if any of multiple keys exist
SELECT '{"name": "John"}'::jsonb ?| ARRAY['name', 'email', 'phone'];
-- Result: t

-- Check if all keys exist (will fail)
SELECT '{"name": "John"}'::jsonb ?& ARRAY['name', 'email'];
-- Result: f

-- Check if one JSON is contained in another
SELECT '{"a": 1, "b": 2}'::jsonb <@ '{"a": 1, "b": 2, "c": 3}'::jsonb;
-- Result: t
```

---

### 5. Update Specific JSON Field Value

**Problem:** Update a specific field value within a JSON object.

**Solution:** Use `jsonb_set` to modify values at specific paths.

```sql
-- Sample data
CREATE TABLE user_profiles (id INT, profile JSONB);
INSERT INTO user_profiles VALUES
(1, '{"name": "John Doe", "age": 30, "email": "john@example.com"}');

-- Update age field
UPDATE user_profiles
SET profile = jsonb_set(profile, '{age}', '31')
WHERE id = 1;
-- Result: {"name": "John Doe", "age": 31, "email": "john@example.com"}

-- Update nested field
UPDATE user_profiles
SET profile = jsonb_set(profile, '{email}', 'john.doe@example.com')
WHERE id = 1;
-- Result: {"name": "John Doe", "age": 31, "email": "john.doe@example.com"}

-- Add new field if it doesn't exist
UPDATE user_profiles
SET profile = jsonb_set(profile, '{phone}', '"555-1234"')
WHERE id = 1;
-- Result: {"name": "John Doe", "age": 31, "email": "john.doe@example.com", "phone": "555-1234"}
```

---

### 6. Insert Value into JSON Array

**Problem:** Add a new element to an existing JSON array.

**Solution:** Use `jsonb_insert` to add elements at specific positions.

```sql
-- Sample data with array
CREATE TABLE task_lists (id INT, tasks JSONB);
INSERT INTO task_lists VALUES
(1, '["Complete project", "Review code", "Write documentation"]');

-- Insert at beginning of array
UPDATE task_lists
SET tasks = jsonb_insert(tasks, '{0}', '"Start project"')
WHERE id = 1;
-- Result: ["Start project", "Complete project", "Review code", "Write documentation"]

-- Insert at specific position
UPDATE task_lists
SET tasks = jsonb_insert(tasks, '{2}', '"Test application"')
WHERE id = 1;
-- Result: ["Start project", "Complete project", "Test application", "Review code", "Write documentation"]

-- Insert at end
UPDATE task_lists
SET tasks = jsonb_insert(tasks, ARRAY[jsonb_array_length(tasks)], '"Deploy to production"')
WHERE id = 1;
-- Result: ["Start project", "Complete project", "Test application", "Review code", "Write documentation", "Deploy to production"]
```

---

### 7. Delete Fields or Elements from JSON

**Problem:** Remove unwanted fields or elements from JSON data.

**Solution:** Use deletion operators `-` and `#-`.

```sql
-- Sample data
CREATE TABLE user_data (id INT, data JSONB);
INSERT INTO user_data VALUES
(1, '{"name": "John", "email": "john@example.com", "password": "secret", "temp": "data"}');

-- Delete single field
SELECT data - 'password' as cleaned_data
FROM user_data
WHERE id = 1;
-- Result: {"name": "John", "email": "john@example.com", "temp": "data"}

-- Delete multiple fields
SELECT data - ARRAY['password', 'temp'] as cleaned_data
FROM user_data
WHERE id = 1;
-- Result: {"name": "John", "email": "john@example.com"}

-- Delete from array
SELECT '["a", "b", "c", "d"]'::jsonb - 1 as array_after_delete;
-- Result: ["a", "c", "d"]

-- Delete at specific path
DELETE FROM user_data
WHERE data #>> '{email}' = 'john@example.com';

-- Delete nested field
SELECT data #- '{temp}' as result
FROM user_data
WHERE id = 1;
```

---

### 8. Convert SQL Data to JSON

**Problem:** Convert regular SQL data (rows, arrays) to JSON format.

**Solution:** Use JSON creation functions.

```sql
-- Convert row to JSON
SELECT row_to_json(row(1, 'John', 'john@example.com', 30))
AS user_json;
-- Result: {"f1":1, "f2":"John", "f3":"john@example.com", "f4":30}

-- Convert row with column names
SELECT row_to_json(t)
FROM (SELECT id, name, email, age FROM users WHERE id = 1) t;
-- Result: {"id":1, "name":"John Doe", "email":"john@example.com", "age":30}

-- Convert array to JSON
SELECT array_to_json(ARRAY[1, 2, 3, 4, 5]);
-- Result: [1, 2, 3, 4, 5]

-- Build JSON object from arguments
SELECT json_build_object(
  'name', 'John Doe',
  'age', 30,
  'email', 'john@example.com'
);
-- Result: {"age": 30, "email": "john@example.com", "name": "John Doe"}

-- Build JSON array from arguments
SELECT json_build_array('apple', 'banana', 'cherry');
-- Result: ["apple", "banana", "cherry"]

-- Convert any SQL value to JSON
SELECT to_json(42), to_json('hello'), to_json(true);
-- Results: 42, "hello", true
```

---

### 9. Query JSON Data with Complex Conditions

**Problem:** Search JSON data using complex path expressions and filters.

**Solution:** Use JSON path query functions.

```sql
-- Sample complex data
CREATE TABLE employees (id INT, data JSONB);
INSERT INTO employees VALUES
(1, '{
  "departments": [
    {"name": "Engineering", "employees": [
      {"name": "Alice", "salary": 90000, "skills": ["Python", "Java"]},
      {"name": "Bob", "salary": 85000, "skills": ["JavaScript", "React"]}
    ]},
    {"name": "Sales", "employees": [
      {"name": "Charlie", "salary": 75000, "skills": ["Communication", "Sales"]}
    ]}
  ]
}');

-- Find all employees with salary > 80000
SELECT jsonb_path_query(data, '$.departments[*].employees[*] ? (@.salary > 80000)')
FROM employees
WHERE id = 1;
-- Results:
// {"name": "Alice", "salary": 90000, "skills": ["Python", "Java"]}
// {"name": "Bob", "salary": 85000, "skills": ["JavaScript", "React"]}

-- Find employees with specific skill
SELECT jsonb_path_query(data, '$.departments[*].employees[*] ? (@.skills[*] == "Python")')
FROM employees
WHERE id = 1;
-- Result: {"name": "Alice", "salary": 90000, "skills": ["Python", "Java"]}

-- Use variables in path queries
SELECT jsonb_path_query(
  data,
  '$.departments[*].employees[*] ? (@.salary > $min_salary)',
  '{"min_salary": 80000}'
)
FROM employees
WHERE id = 1;

-- Check if any condition matches
SELECT jsonb_path_exists(
  data,
  '$.departments[*].employees[*] ? (@.salary > 95000)'
)
FROM employees
WHERE id = 1;
-- Result: f
```

---

### 10. Remove Null Values from JSON

**Problem:** Clean up JSON data by removing null fields.

**Solution:** Use `json_strip_nulls` function.

```sql
-- Sample data with nulls
CREATE TABLE clean_data (id INT, data JSONB);
INSERT INTO clean_data VALUES
(1, '{"name": "John", "email": null, "age": 30, "phone": null}');

-- Remove null fields from objects
SELECT json_strip_nulls(data) as cleaned
FROM clean_data
WHERE id = 1;
-- Result: {"name": "John", "age": 30}

-- Handle nested objects
SELECT json_strip_nulls('{
  "user": {
    "name": "John",
    "email": null,
    "address": {
      "street": "123 Main St",
      "city": null,
      "zip": "12345"
    }
  }
}'::jsonb);
-- Result: {"user": {"name": "John", "address": {"street": "123 Main St", "zip": "12345"}}}

-- Remove nulls from arrays (optional)
SELECT jsonb_strip_nulls('[1, null, 3, null, 5]', true);
-- Result: [1, 3, 5]

-- Remove nulls but keep array nulls
SELECT jsonb_strip_nulls('[1, null, 3, null, 5]', false);
-- Result: [1, null, 3, null, 5]
```

---

### 11. Validate JSON Structure

**Problem:** Check if data is valid JSON and validate its structure.

**Solution:** Use `IS JSON` predicate and `json_typeof`.

```sql
-- Check if valid JSON
SELECT '123' IS JSON as valid_number,
       '"abc"' IS JSON as valid_string,
       '{"a": "b"}' IS JSON as valid_object,
       '[1,2]' IS JSON as valid_array,
       'abc' IS JSON as invalid;
-- Results: t, t, t, t, f

-- Check specific JSON types
SELECT '{"a": "b"}' IS JSON OBJECT as is_object,
       '[1,2]' IS JSON ARRAY as is_array,
       '123' IS JSON SCALAR as is_scalar;
-- Results: t, t, t

-- Check for duplicate keys
SELECT '[{"a":"1"}, {"b":"2","b":"3"}]'::json IS JSON ARRAY WITH UNIQUE KEYS;
-- Result: f

-- Get type of JSON value
SELECT json_typeof('{"a": 1}') as object_type,
       json_typeof('[1, 2, 3]') as array_type,
       json_typeof('"hello"') as string_type,
       json_typeof('123') as number_type,
       json_typeof('true') as boolean_type,
       json_typeof('null'::json) as null_type;
-- Results: object, array, string, number, boolean, null

-- Validate table data
SELECT id, data,
       CASE
         WHEN data IS NOT JSON THEN 'Invalid JSON'
         WHEN data IS JSON OBJECT THEN 'Valid Object'
         WHEN data IS JSON ARRAY THEN 'Valid Array'
         ELSE 'Valid JSON'
       END as validation_result
FROM users;
```

---

### 12. Convert JSON to SQL Rows

**Problem:** Transform JSON data into relational table format.

**Solution:** Use `json_to_record` and `json_to_recordset`.

```sql
-- Convert JSON object to typed row
SELECT *
FROM json_to_record('{"name": "John", "age": 30, "email": "john@example.com"}')
  AS x(name TEXT, age INTEGER, email TEXT);
-- Results:
// name | age | email
// -----+-----+------------------
// John |  30 | john@example.com

-- Convert JSON array to set of rows
SELECT *
FROM json_to_recordset('[
  {"name": "John", "age": 30},
  {"name": "Jane", "age": 25},
  {"name": "Bob", "age": 35}
]')
  AS x(name TEXT, age INTEGER);
-- Results:
// name | age
// -----+-----
// John |  30
// Jane |  25
// Bob  |  35

-- Handle missing fields
SELECT *
FROM json_to_recordset('[{"name": "John"}, {"age": 25}]')
  AS x(name TEXT, age INTEGER);
-- Results:
// name | age
// -----+-----
// John |
//      |  25

-- Convert with nested structures
SELECT *
FROM json_to_record('{"user": {"name": "John"}, "id": 1}')
  AS x(user JSONB, id INTEGER);
-- Results:
// user               | id
// --------------------+----
// {"name": "John"}    |  1
```

---

### 13. Count Array Elements

**Problem:** Count the number of elements in a JSON array.

**Solution:** Use `json_array_length`.

```sql
-- Get array length
SELECT json_array_length('[1, 2, 3, 4, 5]');
-- Result: 5

-- Count nested array elements
SELECT json_array_length('[[1, 2], [3, 4]]');
-- Result: 2 (counts top-level only)

-- Count objects in array
SELECT json_array_length('[{"a": 1}, {"b": 2}, {"c": 3}]');
-- Result: 3

-- Empty array
SELECT json_array_length('[]');
-- Result: 0

-- Count in table data
SELECT id, items, json_array_length(items) as item_count
FROM orders;
-- Results:
// id | items                                                 | item_count
// ----+-------------------------------------------------------+------------
//  1 | [{"product": "Laptop", "price": 999.99}, {...}]      | 2
```

---

### 14. Merge JSON Objects

**Problem:** Combine multiple JSON objects into one.

**Solution:** Use concatenation operator `||`.

```sql
-- Merge two objects
SELECT '{"a": 1}'::jsonb || '{"b": 2}'::jsonb;
-- Result: {"a": 1, "b": 2}

-- Merge with overlapping keys (second wins)
SELECT '{"a": 1, "b": 2}'::jsonb || '{"a": 3, "c": 4}'::jsonb;
-- Result: {"a": 3, "b": 2, "c": 4}

-- Merge multiple objects
SELECT '{"name": "John"}'::jsonb ||
       '{"age": 30}'::jsonb ||
       '{"email": "john@example.com"}'::jsonb;
-- Result: {"name": "John", "age": 30, "email": "john@example.com"}

-- Merge arrays
SELECT '[1, 2]'::jsonb || '[3, 4]'::jsonb;
-- Result: [1, 2, 3, 4]

-- Merge object and scalar (creates array)
SELECT '{"a": 1}'::jsonb || '42'::jsonb;
-- Result: [{"a": 1}, 42]
```

---

### 15. Get All Keys from JSON Object

**Problem:** Extract all keys from a JSON object.

**Solution:** Use `json_object_keys`.

```sql
-- Get object keys
SELECT *
FROM json_object_keys('{"name": "John", "age": 30, "email": "john@example.com"}');
-- Results:
// json_object_keys
// -----------------
// name
// age
// email

-- Count keys
SELECT COUNT(*)
FROM json_object_keys('{"a": 1, "b": 2, "c": 3}');
-- Result: 3

-- Use in queries
SELECT id, key, value
FROM users,
     json_each(data)
WHERE id = 1;
-- Results:
// id | key   | value
// ----+-------+--------
//  1 | name  | "John"
//  1 | age   | 30
//  1 | email | "john@example.com"

-- Get keys as array
SELECT ARRAY(
  SELECT json_object_keys
  FROM json_object_keys('{"a": 1, "b": 2, "c": 3}')
);
-- Result: {a,b,c}
```

---

### 16. Search in JSON Arrays

**Problem:** Find specific elements within JSON arrays.

**Solution:** Combine array expansion with filtering.

```sql
-- Find specific element in array
SELECT item
FROM products,
     json_array_elements(details->'tags') as item
WHERE item->>'name' = 'premium';

-- Find all elements matching criteria
SELECT item->>'name' as product_name, (item->>'price')::numeric as price
FROM orders,
     json_array_elements(items) as item
WHERE (item->>'price')::numeric BETWEEN 50 AND 200;

-- Search in nested arrays
SELECT department->>'name' as dept_name,
       json_array_length(department->'employees') as employee_count
FROM companies,
     json_array_elements(departments) as department
WHERE json_array_length(department->'employees') > 5;

-- Find first matching element
SELECT (
  SELECT item
  FROM orders,
       json_array_elements(items) as item
  WHERE item->>'product' = 'Laptop'
  LIMIT 1
)->>'price' as laptop_price;
```

---

### 17. Aggregate JSON Data

**Problem:** Combine JSON values from multiple rows.

**Solution:** Use aggregation functions with JSON.

```sql
-- Aggregate JSON objects into array
SELECT json_agg(data)
FROM users
WHERE age > 25;
-- Result: [{"id": 1, "name": "John", "age": 30}, {"id": 2, "name": "Jane", "age": 28}]

-- Aggregate specific fields
SELECT json_agg(json_build_object('name', name, 'age', age))
FROM users
WHERE age > 25;
-- Result: [{"name": "John", "age": 30}, {"name": "Jane", "age": 28}]

-- Aggregate into JSON object
SELECT json_object_agg(name, email)
FROM users;
-- Result: {"John": "john@example.com", "Jane": "jane@example.com"}

-- Conditional aggregation
SELECT json_agg(
  CASE WHEN age > 30 THEN json_build_object('name', name, 'age', age) END
) as senior_users
FROM users;
-- Result: [null, {"name": "Jane", "age": 35}, null]
```

---

### 18. Handle Null Values in JSON Updates

**Problem:** Update JSON values while handling null values appropriately.

**Solution:** Use `jsonb_set_lax` for flexible null handling.

```sql
-- Sample data
CREATE TABLE flexible_data (id INT, data JSONB);
INSERT INTO flexible_data VALUES
(1, '{"name": "John", "age": 30, "email": "john@example.com"}');

-- Update with null (default behavior - use JSON null)
UPDATE flexible_data
SET data = jsonb_set_lax(data, '{email}', NULL)
WHERE id = 1;
-- Result: {"name": "John", "age": 30, "email": null}

-- Update with null (delete key)
UPDATE flexible_data
SET data = jsonb_set_lax(data, '{age}', NULL, false, 'delete_key')
WHERE id = 1;
-- Result: {"name": "John", "email": null}

-- Update with null (return original unchanged)
UPDATE flexible_data
SET data = jsonb_set_lax(data, '{nonexistent}', NULL, true, 'return_target')
WHERE id = 1;
-- Result: {"name": "John", "email": null} (unchanged)

-- Update with null (raise exception)
-- This would throw an error:
UPDATE flexible_data
SET data = jsonb_set_lax(data, '{name}', NULL, false, 'raise_exception')
WHERE id = 1;
-- Result: ERROR: cannot set null at path
```

---

### 19. Pretty Print JSON for Display

**Problem:** Format JSON data for readable output.

**Solution:** Use `jsonb_pretty` function.

```sql
-- Pretty print simple object
SELECT jsonb_pretty('{"name": "John", "age": 30}'::jsonb);
-- Result:
// {
//     "name": "John",
//     "age": 30
// }

-- Pretty print complex nested structure
SELECT jsonb_pretty('{
  "user": {
    "name": "John",
    "profile": {
      "age": 30,
      "address": {
        "street": "123 Main St",
        "city": "Boston"
      }
    }
  }
}'::jsonb);
-- Result:
// {
//     "user": {
//         "name": "John",
//         "profile": {
//             "age": 30,
//             "address": {
//                 "street": "123 Main St",
//                 "city": "Boston"
//             }
//         }
//     }
// }

-- Pretty print arrays
SELECT jsonb_pretty('[1, 2, 3, 4, 5]'::jsonb);
-- Result:
// [
//     1,
//     2,
//     3,
//     4,
//     5
// ]

-- Format table data for export
SELECT jsonb_pretty(json_agg(data))
FROM users
WHERE age > 25;
```

---

### 20. Extract Array Elements by Index

**Problem:** Access specific elements in JSON arrays using indexes.

**Solution:** Use the `->` operator with integer indices.

```sql
-- Get first element
SELECT '[1, 2, 3, 4, 5]'::json->0;
-- Result: 1

-- Get last element using negative index
SELECT '[1, 2, 3, 4, 5]'::json->-1;
-- Result: 5

-- Get specific element
SELECT '[{"name": "John"}, {"name": "Jane"}, {"name": "Bob"}]'::json->1;
-- Result: {"name": "Jane"}

-- Get element as text
SELECT '[1, 2, 3]'::json->>1;
-- Result: 2

-- Access nested array elements
SELECT '[[1, 2], [3, 4], [5, 6]]'::json->1->0;
-- Result: 3

-- Out of bounds returns NULL
SELECT '[1, 2, 3]'::json->10;
-- Result: NULL
```

---

### 21. Validate and Test JSON Paths

**Problem:** Test if JSON paths exist and match specific conditions.

**Solution:** Use `jsonb_path_exists` and related functions.

```sql
-- Check if path exists
SELECT jsonb_path_exists('{"users": [{"name": "John"}]}', '$.users[*].name');
-- Result: t

-- Check specific condition
SELECT jsonb_path_exists('{"numbers": [1, 5, 10, 15]}', '$.numbers[*] ? (@ > 8)');
-- Result: t

-- Check with variables
SELECT jsonb_path_exists(
  '{"items": [{"price": 10}, {"price": 20}, {"price": 30}]}',
  '$.items[*] ? (@.price > $min_price)',
  '{"min_price": 15}'
);
-- Result: t

-- Path predicate check
SELECT jsonb_path_match(
  '{"data": [1, 2, 3, 4, 5]}',
  'all($.data[*] ? (@ < 10))'
);
-- Result: t

-- Silent mode (suppresses errors)
SELECT jsonb_path_exists(
  '{"data": "not an array"}',
  '$.data[*] ? (@ > 5)',
  NULL,
  true
);
-- Result: f (instead of error)
```

---

### 22. Convert Between JSON and SQL Types

**Problem:** Convert JSON data to appropriate SQL types for processing.

**Solution:** Use type casting and conversion functions.

```sql
-- Convert JSON string to SQL text
SELECT (data->>'name')::text as name
FROM users
WHERE id = 1;

-- Convert JSON number to SQL integer
SELECT (data->>'age')::integer as age
FROM users
WHERE id = 1;

-- Convert JSON number to SQL numeric
SELECT (data->>'price')::numeric(10,2) as price
FROM products
WHERE id = 1;

-- Convert JSON array to SQL array
SELECT ARRAY(
  SELECT (item->>'value')::integer
  FROM json_array_elements('[1, 2, 3, 4, 5]') as item
) as sql_array;
-- Result: {1,2,3,4,5}

-- Convert JSON boolean to SQL boolean
SELECT (data->>'active')::boolean as active
FROM users
WHERE id = 1;

-- Convert JSON date string to SQL date
SELECT (data->>'birthdate')::date as birthdate
FROM users
WHERE id = 1;
```

---

### 23. Search JSON Data by Type

**Problem:** Find JSON elements based on their data type.

**Solution:** Use `json_typeof` in queries.

```sql
-- Find all string values in object
SELECT key, value
FROM users,
     json_each(data)
WHERE json_typeof(value) = 'string';

-- Find all numeric values
SELECT key, value
FROM products,
     json_each(details)
WHERE json_typeof(value) = 'number';

-- Find all null values
SELECT key
FROM users,
     json_each(data)
WHERE json_typeof(value) = 'null';

-- Find all objects
SELECT key
FROM complex_data,
     json_each(data)
WHERE json_typeof(value) = 'object';

-- Find all arrays
SELECT key
FROM complex_data,
     json_each(data)
WHERE json_typeof(value) = 'array';

-- Filter by multiple types
SELECT key, json_typeof(value) as type
FROM mixed_data,
     json_each(data)
WHERE json_typeof(value) IN ('string', 'number');
```

---

### 24. Build Complex JSON Structures

**Problem:** Create complex nested JSON structures from SQL data.

**Solution:** Combine multiple JSON building functions.

```sql
-- Build nested object structure
SELECT json_build_object(
  'user', json_build_object(
    'name', 'John Doe',
    'contact', json_build_object(
      'email', 'john@example.com',
      'phone', '555-1234'
    )
  ),
  'orders', json_build_array(
    json_build_object(
      'id', 1,
      'items', json_build_array('Laptop', 'Mouse')
    ),
    json_build_object(
      'id', 2,
      'items', json_build_array('Keyboard', 'Monitor')
    )
  )
);
-- Result: {"user": {"name": "John Doe", "contact": {"email": "john@example.com", "phone": "555-1234"}}, "orders": [{"id": 1, "items": ["Laptop", "Mouse"]}, {"id": 2, "items": ["Keyboard", "Monitor"}]}

-- Build from table data
SELECT json_build_object(
  'user', json_build_object(
    'name', name,
    'email', email
  ),
  'total_orders', COUNT(*),
  'recent_orders', (
    SELECT json_agg(json_build_object(
      'id', order_id,
      'date', order_date
    ))
    FROM orders
    WHERE orders.user_id = users.user_id
    LIMIT 3
  )
)
FROM users
GROUP BY user_id, name, email;
```

---

### 25. Compare JSON Values

**Problem:** Compare JSON values for equality or containment.

**Solution:** Use comparison operators and containment checks.

```sql
-- Check exact equality
SELECT '{"a": 1, "b": 2}'::jsonb = '{"a": 1, "b": 2}'::jsonb;
-- Result: t

-- Order doesn't matter for objects
SELECT '{"a": 1, "b": 2}'::jsonb = '{"b": 2, "a": 1}'::jsonb;
-- Result: t

-- Array order matters
SELECT '[1, 2, 3]'::jsonb = '[1, 3, 2]'::jsonb;
-- Result: f

-- Containment checks
SELECT '{"a": 1, "b": 2, "c": 3}'::jsonb @> '{"a": 1, "b": 2}'::jsonb;
-- Result: t

-- Array containment
SELECT '[1, 2, 3, 4, 5]'::jsonb @> '[2, 4]'::jsonb;
-- Result: t

-- Nested containment
SELECT '{"user": {"name": "John", "age": 30}}'::jsonb @> '{"user": {"name": "John"}}'::jsonb;
-- Result: t

-- Find matching rows
SELECT *
FROM user_profiles
WHERE data @> '{"age": 30}'::jsonb;
```

---

### 26. Extract and Transform JSON Data

**Problem:** Extract JSON data and transform it for analysis.

**Solution:** Combine extraction functions with SQL transformations.

```sql
-- Calculate total order amount from JSON
SELECT order_id,
       SUM((item->>'price')::numeric * (item->>'quantity')::integer) as total
FROM orders,
     json_array_elements(items) as item
GROUP BY order_id;

-- Extract and format dates
SELECT user_id,
       (data->>'created_at')::timestamp::date as creation_date
FROM users
WHERE id = 1;

-- Transform array to comma-separated string
SELECT string_agg(item->>'name', ', ')
FROM products,
     json_array_elements(tags) as item
WHERE product_id = 1;
-- Result: electronics, laptop, premium

-- Extract nested values for reporting
SELECT product_id,
       details->>'name' as product_name,
       (details #>> '{specs,price}')::numeric as price,
       details #>> '{specs,manufacturer}' as manufacturer
FROM products
WHERE category = 'electronics';

-- Create summary statistics
SELECT
  COUNT(*) as total_orders,
  AVG(json_array_length(items)) as avg_items_per_order,
  MAX(json_array_length(items)) as max_items_in_order
FROM orders;
```

---

### 27. Handle Missing JSON Fields Gracefully

**Problem:** Work with JSON data that may have missing optional fields.

**Solution:** Use COALESCE and null handling techniques.

```sql
-- Handle missing fields with COALESCE
SELECT
  data->>'name' as name,
  COALESCE(data->>'phone', 'N/A') as phone,
  COALESCE(data->>'email', 'no-email@example.com') as email
FROM users;

-- Provide default values
SELECT
  product_id,
  COALESCE(details->>'price', '0')::numeric as price,
  COALESCE(details->>'discount', '0')::numeric as discount
FROM products;

-- Check field existence before access
SELECT id,
  CASE
    WHEN data ? 'premium' THEN data->>'premium'
    ELSE 'false'
  END as is_premium
FROM user_profiles;

-- Safe nested access
SELECT
  data->>'name' as name,
  COALESCE(data #>> '{address,city}', 'Unknown') as city
FROM users;

-- Use COALESCE with array operations
SELECT
  product_id,
  COALESCE(json_array_length(tags), 0) as tag_count
FROM products;
```

---

### 28. Query JSON Arrays with Conditions

**Problem:** Filter and extract data from JSON arrays based on multiple conditions.

**Solution:** Use jsonb_path_query with complex filter expressions.

```sql
-- Find products in price range with specific attributes
SELECT jsonb_path_query_array(
  '{
    "products": [
      {"name": "Laptop", "price": 999, "category": "electronics", "stock": 10},
      {"name": "Mouse", "price": 29, "category": "electronics", "stock": 50},
      {"name": "Desk", "price": 299, "category": "furniture", "stock": 5},
      {"name": "Monitor", "price": 399, "category": "electronics", "stock": 15}
    ]
  }'::jsonb,
  '$.products[*] ? (@.price >= $min && @.price <= $max && @.category == $cat)',
  '{"min": 100, "max": 500, "cat": "electronics"}'
);
-- Result: [{"name": "Laptop", "price": 999, "category": "electronics", "stock": 10}] (Wait, this should be filtered by the range)
-- Actually: [{"name": "Monitor", "price": 399, "category": "electronics", "stock": 15}]

-- Find items with low stock
SELECT jsonb_path_query(
  inventory,
  '$.items[*] ? (@.stock < $threshold).name',
  '{"threshold": 10}'
)
FROM warehouses;

-- Complex nested conditions
SELECT jsonb_path_query(
  orders,
  '$.products[*] ? (@.price > 100 && @.category == "electronics" && @.stock > 0)'
)
FROM order_data;

-- Multiple filter conditions
SELECT jsonb_path_query_array(
  data,
  '$.users[*] ? (@.age >= $min_age && @.age <= $max_age && @.department == $dept)',
  '{"min_age": 25, "max_age": 40, "dept": "Engineering"}'
)
FROM employee_data;
```

---

### 29. Update JSON Arrays Conditionally

**Problem:** Update specific elements in JSON arrays based on conditions.

**Solution:** Combine jsonb_set with array filtering.

```sql
-- Update all matching elements in array
UPDATE shopping_carts
SET items = (
  SELECT jsonb_agg(
    CASE
      WHEN item->>'product_id' = '123' THEN
        jsonb_set(item, '{quantity}', ((item->>'quantity')::int + 1)::text::jsonb)
      ELSE item
    END
  )
  FROM json_array_elements(items) as item
)
WHERE cart_id = 1;

-- Update specific array element by index
UPDATE user_data
SET preferences = jsonb_set(preferences, ARRAY[0], jsonb_set(preferences->0, '{active}', 'true'))
WHERE user_id = 1;

-- Batch update array elements
UPDATE products
SET tags = (
  SELECT jsonb_agg(
    CASE
      WHEN item IN ('old', 'deprecated') THEN 'legacy'
      ELSE item
    END
  )
  FROM json_array_elements_text(tags) as item
)
WHERE product_id = 1;

-- Update nested array elements
UPDATE config
SET settings = jsonb_set(
  settings,
  '{notifications,email}',
  jsonb_set(settings #> '{notifications,email}', '{enabled}', 'false')
)
WHERE user_id = 1;
```

---

### 30. Generate JSON from Query Results

**Problem:** Create JSON responses from complex SQL queries.

**Solution:** Use JSON aggregation functions with query results.

```sql
-- Create dashboard summary
SELECT json_build_object(
  'total_users', (SELECT COUNT(*) FROM users),
  'active_users', (SELECT COUNT(*) FROM users WHERE last_login > NOW() - INTERVAL '30 days'),
  'total_orders', (SELECT COUNT(*) FROM orders),
  'revenue', (SELECT COALESCE(SUM(total), 0) FROM orders WHERE created_at > NOW() - INTERVAL '30 days'),
  'top_products', (
    SELECT json_agg(json_build_object(
      'name', p.name,
      'sales', COUNT(oi.order_id)
    ))
    FROM order_items oi
    JOIN products p ON oi.product_id = p.id
    GROUP BY p.name
    ORDER BY COUNT(oi.order_id) DESC
    LIMIT 5
  )
) as dashboard_data;

-- Create user profile response
SELECT json_build_object(
  'user', json_build_object(
    'id', u.user_id,
    'name', u.name,
    'email', u.email
  ),
  'profile', (
    SELECT row_to_json(p.*)
    FROM user_profiles p
    WHERE p.user_id = u.user_id
  ),
  'recent_activity', (
    SELECT json_agg(json_build_object(
      'action', a.action,
      'timestamp', a.created_at
    ))
    FROM activity_log a
    WHERE a.user_id = u.user_id
    ORDER BY a.created_at DESC
    LIMIT 10
  )
)
FROM users u
WHERE u.user_id = 1;

-- Create paginated response
SELECT json_build_object(
  'data', json_agg(row_to_json(t.*)),
  'pagination', json_build_object(
    'page', 1,
    'per_page', 10,
    'total', (SELECT COUNT(*) FROM users),
    'total_pages', CEIL((SELECT COUNT(*) FROM users)::numeric / 10)
  )
)
FROM (
  SELECT *
  FROM users
  ORDER BY created_at DESC
  LIMIT 10 OFFSET 0
) t;
```

---

## Summary

This guide provides practical solutions for common JSON operations in PostgreSQL. Each use case demonstrates:

1. **Real-world problems** you'll encounter when working with JSON data
2. **Function combinations** that solve specific problems effectively
3. **Expected results** so you know what to expect

**Key Principles:**

- **Use jsonb for performance** when you need to query or modify JSON frequently
- **Use json for preservation** when exact formatting matters
- **Combine functions** to handle complex operations
- **Validate input** using `IS JSON` and `json_typeof`
- **Handle missing data** gracefully with COALESCE and null handling
- **Use indexing** with containment operators (`@>`, `?`, `?&`, `?|`) for performance

**Common Function Combinations:**

| Task | Functions Used |
|------|----------------|
| Extract nested values | `#>>`, `#>` |
| Filter array elements | `json_array_elements`, `->>`, WHERE |
| Update specific values | `jsonb_set`, `jsonb_insert` |
| Query complex data | `jsonb_path_query`, `jsonb_path_exists` |
| Convert to rows | `json_to_record`, `json_to_recordset` |
| Build JSON from SQL | `json_build_object`, `json_build_array`, `json_agg` |
| Validate data | `IS JSON`, `json_typeof` |
| Search and filter | `@>`, `?`, `?&`, `?|`, `@?`, `@@` |

Master these patterns and you'll be able to handle virtually any JSON manipulation task in PostgreSQL!