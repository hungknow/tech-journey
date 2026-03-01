# 0317 Shortest Distance from All Buildings

## Problem Description

You are given a `m x n` grid where:
- `0` represents an empty land
- `1` represents a building
- `2` represents an obstacle

You want to build a house on an empty land. The house must have the shortest distance from all buildings.

Return the minimum distance sum to all buildings. If it's impossible to build such a house, return `-1`.

### Example 1:
```
Input: grid = [[1,0,2,0,1],[0,0,0,0,0],[0,0,1,0,0]]
Output: 7
```

### Example 2:
```
Input: grid = [[1,0],[0,0]]
Output: 1
```

## Approach

This problem can be solved using BFS from each building:

1. **Multi-source BFS**:
   - For each building, perform BFS to calculate distances to all empty lands
   - Accumulate distances for each empty land
   - Track how many buildings can reach each empty land

2. **Distance Calculation**:
   - For each building, use BFS to find reachable empty lands
   - Update distance sum and count for each empty land

3. **Result Calculation**:
   - Find the minimum distance sum among empty lands reachable from all buildings
   - If no such empty land exists, return -1

## Solution Code

```go
func shortestDistance(grid [][]int) int {
    if len(grid) == 0 || len(grid[0]) == 0 {
        return -1
    }
    
    m, n := len(grid), len(grid[0])
    buildings := 0
    
    // Count buildings
    for i := 0; i < m; i++ {
        for j := 0; j < n; j++ {
            if grid[i][j] == 1 {
                buildings++
            }
        }
    }
    
    // Distance sum and reach count for each empty land
    distanceSum := make([][]int, m)
    reachCount := make([][]int, m)
    for i := 0; i < m; i++ {
        distanceSum[i] = make([]int, n)
        reachCount[i] = make([]int, n)
    }
    
    // Directions: up, down, left, right
    dirs := [][2]int{{-1, 0}, {1, 0}, {0, -1}, {0, 1}}
    
    // BFS from each building
    for i := 0; i < m; i++ {
        for j := 0; j < n; j++ {
            if grid[i][j] == 1 {
                // BFS from this building
                visited := make([][]bool, m)
                for k := 0; k < m; k++ {
                    visited[k] = make([]bool, n)
                }
                
                queue := [][3]int{{i, j, 0}} // row, col, distance
                visited[i][j] = true
                
                for len(queue) > 0 {
                    cell := queue[0]
                    queue = queue[1:]
                    
                    for _, dir := range dirs {
                        newRow, newCol := cell[0]+dir[0], cell[1]+dir[1]
                        
                        // Check bounds and if cell is empty land and not visited
                        if newRow >= 0 && newRow < m && newCol >= 0 && newCol < n && 
                           grid[newRow][newCol] == 0 && !visited[newRow][newCol] {
                            visited[newRow][newCol] = true
                            distance := cell[2] + 1
                            
                            // Update distance sum and reach count
                            distanceSum[newRow][newCol] += distance
                            reachCount[newRow][newCol]++
                            
                            queue = append(queue, [3]int{newRow, newCol, distance})
                        }
                    }
                }
            }
        }
    }
    
    // Find the minimum distance sum among empty lands reachable from all buildings
    minDistance := math.MaxInt32
    for i := 0; i < m; i++ {
        for j := 0; j < n; j++ {
            if grid[i][j] == 0 && reachCount[i][j] == buildings {
                if distanceSum[i][j] < minDistance {
                    minDistance = distanceSum[i][j]
                }
            }
        }
    }
    
    if minDistance == math.MaxInt32 {
        return -1
    }
    
    return minDistance
}
```

## Complexity Analysis

- **Time**: O(k * m * n) where k is the number of buildings, m and n are grid dimensions
  - For each building, we perform BFS which takes O(m * n)
- **Space**: O(m * n) for distance sum, reach count, and visited arrays

## Link

[LeetCode 0317 Shortest Distance from All Buildings](https://leetcode.com/problems/shortest-distance-from-all-buildings/)