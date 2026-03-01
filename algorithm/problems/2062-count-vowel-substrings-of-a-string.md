# 2062 Count Vowel Substrings of a String

## Problem Description

Given a string `word`, return the number of vowel substrings in `word`.

A vowel substring is a substring that contains only vowels ('a', 'e', 'i', 'o', 'u') and has all five vowels present at least once.

### Example 1:
```
Input: word = "aeiouu"
Output: 2
Explanation: The vowel substrings are "aeiou" and "aeiouu".
```

### Example 2:
```
Input: word = "unicornarihan"
Output: 0
Explanation: There are no vowel substrings.
```

### Example 3:
```
Input: word = "cuaieuouac"
Output: 7
Explanation: The vowel substrings are "uaieuoua", "uaieuouac", "aieuoua", "aieuouac", "ieuoua", "ieuouac", "euoua", "euouac", "uoua", "uouac", "oua", "ouac".
```

## Approach

This problem can be solved using a sliding window approach:

1. First, identify all the vowel substrings (substrings containing only vowels).
2. For each vowel substring, count how many sub-substrings contain all five vowels.
3. Use a sliding window to efficiently count these sub-substrings.

## Solution Code

```go
func countVowelSubstrings(word string) int {
    n := len(word)
    vowels := make(map[byte]bool)
    vowels['a'] = true
    vowels['e'] = true
    vowels['i'] = true
    vowels['o'] = true
    vowels['u'] = true
    
    result := 0
    
    for i := 0; i < n; i++ {
        // Skip non-vowel characters
        if !vowels[word[i]] {
            continue
        }
        
        // Find the end of the current vowel substring
        j := i
        for j < n && vowels[word[j]] {
            j++
        }
        
        // Process the vowel substring word[i:j]
        vowelSubstring := word[i:j]
        result += countSubstringsWithAllVowels(vowelSubstring)
        
        // Move to the next position
        i = j
    }
    
    return result
}

func countSubstringsWithAllVowels(s string) int {
    n := len(s)
    result := 0
    
    for i := 0; i < n; i++ {
        vowelCount := make(map[byte]int)
        
        for j := i; j < n; j++ {
            vowelCount[s[j]]++
            
            // Check if we have all five vowels
            if len(vowelCount) == 5 {
                result++
            }
        }
    }
    
    return result
}
```

## Complexity Analysis

- **Time**: O(n^2) - For each vowel substring, we check all possible sub-substrings
- **Space**: O(1) - We only use a constant amount of extra space for the vowel count

## Link

[LeetCode 2062 Count Vowel Substrings of a String](https://leetcode.com/problems/count-vowel-substrings-of-a-string/)