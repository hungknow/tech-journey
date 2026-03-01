# 1044 Longest Duplicate Substring

## Problem Description

Given a string `s`, return the longest duplicate substring. The answer is the longest substring that appears at least twice in the given string.

### Example 1:
```
Input: s = "banana"
Output: "ana"
```

### Example 2:
```
Input: s = "abcd"
Output: ""
Explanation: There is no substring that appears at least twice.
```

## The Twist

Finding the **longest duplicate substring** efficiently. This can be solved using binary search on substring length.

## Algorithm

### Binary Search on Substring Length:
1. The answer is between 1 and len(s)/2
2. Binary search on this range:
   - For each `mid`, check if there exists a duplicate substring of length `mid`
   - If yes, try longer length (`left = mid + 1`)
   - Otherwise, try shorter length (`right = mid - 1`)
3. When loop ends, `right` is the maximum length
4. Find the actual substring by checking all substrings of that length

To check if a duplicate substring of length `k` exists, use a rolling hash.

## Complexity

- **Time**: O(n log n) - binary search with O(n) duplicate checking
- **Space**: O(n) - hash set for duplicate checking

## Solution Code

```go
package main

func longestDupSubstring(s string) string {
	if len(s) < 2 {
		return ""
	}
	
	left, right := 1, len(s)/2
	result := ""
	
	for left <= right {
		mid := left + (right-left)/2
		
		if hasDuplicateSubstring(s, mid) {
			result = findDuplicateSubstring(s, mid)
			left = mid + 1
		} else {
			right = mid - 1
		}
	}
	
	return result
}

func hasDuplicateSubstring(s string, k int) bool {
	seen := make(map[string]bool)
	
	for i := 0; i <= len(s)-k; i++ {
		substr := s[i : i+k]
		if seen[substr] {
			return true
		}
		seen[substr] = true
	}
	
	return false
}

func findDuplicateSubstring(s string, k int) string {
	seen := make(map[string]bool)
	
	for i := 0; i <= len(s)-k; i++ {
		substr := s[i : i+k]
		if seen[substr] {
			continue
		}
		
		// Check if this substring appears again
		for j := i + 1; j <= len(s)-k; j++ {
			if s[j:j+k] == substr {
				return substr
			}
		}
		
		seen[substr] = true
	}
	
	return ""
}
```

## Link

[LeetCode 1044 Longest Duplicate Substring](https://leetcode.com/problems/longest-duplicate-substring/)
