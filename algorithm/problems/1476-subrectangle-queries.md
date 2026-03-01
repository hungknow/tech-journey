# 1476 Subrectangle Queries

## Problem Description

Implement the class `SubrectangleQueries` which receives a rectangle `rows x cols` matrix and then supports queries for the sum of elements inside a subrectangle.

The class should have the following methods:

- `SubrectangleQueries(int[][] rectangle)` initializes the class with the given rectangle matrix.
- `void updateSubrectangle(int row1, int col1, int row2, int col2, int newValue)` updates all elements in the subrectangle whose upper left corner is `(row1,col1)` and bottom right corner is `(row2,col2)` to have `newValue`.
- `int getValue(int row, int col)` returns the current value at `(row,col)`.

### Example 1:
```
Input
["SubrectangleQueries","getValue","updateSubrectangle","getValue","getValue","updateSubrectangle","getValue","getValue"]
[[[[1,2,1],[4,3,4],[1,1,1]]],[0,2],[0,0,2,2,100],[0,2],[0,1],[1,1,2,2,20],[2,2],[1,1]]]
Output
[null,1,null,100,100,null,20,20]

Explanation
SubrectangleQueries subrectangleQueries = new SubrectangleQueries([[1,2,1],[4,3,4],[1,1,1]]);
subrectangleQueries.getValue(0,2); // return 1
subrectangleQueries.updateSubrectangle(0,0,2,2,100); // update all values in the rectangle to 100
subrectangleQueries.getValue(0,2); // return 100
subrectangleQueries.getValue(0,1); // return 100
subrectangleQueries.updateSubrectangle(1,1,2,2,20); // update all values in the rectangle to 20
subrectangleQueries.getValue(2,2); // return 20
subrectangleQueries.getValue(1,1); // return 20
```

## The Twist

Implementing a subrectangle query system that efficiently supports updating entire subrectangles and retrieving individual values.

## Algorithm

### Direct Update Approach:
1. Store the rectangle matrix as is
2. For updateSubrectangle(row1, col1, row2, col2, newValue):
   - Iterate through all cells in the specified subrectangle
   - Update each cell to the newValue
3. For getValue(row, col):
   - Return the value at the specified position

The key insight is that since we only need to retrieve individual values (not sums), we can directly update the matrix without needing complex preprocessing.

## Complexity

- **Time**: 
  - SubrectangleQueries constructor: O(m*n) where m and n are the dimensions of the rectangle
  - updateSubrectangle: O((row2-row1+1) * (col2-col1+1)) in the worst case
  - getValue: O(1)
- **Space**: O(m*n) where m and n are the dimensions of the rectangle

## Solution Code

```go
package main

type SubrectangleQueries struct {
	rectangle [][]int
	rows      int
	cols      int
}

func Constructor(rectangle [][]int) SubrectangleQueries {
	return SubrectangleQueries{
		rectangle: rectangle,
		rows:      len(rectangle),
		cols:      len(rectangle[0]),
	}
}

func (this *SubrectangleQueries) UpdateSubrectangle(row1 int, col1 int, row2 int, col2 int, newValue int)  {
	for i := row1; i <= row2; i++ {
		for j := col1; j <= col2; j++ {
			this.rectangle[i][j] = newValue
		}
	}
}

func (this *SubrectangleQueries) GetValue(row int, col int) int {
	return this.rectangle[row][col]
}

/**
 * Your SubrectangleQueries object will be instantiated and called as such:
 * obj := Constructor(rectangle);
 * obj.UpdateSubrectangle(row1,col1,row2,col2,newValue);
 * param_3 := obj.GetValue(row,col);
 */
```

## Link

[LeetCode 1476 Subrectangle Queries](https://leetcode.com/problems/subrectangle-queries/)