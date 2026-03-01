# 0278 First Bad Version

## Problem Description

You are a product manager and currently leading a team to develop a new product. Unfortunately, the latest version of your product fails the quality check. Since each version is developed based on the previous version, all the versions after a bad version are also bad.

Suppose you have `n` versions `[1, 2, ..., n]` and you want to find out the first bad one, which causes all the following ones to be bad.

You are given an API `bool isBadVersion(version)` which returns whether `version` is bad. Implement a function to find the first bad version. You should minimize the number of calls to the API.

### Example 1:
```
Input: n = 5, bad = 4
Output: 4
Explanation:
call isBadVersion(3) -> false
call isBadVersion(5) -> true
call isBadVersion(4) -> true
Then 4 is the first bad version.
```

### Example 2:
```
Input: n = 1, bad = 1
Output: 1
```

## The Twist

Finding the **first bad version** using binary search. The versions follow a pattern where all versions before the first bad version are good, and all versions after are bad.

## Algorithm

### Binary Search for First Bad Version:
1. Use binary search with `left` and `right` pointers
2. While `left < right`:
   - Calculate `mid = left + (right - left) / 2` (to avoid overflow)
   - If `isBadVersion(mid)` is true, the first bad version is at or before `mid` (`right = mid`)
   - Otherwise, the first bad version is after `mid` (`left = mid + 1`)
3. When loop ends, `left` points to the first bad version

## Complexity

- **Time**: O(log n) - binary search
- **Space**: O(1) - constant extra space

## Solution Code

```go
package main

/**
 * Forward declaration of isBadVersion API.
 * @param   version   your guess about first bad version
 * @return 	 	      true if current version is bad
 *		          false if current version is good
 * func isBadVersion(version int) bool;
 */

func firstBadVersion(n int) int {
	left, right := 1, n
	
	for left < right {
		mid := left + (right-left)/2
		
		if isBadVersion(mid) {
			right = mid
		} else {
			left = mid + 1
		}
	}
	
	return left
}

// Mock implementation for testing
func isBadVersion(version int) bool {
	// This would be provided by the platform
	// For testing purposes, let's say version 4 is the first bad version
	return version >= 4
}
```

## Link

[LeetCode 0278 First Bad Version](https://leetcode.com/problems/first-bad-version/)
