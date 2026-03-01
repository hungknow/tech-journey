# 0631 Design Excel Sum Formula

## Problem Description

Design the Excel class that represents a 2D array of cells:

```
Excel(int height, char width)
```

Initializes the object with the height `h` and the width `w` represented by the character `c`.

```
void set(int row, char column, int val)
```

Sets the value of the cell at `(row, column)` to `val`.

```
int get(int row, char column)
```

Returns the value of the cell at `(row, column)`.

```
int sum(int row, char column, String[] numbers)
```

Sets the cell at `(row, column)` to be the sum of the cells represented by `numbers`. Returns the value of the sum. `numbers` is a list of strings representing the cells to sum.

### Example 1:
```
Input
["Excel", "set", "get", "sum", "set", "get", "get", "sum"]
[[3, "C"], [1, "A", 2], [1, "A"], [1, "A", ["A2"]], [2, "A", 1], [1, "A"], [2, "A"], [2, "A", ["A1", "A2"]]]
Output
[null, null, 2, 0, null, 2, 1, 3]

Explanation
Excel excel = new Excel(3, "C");
excel.set(1, "A", 2);
excel.get(1, "A"); // return 2
excel.sum(1, "A", ["A2"]); // set cell (1, "A") to be the sum of cell "A2", return 0
excel.set(2, "A", 1);
excel.get(1, "A"); // return 2
excel.get(2, "A"); // return 1
excel.sum(2, "A", ["A1", "A2"]); // set cell (2, "A") to be the sum of cells "A1" and "A2", return 3
```

## The Twist

Implementing an Excel-like spreadsheet system that supports both direct values and sum formulas with proper dependency tracking and cycle detection.

## Algorithm

### Graph + DFS Approach:
1. Use a 2D array to store the cells
2. Each cell can either store a direct value or a list of dependencies
3. For set(row, column, val):
   - Set the cell to the direct value
   - Clear any existing dependencies
4. For get(row, column):
   - If the cell has a direct value, return it
   - If the cell has dependencies, recursively sum the values of all dependencies
5. For sum(row, column, numbers):
   - Parse the numbers string to extract cell references
   - Store the dependencies for the cell
   - Calculate the sum by recursively evaluating all dependencies
   - Return the calculated sum

The key insight is using a graph-based approach to track dependencies between cells and using DFS to calculate sums with proper cycle detection.

## Complexity

- **Time**: 
  - set: O(1)
  - get: O(n) where n is the number of dependencies in the worst case
  - sum: O((r * c)^2) where r is rows and c is columns in the worst case
- **Space**: O(r * c) where r is rows and c is columns

## Solution Code

```go
package main

import (
	"strconv"
	"strings"
)

type Cell struct {
	value       int
	dependencies []string
}

type Excel struct {
	height int
	width  int
	cells  [][]*Cell
}

func Constructor(height int, widthChar rune) Excel {
	width := int(widthChar - 'A' + 1)
	cells := make([][]*Cell, height)
	for i := range cells {
		cells[i] = make([]*Cell, width)
		for j := range cells[i] {
			cells[i][j] = &Cell{value: 0}
		}
	}
	
	return Excel{
		height: height,
		width:  width,
		cells:  cells,
	}
}

func (this *Excel) Set(row int, columnChar rune, val int) {
	col := int(columnChar - 'A')
	this.cells[row-1][col].value = val
	this.cells[row-1][col].dependencies = nil
}

func (this *Excel) Get(row int, columnChar rune) int {
	col := int(columnChar - 'A')
	return this.getValue(row-1, col, make(map[string]bool))
}

func (this *Excel) Sum(row int, columnChar rune, numbers []string) int {
	col := int(columnChar - 'A')
	this.cells[row-1][col].dependencies = make([]string, len(numbers))
	copy(this.cells[row-1][col].dependencies, numbers)
	
	return this.getValue(row-1, col, make(map[string]bool))
}

func (this *Excel) getValue(row, col int, visited map[string]bool) int {
	key := string(rune('A'+col)) + strconv.Itoa(row+1)
	
	if visited[key] {
		return 0 // Cycle detected
	}
	
	visited[key] = true
	defer func() { delete(visited, key) }()
	
	cell := this.cells[row][col]
	if cell.dependencies == nil {
		return cell.value
	}
	
	sum := 0
	for _, dep := range cell.dependencies {
		parts := strings.Split(dep, ":")
		if len(parts) == 1 {
			// Single cell reference
			r, c := this.parseCellReference(parts[0])
			sum += this.getValue(r, c, visited)
		} else {
			// Range reference
			r1, c1 := this.parseCellReference(parts[0])
			r2, c2 := this.parseCellReference(parts[1])
			
			for i := min(r1, r2); i <= max(r1, r2); i++ {
				for j := min(c1, c2); j <= max(c1, c2); j++ {
					sum += this.getValue(i, j, visited)
				}
			}
		}
	}
	
	return sum
}

func (this *Excel) parseCellReference(ref string) (int, int) {
	col := int(ref[0] - 'A')
	row, _ := strconv.Atoi(ref[1:])
	return row - 1, col
}

func min(a, b int) int {
	if a < b {
		return a
	}
	return b
}

func max(a, b int) int {
	if a > b {
		return a
	}
	return b
}
```

## Link

[LeetCode 0631 Design Excel Sum Formula](https://leetcode.com/problems/design-excel-sum-formula/)