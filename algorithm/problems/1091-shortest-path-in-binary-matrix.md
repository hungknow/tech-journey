# 1091 Shortest Path in Binary Matrix

## Problem Description

You are given an `n x n` binary matrix `grid`. In each step, you can move to any of the 8 adjacent cells (including diagonals).

A path is valid if:
- The starting cell is `(0, 0)` and the ending cell is `(n-1, n-1)`
- All cells on the path have value `0`
- The path length is the number of cells visited

Return the length of the shortest clear path from `(0, 0)` to `(n-1, n-1)`. If no such path exists, return -1.

### Example 1:
```
Input: grid = [[0,1],[1,0]]
Output: 2
```

### Example 2:
```
Input: grid = [[0,0,0],[1,1,0],[1,1,0]]
Output: 4
```

## Approach

This problem can be solved using BFS to find the shortest path:

1. **BFS Traversal**:
   - Start BFS from `(0, 0)` if it's a valid starting point
   - Move in all 8 directions (including diagonals)
   - Track visited cells to avoid cycles

2. **Path Length Tracking**:
   - Each BFS level represents one step in the path
   - Increment path length for each level

3. **Early Termination**: When we reach the target cell, return the current path length

## Solution Code

```go
func shortestPathBinaryMatrix(grid [][]int) int {
    n := len(grid)
    if n == 0 {
        return -1
    }
    
    // Check if start or end is blocked
    if grid[0][0] == 1 || grid[n-1][n-1] == 1 {
        return -1
    }
    
    // Check if start is the same as end
    if n == 1 {
        return 1
    }
    
    // Directions: 8 directions (including diagonals)
    dirs := [][2]int{
        {-1, -1}, {-1, 0}, {-1, 1},
        {0, -1},           {0, 1},
        {1, -1},  {1, 0},  {1, 1},
    }
    
    // BFS setup
    queue := [][2]int{{0, 0}}
    visited := make([][]bool, n)
    for i := 0; i < n; i++ {
        visited[i] = make([]bool, n)
    }
    visited[0][0] = true
    pathLength := 1
    
    for len(queue) > 0 {
        levelSize := len(queue)
        
        for i := 0; i < levelSize; i++ {
            current := queue[0]
            queue = queue[1:]
            
            row, col := current[0], current[1]
            
            // Check if we reached the target
            if row == n-1 && col == n-1 {
                return pathLength
            }
            
            // Explore all 8 directions
            for _, dir := range dirs {
                newRow, newCol := row+dir[0], col+dir[1]
                
                // Check bounds and if cell is valid
                if newRow >= 0 && newRow < n && newCol >= 0 && newCol < n &&
                   grid[newRow][newCol] == 0 && !visited[newRow][newCol] {
                    visited[newRow][newCol] = true
                    queue = append(queue, [2]int{newRow, newCol})
                }
            }
        }
        
        pathLength++
    }
    
    return -1
}
```

## Complexity Analysis

- **Time**: O(n^2) where n is the dimension of the grid
  - Each cell is processed at most once
  - For each cell, we check up to 8 neighbors
- **Space**: O(n^2) for the visited array and queue

## Link

[LeetCode 1091 Shortest Path in Binary Matrix](https://leetcode.com/problems/shortest-path-in-binary-matrix/)