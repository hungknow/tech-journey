# 2953 Count Complete Substrings

## Problem Description

A string is **complete** if each character appears exactly the same number of times in the string.

You are given a string `s` and an integer `k`. Return the number of complete substrings of `s`.

A substring is a contiguous sequence of characters within the string.

### Example 1:
```
Input: s = "igigee", k = 2
Output: 3
Explanation: The complete substrings are "ig", "ig", "ee".
```

### Example 2:
```
Input: s = "aaabbbccc", k = 3
Output: 6
Explanation: The complete substrings are "aaa", "bbb", "ccc", "aaabbb", "aaabbbccc", "bbbccc".
```

### Example 3:
```
Input: s = "abc", k = 1
Output: 3
Explanation: The complete substrings are "a", "b", "c".
```

## Solution

This problem asks us to count the number of substrings where each character appears exactly `k` times. This is a sliding window problem combined with frequency counting.

### Approach

1. First, we need to identify all possible substrings that could be complete.
2. For each possible substring length (which must be a multiple of `k`), we check if the substring is complete.
3. A substring of length `n*k` is complete if it contains exactly `n` distinct characters, each appearing exactly `k` times.

The key insight is that a complete substring must have:
- Length that is a multiple of `k`
- Exactly `length/k` distinct characters
- Each character appearing exactly `k` times

We can use a sliding window approach to check all possible substrings:

1. For each possible window size that is a multiple of `k` (from `k` to `len(s)`):
2. Use a sliding window to check all substrings of that size
3. For each window, count the frequency of characters and check if it's complete

### Code

```go
func countCompleteSubstrings(s string, k int) int {
    n := len(s)
    result := 0
    
    // Check all possible substring lengths that are multiples of k
    for length := k; length <= n; length += k {
        // Number of distinct characters needed for this length
        distinct := length / k
        
        // Use sliding window to check all substrings of this length
        freq := make(map[byte]int)
        
        // Initialize the first window
        for i := 0; i < length; i++ {
            freq[s[i]]++
        }
        
        // Check if the first window is complete
        if isComplete(freq, distinct, k) {
            result++
        }
        
        // Slide the window
        for i := length; i < n; i++ {
            // Remove the leftmost character
            freq[s[i-length]]--
            if freq[s[i-length]] == 0 {
                delete(freq, s[i-length])
            }
            
            // Add the new character
            freq[s[i]]++
            
            // Check if the current window is complete
            if isComplete(freq, distinct, k) {
                result++
            }
        }
    }
    
    return result
}

func isComplete(freq map[byte]int, distinct, k int) bool {
    if len(freq) != distinct {
        return false
    }
    
    for _, count := range freq {
        if count != k {
            return false
        }
    }
    
    return true
}
```

### Complexity Analysis

- **Time Complexity**: O(n^2) - For each possible substring length (O(n)), we check all substrings of that length (O(n))
- **Space Complexity**: O(1) - The frequency map has at most 26 entries (for lowercase English letters)

## Link

[LeetCode 2953 Count Complete Substrings](https://leetcode.com/problems/count-complete-substrings/)