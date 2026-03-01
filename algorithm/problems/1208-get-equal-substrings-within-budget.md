# 1208 Get Equal Substrings Within Budget

## Problem Description

You are given two strings `s` and `t` of the same length and an integer `maxCost`.

You want to change `s` to `t`. Changing the i-th character of `s` to i-th character of `t` costs `|s[i] - t[i]|` (the difference between the ASCII values of the characters).

Return the maximum length of a substring of `s` that can be changed to `t` such that the cost does not exceed `maxCost`.

### Example 1:
```
Input: s = "abcd", t = "bcdf", maxCost = 3
Output: 3
Explanation: "abc" of s can be changed to "bcd" with a cost of 3.
The cost of changing "abc" to "bcd" is |'a'-'b'| + |'b'-'c'| + |'c'-'d'| = 1 + 1 + 1 = 3.
```

### Example 2:
```
Input: s = "abcd", t = "cdef", maxCost = 3
Output: 1
Explanation: Each character in s costs 2 to change to the corresponding character in t.
We can only change one character, so the answer is 1.
```

### Example 3:
```
Input: s = "abcd", t = "acde", maxCost = 0
Output: 1
Explanation: We cannot change any character, so the answer is 1 (the empty substring).
```

## Approach

This problem can be solved using a sliding window approach:

1. First, calculate the cost array where `cost[i] = |s[i] - t[i]|`.
2. Use a sliding window to find the longest subarray with sum ≤ `maxCost`.
3. For each position, expand the window as much as possible while keeping the sum ≤ `maxCost`.
4. If the sum exceeds `maxCost`, shrink the window from the left until the sum is ≤ `maxCost` again.

## Solution Code

```go
func equalSubstring(s string, t string, maxCost int) int {
    n := len(s)
    left := 0
    currentCost := 0
    maxLen := 0
    
    for right := 0; right < n; right++ {
        // Add the cost of changing s[right] to t[right]
        currentCost += abs(int(s[right]) - int(t[right]))
        
        // If the cost exceeds maxCost, shrink the window from the left
        for currentCost > maxCost {
            currentCost -= abs(int(s[left]) - int(t[left]))
            left++
        }
        
        // Update the maximum length
        maxLen = max(maxLen, right-left+1)
    }
    
    return maxLen
}

func abs(x int) int {
    if x < 0 {
        return -x
    }
    return x
}

func max(a, b int) int {
    if a > b {
        return a
    }
    return b
}
```

## Complexity Analysis

- **Time**: O(n) - We traverse the strings once with the sliding window
- **Space**: O(1) - We only use a few variables regardless of the input size

## Link

[LeetCode 1208 Get Equal Substrings Within Budget](https://leetcode.com/problems/get-equal-substrings-within-budget/)