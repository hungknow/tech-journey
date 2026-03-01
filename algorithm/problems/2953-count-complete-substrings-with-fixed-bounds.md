# 2953 Count Complete Substrings With Fixed Bounds

## Problem Description

You are given a string `s` and two integers `minK` and `maxK`.

A substring is complete if it contains all characters and each character appears at least `minK` times and at most `maxK` times.

Return the number of complete substrings with fixed bounds.

### Example 1:
```
Input: s = "ababa", minK = 2, maxK = 3
Output: 2
Explanation: The complete substrings are "aba" and "bab", each character appears between 2 and 3 times.
```

### Example 2:
```
Input: s = "aaaa", minK = 1, maxK = 1
Output: 0
Explanation: No substring can satisfy the condition.
```

## Approach

This problem can be solved using a sliding window approach:

1. Use a sliding window to maintain a substring where each character appears between `minK` and `maxK` times.
2. Use a hash map to count the frequency of each character in the current window.
3. Expand the window to the right, adding the current character to the map.
4. If the current character's count exceeds `maxK`, shrink the window from the left until the count is at most `maxK`.
5. For each valid window, check if all characters appear between `minK` and `maxK` times.
6. If so, count it as a complete substring.

## Solution Code

```go
func countCompleteSubstrings(s string, minK int, maxK int) int {
    n := len(s)
    if n == 0 {
        return 0
    }
    
    result := 0
    
    for i := 0; i < n; i++ {
        freq := make(map[byte]int)
        
        // Expand the window to the right
        for j := i; j < n; j++ {
            freq[s[j]]++
            
            // If the current character's count exceeds maxK, shrink from the left
            for freq[s[i]] > maxK {
                freq[s[i]]--
                if freq[s[i]] == 0 {
                    delete(freq, s[i])
                }
                i++
            }
        }
        
        // Check if the current window is complete
        isComplete := true
        for _, count := range freq {
            if count < minK || count > maxK {
                isComplete = false
                break
            }
        }
        
        if isComplete {
            result++
        }
    }
    
    return result
}
```

## Complexity Analysis

- **Time**: O(n^2) - For each position, we might check all subsequent characters
- **Space**: O(k) - We store the frequency of at most maxK elements in the current window

## Link

[LeetCode 2953 Count Complete Substrings With Fixed Bounds](https://leetcode.com/problems/count-complete-substrings-with-fixed-bounds/)