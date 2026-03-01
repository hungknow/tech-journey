# 1102 Path With Maximum Minimum Value

## Problem Description

You are given a 2D grid `grid` where `grid[i][j]` represents the value of cell (i, j).

A path from the top-left corner `(0, 0)` to the bottom-right corner `(m-1, n-1)` is valid if the minimum value along the path is maximized.

Return the maximum minimum value along the any path from the top-left to bottom-right corner.

### Example 1:
```
Input: grid = [[5,4,3,5],[4,1,2],[4,2,6]]
Output: 2
```

### Example 2:
```
Input: grid = [[3,2,1],[3,4,5,6]]
Output: 2
```

## Approach

This problem can be solved using binary search combined with BFS:

1. **Binary Search on Answer**: Binary search the minimum possible maximum value
2. **BFS with Path Validation**: For each candidate maximum value, use BFS to check if there's a path with all values >= candidate

## Solution Code

```go
func maximumMinimumPath(grid [][]int) int {
    m, n := len(grid), len(grid[0])
    
    left, right := 0, n-1
    low, high := 0, math.MinInt32
    
    // Binary search on the answer
    for low <= high {
        mid := (low + high) / 2
        
        if canReach(grid, left, right, mid) {
            high = mid
        } else {
            low = mid + 1
        }
    }
    
    return high
}

func canReach(grid [][]int, left, right, threshold int) bool {
    m, n := len(grid), len(grid[0])
    
    if left < 0 || left >= m || right < 0 || right >= n {
        return false
    }
    
    visited := make([][]bool, m)
    queue := [][2]int{{left, right}}
    visited[left][right] = true
    
    for len(queue) > 0 {
        current := queue[0]
        queue = queue[1:]
        
        if current[0] == right && current[1] == n-1 {
            return true
        }
        
        for _, dir := range [][2]int{{-1, 0}, {0, 1}, {0, -1}, {1, 0}} {
            ni, nj := current[0]+dir[0], current[1]+dir[1]
            
            if ni >= 0 && ni < m && nj >= 0 && nj < n && !visited[ni][nj] && grid[ni][nj] >= threshold {
                visited[ni][nj] = true
                queue = append(queue, [ni, nj])
            }
        }
    }
    
    return false
}
```

## Complexity Analysis

- **Time**: O(log(maxValue × m × n)) where m and n are the grid dimensions
  - Binary search: O(log(maxValue))
  - BFS for each candidate: O(m × n × maxValue)
- **Space**: O(m × n) for the visited array and queue

## Link

[LeetCode 1102 Path With Maximum Minimum Value](https://leetcode.com/problems/path-with-maximum-minimum-value/)