# 1263 Minimum Moves to Move a Box to Their Target Location

## Problem Description

You are given a grid with:
- `S`: player's starting position
- `B`: box's starting position
- `T`: target position
- `.`: empty cell
- `#`: obstacle

The player can move to adjacent cells (up, down, left, right). The player can push the box if the box is adjacent to the player and the cell behind the box is empty.

Return the minimum number of moves required to push the box to the target. If it's impossible, return -1.

### Example 1:
```
Input: grid = [["#","#","#","#","#","#"],
               ["#","T","#","#","#","#"],
               ["#",".",".","B",".","#"],
               ["#",".","#","#",".","#"],
               ["#",".",".",".","S","#"],
               ["#","#","#","#","#","#"]]
Output: 3
```

### Example 2:
```
Input: grid = [["#","#","#","#","#","#"],
               ["#","T",".",".","#","#"],
               ["#",".","#","B",".","#"],
               ["#",".",".",".",".","#"],
               ["#",".",".",".","S","#"],
               ["#","#","#","#","#","#"]]
Output: 5
```

## Approach

This problem can be solved using BFS with state tracking:

1. **State Representation**:
   - Each state is (player_row, player_col, box_row, box_col)
   - Track both player and box positions

2. **BFS Traversal**:
   - Start BFS from the initial state
   - For each state, generate all possible next states
   - Track visited states to avoid cycles

3. **Move Generation**:
   - Player can move to adjacent empty cells
   - Player can push the box if adjacent and the cell behind box is empty

## Solution Code

```go
func minPushBox(grid [][]byte) int {
    m, n := len(grid), len(grid[0])
    
    // Find initial positions
    var player, box, target [2]int
    for i := 0; i < m; i++ {
        for j := 0; j < n; j++ {
            if grid[i][j] == 'S' {
                player = [2]int{i, j}
            } else if grid[i][j] == 'B' {
                box = [2]int{i, j}
            } else if grid[i][j] == 'T' {
                target = [2]int{i, j}
            }
        }
    }
    
    // Directions: up, down, left, right
    dirs := [][2]int{{-1, 0}, {1, 0}, {0, -1}, {0, 1}}
    
    // BFS setup
    queue := [][4]int{{player[0], player[1], box[0], box[1]}}
    visited := make(map[[4]int]bool)
    visited[[4]int{player[0], player[1], box[0], box[1]}] = true
    moves := 0
    
    for len(queue) > 0 {
        levelSize := len(queue)
        
        for i := 0; i < levelSize; i++ {
            current := queue[0]
            queue = queue[1:]
            
            playerRow, playerCol, boxRow, boxCol := current[0], current[1], current[2], current[3]
            
            // Check if box reached target
            if boxRow == target[0] && boxCol == target[1] {
                return moves
            }
            
            // Try all four directions
            for _, dir := range dirs {
                newPlayerRow, newPlayerCol := playerRow+dir[0], playerCol+dir[1]
                
                // Check if player can move to new position
                if newPlayerRow >= 0 && newPlayerRow < m && newPlayerCol >= 0 && newPlayerCol < n &&
                   grid[newPlayerRow][newPlayerCol] != '#' {
                    
                    // If player moves to box position, check if box can be pushed
                    if newPlayerRow == boxRow && newPlayerCol == boxCol {
                        newBoxRow, newBoxCol := boxRow+dir[0], boxCol+dir[1]
                        
                        // Check if box can be pushed to new position
                        if newBoxRow >= 0 && newBoxRow < m && newBoxCol >= 0 && newBoxCol < n &&
                           grid[newBoxRow][newBoxCol] != '#' {
                            
                            newState := [4]int{newPlayerRow, newPlayerCol, newBoxRow, newBoxCol}
                            if !visited[newState] {
                                visited[newState] = true
                                queue = append(queue, newState)
                            }
                        }
                    } else {
                        // Player just moves without pushing box
                        newState := [4]int{newPlayerRow, newPlayerCol, boxRow, boxCol}
                        if !visited[newState] {
                            visited[newState] = true
                            queue = append(queue, newState)
                        }
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

- **Time**: O(m^2 * n^2) where m and n are the dimensions of the grid
  - Each state is processed at most once
  - There are O(m^2 * n^2) possible states
- **Space**: O(m^2 * n^2) for the visited set and queue

## Link

[LeetCode 1263 Minimum Moves to Move a Box to Their Target Location](https://leetcode.com/problems/minimum-moves-to-move-a-box-to-their-target-location/)