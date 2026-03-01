# 0773 Sliding Puzzle

## Problem Description

You are given a 2x3 board representing a sliding puzzle. The board contains tiles numbered 1-6 and one empty space (represented as 0).

You can move a tile adjacent to the empty space into the empty space. The goal is to reach the board state `[[1,2,3],[4,5,0]]`.

Return the minimum number of moves required to solve the puzzle, or -1 if it's impossible.

### Example 1:
```
Input: board = [[1,2,3],[4,0,5]]
Output: 1
```

### Example 2:
```
Input: board = [[1,2,3],[5,4,0]]
Output: -1
```

## Approach

This problem can be solved using BFS to find the shortest path in the state space:

1. **State Representation**:
   - Convert the 2x3 board to a string for easy hashing
   - Track the position of the empty space (0)

2. **BFS Traversal**:
   - Start BFS from the initial board state
   - For each state, generate all possible next states by moving adjacent tiles
   - Track visited states to avoid cycles

3. **Early Termination**: When we reach the target state, return the current distance

## Solution Code

```go
func slidingPuzzle(board [][]int) int {
    // Convert board to string representation
    start := ""
    zeroPos := 0
    for i := 0; i < 2; i++ {
        for j := 0; j < 3; j++ {
            start += string(board[i][j] + '0')
            if board[i][j] == 0 {
                zeroPos = i*3 + j
            }
        }
    }
    
    target := "123450"
    
    // Check if already solved
    if start == target {
        return 0
    }
    
    // BFS setup
    queue := []string{start}
    visited := make(map[string]bool)
    visited[start] = true
    moves := 0
    
    // Possible moves for each position
    directions := map[int][]int{
        0: {1, 3},
        1: {0, 2, 4},
        2: {1, 5},
        3: {0, 4},
        4: {1, 3, 5},
        5: {2, 4},
    }
    
    for len(queue) > 0 {
        levelSize := len(queue)
        
        for i := 0; i < levelSize; i++ {
            current := queue[0]
            queue = queue[1:]
            
            // Check if we reached the target
            if current == target {
                return moves
            }
            
            // Find position of 0
            zeroPos = 0
            for i := 0; i < 6; i++ {
                if current[i] == '0' {
                    zeroPos = i
                    break
                }
            }
            
            // Generate all possible next states
            for _, nextPos := range directions[zeroPos] {
                // Swap 0 with adjacent tile
                nextState := []byte(current)
                nextState[zeroPos], nextState[nextPos] = nextState[nextPos], nextState[zeroPos]
                nextStateStr := string(nextState)
                
                if !visited[nextStateStr] {
                    visited[nextStateStr] = true
                    queue = append(queue, nextStateStr)
                }
            }
        }
        
        moves++
    }
    
    return -1
}
```

## Complexity Analysis

- **Time**: O(6! * 6) where 6! is the total number of possible states (720)
  - Each state is processed at most once
  - For each state, we generate up to 4 possible next states
- **Space**: O(6!) for the visited set and queue

## Link

[LeetCode 0773 Sliding Puzzle](https://leetcode.com/problems/sliding-puzzle/)