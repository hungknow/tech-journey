# 0882 Reachable Nodes In Subdivided Graph

## Problem Description

You are given a 5x5 grid `grid` where each cell contains either `0` (empty) or `1` (obstacle).

The grid is subdivided into smaller 1x1 cells. Each cell can be traversed in 4 directions.

You can move from one cell to an adjacent cell in one step.

Return the minimum number of steps to reach the bottom-right corner from the top-left corner `(0, 0)`. If it's impossible, return `-1`.

### Example 1:
```
Input: grid = [[0,0,1,0,1,0,1,0,0,1],[1,0,0,1,0,0,0],[1,0,0,0,0,0,1]]
Output: 3
```

## Approach

This problem can be solved using BFS with state tracking:

1. **BFS with State**: 
   - Track position and steps for each cell
   - Use a queue to process cells in BFS order
   - Mark visited cells to avoid revisiting

2. **Early Termination**: When reaching the target cell, return the steps

## Solution Code

```go
func shortestPath(grid [][]int) int {
    m, n := len(grid), len(grid[0])
    
    if m == 0 || n == 0 {
        return -1
    }
    
    // Directions: up, down, left, right, down
    dirs := [][2]int{{-1, 0}, {0, 1}, {0, -1}, {1, 0}}
    
    // Visited array
    visited := make([][]bool, m)
    
    // Queue for BFS
    queue := [][3]int{{0, 0, 0}}
    
    // Start from (0, 0)
    queue = append(queue, [0, 0, 0])
    visited[0][0] = true
    
    for len(queue) > 0 {
        current := queue[0]
        queue = queue[1:]
        
        // Check if reached target
        if current[0] == m-1 && current[1] == n-1 {
            return len(visited)
        }
        
        // Explore all 4 directions
        for _, dir := range dirs {
            ni, nj := current[0]+dir[0], current[1]+dir[1]
            
            if ni >= 0 && ni < m && nj >= 0 && nj < n && !visited[ni][nj] && grid[ni][nj] != 1 {
                visited[ni][nj] = true
                queue = append(queue, [ni, nj])
            }
        }
        
        steps++
    }
    
    return -1
}
```

## Complexity Analysis

- **Time**: O(m × n) where m and n are the grid dimensions
  - BFS visits each cell at most once
- **Space**: O(m × n) for the visited array and queue

## Link

[LeetCode 0882 Reachable Nodes In Subdivided Graph](https://leetcode.com/problems/reachable-nodes-in-subdivided-graph/)