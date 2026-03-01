# 1728 Cat and Mouse II

## Problem Description

A game is played on a grid where a cat and a mouse take turns moving. The grid contains:
- Walls marked as 1
- Empty cells marked as 0
- Cat starting position `cat`
- Mouse starting position `mouse`
- Food position `food`

The cat moves first and can move to any adjacent cell (including diagonally) except walls. The mouse can only move to adjacent cells (up, down, left, right).

The cat wins if it reaches the mouse or food. The mouse wins if it reaches the food.

If both play optimally, return the number of turns until the game ends, or -1 if the game continues indefinitely.

### Example 1:
```
Input: grid = [[1,1,1,1,1,1],[1,0,0,0,0,1],[1,0,2,0,0,1],[1,0,0,0,0,1],[1,1,1,1,1,1]]
cat = [3,2], mouse = [1,4], food = [2,2]
Output: 4
```

### Example 2:
```
Input: grid = [[1,1,1,1,1,1],[1,0,0,0,0,1],[1,0,2,0,0,1],[1,0,0,0,0,1],[1,1,1,1,1,1]]
cat = [3,2], mouse = [1,4], food = [2,2]
Output: 4
```

## Approach

This problem can be solved using BFS with game theory concepts:

1. **State Representation**:
   - Each state is (cat_row, cat_col, mouse_row, mouse_col, turn)
   - Turn alternates between cat (0) and mouse (1)

2. **BFS from Terminal States**:
   - Start from terminal states where the game is decided
   - Cat wins when cat reaches mouse or food
   - Mouse wins when mouse reaches food
   - Work backwards to determine the outcome of all states

3. **Game Theory Logic**:
   - If it's cat's turn and any move leads to cat win, current state is cat win
   - If all moves lead to mouse win, current state is mouse win
   - Otherwise, it's a draw

## Solution Code

