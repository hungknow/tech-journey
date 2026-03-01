# 1898 Maximum Number of Removable Characters

## Problem Description

You are given two strings `s` and `p` where `p` is a subsequence of `s`. You are also given an array `removable` of integers representing indices of `s` that can be removed.

Find the maximum number of indices you can remove from `s` such that `p` is still a subsequence of `s`.

### Example 1:
```
Input: s = "abcacb", p = "ab", removable = [3,1,0]
Output: 2
Explanation: After removing indices 3 and 1, s becomes "abcb" and p is still a subsequence.
```

### Example 2:
```
Input: s = "abcbddddd", p = "abcd", removable = [3,2,1,4,5,6]
Output: 1
Explanation: After removing index 3, s becomes "abcddddd" and p is still a subsequence.
```

## The Twist

Finding the **maximum number of removable characters** while maintaining `p` as a subsequence. This involves using binary search to efficiently determine the maximum number of removals.

## Algorithm

### Binary Search Approach:
1. Sort the `removable` array to maintain order
2. Use binary search on the number of removals (from 0 to len(removable))
3. For each candidate number `k` of removals:
   - Create a set of the first `k` indices to remove
   - Check if `p` is still a subsequence of `s` after removing those characters
4. If `p` is still a subsequence, try removing more characters; otherwise, try removing fewer
5. Return the maximum number of removals

The key insight is that if we can remove `k` characters and maintain `p` as a subsequence, we can also remove any fewer than `k` characters, enabling binary search.

## Complexity

- **Time**: O(n log n) - binary search with subsequence check
- **Space**: O(n) - space for the removal set

## Solution Code

```go
package main

import (
	"fmt"
	"sort"
)

func maximumRemovals(s string, p string, removable []int) int {
	// Sort removable to maintain order
	sort.Ints(removable)
	
	// Binary search for the maximum number of removals
	left := 0
	right := len(removable)
	
	result := 0
	
	for left <= right {
		mid := left + (right-left)/2
		
		// Check if p is still a subsequence after removing mid characters
		if isSubsequence(s, p, removable[:mid]) {
			result = mid
			left = mid + 1 // Try removing more
		} else {
			right = mid - 1 // Try removing fewer
		}
	}
	
	return result
}

func isSubsequence(s, p string, removable []int) bool {
	// Create a set of indices to remove
	removeSet := make(map[int]bool)
	for _, idx := range removable {
		removeSet[idx] = true
	}
	
	// Check if p is a subsequence of s after removals
	i, j := 0, 0
	for i < len(s) && j < len(p) {
		if removeSet[i] {
			i++
			continue
		}
		
		if s[i] == p[j] {
			j++
		}
		i++
	}
	
	return j == len(p)
}
```

## Link

[LeetCode 1898 Maximum Number of Removable Characters](https://leetcode.com/problems/maximum-number-of-removable-characters/)