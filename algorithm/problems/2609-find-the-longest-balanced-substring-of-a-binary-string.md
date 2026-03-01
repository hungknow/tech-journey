# 2609 Find the Longest Balanced Substring of a Binary String

## Problem Description

You are given a binary string `s`. A substring of `s` is called **balanced** if it contains an equal number of `'0'`s and `'1'`s.

Return the length of the longest balanced substring of `s`.

### Example 1:
```
Input: s = "01000111"
Output: 6
Explanation: The longest balanced substring is "010001".
```

### Example 2:
```
Input: s = "00111"
Output: 4
Explanation: The longest balanced substring is "0011".
```

### Example 3:
```
Input: s = "1111"
Output: 0
```

## Solution

The problem asks us to find the longest substring with equal number of 0's and 1's. This is a classic two-pointer problem where we can use a sliding window approach.

### Approach

1. We'll use a sliding window approach with two pointers, `left` and `right`.
2. For each window, we'll keep track of the count of 0's and 1's.
3. If the counts are equal, we update our answer with the window size.
4. If the window is not balanced, we need to move the `left` pointer to try to find a balanced window.

However, a more efficient approach is to iterate through all possible substrings and check if they are balanced:

1. For each starting index `i`, iterate through all ending indices `j`.
2. Keep track of the count of 0's and 1's in the current substring.
3. If the counts are equal, update the maximum length found.

This approach has a time complexity of O(n^2), which is acceptable given the constraints.

### Code

```go
func findTheLongestBalancedSubstring(s string) int {
    maxLen := 0
    n := len(s)
    
    for i := 0; i < n; i++ {
        zeros, ones := 0, 0
        for j := i; j < n; j++ {
            if s[j] == '0' {
                zeros++
            } else {
                ones++
            }
            
            if zeros == ones {
                maxLen = max(maxLen, j-i+1)
            }
        }
    }
    
    return maxLen
}

func max(a, b int) int {
    if a > b {
        return a
    }
    return b
}
```

### Complexity Analysis

- **Time Complexity**: O(n^2) - We check all possible substrings
- **Space Complexity**: O(1) - We only use constant extra space

## Link

[LeetCode 2609 Find the Longest Balanced Substring of a Binary String](https://leetcode.com/problems/find-the-longest-balanced-substring-of-a-binary-string/)