# 0704 Binary Search

## Problem Description

Given an array of integers `nums` which is sorted in ascending order, and an integer `target`, write a function to search `target` in `nums`. If `target` exists, then return its index. Otherwise, return `-1`.

You must write an algorithm with O(log n) runtime complexity.

### Example 1:
```
Input: nums = [-1,0,3,5,9,12], target = 9
Output: 4
Explanation: 9 exists in nums and its index is 4
```

### Example 2:
```
Input: nums = [-1,0,3,5,9,12], target = 2
Output: -1
Explanation: 2 does not exist in nums so return -1
```

## The Twist

This is the **classic binary search** problem - finding an element in a sorted array efficiently.

## Algorithm

### Standard Binary Search:
1. Use binary search with `left = 0` and `right = len(nums) - 1`
2. While `left <= right`:
   - Calculate `mid = left + (right-left) / 2`
   - If `nums[mid] == target`, return `mid`
   - If `nums[mid] < target`, search right half (`left = mid + 1`)
   - If `nums[mid] > target`, search left half (`right = mid - 1`)
3. If loop ends without finding target, return `-1`

## Complexity

- **Time**: O(log n) - binary search
- **Space**: O(1) - constant extra space

## Solution Code

```go
package main

func search(nums []int, target int) int {
	left, right := 0, len(nums)-1
	
	for left <= right {
		mid := left + (right-left)/2
		
		if nums[mid] == target {
			return mid
		} else if nums[mid] < target {
			left = mid + 1
		} else {
			right = mid - 1
		}
	}
	
	return -1
}
```

## Link

[LeetCode 0704 Binary Search](https://leetcode.com/problems/binary-search/)
