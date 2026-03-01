# 0034 Find First and Last Position of Element in Sorted Array

## Problem Description

Given an array of integers `nums` sorted in non-decreasing order, find the starting and ending position of a given `target` value.

If target is not found in the array, return `[-1, -1]`.

You must write an algorithm with O(log n) runtime complexity.

### Example 1:
```
Input: nums = [5,7,7,8,8,10], target = 8
Output: [3,4]
```

### Example 2:
```
Input: nums = [5,7,7,8,8,10], target = 6
Output: [-1,-1]
```

### Example 3:
```
Input: nums = [], target = 0
Output: [-1,-1]
```

## The Twist

Finding **both the first and last occurrence** of a target in a sorted array using binary search. This requires two separate binary searches: one for the leftmost and one for the rightmost position.

## Algorithm

### Two Binary Searches:
1. **Find First Position**:
   - Use binary search, but when `nums[mid] == target`, continue searching left
   - This ensures we find the leftmost occurrence

2. **Find Last Position**:
   - Use binary search, but when `nums[mid] == target`, continue searching right
   - This ensures we find the rightmost occurrence

3. If first position is -1, return `[-1, -1]` immediately

## Complexity

- **Time**: O(log n) - two binary searches
- **Space**: O(1) - constant extra space

## Solution Code

```go
package main

func searchRange(nums []int, target int) []int {
	return []int{findFirst(nums, target), findLast(nums, target)}
}

func findFirst(nums []int, target int) int {
	left, right := 0, len(nums)-1
	result := -1
	
	for left <= right {
		mid := left + (right-left)/2
		
		if nums[mid] == target {
			result = mid
			right = mid - 1 // Continue searching left
		} else if nums[mid] < target {
			left = mid + 1
		} else {
			right = mid - 1
		}
	}
	
	return result
}

func findLast(nums []int, target int) int {
	left, right := 0, len(nums)-1
	result := -1
	
	for left <= right {
		mid := left + (right-left)/2
		
		if nums[mid] == target {
			result = mid
			left = mid + 1 // Continue searching right
		} else if nums[mid] < target {
			left = mid + 1
		} else {
			right = mid - 1
		}
	}
	
	return result
}
```

## Link

[LeetCode 0034 Find First and Last Position of Element in Sorted Array](https://leetcode.com/problems/find-first-and-last-position-of-element-in-sorted-array/)
