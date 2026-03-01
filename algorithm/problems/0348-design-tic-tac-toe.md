# 0348 Design Tic-Tac-Toe

## Problem Description

Assume the following rules are for the tic-tac-toe game on an n x n board between two players:

1. A move is guaranteed to be valid and is placed on an empty block.
2. Once a winning condition is reached, no more moves will be allowed.
3. A player who succeeds in placing n of their marks in a horizontal, vertical, or diagonal row wins the game.

Implement the `TicTacToe` class:

- `TicTacToe(int n)` Initializes the object the size of the board n.
- `int move(int row, int col, int player)` Indicates that the player with id `player` plays at the cell `(row, col)` of the board. The move is guaranteed to be a legal move.

Return `0` if there is no winner after the move, `1` if player 1 wins, or `2` if player 2 wins.

### Example 1:
```
Input
["TicTacToe", "move", "move", "move"]
[[3], [0, 0, 1], [0, 2, 2], [2, 2, 1]]
Output
[null, 0, 0, 1]

Explanation
TicTacToe ticTacToe = new TicTacToe(3);
Assume that player 1 is "X" and player 2 is "O" in the board.
ticTacToe.move(0, 0, 1); // return 0 (no one wins)
|X| | |
| | | |    // Player 1 makes a move at (0, 0).
| | | |

ticTacToe.move(0, 2, 2); // return 0 (no one wins)
|X| |O|
| | | |    // Player 2 makes a move at (0, 2).
| | | |

ticTacToe.move(2, 2, 1); // return 1 (player 1 wins)
|X| |O|
| | | |    // Player 1 makes a move at (2, 2).
| | |X|
```

## The Twist

Implementing a tic-tac-toe game that efficiently checks for winning conditions after each move without scanning the entire board.

## Algorithm

### Row/Column/Diagonal Counters Approach:
1. Use arrays to track the count of marks for each player in rows and columns
2. Use two variables to track the main and anti-diagonal counts
3. For each move:
   - Increment the count for the current player in the corresponding row and column
   - If the move is on a diagonal, update the diagonal counters
   - Check if any counter reaches n (winning condition)
4. Return the winner if found, otherwise return 0

The key insight is that we only need to track the count of marks in each row, column, and diagonal rather than storing the entire board state.

## Complexity

- **Time**: 
  - TicTacToe constructor: O(1)
  - move: O(1)
- **Space**: O(n) for the row and column counters

## Solution Code

```go
package main

type TicTacToe struct {
    rows    []int
    cols    []int
    diagonal int
    antiDiagonal int
    size    int
}

func Constructor(n int) TicTacToe {
    return TicTacToe{
        rows:         make([]int, n),
        cols:         make([]int, n),
        diagonal:     0,
        antiDiagonal: 0,
        size:         n,
    }
}

func (this *TicTacToe) Move(row int, col int, player int) int {
    // Player 1 is represented as +1, Player 2 as -1
    currentPlayer := 1
    if player == 2 {
        currentPlayer = -1
    }
    
    // Update row and column
    this.rows[row] += currentPlayer
    this.cols[col] += currentPlayer
    
    // Update diagonal if applicable
    if row == col {
        this.diagonal += currentPlayer
    }
    
    // Update anti-diagonal if applicable
    if row+col == this.size-1 {
        this.antiDiagonal += currentPlayer
    }
    
    // Check for win
    if abs(this.rows[row]) == this.size ||
       abs(this.cols[col]) == this.size ||
       abs(this.diagonal) == this.size ||
       abs(this.antiDiagonal) == this.size {
        return player
    }
    
    return 0
}

func abs(x int) int {
    if x < 0 {
        return -x
    }
    return x
}
```

## Link

[LeetCode 0348 Design Tic-Tac-Toe](https://leetcode.com/problems/design-tic-tac-toe/)