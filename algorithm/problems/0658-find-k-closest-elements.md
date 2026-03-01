# 0658 Find K Closest Elements

## Problem Description

Given a sorted integer array `arr`, two integers `k` and `x`, return the `k` closest integers to `x` in the array. The result should also be sorted in ascending order.

An integer `a` is closer to `x` than an integer `b` if:

- `|a - x| < |b - x|`, or
- `|a - x| == |b - x|` and `a < b`

### Example 1:
```
Input: arr = [1,2,3,4,5], k = 4, x = 3
Output: [1,2,3,4]
```

### Example 2:
```
Input: arr = [1,2,3,4,5], k = 4, x = -1
Output: [1,2,3,4]
```

## The Twist

Finding the **k closest elements** in a sorted array. We can use binary search to find the left boundary of the k-element window.

## Algorithm

### Binary Search for Window Start:
1. The answer window is between indices 0 and n-k
2. Binary search on this range:
   - For each `mid`, compare the distance of `arr[mid]` and `arr[mid+k]` to `x`
   - If `x - arr[mid] > arr[mid+k] - x`, the window is too far left (`left = mid + 1`)
   - Otherwise, the window is too far right or just right (`right = mid`)
3. When loop ends, `left` is the start of the k-element window

## Complexity

- **Time**: O(log n + k) - binary search + slicing
- **Space**: O(k) - result array

## Solution Code

```go
package main

func findClosestElements(arr []int, k, x int) []int {
	left, right := 0, len(arr)-k
	
	// Binary search for the left boundary of the k-element window
	for left < right {
		mid := left + (right-left)/2
		
		// Compare distances of window boundaries to x
		if x-arr[mid] > arr[mid+k]-x {
			left = mid + 1
		} else {
			right = mid
		}
	}
	
	// Return the k elements starting from left
	return arr[left : left+k]
}
```

## Link

[LeetCode 0658 Find K Closest Elements](https://leetcode.com/problems/find-k-closest-elements/)
