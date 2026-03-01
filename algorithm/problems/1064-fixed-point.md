# 1064 Fixed Point

## Problem Description

Given an integer array `arr` sorted in strictly increasing order, return the fixed point if the array contains one. Otherwise, return -1.

A fixed point is an index `i` such that `arr[i] == i`.

### Example 1:
```
Input: arr = [-10,-5,0,3,7]
Output: 3
Explanation: arr[3] == 3, so the fixed point is 3.
```

### Example 2:
```
Input: arr = [0,2,5,8,9]
Output: -1
Explanation: There is no fixed point in the array.
```

## The Twist

Finding a **fixed point** in a sorted array efficiently. Since the array is sorted, we can use binary search.

## Algorithm

### Binary Search for Fixed Point:
1. Use binary search with `left = 0` and `right = len(arr) - 1`
2. While `left <= right`:
   - Calculate `mid = left + (right-left) / 2`
   - If `arr[mid] == mid`, return `mid`
   - If `arr[mid] < mid`, fixed point is in the right half (`left = mid + 1`)
   - Otherwise, fixed point is in the left half (`right = mid - 1`)
3. If loop ends, return -1

## Complexity

- **Time**: O(log n) - binary search
- **Space**: O(1) - constant extra space

## Solution Code

```go
package main

func fixedPoint(arr []int) int {
	left, right := 0, len(arr)-1
	
	for left <= right {
		mid := left + (right-left)/2
		
		if arr[mid] == mid {
			return mid
		} else if arr[mid] < mid {
			left = mid + 1
		} else {
			right = mid - 1
		}
	}
	
	return -1
}
```

## Link

[LeetCode 1064 Fixed Point](https://leetcode.com/problems/fixed-point/)
