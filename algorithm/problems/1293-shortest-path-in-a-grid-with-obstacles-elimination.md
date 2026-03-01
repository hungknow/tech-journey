# 1293 Shortest Path in a Grid with Obstacles Elimination

## Problem Description

You are given an `m x n` grid where each cell can be:
- `0`: empty cell
- `1`: obstacle

You start at `(0, 0)` and want to reach `(m-1, n-1)`. You can eliminate at most `k` obstacles.

Return the shortest path length from start to target. If it's impossible, return -1.

### Example 1:
```
Input: grid = [[0,0,0],[1,1,0],[0,0,0],[0,1,1],[0,0,0]], k = 1
Output: 6
```

### Example 2:
```
Input: grid = [[0,1,1],[1,1,1],[1,0,0]], k = 1
Output: -1
```

## Approach

This problem can be solved using BFS with state tracking:

1. **State Representation**:
   - Each state is (row, col, obstacles_eliminated)
   - Track the number of obstacles eliminated so far

2. **BFS Traversal**:
   - Start BFS from (0, 0, 0)
   - For each state, move in four directions
   - If encountering an obstacle, increment the obstacle count

3. **State Validation**:
   - Only proceed if obstacles_eliminated ≤ k
   - Track visited states to avoid cycles

## Solution Code

```go
func shortestPath(grid [][]int, k int) int {
    m, n := len(grid), len(grid[0])
    
    // Edge case: if we can eliminate all obstacles, take direct path
    if k >= m+n-2 {
        return m + n - 2
    }
    
    // Directions: up, down, left, right
    dirs := [][2]int{{-1, 0}, {1, 0}, {0, -1}, {0, 1}}
    
    // BFS setup: state is (row, col, obstacles_eliminated)
    queue := [][3]int{{0, 0, 0}}
    visited := make([][]int, m)
    for i := 0; i < m; i++ {
        visited[i] = make([]int, n)
        for j := 0; j < n; j++ {
            visited[i][j] = math.MaxInt32
        }
    }
    visited[0][0] = 0
    steps := 0
    
    for len(queue) > 0 {
        levelSize := len(queue)
        
        for i := 0; i < levelSize; i++ {
            current := queue[0]
            queue = queue[1:]
            
            row, col, obstacles := current[0], current[1], current[2]
            
            // Check if we reached the target
            if row == m-1 && col == n-1 {
                return steps
            }
            
            // Explore all four directions
            for _, dir := range dirs {
                newRow, newCol := row+dir[0], col+dir[1]
                
                // Check bounds
                if newRow >= 0 && newRow < m && newCol >= 0 && newCol < n {
                    newObstacles := obstacles
                    
                    // If it's an obstacle, increment count
                    if grid[newRow][newCol] == 1 {
                        newObstacles++
                    }
                    
                    // Check if we can proceed and if this is a better state
                    if newObstacles <= k && newObstacles < visited[newRow][newCol] {
                        visited[newRow][newCol] = newObstacles
                        queue = append(queue, [3]int{newRow, newCol, newObstacles})
                    }
                }
            }
        }
        
        steps++
    }
    
    return -1
}
```

## Complexity Analysis

- **Time**: O(m * n * k) where m and n are the dimensions of the grid
  - Each cell can be visited up to k+1 times (once for each possible obstacle count)
- **Space**: O(m * n * k) for the visited array and queue

## Link

[LeetCode 1293 Shortest Path in a Grid with Obstacles Elimination](https://leetcode.com/problems/shortest-path-in-a-grid-with-obstacles-elimination/)