# 0567 Permutation in String

## Problem Description

Given two strings `s1` and `s2`, return `true` if `s2` contains a permutation of `s1`.

In other words, return `true` if one of `s1`'s permutations is the substring of `s2`.

### Example 1:
```
Input: s1 = "ab", s2 = "eidbaooo"
Output: true
Explanation: s2 contains one permutation of s1 ("ba").
```

### Example 2:
```
Input: s1 = "ab", s2 = "eidboaoo"
Output: false
```

## Sliding Window with Two Pointers Approach

This problem can be efficiently solved using a sliding window approach with two pointers. We maintain a window of size equal to `s1` and slide it across `s2`, checking if the window contains a permutation of `s1`.

### Algorithm Steps:

1. Create a frequency map for characters in `s1`
2. Initialize two pointers `left` and `right` for the sliding window
3. Initialize a counter to track how many characters from `s1` we need to match
4. Slide the window across `s2`:
   - Add the character at `right` to the window
   - If it's a character from `s1`, decrement its count in the frequency map
   - If the count becomes negative, move `left` forward until the window is valid again
   - If the window size equals `s1`, return true
5. If we finish traversing `s2` without finding a match, return false

## Complexity

- **Time**: O(n + m) - where n and m are the lengths of s1 and s2 respectively
- **Space**: O(1) - constant space for the frequency map (at most 26 letters)

## Solution Code

```go
package main

func checkInclusion(s1 string, s2 string) bool {
    if len(s1) > len(s2) {
        return false
    }
    
    // Create frequency map for s1
    freq := make([]int, 26)
    for _, char := range s1 {
        freq[char-'a']++
    }
    
    left, right := 0, 0
    count := len(s1)
    
    for right < len(s2) {
        // Add current character to the window
        if freq[s2[right]-'a'] > 0 {
            freq[s2[right]-'a']--
            count--
            right++
        } else {
            // Window is invalid, move left pointer
            freq[s2[left]-'a']++
            left++
            count++
        }
        
        // If we've found all characters
        if count == 0 {
            return true
        }
    }
    
    return false
}
```

## Alternative Approach (Fixed-size Sliding Window)

An alternative approach is to maintain a fixed-size sliding window and compare character frequencies at each position.

## Alternative Solution Code

```go
package main

func checkInclusion(s1 string, s2 string) bool {
    if len(s1) > len(s2) {
        return false
    }
    
    // Create frequency maps
    s1Freq := make([]int, 26)
    windowFreq := make([]int, 26)
    
    // Initialize frequency maps
    for i := 0; i < len(s1); i++ {
        s1Freq[s1[i]-'a']++
        windowFreq[s2[i]-'a']++
    }
    
    // Check if the first window matches
    if matches(s1Freq, windowFreq) {
        return true
    }
    
    // Slide the window
    for i := len(s1); i < len(s2); i++ {
        // Remove the leftmost character
        windowFreq[s2[i-len(s1)]-'a']--
        // Add the new character
        windowFreq[s2[i]-'a']++
        
        // Check if the window matches
        if matches(s1Freq, windowFreq) {
            return true
        }
    }
    
    return false
}

func matches(s1Freq, windowFreq []int) bool {
    for i := 0; i < 26; i++ {
        if s1Freq[i] != windowFreq[i] {
            return false
        }
    }
    return true
}
```

## Link

[LeetCode 0567 Permutation in String](https://leetcode.com/problems/permutation-in-string/)