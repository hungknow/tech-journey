# 2617 Minimum Number of Visited Cells in a Grid

## Problem Description

You are given a `m x n` grid where each cell contains a non-negative integer. You start at cell `(0, 0)` and want to reach cell `(m-1, n-1)`.

From cell `(i, j)`, you can move to:
- `(i + a, j)` where `a` is any positive integer and `i + a < m`
- `(i, j + b)` where `b` is any positive integer and `j + b < n`

Return the minimum number of cells you need to visit to reach the target, including the start and end cells.

### Example 1:
```
Input: grid = [[0,1,3,2],[4,2,1,1]]
Output: 4
```

### Example 2:
```
Input: grid = [[0,2,1],[3,4,2]]
Output: 3
```

## Approach

This problem can be solved using BFS with optimization:

1. **BFS with State**:
   - Each state is (row, col)
   - Track the minimum number of cells visited to reach each position

2. **Optimized Moves**:
   - From each cell, we can jump to any cell in the same row or column
   - Use preprocessing to find optimal jumps
   - Track visited cells to avoid cycles

3. **Early Termination**: When we reach the target, return the cell count

## Solution Code

```go
func minimumVisitedCells(grid [][]int) int {
    m, n := len(grid), len(grid[0])
    
    // Directions: right and down (we can jump any distance)
    // We'll use BFS to find the optimal path
    
    // Preprocess to find the best jumps from each cell
    rowJumps := make([][]int, m)
    colJumps := make([][]int, n)
    
    for i := 0; i < m; i++ {
        rowJumps[i] = make([]int, n)
        minVal := math.MaxInt32
        for j := 0; j < n; j++ {
            if grid[i][j] < minVal {
                minVal = grid[i][j]
            }
            rowJumps[i][j] = minVal
        }
    }
    
    for j := 0; j < n; j++ {
        colJumps[j] = make([]int, m)
        minVal := math.MaxInt32
        for i := 0; i < m; i++ {
            if grid[i][j] < minVal {
                minVal = grid[i][j]
            }
            colJumps[j][i] = minVal
        }
    }
    
    // BFS setup
    queue := [][3]int{{0, 0, 1}} // row, col, cells_visited
    visited := make([][]bool, m)
    for i := 0; i < m; i++ {
        visited[i] = make([]bool, n)
    }
    visited[0][0] = true
    
    for len(queue) > 0 {
        current := queue[0]
        queue = queue[1:]
        
        row, col, cellsVisited := current[0], current[1], current[2]
        
        // Check if we reached the target
        if row == m-1 && col == n-1 {
            return cellsVisited
        }
        
        // Try all possible jumps in the same row
        for nextCol := 0; nextCol < n; nextCol++ {
            if nextCol != col && !visited[row][nextCol] {
                visited[row][nextCol] = true
                queue = append(queue, [3]int{row, nextCol, cellsVisited + 1})
            }
        }
        
        // Try all possible jumps in the same column
        for nextRow := 0; nextRow < m; nextRow++ {
            if nextRow != row && !visited[nextRow][col] {
                visited[nextRow][col] = true
                queue = append(queue, [3]int{nextRow, col, cellsVisited + 1})
            }
        }
    }
    
    return -1 // Should not reach here for valid inputs
}
```

## Complexity Analysis

- **Time**: O(m * n * (m + n)) where m and n are the dimensions of the grid
  - Each cell can be visited once
  - For each cell, we might explore O(m + n) possible jumps
- **Space**: O(m * n) for the visited array and queue

## Link

[LeetCode 2617 Minimum Number of Visited Cells in a Grid](https://leetcode.com/problems/minimum-number-of-visited-cells-in-a-grid/)