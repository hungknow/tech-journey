# 1568 Minimum Number of Days to Disconnect Island

## Problem Description

You are given a binary grid `grid` of size `m x n` where `1` represents land and `0` represents water. An island is a group of connected `1`s connected horizontally or vertically.

The grid is initially an island. You can remove exactly one land cell per day. Return the minimum number of days to disconnect the island (make it no longer an island).

If it's impossible to disconnect the island, return `-1`.

### Example 1:
```
Input: grid = [[0,1],[1,0]]
Output: 2
```

### Example 2:
```
Input: grid = [[1,1]]
Output: 1
```

### Example 3:
```
Input: grid = [[1,0,1,0]]
Output: -1
```

## Approach

This problem can be solved using articulation points (cut vertices) concept:

1. **Initial Check**: If the grid has only one land cell, return 1 (removing it disconnects the island).

2. **Find Articulation Points**: 
   - An articulation point is a land cell whose removal increases the number of connected components
   - Use DFS to find articulation points in the grid graph
   - For each land cell, check if it's an articulation point

3. **Result**: 
   - If we find any articulation point, return 1 (removing it disconnects the island)
   - If no articulation points found, return 2 (need to remove at least 2 cells)
   - If the island is too small to be disconnected, return -1

## Solution Code

```go
func minDays(grid [][]int) int {
    m, n := len(grid), len(grid[0])
    landCount := 0
    
    // Count total land cells and find the first land cell
    firstLand := [2]int{-1, -1}
    for i := 0; i < m; i++ {
        for j := 0; j < n; j++ {
            if grid[i][j] == 1 {
                landCount++
                if firstLand[0] == -1 {
                    firstLand = [2]int{i, j}
                }
            }
        }
    }
    
    if landCount == 1 {
        return 1
    }
    
    // Check if there's any articulation point
    if hasArticulationPoint(grid, firstLand[0], firstLand[1], m, n) {
        return 1
    }
    
    // If no articulation point found, check if we can disconnect with 2 removals
    if landCount <= 3 {
        return -1
    }
    
    return 2
}

func hasArticulationPoint(grid [][]int, startI, startJ, m, n int) bool {
    visited := make([][]bool, m)
    for i := range visited {
        visited[i] = make([]bool, n)
    }
    
    // DFS to find articulation points
    time := 0
    disc := make([][]int, m)
    low := make([][]int, m)
    parent := make([][]int, m)
    
    for i := range disc {
        disc[i] = make([]int, n)
        low[i] = make([]int, n)
        parent[i] = make([]int, n)
        for j := range disc[i] {
            parent[i][j] = -1
        }
    }
    
    var dfs func(i, j, pi, pj int) (bool, int)
    dfs = func(i, j, pi, pj int) (bool, int) {
        visited[i][j] = true
        time++
        disc[i][j] = time
        low[i][j] = time
        
        children := 0
        isArticulation := false
        
        // Check all 4 neighbors
        dirs := [][2]int{{-1, 0}, {1, 0}, {0, -1}, {0, 1}}
        for _, dir := range dirs {
            ni, nj := i+dir[0], j+dir[1]
            
            if ni >= 0 && ni < m && nj >= 0 && nj < n && grid[ni][nj] == 1 {
                if !visited[ni][nj] {
                    children++
                    parent[ni][nj] = i*n + j
                    
                    childIsArticulation, _ := dfs(ni, nj, i, j)
                    if childIsArticulation {
                        return true, 0
                    }
                    
                    low[i][j] = min(low[i][j], low[ni][nj])
                    
                    if pi != -1 && low[ni][nj] >= disc[i][j] {
                        isArticulation = true
                    }
                } else if ni != pi || nj != pj {
                    low[i][j] = min(low[i][j], disc[ni][nj])
                }
            }
        }
        
        if pi == -1 && children > 1 {
            isArticulation = true
        }
        
        return isArticulation, children
    }
    
    // Run DFS from the starting land cell
    isArticulation, _ := dfs(startI, startJ, -1, -1)
    
    return isArticulation
}

func min(a, b int) int {
    if a < b {
        return a
    }
    return b
}
```

## Complexity Analysis

- **Time**: O(m × n) where m and n are the grid dimensions
  - The DFS visits each land cell exactly once
- **Space**: O(m × n) for the visited, disc, low, and parent arrays

## Link

[LeetCode 1568 Minimum Number of Days to Disconnect Island](https://leetcode.com/problems/minimum-number-of-days-to-disconnect-island/)