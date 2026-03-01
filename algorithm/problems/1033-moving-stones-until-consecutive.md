# 1033 Moving Stones Until Consecutive

## Problem Description

There are three stones in different positions on a number line. You are given three integers `a`, `b`, and `c` representing the positions of the stones.

In each move, you can pick up a stone and move it to an unoccupied position. The move is valid if the stone is moved to a position that is adjacent to another stone.

Return the minimum number of moves to make the stones occupy consecutive positions, and the maximum number of moves to make the stones occupy consecutive positions.

### Example 1:
```
Input: a = 1, b = 2, c = 5
Output: [1, 2]
Explanation: Move the stone from 5 to 4, then to 3, making the positions [1, 2, 3].
Minimum moves: 1
Maximum moves: 2
```

### Example 2:
```
Input: a = 4, b = 3, c = 2
Output: [0, 0]
Explanation: The stones are already in consecutive positions.
```

### Example 3:
```
Input: a = 3, b = 5, c = 1
Output: [1, 2]
Explanation: Move the stone from 5 to 4, then to 3, making the positions [1, 2, 3].
Minimum moves: 1
Maximum moves: 2
```

## Approach

First, we need to sort the three positions to make them easier to work with. Let's call them `x`, `y`, and `z` where `x < y < z`.

For the minimum number of moves:
- If `z - x == 2`, the stones are already consecutive, so 0 moves.
- If `y - x <= 2` or `z - y <= 2`, we can move the farthest stone to be adjacent to the middle stone, so 1 move.
- Otherwise, we need at least 2 moves.

For the maximum number of moves:
- The maximum is simply `z - x - 2`, which represents the number of empty positions between the first and last stone.

## Solution Code

```go
func numMovesStones(a int, b int, c int) []int {
    // Sort the three positions
    stones := []int{a, b, c}
    sort.Ints(stones)
    x, y, z := stones[0], stones[1], stones[2]
    
    // Calculate minimum moves
    var minMoves int
    if z - x == 2 {
        // Already consecutive
        minMoves = 0
    } else if y - x <= 2 || z - y <= 2 {
        // Can make consecutive in one move
        minMoves = 1
    } else {
        // Need at least two moves
        minMoves = 2
    }
    
    // Calculate maximum moves
    maxMoves := z - x - 2
    
    return []int{minMoves, maxMoves}
}
```

## Complexity Analysis

- **Time**: O(1) - We perform a constant number of operations
- **Space**: O(1) - We only use a few variables regardless of the input size

## Link

[LeetCode 1033 Moving Stones Until Consecutive](https://leetcode.com/problems/moving-stones-until-consecutive/)