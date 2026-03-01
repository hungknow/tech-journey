# 1358 Number of Substrings Containing All Three Characters

## Problem Description

Given a string `s` consisting only of characters 'a', 'b', and 'c', return the number of substrings containing all three characters at least once.

### Example 1:
```
Input: s = "abcabc"
Output: 10
Explanation: The substrings containing "a", "b", and "c" are:
"abc", "abca", "abcab", "abcabc", "bca", "bcab", "bcabc", "cab", "cabc", "abc"
```

### Example 2:
```
Input: s = "aaacb"
Output: 3
Explanation: The substrings containing "a", "b", and "c" are:
"aaacb", "aacb", "acb"
```

### Example 3:
```
Input: s = "abc"
Output: 1
```

## Approach

This problem can be solved using a sliding window approach:

1. Use a sliding window to maintain a count of each character ('a', 'b', 'c') in the current window.
2. Expand the window to the right until it contains all three characters.
3. Once the window contains all three characters, all substrings ending at the current position and starting from any position before or at the left boundary of the window will contain all three characters.
4. Add the number of valid substrings to the result and continue expanding the window.

## Solution Code

```go
func numberOfSubstrings(s string) int {
    n := len(s)
    count := make(map[byte]int)
    left := 0
    result := 0
    
    for right := 0; right < n; right++ {
        // Add current character to the window
        count[s[right]]++
        
        // While the window contains all three characters
        for count['a'] > 0 && count['b'] > 0 && count['c'] > 0 {
            // All substrings ending at right and starting from any position <= left
            // will contain all three characters
            result += n - right
            
            // Try to shrink the window from the left
            count[s[left]]--
            left++
        }
    }
    
    return result
}
```

## Complexity Analysis

- **Time**: O(n) - We traverse the string once with the sliding window
- **Space**: O(1) - We only use a constant amount of extra space for the character counts

## Link

[LeetCode 1358 Number of Substrings Containing All Three Characters](https://leetcode.com/problems/number-of-substrings-containing-all-three-characters/)