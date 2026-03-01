# 0081 Search in Rotated Sorted Array II

## Problem Description

There is an integer array `nums` sorted in non-decreasing order (not necessarily with distinct values). Prior to being passed to your function, `nums` is possibly rotated at an unknown pivot index `k` (1 <= k < nums.length) such that the resulting array is `[nums[k], nums[k+1], ..., nums[n-1], nums[0], nums[1], ..., nums[k-1]]` (0-indexed).

Given the array `nums` after the possible rotation and an integer `target`, return `true` if `target` is in `nums`, or `false` if it is not in `nums`.

You must decrease the overall operation steps as much as possible.

### Example 1:
```
Input: nums = [2,5,6,0,0,1,2], target = 0
Output: true
```

### Example 2:
```
Input: nums = [2,5,6,0,0,1,2], target = 3
Output: false
```

## The Twist

The array contains **duplicates**, which makes it harder to determine which half is sorted. When `nums[left] == nums[mid] == nums[right]`, we can't determine which half is sorted and must shrink the search space.

## Algorithm

### Modified Binary Search with Duplicates:
1. Use standard binary search with `left` and `right` pointers
2. When `nums[left] == nums[mid] == nums[right]`:
   - Shrink search space by incrementing `left` and decrementing `right`
3. Otherwise, determine which half is sorted:
   - If `nums[left] <= nums[mid]`, left half is sorted
   - Otherwise, right half is sorted
4. Check if target is in the sorted half and search accordingly

## Complexity

- **Time**: O(log n) average, O(n) worst case (when many duplicates)
- **Space**: O(1) - constant extra space

## Solution Code

```go
package main

func search(nums []int, target int) bool {
	left, right := 0, len(nums)-1
	
	for left <= right {
		mid := left + (right-left)/2
		
		if nums[mid] == target {
			return true
		}
		
		// When we can't determine which half is sorted
		if nums[left] == nums[mid] && nums[mid] == nums[right] {
			left++
			right--
			continue
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
	
	return false
}
```

## Link

[LeetCode 0081 Search in Rotated Sorted Array II](https://leetcode.com/problems/search-in-rotated-sorted-array-ii/)
