# 1156 Swap For Longest Repeated Character Substring

## Problem Description

You are given a string `s`. You can swap any two characters of the string any number of times.

Return the length of the longest substring with repeated characters.

### Example 1:
```
Input: s = "ababa"
Output: 3
Explanation: We can swap the first 'b' with the last 'a', resulting in "baaba".
The longest repeated character substring is "aaa" with length 3.
```

### Example 2:
```
Input: s = "aaabaaa"
Output: 6
Explanation: Swap 'b' with the last 'a', resulting in "aaaaaaa".
The longest repeated character substring is "aaaaaaa" with length 7.
```

### Example 3:
```
Input: s = "aaaaa"
Output: 5
Explanation: No swap needed, the longest repeated character substring is "aaaaa" with length 5.
```

## Approach

This problem can be solved using a sliding window approach combined with character frequency counting:

1. First, count the frequency of each character in the string.
2. Use a sliding window to find the longest substring where at most one character is different from the others.
3. For each character, check if we can extend a substring by swapping one occurrence of that character from outside the window with a different character inside the window.
4. The maximum length is the maximum of:
   - The frequency of the most common character (if we don't need to swap)
   - The length of the longest substring with at most one different character (if we can swap)

## Solution Code

```go
func maxRepOpt1(text string) int {
    // Count frequency of each character
    freq := make(map[byte]int)
    for i := 0; i < len(text); i++ {
        freq[text[i]]++
    }
    
    maxLen := 0
    
    // For each character, find the longest substring with at most one different character
    for char, count := range freq {
        left := 0
        differentCount := 0
        
        for right := 0; right < len(text); right++ {
            if text[right] != char {
                differentCount++
            }
            
            // If more than one different character, shrink the window
            for differentCount > 1 {
                if text[left] != char {
                    differentCount--
                }
                left++
            }
            
            // Calculate the current window length
            windowLen := right - left + 1
            
            // If we have more of this character outside the window, we can potentially extend
            if windowLen < count {
                windowLen++
            }
            
            maxLen = max(maxLen, windowLen)
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

## Complexity Analysis

- **Time**: O(n * 26) = O(n) - We use a sliding window for each character (at most 26 for lowercase English letters)
- **Space**: O(26) = O(1) - We store the frequency of each character

## Link

[LeetCode 1156 Swap For Longest Repeated Character Substring](https://leetcode.com/problems/swap-for-longest-repeated-character-substring/)