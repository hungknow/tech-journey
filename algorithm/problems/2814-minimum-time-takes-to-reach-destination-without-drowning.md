# 2814 Minimum Time Takes to Reach Destination Without Drowning

## Problem Description

You are given a grid representing a river where:
- `0`: land
- `1`: water

You start at `(0, 0)` and want to reach `(m-1, n-1)`. The water level rises by 1 every time unit.

You can move to adjacent cells (up, down, left, right). You can only stand on land or water if the current time is less than the water level at that cell.

Return the minimum time to reach the destination, or -1 if impossible.

### Example 1:
```
Input: grid = [[0,1,0,0,0],[0,1,0,1,0],[0,0,0,0,0]]
Output: 6
```

### Example 2:
```
Input: grid = [[0,1],[1,0]]
Output: -1
```

## Approach

This problem can be solved using BFS with time tracking:

1. **State Representation**:
   - Each state is (row, col, time)
   - Track the current time and water level

2. **BFS with Time**:
   - Start BFS from (0, 0, 0)
   - For each state, check if current cell is safe
   - Generate next states with time + 1

3. **Safety Check**:
   - A cell is safe if it's land or if water level < current time
   - Early terminate when reaching destination

## Solution Code

```go
func minimumTime(grid [][]int) int {
    m, n := len(grid), len(grid[0])
    
    // Directions: up, down, left, right
    dirs := [][2]int{{-1, 0}, {1, 0}, {0, -1}, {0, 1}}
    
    // BFS setup: state is (row, col, time)
    queue := [][3]int{{0, 0, 0}}
    visited := make([][]int, m)
    for i := 0; i < m; i++ {
        visited[i] = make([]int, n)
        for j := 0; j < n; j++ {
            visited[i][j] = math.MaxInt32
        }
    }
    visited[0][0] = 0
    
    for len(queue) > 0 {
        current := queue[0]
        queue = queue[1:]
        
        row, col, time := current[0], current[1], current[2]
        
        // Check if we reached the destination
        if row == m-1 && col == n-1 {
            return time
        }
        
        // Explore neighbors
        for _, dir := range dirs {
            newRow, newCol := row+dir[0], col+dir[1]
            newTime := time + 1
            
            if newRow >= 0 && newRow < m && newCol >= 0 && newCol < n {
                // Check if the cell is safe at newTime
                if grid[newRow][newCol] == 0 {
                    // Land is always safe
                    if visited[newRow][newCol] > newTime {
                        visited[newRow][newCol] = newTime
                        queue = append(queue, [3]int{newRow, newCol, newTime})
                    }
                } else {
                    // Water is safe only if newTime <= water level
                    if newTime <= grid[newRow][newCol] && visited[newRow][newCol] > newTime {
                        visited[newRow][newCol] = newTime
                        queue = append(queue, [3]int{newRow, newCol, newTime})
                    }
                }
            }
        }
    }
    
    return -1
}
```

## Complexity Analysis

- **Time**: O(m * n) where m and n are the dimensions of the grid
  - Each cell can be visited at most once
  - For each cell, we explore 4 neighbors
- **Space**: O(m * n) for the visited array and queue

## Link

[LeetCode 2814 Minimum Time Takes to Reach Destination Without Drowning](https://leetcode.com/problems/minimum-time-takes-to-reach-destination-without-drowning/)