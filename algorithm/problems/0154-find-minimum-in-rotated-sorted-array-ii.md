# 0154 Find Minimum in Rotated Sorted Array II

## Problem Description

Suppose an array of length `n` sorted in ascending order is rotated between `1` and `n` times. For example, the array `nums = [0,1,2,4,5,6,7]` might become:

- `[4,5,6,7,0,1,2]` if it was rotated 4 times.
- `[0,1,2,4,5,6,7]` if it was rotated 7 times.

Notice that rotating an array `[a[0], a[1], a[2], ..., a[n-1]]` 1 time results in the array `[a[n-1], a[0], a[1], a[2], ..., a[n-2]]`.

Given the sorted rotated array `nums` that may contain **duplicates**, return the minimum element of this array.

You must decrease the overall operation steps as much as possible.

### Example 1:
```
Input: nums = [1,3,5]
Output: 1
```

### Example 2:
```
Input: nums = [2,2,2,0,1]
Output: 0
```

## The Twist

The array contains **duplicates**, which makes it harder to determine which half contains the minimum. When `nums[mid] == nums[right]`, we can't determine which half contains the minimum and must shrink the search space.

## Algorithm

### Binary Search with Duplicates:
1. Use binary search with `left` and `right` pointers
2. While `left < right`:
   - Calculate `mid = left + (right - left) / 2`
   - If `nums[mid] > nums[right]`, the minimum is in the right half (`left = mid + 1`)
   - Else if `nums[mid] < nums[right]`, the minimum is in the left half including `mid` (`right = mid`)
   - Else (`nums[mid] == nums[right]`), shrink the search space (`right--`)
3. When loop ends, `left` points to the minimum element

## Complexity

- **Time**: O(log n) average, O(n) worst case (when many duplicates)
- **Space**: O(1) - constant extra space

## Solution Code

```go
package main

func findMin(nums []int) int {
	left, right := 0, len(nums)-1
	
	for left < right {
		mid := left + (right-left)/2
		
		if nums[mid] > nums[right] {
			// Minimum is in the right half
			left = mid + 1
		} else if nums[mid] < nums[right] {
			// Minimum is in the left half including mid
			right = mid
		} else {
			// nums[mid] == nums[right], can't determine, shrink search space
			right--
		}
	}
	
	return nums[left]
}
```

## Link

[LeetCode 0154 Find Minimum in Rotated Sorted Array II](https://leetcode.com/problems/find-minimum-in-rotated-sorted-array-ii/)
