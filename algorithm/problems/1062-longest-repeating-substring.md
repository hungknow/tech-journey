# 1062 Longest Repeating Substring

## Problem Description

Given a string `s`, return the longest repeating substring in `s`. A repeating substring is a substring that appears at least twice consecutively.

### Example 1:
```
Input: s = "abbcccddd"
Output: 3
Explanation: The longest repeating substring is "ddd" of length 3.
```

### Example 2:
```
Input: s = "ababa"
Output: 2
Explanation: The longest repeating substring is "ab" of length 2.
```

## The Twist

Finding the **longest repeating substring** efficiently. This can be solved using binary search on substring length.

## Algorithm

### Binary Search on Substring Length:
1. The answer is between 1 and len(s)/2
2. Binary search on this range:
   - For each `mid`, check if there exists a repeating substring of length `mid`
   - If yes, try longer length (`left = mid + 1`)
   - Otherwise, try shorter length (`right = mid - 1`)
3. When loop ends, `right` is the maximum length
4. Find the actual substring by checking all substrings of that length

To check if a repeating substring of length `k` exists, check if any substring of length `k` appears twice consecutively.

## Complexity

- **Time**: O(n log n) - binary search with O(n) repeating checking
- **Space**: O(1) - constant extra space

## Solution Code

```go
package main

func longestRepeatingSubstring(s string) int {
	if len(s) < 2 {
		return 0
	}
	
	left, right := 1, len(s)/2
	result := 0
	
	for left <= right {
		mid := left + (right-left)/2
		
		if hasRepeatingSubstring(s, mid) {
			result = mid
			left = mid + 1
		} else {
			right = mid - 1
		}
	}
	
	return result
}

func hasRepeatingSubstring(s string, k int) bool {
	for i := 0; i <= len(s)-k; i++ {
		substr := s[i : i+k]
		
		// Check if this substring appears twice consecutively
		if strings.Contains(s, substr+substr) || 
		   strings.Contains(s[i:], substr) ||
		   (i > 0 && strings.Contains(s[:i-1], substr)) {
			return true
		}
	}
	
	return false
}
```

## Link

[LeetCode 1062 Longest Repeating Substring](https://leetcode.com/problems/longest-repeating-substring/)
