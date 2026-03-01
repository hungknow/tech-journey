# 2658 Maximum Number of Fish in a Grid

## Problem Description

You are given a `m x n` grid where each cell contains:
- `0`: empty water
- A positive integer: number of fish in that cell

You can start at any cell and can move to adjacent cells (up, down, left, right). You can only visit cells with fish once.

Return the maximum number of fish you can collect.

### Example 1:
```
Input: grid = [[0,2,1,0],[4,3,0,5],[1,0,2,0]]
Output: 10
```

### Example 2:
```
Input: grid = [[1,0,0],[0,1,0],[0,0,1]]
Output: 3
```

## Approach

This problem can be solved using BFS from each starting cell:

1. **Multi-source BFS**:
   - For each cell with fish, perform BFS to collect fish
   - Track visited cells to avoid revisiting
   - Calculate total fish collected

2. **Fish Collection**:
   - Start BFS from each non-empty cell
   - Collect fish from all reachable cells
   - Keep track of the maximum total

3. **Optimization**: Use memoization to avoid redundant calculations

## Solution Code

```go
func findMaxFish(grid [][]int) int {
    m, n := len(grid), len(grid[0])
    maxFish := 0
    
    // Directions: up, down, left, right
    dirs := [][2]int{{-1, 0}, {1, 0}, {0, -1}, {0, 1}}
    
    // Try starting from each cell with fish
    for i := 0; i < m; i++ {
        for j := 0; j < n; j++ {
            if grid[i][j] > 0 {
                // BFS from this cell
                visited := make([][]bool, m)
                for k := 0; k < m; k++ {
                    visited[k] = make([]bool, n)
                }
                
                queue := [][2]int{{i, j}}
                visited[i][j] = true
                currentFish := grid[i][j]
                
                for len(queue) > 0 {
                    current := queue[0]
                    queue = queue[1:]
                    
                    row, col := current[0], current[1]
                    
                    // Explore neighbors
                    for _, dir := range dirs {
                        newRow, newCol := row+dir[0], col+dir[1]
                        
                        if newRow >= 0 && newRow < m && newCol >= 0 && newCol < n &&
                           grid[newRow][newCol] > 0 && !visited[newRow][newCol] {
                            visited[newRow][newCol] = true
                            currentFish += grid[newRow][newCol]
                            queue = append(queue, [2]int{newRow, newCol})
                        }
                    }
                }
                
                if currentFish > maxFish {
                    maxFish = currentFish
                }
            }
        }
    }
    
    return maxFish
}
```

## Complexity Analysis

- **Time**: O(m * n * (m * n)) where m and n are the dimensions of the grid
  - For each cell with fish, we might perform BFS over the entire grid
  - In the worst case, this is O(m * n * (m * n))
- **Space**: O(m * n) for the visited array and queue

## Link

[LeetCode 2658 Maximum Number of Fish in a Grid](https://leetcode.com/problems/maximum-number-of-fish-in-a-grid/)