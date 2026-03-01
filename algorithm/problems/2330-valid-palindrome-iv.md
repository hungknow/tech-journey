# 2330 Valid Palindrome IV

## Problem Description

You are given a string `s`. You can replace any character in `s` with any other character.

Return the minimum number of replacements needed to make `s` a palindrome.

A string is a palindrome if it reads the same forward and backward.

### Example 1:
```
Input: s = "abc"
Output: 1
Explanation: Replace 'b' with 'a' to get "aca", which is a palindrome.
```

### Example 2:
```
Input: s = "abcba"
Output: 0
Explanation: The string is already a palindrome.
```

## Approach

This problem can be solved using a two-pointer approach:

1. Use two pointers, one starting from the beginning (`left`) and one from the end (`right`) of the string.
2. Compare the characters at these pointers:
   - If they are the same, move both pointers inward.
   - If they are different, increment the replacement count and move both pointers inward.
3. The total number of replacements needed is the number of mismatched character pairs.

## Solution Code

```go
func minPalindromeCost(s string) int {
    left, right := 0, len(s)-1
    replacements := 0
    
    for left < right {
        if s[left] != s[right] {
            replacements++
        }
        left++
        right--
    }
    
    return replacements
}
```

## Complexity Analysis

- **Time**: O(n) - We traverse the string once with two pointers
- **Space**: O(1) - We only use a few pointers regardless of the input size

## Link

[LeetCode 2330 Valid Palindrome IV](https://leetcode.com/problems/valid-palindrome-iv/)