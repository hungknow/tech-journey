# 1234 Replace the Substring for Balanced String

## Problem Description

You are given a string `s` containing only `'Q'`, `'W'`, `'E'`, and `'R'`.

A string is balanced if each character appears `n/4` times, where `n` is the length of the string.

Return the minimum length of the substring that can be replaced with any string of the same length to make `s` balanced.

### Example 1:
```
Input: s = "QWER"
Output: 0
Explanation: s is already balanced.
```

### Example 2:
```
Input: s = "QQWE"
Output: 1
Explanation: We need to replace one 'Q' with 'R' to make the string balanced.
```

### Example 3:
```
Input: s = "QQQW"
Output: 2
Explanation: We need to replace two 'Q's with 'E' and 'R' to make the string balanced.
```

## Approach

This problem can be solved using a sliding window approach:

1. First, count the frequency of each character in the string.
2. Calculate the target frequency for each character, which is `n/4`.
3. Use a sliding window to find the smallest window that, when replaced, can make the entire string balanced.
4. For each window, check if the characters outside the window can be balanced within the target frequency.

## Solution Code

```go
func balancedString(s string) int {
    n := len(s)
    target := n / 4
    
    // Count the frequency of each character
    count := make(map[byte]int)
    for i := 0; i < n; i++ {
        count[s[i]]++
    }
    
    // Check if the string is already balanced
    if count['Q'] == target && count['W'] == target && count['E'] == target && count['R'] == target {
        return 0
    }
    
    // Sliding window approach
    left := 0
    minLen := n
    
    for right := 0; right < n; right++ {
        // Include current character in the window
        count[s[right]]--
        
        // Check if the remaining characters outside the window can be balanced
        for left <= right && count['Q'] <= target && count['W'] <= target && count['E'] <= target && count['R'] <= target {
            // Update the minimum window length
            minLen = min(minLen, right-left+1)
            
            // Try to shrink the window from the left
            count[s[left]]++
            left++
        }
    }
    
    return minLen
}

func min(a, b int) int {
    if a < b {
        return a
    }
    return b
}
```

## Complexity Analysis

- **Time**: O(n) - We traverse the string once with the sliding window
- **Space**: O(1) - We only use a constant amount of extra space for the character counts

## Link

[LeetCode 1234 Replace the Substring for Balanced String](https://leetcode.com/problems/replace-the-substring-for-balanced-string/)