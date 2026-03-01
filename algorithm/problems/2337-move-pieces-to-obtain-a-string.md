# 2337 Move Pieces to Obtain a String

## Problem Description

You are given two strings `start` and `target`, both of length `n`. Each string consists only of the characters 'L', 'R', and '_' where '_' represents an empty space.

You want to transform `start` into `target`. In one move, you can move any character 'L' or 'R' to any adjacent empty space '_'.

Return `true` if it is possible to transform `start` into `target`, otherwise return `false`.

### Example 1:
```
Input: start = "_L__R__R_", target = "L______RR"
Output: true
Explanation: We can move the first 'L' to the left, and the first 'R' to the right to get the target.
```

### Example 2:
```
Input: start = "R_L_", target = "__LR"
Output: false
Explanation: The 'R' cannot move to the left to match the target.
```

## Approach

This problem can be solved using a two-pointer approach:

1. First, remove all '_' characters from both strings to get the sequences of 'L' and 'R'.
2. If the sequences are different, it's impossible to transform, return false.
3. Use two pointers to traverse the sequences:
   - For each 'L' in `start`, its position in `target` must be less than or equal to its position in `start`.
   - For each 'R' in `start`, its position in `target` must be greater than or equal to its position in `start`.
4. If all these conditions are satisfied, return true.

## Solution Code

```go
func canChange(start string, target string) bool {
    // Extract the positions of 'L' and 'R' in both strings
    var startPieces, targetPieces []struct {
        char byte
        pos  int
    }
    
    for i, c := range start {
        if c != '_' {
            startPieces = append(startPieces, struct {
                char byte
                pos  int
            }{c, i})
        }
    }
    
    for i, c := range target {
        if c != '_' {
            targetPieces = append(targetPieces, struct {
                char byte
                pos  int
            }{c, i})
        }
    }
    
    // If the number of pieces is different, impossible
    if len(startPieces) != len(targetPieces) {
        return false
    }
    
    // Check each corresponding piece
    for i := 0; i < len(startPieces); i++ {
        if startPieces[i].char != targetPieces[i].char {
            return false
        }
        
        // For 'L', it can only move left (position in target <= position in start)
        if startPieces[i].char == 'L' && targetPieces[i].pos > startPieces[i].pos {
            return false
        }
        
        // For 'R', it can only move right (position in target >= position in start)
        if startPieces[i].char == 'R' && targetPieces[i].pos < startPieces[i].pos {
            return false
        }
    }
    
    return true
}
```

## Complexity Analysis

- **Time**: O(n) - We traverse both strings once
- **Space**: O(n) - We store the positions of 'L' and 'R' in both strings

## Link

[LeetCode 2337 Move Pieces to Obtain a String](https://leetcode.com/problems/move-pieces-to-obtain-a-string/)