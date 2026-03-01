# 0702 Search in a Sorted Array of Unknown Size

## Problem Description

This is an interactive problem.

You have a sorted array of unique elements and an unknown size. You do not have an access to the array but you can use the `ArrayReader` interface to access it.

- `ArrayReader.get(k)` returns the element at the `k`th index (0-indexed) of the secret array. If the `k`th index is out of bounds, it returns `2^31 - 1`.

You are also given an integer `target`.

Return the index `k` of the `target` element in the sorted array, or return `-1` if it's not present in the array.

### Example 1:
```
Input: secret = [-1,0,3,5,9,12], target = 9
Output: 4
Explanation: 9 exists in secret and its index is 4.
```

### Example 2:
```
Input: secret = [-1,0,3,5,9,12], target = 2
Output: -1
Explanation: 2 does not exist in secret so return -1.
```

## The Twist

The array has **unknown size**, so we first need to find the search bounds using exponential search, then perform binary search within those bounds.

## Algorithm

### Two-Phase Approach:
1. **Find Search Bounds**:
   - Start with `left = 0` and `right = 1`
   - Exponentially increase `right` until `ArrayReader.get(right) >= target` or we hit the boundary
   - Update `left` to previous `right` value

2. **Binary Search Within Bounds**:
   - Perform standard binary search between `left` and `right`
   - Use `ArrayReader.get(mid)` to access elements
   - Handle out-of-bounds cases (returns 2^31 - 1)

## Complexity

- **Time**: O(log n) - exponential search + binary search
- **Space**: O(1) - constant extra space

## Solution Code

```go
package main

/**
 * // This is the ArrayReader's API interface.
 * // You should not implement it, or speculate about its implementation
 * type ArrayReader struct {
 * }
 *
 * func (this *ArrayReader) get(index int) int {}
 */

type ArrayReader struct{}

func (this *ArrayReader) get(index int) int {
	// This would be provided by the platform
	// For testing purposes, let's implement a simple version
	secret := []int{-1, 0, 3, 5, 9, 12}
	if index >= len(secret) {
		return 1 << 31 - 1
	}
	return secret[index]
}

func search(reader ArrayReader, target int) int {
	// First, find the search bounds
	left, right := 0, 1
	
	// Exponentially increase the right bound
	for reader.get(right) < target {
		left = right
		right *= 2
	}
	
	// Binary search within the bounds
	for left <= right {
		mid := left + (right-left)/2
		midValue := reader.get(mid)
		
		if midValue == target {
			return mid
		} else if midValue < target {
			left = mid + 1
		} else {
			right = mid - 1
		}
	}
	
	return -1
}
```

## Link

[LeetCode 0702 Search in a Sorted Array of Unknown Size](https://leetcode.com/problems/search-in-a-sorted-array-of-unknown-size/)
