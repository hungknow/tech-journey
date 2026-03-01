# 0286 Walls and Gates

## Problem Description

You are given a `m x n` grid where:
- `-1` represents a wall or obstacle
- `0` represents a gate
- `INF` (2^31 - 1) represents an empty room

Fill each empty room with the distance to its nearest gate. If it is impossible to reach a gate, leave the room as `INF`.

### Example 1:
```
Input: rooms = [[2147483647,-1,0,2147483647],[2147483647,2147483647,2147483647,-1],[2147483647,-1,2147483647,-1],[0,-1,2147483647,2147483647]]
Output: [[3,-1,0,1],[2,2,1,-1],[1,-1,2,-1],[0,-1,3,4]]
```

## Approach

This problem can be solved using BFS starting from all gates simultaneously:

1. **Multi-source BFS**:
   - Find all gates (cells with value 0)
   - Add them to the queue as starting points
   - Perform BFS to fill distances

2. **Distance Calculation**:
   - For each cell, the distance is the distance from the nearest gate
   - Update empty rooms with the distance when first reached

3. **Early Termination**: Once all reachable cells are processed, we're done

## Solution Code

```go
func wallsAndGates(rooms [][]int) {
    if len(rooms) == 0 || len(rooms[0]) == 0 {
        return
    }
    
    m, n := len(rooms), len(rooms[0])
    INF := 2147483647
    
    // Find all gates and add to queue
    queue := [][2]int{}
    for i := 0; i < m; i++ {
        for j := 0; j < n; j++ {
            if rooms[i][j] == 0 {
                queue = append(queue, [2]int{i, j})
            }
        }
    }
    
    // Directions: up, down, left, right
    dirs := [][2]int{{-1, 0}, {1, 0}, {0, -1}, {0, 1}}
    
    // BFS from all gates
    for len(queue) > 0 {
        cell := queue[0]
        queue = queue[1:]
        
        for _, dir := range dirs {
            newRow, newCol := cell[0]+dir[0], cell[1]+dir[1]
            
            // Check bounds and if cell is empty room
            if newRow >= 0 && newRow < m && newCol >= 0 && newCol < n && rooms[newRow][newCol] == INF {
                // Update distance and add to queue
                rooms[newRow][newCol] = rooms[cell[0]][cell[1]] + 1
                queue = append(queue, [2]int{newRow, newCol})
            }
        }
    }
}
```

## Complexity Analysis

- **Time**: O(m * n) where m and n are the dimensions of the grid
  - Each cell is processed at most once
  - Multi-source BFS ensures optimal distance calculation
- **Space**: O(m * n) in the worst case for the queue (when all cells are gates)

## Link

[LeetCode 0286 Walls and Gates](https://leetcode.com/problems/walls-and-gates/)