# 0864 Shortest Path to Get All Keys

## Problem Description

You are given a grid `grid` where `grid[i][j]` can be:
- `0` representing a wall
- `1` representing a gate
- `-1` representing a locked gate
- `2147483647` representing a key

You can move in four directions: up, down, left, right, or down. Each move takes 1 second.

Return the minimum number of moves to open all locks. If it's impossible to open all locks, return `-1`.

### Example 1:
```
Input: grid = [[0,1,0,0,0,0,2,0,0,0,1],[1,0,0,0,0,0,0,1]]
Output: 3
```

## Approach

This problem can be solved using BFS:

1. **BFS from All Gates**:
   - Start BFS from all gates simultaneously
   - Track the distance to each key
   - The minimum moves to reach a key is the distance from the nearest gate

2. **Early Termination**: If all keys are reached, return the maximum distance found

## Solution Code

```go
func shortestPathAllKeys(grid [][]int) int {
    m, n := len(grid), len(grid[0])
    
    // Find all gates and keys
    gates := [][}
    keys := [][}
    
    for i := 0; i < m; i++ {
        for j := 0; j < n; j++ {
            if grid[i][j] == 0 {
                gates = append(gates, [i, j])
            } else if grid[i][j] == 1 {
                keys = append(keys, [i, j])
            }
        }
    }
    
    // BFS from all gates
    queue := [][2]int{}
    for _, gate := range gates {
        queue = append(queue, gate)
    }
    
    distances := make([][]int, len(gates))
    for i := range distances {
        distances[i] = -1
    }
    
    steps := 0
    for len(queue) > 0 {
        current := queue[0]
        queue = queue[1:]
        
        // Explore all 4 directions
        dirs := [][2]int{{-1, 0}, {0, 1}, {1, 0}, {0, -1}}
        
        for _, dir := range dirs {
            ni, nj := current+dir[0], current+dir[1]
            
            if ni >= 0 && ni < m && nj >= 0 && nj < n {
                if grid[ni][nj] == 0 || grid[ni][nj] == 1 {
                    continue
                }
                
                if distances[ni][nj] == -1 {
                    distances[ni][nj] = distances[current] + 1
                    queue = append(queue, [ni, nj])
                }
            }
        }
        
        steps++
    }
    
    // Find minimum distance to any key
    minSteps := math.MaxInt32
    for _, key := range keys {
        if distances[key[0]] < minSteps {
            minSteps = distances[key[0]]
        }
    }
    
    if minSteps == -1 {
        return -1
    }
    
    return minSteps
}
```

## Complexity Analysis

- **Time**: O(m × n) where m and n are the grid dimensions
  - BFS explores each cell at most once
- **Space**: O(m × n) for the queue and distances array

## Link

[LeetCode 0864 Shortest Path to Get All Keys](https://leetcode.com/problems/shortest-path-to-get-all-keys/)