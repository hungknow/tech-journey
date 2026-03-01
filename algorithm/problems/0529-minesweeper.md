# 0529 Minesweeper

## Problem Description

You are given an `m x n` character matrix `board` representing the game board where:
- `'M'` represents an unrevealed mine
- `'E'` represents an unrevealed empty square
- `'B'` represents a revealed blank square that has no adjacent mines (i.e., above, below, left, right, and all 4 diagonally adjacent squares)
- Digit (`'1'` to `'8'`) represents how many mines are adjacent to this revealed square
- `'X'` represents a revealed mine

You are also given a list of integers `clicks` where `clicks[i] = [ri, ci]` indicates that the ith click was on the cell `(ri, ci)`.

Return the board after revealing the specified cells according to the following rules:
1. If a mine `'M'` is revealed, change it to `'X'` and stop.
2. If an empty square `'E'` with no adjacent mines is revealed, change it to `'B'` and recursively reveal all adjacent unrevealed squares.

### Example 1:
```
Input: board = [["E","E","E","E","E"],["E","E","M","E"],["E","E","E","E"],["E","E","E","E"]], clicks = [[3,0]]
Output: [["B","1","E","1"],["B","1","M","1"],["B","1","1","1"],["B","1","1","1"]]
```

### Example 2:
```
Input: board = [["B","1","E","1"],["B","1","M","1"],["B","1","1","1"],["B","1","1","1"]], clicks = [[1,2]]
Output: [["B","1","E","1"],["B","1","X","1"],["B","1","1","1"],["B","1","1","1"]]
```

## The Twist

Clicking on an empty cell triggers a **flood fill** to reveal all connected empty cells. We need to handle this recursively while counting adjacent mines for non-empty cells.

## Algorithm

### BFS/DFS Flood Fill:
1. For each click:
   - If mine, set to 'X' and return
   - If already revealed, skip
   - If empty, perform BFS/DFS to reveal all connected empty cells
2. For non-empty cells, count adjacent mines and display count
3. Return the modified board

### Mine Counting:
- For each cell, check all 8 neighbors
- Count how many are mines ('M')

## Complexity

- **Time**: O(m * n) - each cell visited at most once
- **Space**: O(m * n) - worst case for BFS/DFS stack

## Link

[LeetCode 0529 Minesweeper](https://leetcode.com/problems/minesweeper/)
