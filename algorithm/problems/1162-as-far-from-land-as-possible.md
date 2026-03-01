# 1162 As Far from Land as Possible

## Problem Description

You are given an `n x n` grid containing only `0`s (water) and `1`s (land). You can walk in four directions (up, down, left, right).

A cell is considered "far from land" if it is a water cell and the distance to the nearest land cell is maximized.

Return the maximum distance to the nearest land cell. If the grid contains only water or only land, return -1.

### Example 1:
```
Input: grid = [[1,0,1],[0,0,0],[1,0,1]]
Output: 2
```

### Example 2:
```
Input: grid = [[1,0,0],[0,0,0],[0,0,1]]
Output: 4
```

## Approach

This problem can be solved using multi-source BFS from all land cells:

1. **Multi-source BFS**:
   - Start BFS from all land cells simultaneously
   - Expand outward to water cells, calculating distances
   - The last water cell reached will have the maximum distance

2. **Distance Calculation**:
   - Each BFS level represents increasing distance from land
   - Track the distance for each water cell

3. **Edge Cases**: Handle grids with only water or only land

## Solution Code

```go
func maxDistance(grid [][]int) int {
    n := len(grid)
    if n == 0 {
        return -1
    }
    
    // Count land and water cells
    landCount := 0
    waterCount := 0
    
    // Collect all land cells for multi-source BFS
    queue := [][2]int{}
    
    for i := 0; i < n; i++ {
        for j := 0; j < n; j++ {
            if grid[i][j] == 1 {
                landCount++
                queue = append(queue, [2]int{i, j})
            } else {
                waterCount++
            }
        }
    }
    
    // Edge cases: all land or all water
    if landCount == 0 || waterCount == 0 {
        return -1
    }
    
    // Directions: up, down, left, right
    dirs := [][2]int{{-1, 0}, {1, 0}, {0, -1}, {0, 1}}
    
    // Multi-source BFS from all land cells
    distance := 0
    
    for len(queue) > 0 {
        levelSize := len(queue)
        
        for i := 0; i < levelSize; i++ {
            current := queue[0]
            queue = queue[1:]
            
            row, col := current[0], current[1]
            
            // Explore neighbors
            for _, dir := range dirs {
                newRow, newCol := row+dir[0], col+dir[1]
                
                // Check bounds and if cell is water
                if newRow >= 0 && newRow < n && newCol >= 0 && newCol < n && grid[newRow][newCol] == 0 {
                    grid[newRow][newCol] = 1 // Mark as visited (land)
                    queue = append(queue, [2]int{newRow, newCol})
                }
            }
        }
        
        if len(queue) > 0 {
            distance++
        }
    }
    
    return distance
}
```

## Complexity Analysis

- **Time**: O(n^2) where n is the dimension of the grid
  - Each cell is processed at most once
  - Multi-source BFS ensures optimal distance calculation
- **Space**: O(n^2) in the worst case for the queue (when all cells are land)

## Link

[LeetCode 1162 As Far from Land as Possible](https://leetcode.com/problems/as-far-from-land-as-possible/)