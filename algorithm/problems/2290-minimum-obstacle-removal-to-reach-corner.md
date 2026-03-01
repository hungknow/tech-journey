# 2290 Minimum Obstacle Removal to Reach Corner

## Problem Description

You are given a `m x n` grid where each cell contains:
- `0`: empty cell
- `1`: obstacle

You start at `(0, 0)` and want to reach `(m-1, n-1)`. You can remove obstacles at a cost of 1 each.

Return the minimum number of obstacles you need to remove to reach the target.

### Example 1:
```
Input: grid = [[0,1,1],[1,1,0],[1,0,0]]
Output: 2
```

### Example 2:
```
Input: grid = [[0,1,0,0,0],[0,1,0,1,0],[0,0,0,1,0]]
Output: 0
```

## Approach

This problem can be solved using 0-1 BFS (Dijkstra with binary costs):

1. **Graph Representation**:
   - Each cell is a node
   - Edge weight is 0 if moving to empty cell, 1 if removing obstacle

2. **0-1 BFS**:
   - Use a deque instead of a priority queue
   - Add to front if cost is 0, add to back if cost is 1
   - This gives O(V + E) time complexity

3. **Cost Tracking**:
   - Track minimum obstacles removed to reach each cell
   - Early terminate when reaching the target

## Solution Code

```go
func minimumObstacles(grid [][]int) int {
    m, n := len(grid), len(grid[0])
    
    // Directions: up, down, left, right
    dirs := [][2]int{{-1, 0}, {1, 0}, {0, -1}, {0, 1}}
    
    // Cost matrix
    cost := make([][]int, m)
    for i := 0; i < m; i++ {
        cost[i] = make([]int, n)
        for j := 0; j < n; j++ {
            cost[i][j] = math.MaxInt32
        }
    }
    cost[0][0] = 0
    
    // 0-1 BFS using deque
    deque := [][3]int{{0, 0, 0}} // row, col, obstacles_removed
    
    for len(deque) > 0 {
        current := deque[0]
        deque = deque[1:]
        
        row, col, currentCost := current[0], current[1], current[2]
        
        // Check if we reached the target
        if row == m-1 && col == n-1 {
            return currentCost
        }
        
        // Skip if we already found a better path
        if currentCost > cost[row][col] {
            continue
        }
        
        // Try all four directions
        for _, dir := range dirs {
            newRow, newCol := row+dir[0], col+dir[1]
            
            if newRow >= 0 && newRow < m && newCol >= 0 && newCol < n {
                // Cost is 0 if empty cell, 1 if obstacle
                newCost := currentCost + grid[newRow][newCol]
                
                if newCost < cost[newRow][newCol] {
                    cost[newRow][newCol] = newCost
                    
                    if grid[newRow][newCol] == 0 {
                        // Add to front for 0 cost
                        deque = append([][3]int{{newRow, newCol, newCost}}, deque...)
                    } else {
                        // Add to back for 1 cost
                        deque = append(deque, [3]int{newRow, newCol, newCost})
                    }
                }
            }
        }
    }
    
    return cost[m-1][n-1]
}
```

## Complexity Analysis

- **Time**: O(m * n) where m and n are the dimensions of the grid
  - Each cell is processed at most once
  - 0-1 BFS provides linear time complexity
- **Space**: O(m * n) for the cost matrix and deque

## Link

[LeetCode 2290 Minimum Obstacle Removal to Reach Corner](https://leetcode.com/problems/minimum-obstacle-removal-to-reach-corner/)