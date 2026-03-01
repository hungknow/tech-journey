# 1170 Compare Strings by Frequency of the Smallest Character

## Problem Description

You are given two string arrays `words1` and `words2`. Each string contains only lowercase English letters.

For each string, the frequency of each character is the number of occurrences of that character in the string.

Return the array of strings that appears in both arrays, ordered by:
1. The frequency of the smallest character
2. If tied, order lexicographically.

### Example 1:
```
Input: words1 = ["b","b","b","c"], words2 = ["a","a","c","b"]
Output: ["b","b","b","c"]
Explanation: The character 'b' has frequency 3 in both arrays, which is the highest frequency.
```

### Example 2:
```
Input: words1 = ["a","b","c","c","c","a","a"], words2 = ["a","b","c","c","c","b","a"]
Output: ["a","b","c","c","c","b","a"]
Explanation: The character 'a' has frequency 3 in both arrays, which is the highest frequency.
```

## The Twist

Comparing strings by **character frequency**. The key insight is to count character frequencies for each string and find the highest frequency.

## Algorithm

### Frequency Counting:
1. For each string, count character frequencies
2. Find the maximum frequency across all characters
3. Collect all characters with the maximum frequency
4. Return the intersection of these characters from both strings
5. Sort the result lexicographically

## Complexity

- **Time**: O(n + m) where n and m are lengths of the strings
- **Space**: O(1) - constant extra space for alphabet counting

## Solution Code

```go
package main

import (
	"sort"
)

func commonChars(words1 []string, words2 []string) []string {
	// Count character frequencies for each string
	count1 := countChars(words1)
	count2 := countChars(words2)
	
	// Find the maximum frequency
	maxFreq := 0
	for _, freq := range count1 {
		if freq > maxFreq {
			maxFreq = freq
		}
	}
	for _, freq := range count2 {
		if freq > maxFreq {
			maxFreq = freq
		}
	}
	
	// Collect characters with maximum frequency
	var result []string
	for char := 'a'; char <= 'z'; char++ {
		if count1[char] == maxFreq && count2[char] == maxFreq {
			result = append(result, string(char))
		}
	}
	
	// Sort lexicographically
	sort.Strings(result)
	
	return result
}

func countChars(words []string) [26]int {
	count := [26]int{}
	
	for _, word := range words {
		for _, char := range word {
			count[char-'a']++
		}
	}
	
	return count
}
```

## Link

[LeetCode 1170 Compare Strings by Frequency of the Smallest Character](https://leetcode.com/problems/compare-strings-by-frequency-of-the-smallest-character/)
