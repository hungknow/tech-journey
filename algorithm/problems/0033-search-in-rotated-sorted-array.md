# 0033 Search in Rotated Sorted Array

## Problem Description

There is an integer array `nums` sorted in ascending order (with distinct values). Prior to being passed to your function, `nums` is possibly rotated at an unknown pivot index `k` (1 <= k < nums.length) such that the resulting array is `[nums[k], nums[k+1], ..., nums[n-1], nums[0], nums[1], ..., nums[k-1]]` (0-indexed).

Given the array `nums` after the possible rotation and an integer `target`, return the index of `target` if it is in `nums`, or `-1` if it is not in `nums`.

You must write an algorithm with O(log n) runtime complexity.

### Example 1:
```
Input: nums = [4,5,6,7,0,1,2], target = 0
Output: 4
```

### Example 2:
```
Input: nums = [4,5,6,7,0,1,2], target = 3
Output: -1
```

### Example 3:
```
Input: nums = [1], target = 0
Output: -1
```

## The Twist

The array is **rotated**, which means it's no longer strictly sorted. However, we can still use binary search by determining which half is sorted and whether the target lies in that half.

## Algorithm

### Modified Binary Search:
1. Use standard binary search with `left` and `right` pointers
2. At each step, determine which half is sorted:
   - If `nums[left] <= nums[mid]`, left half is sorted
   - Otherwise, right half is sorted
3. Check if target is in the sorted half:
   - If left half sorted and `nums[left] <= target < nums[mid]`, search left
   - If right half sorted and `nums[mid] < target <= nums[right]`, search right
4. Otherwise, search the other half

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
		}
		
		// Check if left half is sorted
		if nums[left] <= nums[mid] {
			// Target is in left half
			if nums[left] <= target && target < nums[mid] {
				right = mid - 1
			} else {
				left = mid + 1
			}
		} else {
			// Right half is sorted
			// Target is in right half
			if nums[mid] < target && target <= nums[right] {
				left = mid + 1
			} else {
				right = mid - 1
			}
		}
	}
	
	return -1
}
```

## Link

[LeetCode 0033 Search in Rotated Sorted Array](https://leetcode.com/problems/search-in-rotated-sorted-array/)
