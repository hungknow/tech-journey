# 0345 Reverse Vowels of a String

## Problem Description

Given a string `s`, return the string with the vowels reversed.

### Example 1:
```
Input: s = "hello"
Output: "holle"
```

### Example 2:
```
Input: s = "leetcode"
Output: "leotcede"
```

## Two Pointers Approach

This problem can be solved using the two-pointer technique. We use two pointers starting from the beginning and end of the string, swapping vowels as we move toward the center.

### Algorithm Steps:

1. Convert the string to a character array for easier manipulation
2. Initialize `left = 0` and `right = len(s) - 1`
3. Define a helper function to check if a character is a vowel
4. While `left < right`:
   - If `s[left]` is a vowel, skip it (we'll handle it later)
   - If `s[right]` is a vowel, swap `s[left]` and `s[right]`
   - If `s[left]` is not a vowel and `s[right]` is not a vowel, increment `left` and decrement `right`
   - If `s[left]` is a vowel and `s[right] is not a vowel, increment `left` and decrement `right`
   - If both are vowels, increment `left` and decrement `right`
5. Return the modified string

## Complexity

- **Time**: O(n) - we traverse the string once
- **Space**: O(n) - space for the character array

## Solution Code

```go
package main

func reverseVowels(s string) string {
    // Convert to rune slice to handle Unicode properly
    chars := []rune(s)
    left := 0
    right := len(chars) - 1
    
    isVowel := func(c rune) bool {
        return c == 'a' || c == 'e' || c == 'i' || c == 'o' || c == 'u' ||
               c == 'A' || c == 'E' || c == 'I' || c == 'O' || c == 'U'
    }
    
    for left < right {
        // Move left pointer to the next vowel
        for left < right && !isVowel(chars[left]) {
            left++
        }
        
        // Move right pointer to the previous vowel
        for right > left && !isVowel(chars[right]) {
            right--
        }
        
        // Swap the vowels
        chars[left], chars[right] = chars[right], chars[left]
        
        left++
        right--
    }
    
    return string(chars)
}
```

## Alternative Approach

An alternative approach is to collect all vowels first, reverse them, and then reconstruct the string.

## Alternative Solution Code

```go
package main

func reverseVowels(s string) string {
    // Convert to rune slice to handle Unicode properly
    chars := []rune(s)
    vowels := make([]rune, 0)
    
    // Extract all vowels
    for _, c := range chars {
        if c == 'a' || c == 'e' || c == 'i' || c == 'o' || c == 'u' ||
           c == 'A' || c == 'E' || c == 'I' || c == 'O' || c == 'U' {
            vowels = append(vowels, c)
        }
    }
    
    // Reverse the vowels
    for i, j := 0, len(vowels)-1; i < j; i, j = i+1, j-1 {
        vowels[i], vowels[j] = vowels[j], vowels[i]
    }
    
    // Reconstruct the string with reversed vowels
    vowelIndex := 0
    result := make([]rune, len(chars))
    
    for _, c := range chars {
        if c == 'a' || c == 'e' || c == 'i' || c == 'o' || c == 'u' ||
           c == 'A' || c == 'E' || c == 'I' || c == 'O' || c == 'U' {
            result = append(result, vowels[vowelIndex])
            vowelIndex++
        } else {
            result = append(result, c)
        }
    }
    
    return string(result)
}
```

## Link

[LeetCode 0345 Reverse Vowels of a String](https://leetcode.com/problems/reverse-vowels-of-a-string/)