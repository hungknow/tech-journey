# 2503 Maximum Number of Points from Grid Queries

## Problem Description

You are given an `m x n` grid where each cell has a value. You are also given queries where each query is `[r1, c1, r2, c2]` representing a rectangular region.

For each query, return the maximum number of points you can collect by starting at any cell within the query rectangle and moving to adjacent cells (up, down, left, right), collecting the value of each visited cell exactly once.

### Example 1:
```
Input: grid = [[1,2,3],[4,5,6],[7,8,9]], queries = [[1,1,2,2],[0,0,1,1]]
Output: [24,12]
```

### Example 2:
```
Input: grid = [[5,2,1],[1,2,3]], queries = [[0,0,1,1]]
Output: [16]
```

## Approach

This problem can be solved using BFS for each query:

1. **Query Processing**:
   - For each query, identify the rectangular region
   - Find the maximum value cell within the region as starting point

2. **BFS Traversal**:
   - Start BFS from the maximum value cell
   - Collect values from adjacent cells
   - Track visited cells to avoid cycles

3. **Optimization**:
   - Precompute prefix sums to quickly find maximum in regions
   - Use memoization for overlapping queries

## Solution Code

```go
func maxPoints(grid [][]int, queries [][]int) []int {
    m, n := len(grid), len(grid[0])
    result := make([]int, len(queries))
    
    // Precompute prefix sums for efficient region queries
    prefix := make([][]int, m+1)
    for i := 0; i <= m; i++ {
        prefix[i] = make([]int, n+1)
    }
    
    for i := 0; i < m; i++ {
        for j := 0; j < n; j++ {
            prefix[i+1][j+1] = grid[i][j] + prefix[i][j+1] + prefix[i+1][j] - prefix[i][j]
        }
    }
    
    // Process each query
    for i, query := range queries {
        r1, c1, r2, c2 := query[0], query[1], query[2], query[3]
        
        // Find the cell with maximum value in the query region
        maxVal := 0
        maxRow, maxCol := r1, c1
        
        for row := r1; row <= r2; row++ {
            for col := c1; col <= c2; col++ {
                if grid[row][col] > maxVal {
                    maxVal = grid[row][col]
                    maxRow, maxCol = row, col
                }
            }
        }
        
        // BFS from the maximum value cell
        result[i] = bfs(grid, maxRow, maxCol)
    }
    
    return result
}

func bfs(grid [][]int, startRow, startCol int) int {
    m, n := len(grid), len(grid[0])
    
    // Directions: up, down, left, right
    dirs := [][2]int{{-1, 0}, {1, 0}, {0, -1}, {0, 1}}
    
    queue := [][2]int{{startRow, startCol}}
    visited := make([][]bool, m)
    for i := 0; i < m; i++ {
        visited[i] = make([]bool, n)
    }
    visited[startRow][startCol] = true
    
    total := 0
    
    for len(queue) > 0 {
        current := queue[0]
        queue = queue[1:]
        
        row, col := current[0], current[1]
        total += grid[row][col]
        
        // Explore neighbors
        for _, dir := range dirs {
            newRow, newCol := row+dir[0], col+dir[1]
            
            if newRow >= 0 && newRow < m && newCol >= 0 && newCol < n && !visited[newRow][newCol] {
                visited[newRow][newCol] = true
                queue = append(queue, [2]int{newRow, newCol})
            }
        }
    }
    
    return total
}
```

## Complexity Analysis

- **Time**: O(Q * (m * n)) where Q is the number of queries
  - For each query, we might scan the entire region and perform BFS
  - In the worst case, each query covers the entire grid
- **Space**: O(m * n) for the visited array and queue

## Link

[LeetCode 2503 Maximum Number of Points from Grid Queries](https://leetcode.com/problems/maximum-number-of-points-from-grid-queries/)