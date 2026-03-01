# 2812 Find the Safest Path in a Grid

## Problem Description

You are given a `n x n` binary matrix `grid` where `grid[i][j] = 1` represents a cell containing a thief and `grid[i][j] = 0` represents an empty cell.

The safety factor of a path is defined as the minimum Manhattan distance from any cell on the path to the nearest thief.

Return the maximum safety factor of any path from cell `(0, 0)` to cell `(n-1, n-1)`. If no such path exists, return `-1`.

### Example 1:
```
Input: grid = [[0,0,0,1],[0,0,0,0],[0,0,0,0],[1,0,0,0]]
Output: 2
```

### Example 2:
```
Input: grid = [[0,1,1],[0,1,1],[0,0,0]]
Output: 1
```

## Approach

This problem can be solved using a combination of BFS and binary search:

1. **Precompute Distances**: Use BFS to compute the minimum distance from each cell to the nearest thief.

2. **Binary Search**: Use binary search to find the maximum safety factor:
   - For each candidate safety factor, check if there's a path using BFS
   - If a path exists, try a higher safety factor
   - If no path exists, try a lower safety factor

3. **Path Validation**: For each safety factor, perform BFS to check if a valid path exists.

## Solution Code

```go
func maximumSafenessFactor(grid [][]int) int {
    n := len(grid)
    
    // Step 1: Find all thieves and compute distances using multi-source BFS
    thieves := [][2]int{}
    for i := 0; i < n; i++ {
        for j := 0; j < n; j++ {
            if grid[i][j] == 1 {
                thieves = append(thieves, [2]int{i, j})
            }
        }
    }
    
    // Distance matrix
    dist := make([][]int, n)
    for i := 0; i < n; i++ {
        dist[i] = make([]int, n)
        for j := 0; j < n; j++ {
            dist[i][j] = math.MaxInt32
        }
    }
    
    // Multi-source BFS from all thieves
    queue := [][2]int{}
    for _, thief := range thieves {
        queue = append(queue, thief)
        dist[thief[0]][thief[1]] = 0
    }
    
    dirs := [][2]int{{-1, 0}, {1, 0}, {0, -1}, {0, 1}}
    
    for len(queue) > 0 {
        cell := queue[0]
        queue = queue[1:]
        
        for _, dir := range dirs {
            newRow, newCol := cell[0]+dir[0], cell[1]+dir[1]
            
            if newRow >= 0 && newRow < n && newCol >= 0 && newCol < n {
                if dist[newRow][newCol] > dist[cell[0]][cell[1]]+1 {
                    dist[newRow][newCol] = dist[cell[0]][cell[1]] + 1
                    queue = append(queue, [2]int{newRow, newCol})
                }
            }
        }
    }
    
    // Step 2: Binary search for maximum safety factor
    left, right := 0, n
    result := 0
    
    for left <= right {
        mid := left + (right-left)/2
        
        if canReachWithSafety(dist, mid) {
            result = mid
            left = mid + 1
        } else {
            right = mid - 1
        }
    }
    
    return result
}

func canReachWithSafety(dist [][]int, safety int) bool {
    n := len(dist)
    
    if dist[0][0] < safety || dist[n-1][n-1] < safety {
        return false
    }
    
    visited := make([][]bool, n)
    for i := 0; i < n; i++ {
        visited[i] = make([]bool, n)
    }
    
    queue := [][2]int{{0, 0}}
    visited[0][0] = true
    
    dirs := [][2]int{{-1, 0}, {1, 0}, {0, -1}, {0, 1}}
    
    for len(queue) > 0 {
        cell := queue[0]
        queue = queue[1:]
        
        if cell[0] == n-1 && cell[1] == n-1 {
            return true
        }
        
        for _, dir := range dirs {
            newRow, newCol := cell[0]+dir[0], cell[1]+dir[1]
            
            if newRow >= 0 && newRow < n && newCol >= 0 && newCol < n {
                if !visited[newRow][newCol] && dist[newRow][newCol] >= safety {
                    visited[newRow][newCol] = true
                    queue = append(queue, [2]int{newRow, newCol})
                }
            }
        }
    }
    
    return false
}
```

## Complexity Analysis

- **Time**: O(n² * log n) where n is the dimension of the grid
  - Multi-source BFS: O(n²)
  - Binary search with BFS: O(log n * n²)
- **Space**: O(n²) for the distance matrix and visited arrays

## Link

[LeetCode 2812 Find the Safest Path in a Grid](https://leetcode.com/problems/find-the-safest-path-in-a-grid/)