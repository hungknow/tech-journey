# 1456 Maximum Number of Vowels in a Substring of Given Length

## Problem Description

Given a string `s` and an integer `k`, return the maximum number of vowel letters in any substring of length `k`.

Vowel letters in English are `'a'`, `'e'`, `'i'`, `'o'`, and `'u'`.

### Example 1:
```
Input: s = "abciiidef", k = 3
Output: 2
Explanation: The substring "iii" contains 3 vowel letters, which is the maximum possible.
```

### Example 2:
```
Input: s = "aeiou", k = 2
Output: 2
Explanation: Any substring of length 2 contains 2 vowels.
```

### Example 3:
```
Input: s = "leetcode", k = 3
Output: 2
Explanation: The substring "lee" contains 2 vowels.
```

## Approach

This problem can be solved using a sliding window approach:

1. First, define a helper function to check if a character is a vowel.
2. Count the number of vowels in the first window of size `k`.
3. Slide the window one character at a time:
   - If the character leaving the window is a vowel, decrement the count.
   - If the character entering the window is a vowel, increment the count.
   - Keep track of the maximum count encountered.

## Solution Code

```go
func maxVowels(s string, k int) int {
    n := len(s)
    if k > n {
        return 0
    }
    
    // Helper function to check if a character is a vowel
    isVowel := func(c byte) bool {
        return c == 'a' || c == 'e' || c == 'i' || c == 'o' || c == 'u'
    }
    
    // Count vowels in the first window
    currentCount := 0
    for i := 0; i < k; i++ {
        if isVowel(s[i]) {
            currentCount++
        }
    }
    
    maxCount := currentCount
    
    // Slide the window
    for i := k; i < n; i++ {
        // Remove the leftmost character
        if isVowel(s[i-k]) {
            currentCount--
        }
        
        // Add the new character
        if isVowel(s[i]) {
            currentCount++
        }
        
        // Update the maximum count
        if currentCount > maxCount {
            maxCount = currentCount
        }
    }
    
    return maxCount
}
```

## Complexity Analysis

- **Time**: O(n) - We traverse the string once with the sliding window
- **Space**: O(1) - We only use a few variables regardless of the input size

## Link

[LeetCode 1456 Maximum Number of Vowels in a Substring of Given Length](https://leetcode.com/problems/maximum-number-of-vowels-in-a-substring-of-given-length/)