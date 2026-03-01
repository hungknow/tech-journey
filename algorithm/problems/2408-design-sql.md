# 2408 Design SQL

## Problem Description

Design a simplified SQL-like query language that supports the following operations:

- `SQL()` Initializes the object with an empty table.
- `void addName(string name)` Adds a column named `name` to the table.
- `void deleteRow(string rowId)` Deletes all data from row with the given `rowId`.
- `void select(string rowId, int columnId)` Returns the cell value at the given row and column.
- `int selectCount(int columnId)` Returns the count of cells in the given column.

### Example 1:
```
Input
["SQL","addName","addName","select","select","select","selectCount"]
[[],["Name"],["Age"],["1","Age"],["1","Age"]]
Output
[null,null,null,"John",18,null,2]

Explanation
SQL sql = new SQL();
sql.addName("Name");
sql.addName("Age");
sql.select("1", "Age");  // return "John"
sql.selectCount("Age");    // return 2
```

## The Twist

Implementing a simple SQL-like interface that supports table creation and basic query operations.

## Algorithm

### 2D Array Approach:
1. Use a 2D array to store the table data
2. Track column names and their indices
3. For SQL():
   - Initialize empty table and column mappings
4. For addName(name):
   - Add column with the given name
5. For deleteRow(rowId):
   - Remove all data for the given row
6. For select(rowId, columnId):
   - Return the value at the specified cell
7. For selectCount(columnId):
   - Count non-empty cells in the given column

The key insight is using a simple 2D array to represent the table with column mappings for efficient operations.

## Complexity

- **Time**: 
  - SQL constructor: O(1)
  - addName: O(1)
  - deleteRow: O(n) where n is the number of columns
  - select: O(1)
  - selectCount: O(n) where n is the number of rows
- **Space**: O(n * m) where n is the number of rows and m is the number of columns

## Solution Code

```go
package main

type SQL struct {
	table    [][]string
	colIndex map[string]int
	nextRow  int
}

func Constructor() SQL {
	return SQL{
		table:    make([][]string, 0),
		colIndex: make(map[string]int),
		nextRow: 0,
	}
}

func (this *SQL) AddName(name string)  {
	// Check if column already exists
	if _, exists := this.colIndex[name]; exists {
		return
	}
	
	// Add column
	this.colIndex[name] = len(this.colIndex)
	
	// Add column name to all existing rows
	for i := range this.table {
		if len(this.table[i]) == len(this.colIndex)-1 {
			this.table[i] = append(this.table[i], name)
		} else {
			// Add empty cell
			newRow := make([]string, len(this.colIndex))
			for j := 0; j < len(this.colIndex); j++ {
				newRow[j] = ""
			}
			this.table[i] = append(this.table[i], newRow...)
		}
	}
}

func (this *SQL) DeleteRow(rowId int)  {
	if rowId < 0 || rowId >= len(this.table) {
		return
	}
	
	// Clear the row
	this.table[rowId] = make([]string, len(this.colIndex))
	this.nextRow--
}

func (this *SQL) Select(rowId int, columnId int) string {
	if rowId < 0 || rowId >= len(this.table) || columnId < 0 || columnId >= len(this.colIndex) {
		return ""
	}
	
	return this.table[rowId][columnId]
}

func (this *SQL) SelectCount(columnId int) int {
	count := 0
	for _, row := range this.table {
		if row[columnId] != "" {
			count++
		}
	}
	
	return count
}

/**
 * Your SQL object will be instantiated and called as such:
 * obj := Constructor();
 * obj.AddName(name);
 * obj.DeleteRow(rowId);
 * param_3 := obj.Select(rowId,columnId);
 * param_4 := obj.SelectCount(columnId);
 */
```

## Link

[LeetCode 2408 Design SQL](https://leetcode.com/problems/design-sql/)