```go
func catMouseGame(grid [][]int, catJump int, mouseJump int) int {
    m, n := len(grid), len(grid[0])
    
    // Find positions
    var cat, mouse, food [2]int
    for i := 0; i < m; i++ {
        for j := 0; j < n; j++ {
            if grid[i][j] == 1 {
                cat = [2]int{i, j}
            } else if grid[i][j] == 2 {
                mouse = [2]int{i, j}
            } else if grid[i][j] == 3 {
                food = [2]int{i, j}
            }
        }
    }
    
    // State: (cat_row, cat_col, mouse_row, mouse_col, turn)
    // turn: 0 = cat's turn, 1 = mouse's turn
    // Result: 0 = draw, 1 = cat win, 2 = mouse win
    
    // Initialize result and degree arrays
    result := make(map[[5]int]int)
    degree := make(map[[5]int]int)
    
    queue := [][5]int{}
    
    // Initialize terminal states
    for catRow := 0; catRow < m; catRow++ {
        for catCol := 0; catCol < n; catCol++ {
            for mouseRow := 0; mouseRow < m; mouseRow++ {
                for mouseCol := 0; mouseCol < n; mouseCol++ {
                    if grid[catRow][catCol] == 1 || grid[mouseRow][mouseCol] == 1 {
                        continue
                    }
                    
                    // Cat wins if cat reaches mouse or food
                    if catRow == mouseRow && catCol == mouseCol {
                        result[[5]int{catRow, catCol, mouseRow, mouseCol, 0}] = 1
                        result[[5]int{catRow, catCol, mouseRow, mouseCol, 1}] = 1
                        queue = append(queue, [5]int{catRow, catCol, mouseRow, mouseCol, 0})
                        queue = append(queue, [5]int{catRow, catCol, mouseRow, mouseCol, 1})
                    } else if catRow == food[0] && catCol == food[1] {
                        result[[5]int{catRow, catCol, mouseRow, mouseCol, 0}] = 1
                        result[[5]int{catRow, catCol, mouseRow, mouseCol, 1}] = 1
                        queue = append(queue, [5]int{catRow, catCol, mouseRow, mouseCol, 0})
                        queue = append(queue, [5]int{catRow, catCol, mouseRow, mouseCol, 1})
                    } else if mouseRow == food[0] && mouseCol == food[1] {
                        result[[5]int{catRow, catCol, mouseRow, mouseCol, 0}] = 2
                        result[[5]int{catRow, catCol, mouseRow, mouseCol, 1}] = 2
                        queue = append(queue, [5]int{catRow, catCol, mouseRow, mouseCol, 0})
                        queue = append(queue, [5]int{catRow, catCol, mouseRow, mouseCol, 1})
                    }
                }
            }
        }
    }
    
    // Calculate degrees
    for catRow := 0; catRow < m; catRow++ {
        for catCol := 0; catCol < n; catCol++ {
            for mouseRow := 0; mouseRow < m; mouseRow++ {
                for mouseCol := 0; mouseCol < n; mouseCol++ {
                    if grid[catRow][catCol] == 1 || grid[mouseRow][mouseCol] == 1 {
                        continue
                    }
                    
                    // Count possible moves for cat
                    catMoves := 0
                    for dr := -catJump; dr <= catJump; dr++ {
                        for dc := -catJump; dc <= catJump; dc++ {
                            if dr == 0 && dc == 0 {
                                continue
                            }
                            newCatRow, newCatCol := catRow+dr, catCol+dc
                            if newCatRow >= 0 && newCatRow < m && newCatCol >= 0 && newCatCol < n &&
                               grid[newCatRow][newCatCol] != 1 {
                                catMoves++
                            }
                        }
                    }
                    degree[[5]int{catRow, catCol, mouseRow, mouseCol, 0}] = catMoves
                    
                    // Count possible moves for mouse
                    mouseMoves := 0
                    for dr := -mouseJump; dr <= mouseJump; dr++ {
                        for dc := -mouseJump; dc <= mouseJump; dc++ {
                            if dr == 0 && dc == 0 {
                                continue
                            }
                            newMouseRow, newMouseCol := mouseRow+dr, mouseCol+dc
                            if newMouseRow >= 0 && newMouseRow < m && newMouseCol >= 0 && newMouseCol < n &&
                               grid[newMouseRow][newMouseCol] != 1 {
                                mouseMoves++
                            }
                        }
                    }
                    degree[[5]int{catRow, catCol, mouseRow, mouseCol, 1}] = mouseMoves
                }
            }
        }
    }
    
    // BFS
    turns := 0
    for len(queue) > 0 {
        levelSize := len(queue)
        
        for i := 0; i < levelSize; i++ {
            state := queue[0]
            queue = queue[1:]
            
            catRow, catCol, mouseRow, mouseCol, turn := state[0], state[1], state[2], state[3], state[4]
            currentResult := result[state]
            
            // Find parent states
            if turn == 0 { // Cat's turn, previous was mouse's turn
                for dr := -mouseJump; dr <= mouseJump; dr++ {
                    for dc := -mouseJump; dc <= mouseJump; dc++ {
                        if dr == 0 && dc == 0 {
                            continue
                        }
                        prevMouseRow, prevMouseCol := mouseRow+dr, mouseCol+dc
                        if prevMouseRow >= 0 && prevMouseRow < m && prevMouseCol >= 0 && prevMouseCol < n &&
                           grid[prevMouseRow][prevMouseCol] != 1 {
                            
                            parentState := [5]int{catRow, catCol, prevMouseRow, prevMouseCol, 1}
                            if result[parentState] == 0 {
                                if currentResult == 2 { // Mouse can force win
                                    result[parentState] = 2
                                    queue = append(queue, parentState)
                                } else {
                                    degree[parentState]--
                                    if degree[parentState] == 0 {
                                        result[parentState] = 1 // Cat wins
                                        queue = append(queue, parentState)
                                    }
                                }
                            }
                        }
                    }
                }
            } else { // Mouse's turn, previous was cat's turn
                for dr := -catJump; dr <= catJump; dr++ {
                    for dc := -catJump; dc <= catJump; dc++ {
                        if dr == 0 && dc == 0 {
                            continue
                        }
                        prevCatRow, prevCatCol := catRow+dr, catCol+dc
                        if prevCatRow >= 0 && prevCatRow < m && prevCatCol >= 0 && prevCatCol < n &&
                           grid[prevCatRow][prevCatCol] != 1 {
                            
                            parentState := [5]int{prevCatRow, prevCatCol, mouseRow, mouseCol, 0}
                            if result[parentState] == 0 {
                                if currentResult == 1 { // Cat can force win
                                    result[parentState] = 1
                                    queue = append(queue, parentState)
                                } else {
                                    degree[parentState]--
                                    if degree[parentState] == 0 {
                                        result[parentState] = 2 // Mouse wins
                                        queue = append(queue, parentState)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        
        turns++
        if turns > 1000 { // Prevent infinite loops
            break
        }
    }
    
    initialState := [5]int{cat[0], cat[1], mouse[0], mouse[1], 0}
    if result[initialState] == 0 {
        return -1
    }
    
    return result[initialState]
}
```

## Complexity Analysis

- **Time**: O(m^2 * n^2 * (catJump^2 + mouseJump^2)) where m and n are the dimensions of the grid
  - There are O(m^2 * n^2) possible states
  - For each state, we process O(catJump^2 + mouseJump^2) parent states
- **Space**: O(m^2 * n^2) for the result and degree arrays

## Link

[LeetCode 1728 Cat and Mouse II](https://leetcode.com/problems/cat-and-mouse-ii/)