# 0424 Longest Repeating Character Replacement

## Problem Description

You are given a string `s` consisting of only uppercase English letters.

You can change at most `k` characters in `s` to any other uppercase English character.

Find the length of the longest substring containing the same letter after such replacement.

### Example 1:
```
Input: s = "ABAB", k = 2
Output: 4
Explanation: Replace the two 'A's with two 'B's or vice versa.
```

### Example 2:
```
Input: s = "AABABBA", k = 1
Output: 4
Explanation: Replace the one 'A' at position 3 with 'B' to get "AABBBBB".
The longest substring with the same letter is "BBBB" with length 4.
```

## Sliding Window Approach

This problem can be solved using a sliding window technique. We maintain a window that can contain at most `k` characters that need to be replaced to make all characters in the window the same.

### Algorithm Steps:

1. Initialize a frequency array to count characters in the current window
2. Initialize `left = 0`, `maxCount = 0`, and `maxLength = 0`
3. Iterate through the string with `right` pointer from 0 to n-1:
   - Increment the count of `s[right]` in the frequency array
   - Update `maxCount` with the maximum frequency in the current window
   - If the window size minus `maxCount` is greater than `k`:
     - Decrement the count of `s[left]` and increment `left`
   - Update `maxLength` with `max(maxLength, right - left + 1)`
4. Return `maxLength`

## Complexity

- **Time**: O(n) - we iterate through the string once
- **Space**: O(1) - constant space for the frequency array (26 letters)

## Solution Code

```go
package main

func characterReplacement(s string, k int) int {
	n := len(s)
	if n == 0 {
		return 0
	}
	
	// Frequency array for uppercase English letters
	freq := make([]int, 26)
	left := 0
	maxCount := 0
	maxLength := 0
	
	for right := 0; right < n; right++ {
		// Increment the count of the current character
		charIndex := s[right] - 'A'
		freq[charIndex]++
		
		// Update the maximum frequency in the current window
		if freq[charIndex] > maxCount {
			maxCount = freq[charIndex]
		}
		
		// If we need more than k replacements, shrink the window
		if (right - left + 1) - maxCount > k {
			// Decrement the count of the character at the left pointer
			leftCharIndex := s[left] - 'A'
			freq[leftCharIndex]--
			left++
		}
		
		// Update the maximum length
		if right-left+1 > maxLength {
			maxLength = right - left + 1
		}
	}
	
	return maxLength
}
```

## Link

[LeetCode 0424 Longest Repeating Character Replacement](https://leetcode.com/problems/longest-repeating-character-replacement/)