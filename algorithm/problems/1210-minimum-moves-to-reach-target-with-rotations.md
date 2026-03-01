# 1210 Minimum Moves to Reach Target with Rotations

## Problem Description

In an `n x n` grid, there is a snake that occupies 2 cells. The snake can be in either horizontal or vertical orientation.

The snake starts at position `[[0, 0], [0, 1]]` (horizontal orientation) and wants to reach position `[[n-1, n-2], [n-1, n-1]]`.

The snake can perform the following moves:
1. Move right/down by 1 cell (both parts move together)
2. Rotate clockwise around the lower-right cell (if the 2x2 area is clear)
3. Rotate counter-clockwise around the upper-left cell (if the 2x2 area is clear)

The grid contains obstacles marked as 1, and empty cells marked as 0.

Return the minimum number of moves required to reach the target, or -1 if impossible.

### Example 1:
```
Input: grid = [[0,0,0,0,0,1],
               [1,1,0,0,1,0],
               [0,0,0,0,1,0],
               [0,1,0,0,1,0],
               [0,1,0,0,1,0],
               [0,0,0,0,0,0]]
Output: 11
```

### Example 2:
```
Input: grid = [[0,0,1,1,1,1],
               [0,0,0,0,1,1],
               [1,1,0,0,0,1],
               [1,1,1,0,0,1],
               [1,1,1,0,0,1],
               [1,1,1,0,0,0]]
Output: 9
```

## Approach

This problem can be solved using BFS with state tracking:

1. **State Representation**:
   - Each state is ((tail_row, tail_col), (head_row, head_col))
   - Track both positions of the snake

2. **BFS Traversal**:
   - Start from the initial position
   - Generate all possible next states (moves and rotations)
   - Track visited states to avoid cycles

3. **Move Generation**:
   - Regular moves: shift both parts in the same direction
   - Rotations: check if 2x2 area is clear for rotation

## Solution Code

```go
func minimumMoves(grid [][]int) int {
    n := len(grid)
    if n == 0 {
        return -1
    }
    
    // State: (tail_row, tail_col, head_row, head_col)
    start := [4]int{0, 0, 0, 1}
    target := [4]int{n - 1, n - 2, n - 1, n - 1}
    
    // BFS setup
    queue := [][4]int{start}
    visited := make(map[[4]int]bool)
    visited[start] = true
    moves := 0
    
    // Directions: up, down, left, right
    dirs := [][2]int{{-1, 0}, {1, 0}, {0, -1}, {0, 1}}
    
    for len(queue) > 0 {
        levelSize := len(queue)
        
        for i := 0; i < levelSize; i++ {
            current := queue[0]
            queue = queue[1:]
            
            tailRow, tailCol, headRow, headCol := current[0], current[1], current[2], current[3]
            
            // Check if we reached the target
            if current == target {
                return moves
            }
            
            // Try all four directions
            for _, dir := range dirs {
                newTailRow, newTailCol := tailRow+dir[0], tailCol+dir[1]
                newHeadRow, newHeadCol := headRow+dir[0], headCol+dir[1]
                
                // Check bounds and obstacles
                if newTailRow >= 0 && newTailRow < n && newTailCol >= 0 && newTailCol < n &&
                   newHeadRow >= 0 && newHeadRow < n && newHeadCol >= 0 && newHeadCol < n &&
                   grid[newTailRow][newTailCol] == 0 && grid[newHeadRow][newHeadCol] == 0 {
                    
                    newState := [4]int{newTailRow, newTailCol, newHeadRow, newHeadCol}
                    if !visited[newState] {
                        visited[newState] = true
                        queue = append(queue, newState)
                    }
                }
            }
            
            // Try rotations if snake is horizontal
            if tailRow == headRow {
                // Clockwise rotation
                if tailRow+1 < n && grid[tailRow+1][tailCol] == 0 && grid[headRow+1][headCol] == 0 {
                    newState := [4]int{tailRow, tailCol, tailRow+1, tailCol}
                    if !visited[newState] {
                        visited[newState] = true
                        queue = append(queue, newState)
                    }
                }
                
                // Counter-clockwise rotation
                if tailRow-1 >= 0 && grid[tailRow-1][tailCol] == 0 && grid[headRow-1][headCol] == 0 {
                    newState := [4]int{tailRow-1, tailCol, tailRow, tailCol}
                    if !visited[newState] {
                        visited[newState] = true
                        queue = append(queue, newState)
                    }
                }
            }
            
            // Try rotations if snake is vertical
            if tailCol == headCol {
                // Clockwise rotation
                if tailCol+1 < n && grid[tailRow][tailCol+1] == 0 && grid[headRow][headCol+1] == 0 {
                    newState := [4]int{tailRow, tailCol, tailRow, tailCol+1}
                    if !visited[newState] {
                        visited[newState] = true
                        queue = append(queue, newState)
                    }
                }
                
                // Counter-clockwise rotation
                if tailCol-1 >= 0 && grid[tailRow][tailCol-1] == 0 && grid[headRow][headCol-1] == 0 {
                    newState := [4]int{tailRow, tailCol-1, tailRow, tailCol}
                    if !visited[newState] {
                        visited[newState] = true
                        queue = append(queue, newState)
                    }
                }
            }
        }
        
        moves++
    }
    
    return -1
}
```

## Complexity Analysis

- **Time**: O(n^2) where n is the dimension of the grid
  - Each state is processed at most once
  - There are O(n^2) possible states
- **Space**: O(n^2) for the visited set and queue

## Link

[LeetCode 1210 Minimum Moves to Reach Target with Rotations](https://leetcode.com/problems/minimum-moves-to-reach-target-with-rotations/)