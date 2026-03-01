# 2781 Length of the Longest Valid Substring

## Problem Description

You are given a string `word` and an integer `k`.

A substring is valid if it contains only characters from the set `{'a', 'e', 'i', 'o', 'u'}` and each character appears at most `k` times.

Return the length of the longest valid substring.

### Example 1:
```
Input: word = "aeiouu", k = 2
Output: 5
Explanation: The longest valid substring is "aeiou", which has length 5.
```

### Example 2:
```
Input: word = "leetcode", k = 3
Output: 2
Explanation: The longest valid substrings are "lee" and "eet", both with length 3.
```

## Approach

This problem can be solved using a sliding window approach:

1. Use a sliding window to maintain a substring where each character appears at most `k` times.
2. Use a hash map to count the frequency of each character in the current window.
3. Expand the window to the right, adding the current character to the map.
4. If the current character's count exceeds `k`, shrink the window from the left until the count is at most `k`.
5. Keep track of the maximum window size encountered.

## Solution Code

```go
func longestValidSubstring(word string, k int) int {
    n := len(word)
    if n == 0 {
        return 0
    }
    
    validChars := make(map[byte]bool)
    validChars['a'] = true
    validChars['e'] = true
    validChars['i'] = true
    validChars['o'] = true
    validChars['u'] = true
    
    left := 0
    maxLen := 0
    
    for right := 0; right < n; right++ {
        // Add current character to the window
        if validChars[word[right]] {
            validChars[word[right]] = true
        } else {
            validChars[word[right]] = false
        }
        
        // If the current character's count exceeds k, shrink from the left
        for validChars[word[right]] == false {
            if validChars[word[left]] {
                validChars[word[left]] = false
            }
            left++
        }
        
        // Update the maximum window size
        if right-left+1 > maxLen {
            maxLen = right - left + 1
        }
    }
    
    return maxLen
}
```

## Complexity Analysis

- **Time**: O(n) - We traverse the string once with the sliding window
- **Space**: O(1) - We only use a constant amount of extra space for the character set

## Link

[LeetCode 2781 Length of the Longest Valid Substring](https://leetcode.com/problems/length-of-the-longest-valid-substring/)