# 1368 Minimum Cost to Make at Least One Valid Path in a Grid

## Problem Description

You are given a `m x n` grid where each cell has a direction value:
- `1`: right (→)
- `2`: left (←)
- `3`: down (↓)
- `4`: up (↑)

A path is valid if you can follow the directions from `(0, 0)` to `(m-1, n-1)`.

You can change the direction of any cell at a cost of 1. Return the minimum cost to make at least one valid path from start to end.

### Example 1:
```
Input: grid = [[1,1,1,1],[2,2,2,2],[1,1,1,1],[2,2,2,2]]
Output: 3
```

### Example 2:
```
Input: grid = [[1,1,3],[3,2,2],[1,1,4]]
Output: 0
```

## Approach

This problem can be solved using 0-1 BFS (Dijkstra with binary costs):

1. **Graph Representation**:
   - Each cell is a node
   - Edge weight is 0 if moving in the current direction, 1 if changing direction

2. **0-1 BFS**:
   - Use a deque instead of a priority queue
   - Add to front if cost is 0, add to back if cost is 1
   - This gives O(V + E) time complexity

3. **Cost Tracking**:
   - Track minimum cost to reach each cell
   - Early terminate when reaching the target

## Solution Code

```go
func minCost(grid [][]int) int {
    m, n := len(grid), len(grid[0])
    
    // Directions: right, left, down, up
    dirs := [][2]int{{0, 1}, {0, -1}, {1, 0}, {-1, 0}}
    
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
    deque := [][3]int{{0, 0, 0}} // row, col, cost
    
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
        for dirIndex, dir := range dirs {
            newRow, newCol := row+dir[0], col+dir[1]
            
            if newRow >= 0 && newRow < m && newCol >= 0 && newCol < n {
                // Cost is 0 if moving in current direction, 1 otherwise
                newCost := currentCost
                if grid[row][col] != dirIndex+1 {
                    newCost++
                }
                
                if newCost < cost[newRow][newCol] {
                    cost[newRow][newCol] = newCost
                    
                    if newCost == currentCost {
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

[LeetCode 1368 Minimum Cost to Make at Least One Valid Path in a Grid](https://leetcode.com/problems/minimum-cost-to-make-at-least-one-valid-path-in-a-grid/)