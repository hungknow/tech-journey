# 0036 Valid Sudoku

## Problem Description

Determine if a 9 x 9 Sudoku board is valid. Only the filled cells need to be validated according to the following rules:

1. Each row must contain the digits 1-9 without repetition.
2. Each column must contain the digits 1-9 without repetition.
3. Each of the nine 3 x 3 sub-boxes of the grid must contain the digits 1-9 without repetition.

Note: A Sudoku board (partially filled) could be valid but is not necessarily solvable. Only the filled cells need to be validated.

### Example 1:
```
Input: board = 
[["5","3",".",".","7",".",".",".","."]
,["6",".",".","1","9","5",".",".","."]
,[".","9","8",".",".",".",".","6","."]
,["8",".",".",".","6",".",".",".","3"]
,["4",".",".","8",".","3",".",".","1"]
,["7",".",".",".","2",".",".",".","6"]
,[".","6",".",".",".",".","2","8","."]
,[".",".",".","4","1","9",".",".","5"]
,[".",".",".",".","8",".",".","7","9"]]
Output: true
```

### Example 2:
```
Input: board = 
[["8","3",".",".","7",".",".",".","."]
,["6",".",".","1","9","5",".",".","."]
,[".","9","8",".",".",".",".","6","."]
,["8",".",".",".","6",".",".",".","3"]
,["4",".",".","8",".","3",".",".","1"]
,["7",".",".",".","2",".",".",".","6"]
,[".","6",".",".",".",".","2","8","."]
,[".",".",".","4","1","9",".",".","5"]
,[".",".",".",".","8",".",".","7","9"]]
Output: false
Explanation: Same as Example 1, except with the 5 in the top left corner being changed to an 8.
Since there are two 8's in the top left 3x3 sub-box, it is invalid.
```

## The Twist

Validating **grid constraints**. We need to check three different types of constraints (rows, columns, and 3x3 boxes) simultaneously.

## Hash Table Usage

- **Key**: `formatted_string` like `"5 in row 3"`, `"5 in col 4"`, `"5 in block 1-1"`
- **Value**: `true` (or just use a set)

Algorithm:
1. Use three sets (or one combined set) to track seen numbers
2. For each filled cell (value != '.'):
   - Create row key: `f"{value} in row {row}"`
   - Create column key: `f"{value} in col {col}"`
   - Create block key: `f"{value} in block {row//3}-{col//3}"`
   - Check if any key already exists in the set
   - If yes, return false (duplicate found)
   - Otherwise, add all keys to the set
3. If we complete the loop, return true

## Complexity

- **Time**: O(9²) = O(1) - constant 81 cells
- **Space**: O(9²) = O(1) - constant space for tracking seen numbers

## Link

[LeetCode 0036 Valid Sudoku](https://leetcode.com/problems/valid-sudoku/)
