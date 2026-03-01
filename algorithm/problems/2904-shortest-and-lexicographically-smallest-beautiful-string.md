# 2904 Shortest and Lexicographically Smallest Beautiful String

## Problem Description

A string is beautiful if all its characters appear at most `k` times.

You are given a string `s` and an integer `k`.

Return the shortest lexicographically smallest string that is beautiful.

### Example 1:
```
Input: s = "abcabc", k = 2
Output: "ab"
Explanation: The beautiful strings are "ab", "ac", "bc", "ba", "ca", "cb".
The lexicographically smallest is "ab".
```

### Example 2:
```
Input: s = "aabbcc", k = 2
Output: "abbcc"
Explanation: The beautiful strings are "ab", "ac", "bb", "bc", "ca", "cb".
The lexicographically smallest is "abbcc".
```

## Approach

This problem can be solved using a sliding window approach combined with a frequency count:

1. Use a sliding window to maintain a substring where each character appears at most `k` times.
2. Use a hash map to count the frequency of each character in the current window.
3. Expand the window to the right, adding the current character to the map.
4. If the current character's count exceeds `k`, shrink the window from the left until the count is at most `k`.
5. For each valid window, check if it's the lexicographically smallest so far.

## Solution Code

```go
func shortestBeautifulSubstring(s string, k int) string {
    n := len(s)
    if n == 0 {
        return ""
    }
    
    left := 0
    minString := s
    freq := make(map[byte]int)
    
    for right := 0; right < n; right++ {
        // Add current character to the window
        freq[s[right]]++
        
        // If the current character's count exceeds k, shrink from the left
        for freq[s[left]] > k {
            freq[s[left]]--
            if freq[s[left]] == 0 {
                delete(freq, s[left])
            }
            left++
        }
        
        // Check if the current window is lexicographically smaller
        if right-left+1 == k {
            current := s[left : right+1]
            if current < minString {
                minString = current
            }
        }
    }
    
    return minString
}
```

## Complexity Analysis

- **Time**: O(n^2) - For each position, we might check all previous characters
- **Space**: O(k) - We store the frequency of at most k elements in the current window

## Link

[LeetCode 2904 Shortest and Lexicographically Smallest Beautiful String](https://leetcode.com/problems/shortest-and-lexicographically-smallest-beautiful-string/)