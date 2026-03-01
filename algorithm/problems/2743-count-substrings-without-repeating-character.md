# 2743 Count Substrings Without Repeating Character

## Problem Description

You are given a string `s`. Return the number of substrings in `s` that do not contain any repeating character.

A substring is a contiguous sequence of characters within a string.

### Example 1:
```
Input: s = "abcabc"
Output: 15
Explanation: All substrings except "aa" and "bb" are counted.
```

### Example 2:
```
Input: s = "aa"
Output: 3
Explanation: The substrings are "a", "a", "aa".
```

## Approach

This problem can be solved using a sliding window approach:

1. Use a sliding window to maintain a substring with all unique characters.
2. Use a hash set to track the characters in the current window.
3. Expand the window to the right, adding the current character to the set.
4. If the current character is already in the set, shrink the window from the left until the character is no longer in the set.
5. For each valid window, all substrings ending at the current position and starting from any position within the window are valid.
6. Sum these values for all positions to get the total count.

## Solution Code

```go
func countSubstringWithoutRepeating(s string) int {
    n := len(s)
    result := 0
    
    for i := 0; i < n; i++ {
        seen := make(map[byte]bool)
        for j := i; j < n; j++ {
            if seen[s[j]] {
                break
            }
            seen[s[j]] = true
            result++
        }
    }
    
    return result
}
```

## Complexity Analysis

- **Time**: O(n^2) - For each position, we might check all subsequent characters
- **Space**: O(1) - We only use a constant amount of extra space for the character set

## Link

[LeetCode 2743 Count Substrings Without Repeating Character](https://leetcode.com/problems/count-substrings-without-repeating-character/)