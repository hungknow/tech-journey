# 1287 Element Appearing More Than 25% In Sorted Array

## Problem Description

Given an integer array sorted in non-decreasing order, there is exactly one integer in the array that occurs more than 25% of the time.

Return that integer.

### Example 1:
```
Input: arr = [1,2,2,6,6,6,6,7,10]
Output: 6
```

## The Twist

Finding the element that appears **more than 25%** of the time in a sorted array. Since the array is sorted, we can use binary search to efficiently check if an element appears at least n/4 times.

## Algorithm

### Binary Search for Each Quarter Position:
1. For each position `i` at 0, n/4, n/2, 3n/4:
   - Use binary search to find the first occurrence of `arr[i]`
   - Use binary search to find the last occurrence of `arr[i]`
   - Calculate the count: `lastIndex - firstIndex + 1`
   - If count > n/4, return `arr[i]`

Since the element appears >25% of the time, it must appear at one of these quarter positions.

## Complexity

- **Time**: O(log n) - constant number of binary searches
- **Space**: O(1) - constant extra space

## Solution Code

```go
package main

func findSpecialInteger(arr []int) int {
	n := len(arr)
	quarter := n / 4
	
	// Check elements at quarter positions
	positions := []int{0, n/4, n/2, 3*n/4}
	
	for _, pos := range positions {
		if pos >= n {
			continue
		}
		
		// Find first occurrence using binary search
		first := findFirst(arr, arr[pos])
		// Find last occurrence using binary search
		last := findLast(arr, arr[pos])
		
		if last-first+1 > quarter {
			return arr[pos]
		}
	}
	
	return -1 // Should not reach here as per problem statement
}

func findFirst(arr []int, target int) int {
	left, right := 0, len(arr)-1
	result := 0
	
	for left <= right {
		mid := left + (right-left)/2
		
		if arr[mid] >= target {
			right = mid - 1
		} else {
			left = mid + 1
		}
		
		if arr[mid] == target {
			result = mid
		}
	}
	
	return result
}

func findLast(arr []int, target int) int {
	left, right := 0, len(arr)-1
	result := 0
	
	for left <= right {
		mid := left + (right-left)/2
		
		if arr[mid] <= target {
			left = mid + 1
		} else {
			right = mid - 1
		}
		
		if arr[mid] == target {
			result = mid
		}
	}
	
	return result
}
```

## Link

[LeetCode 1287 Element Appearing More Than 25% In Sorted Array](https://leetcode.com/problems/element-appearing-more-than-25-in-sorted-array/)
