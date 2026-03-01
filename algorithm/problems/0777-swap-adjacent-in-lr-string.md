# 0777 Swap Adjacent in LR String

## Problem Description

In a string composed of `'L'`, `'R'`, and `'X'` characters, like `"RXXLRXRXL"`, a move consists of either replacing one occurrence of `"XL"` with `"LX"`, or replacing one occurrence of `"RX"` with `"XR"`. Given the starting string `start` and the ending string `end`, return `true` if and only if there exists a sequence of moves to transform `start` to `end`.

### Example 1:
```
Input: start = "RXXLRXRXL", end = "XRLXXRRLX"
Output: true
Explanation: We can transform start to end following these steps:
RXXLRXRXL ->
XRXLRXRXL ->
XRLXRXRXL ->
XRLXXRRXL ->
XRLXXRRLX
```

### Example 2:
```
Input: start = "X", end = "L"
Output: false
```

### Example 3:
```
Input: start = "LLR", end = "RRL"
Output: false
```

## Approach

This problem can be solved using a two-pointer approach. Here's the key insight:

1. The relative order of 'L' and 'R' characters must be the same in both strings.
2. 'L' can only move to the left (swap with 'X'), so its position in `end` must be less than or equal to its position in `start`.
3. 'R' can only move to the right (swap with 'X'), so its position in `end` must be greater than or equal to its position in `start`.

We can use two pointers to traverse both strings simultaneously:
- Skip all 'X' characters in both strings
- Compare the non-'X' characters:
  - If they're different, return false
  - If it's 'L' and the position in `end` is greater than in `start`, return false
  - If it's 'R' and the position in `end` is less than in `start`, return false

## Solution Code

```go
func canTransform(start string, end string) bool {
    n := len(start)
    if n != len(end) {
        return false
    }
    
    i, j := 0, 0
    
    for i < n || j < n {
        // Skip 'X' in start
        for i < n && start[i] == 'X' {
            i++
        }
        
        // Skip 'X' in end
        for j < n && end[j] == 'X' {
            j++
        }
        
        // Check if both pointers are at the end
        if i == n && j == n {
            return true
        }
        
        // Check if only one pointer is at the end
        if (i == n) != (j == n) {
            return false
        }
        
        // Check if characters are different
        if start[i] != end[j] {
            return false
        }
        
        // Check movement constraints
        if start[i] == 'L' && i < j {
            return false
        }
        if start[i] == 'R' && i > j {
            return false
        }
        
        i++
        j++
    }
    
    return true
}
```

## Complexity Analysis

- **Time**: O(n) - We traverse both strings once
- **Space**: O(1) - We only use a few pointers regardless of the input size

## Link

[LeetCode 0777 Swap Adjacent in LR String](https://leetcode.com/problems/swap-adjacent-in-lr-string/)