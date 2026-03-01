# 1297 Maximum Number of Occurrences of a Substring

## Problem Description

Given a string `s`, return the maximum number of occurrences of any substring of length `k`.

A substring is a contiguous sequence of characters within a string.

### Example 1:
```
Input: s = "ababcbab", k = 2
Output: 2
Explanation: Substrings of length 2 are "ab", "ba", "ab", "bc", "cb", "ba", "ab".
The maximum number of occurrences is 2 for "ab", "ba".
```

### Example 2:
```
Input: s = "aaaaa", k = 1
Output: 5
Explanation: Substrings of length 1 are "a", "a", "a", "a", "a".
The maximum number of occurrences is 5 for "a".
```

## Approach

This problem can be solved using a sliding window approach combined with a hash map to count occurrences:

1. Use a sliding window of size `k` to extract all substrings of length `k`.
2. Use a hash map to count the occurrences of each substring.
3. Return the maximum count from the hash map.

## Solution Code

```go
func maxFreq(s string, k int) int {
    n := len(s)
    if n < k {
        return 0
    }
    
    // Count occurrences of each substring of length k
    substringCount := make(map[string]int)
    
    for i := 0; i <= n-k; i++ {
        substring := s[i : i+k]
        substringCount[substring]++
    }
    
    // Find the maximum count
    maxCount := 0
    for _, count := range substringCount {
        if count > maxCount {
            maxCount = count
        }
    }
    
    return maxCount
}
```

## Complexity Analysis

- **Time**: O(n * k) - We extract n-k+1 substrings, each of length k
- **Space**: O(n * k) - In the worst case, we store all possible substrings of length k

## Link

[LeetCode 1297 Maximum Number of Occurrences of a Substring](https://leetcode.com/problems/maximum-number-of-occurrences-of-a-substring/)