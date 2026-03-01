# 2730 Find the Longest Semi-Repetitive Substring

## Problem Description

A string is **semi-repetitive** if there is at most one pair of adjacent characters that are the same.

Given a string `s`, return the length of the longest semi-repetitive substring of `s`.

### Example 1:
```
Input: s = "52233"
Output: 4
Explanation: The longest semi-repetitive substring is "5223".
```

### Example 2:
```
Input: s = "5494"
Output: 4
Explanation: The longest semi-repetitive substring is "5494".
```

### Example 3:
```
Input: s = "1111111"
Output: 2
Explanation: The longest semi-repetitive substring is "11".
```

## Solution

The problem asks us to find the longest substring that has at most one pair of adjacent identical characters. This is a sliding window problem where we need to keep track of the number of adjacent identical pairs.

### Approach

1. We'll use a sliding window approach with two pointers, `left` and `right`.
2. We'll keep track of the number of adjacent identical pairs in the current window.
3. If the count exceeds 1, we move the `left` pointer to reduce the count.
4. We update our answer with the maximum window size where the count is at most 1.

### Code

```go
func longestSemiRepetitiveSubstring(s string) int {
    maxLen := 0
    left := 0
    n := len(s)
    
    // Count of adjacent identical pairs in the current window
    pairs := 0
    
    for right := 1; right < n; right++ {
        // Check if current character is same as previous one
        if s[right] == s[right-1] {
            pairs++
        }
        
        // If we have more than 1 pair, move left pointer
        for pairs > 1 {
            if s[left] == s[left+1] {
                pairs--
            }
            left++
        }
        
        // Update the maximum length
        maxLen = max(maxLen, right-left+1)
    }
    
    // Handle the case of empty or single character string
    if n > 0 {
        maxLen = max(maxLen, 1)
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

- **Time Complexity**: O(n) - We iterate through the string once with the sliding window
- **Space Complexity**: O(1) - We only use constant extra space

## Link

[LeetCode 2730 Find the Longest Semi-Repetitive Substring](https://leetcode.com/problems/find-the-longest-semi-repetitive-substring/)