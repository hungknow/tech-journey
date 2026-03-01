# 1631 Path With Minimum Effort

## Problem Description

You are given a 2D grid `heights` where `heights[i][j]` represents the height of cell (i, j).

A path between two cells is a sequence of 4-directionally adjacent cells.

The effort of a path is defined as the maximum absolute difference in heights between two consecutive cells in the path.

Find a path from the top-left cell (0, 0) to the bottom-right cell (m-1, n-1) with minimum effort.

Return the minimum effort required to travel from the top-left cell to the bottom-right cell.

### Example 1:
```
Input: heights = [[1,2,2],[3,8,2],[5,3,5]]
Output: 2
Explanation: The path of minimum effort is [1,2,2,2,5] with effort 2.
```

### Example 2:
```
Input: heights = [[1,2,3],[3,8,4],[5,3,5]]
Output: 1
Explanation: The path of minimum effort is [1,2,3,4,5] with effort 1.
```

## Approach

This problem can be solved using binary search combined with BFS/DFS:

1. **Binary Search on Effort**: Binary search the minimum effort value.

2. **Feasibility Check**: For each effort value, check if there's a path from start to end where the height difference between adjacent cells doesn't exceed the effort.

3. **BFS/DFS for Path Finding**: Use BFS or DFS to find if a path exists with the given effort constraint.

## Solution Code

```go
func minimumEffortPath(heights [][]int) int {
    m, n := len(heights), len(heights[0])
    
    // Binary search on effort
    left, right := 0, 1000000 // Maximum possible height difference
    result := right
    
    for left <= right {
        mid := (left + right) / 2
        
        if canReachEnd(heights, mid) {
            result = mid
            right = mid - 1
        } else {
            left = mid + 1
        }
    }
    
    return result
}

func canReachEnd(heights [][]int, maxEffort int) bool {
    m, n := len(heights), len(heights[0])
    visited := make([][]bool, m)
    for i := range visited {
        visited[i] = make([]bool, n)
    }
    
    queue := [][2]int{{0, 0}}
    visited[0][0] = true
    
    dirs := [][2]int{{-1, 0}, {1, 0}, {0, -1}, {0, 1}}
    
    for len(queue) > 0 {
        front := queue[0]
        queue = queue[1:]
        
        i, j := front[0], front[1]
        
        if i == m-1 && j == n-1 {
            return true
        }
        
        for _, dir := range dirs {
            ni, nj := i+dir[0], j+dir[1]
            
            if ni >= 0 && ni < m && nj >= 0 && nj < n && !visited[ni][nj] {
                if abs(heights[ni][nj]-heights[i][j]) <= maxEffort {
                    visited[ni][nj] = true
                    queue = append(queue, [2]int{ni, nj})
                }
            }
        }
    }
    
    return false
}

func abs(x int) int {
    if x < 0 {
        return -x
    }
    return x
}
```

## Complexity Analysis

- **Time**: O(log(maxHeight) × m × n) where m and n are the grid dimensions
  - Binary search: O(log(maxHeight))
  - BFS for each binary search iteration: O(m × n)
- **Space**: O(m × n) for the visited array and queue

## Link

[LeetCode 1631 Path With Minimum Effort](https://leetcode.com/problems/path-with-minimum-effort/)