# 0153 Find Minimum in Rotated Sorted Array

## Problem Description

Suppose an array of length `n` sorted in ascending order is rotated between `1` and `n` times. For example, the array `nums = [0,1,2,4,5,6,7]` might become:

- `[4,5,6,7,0,1,2]` if it was rotated 4 times.
- `[0,1,2,4,5,6,7]` if it was rotated 7 times.

Notice that rotating an array `[a[0], a[1], a[2], ..., a[n-1]]` 1 time results in the array `[a[n-1], a[0], a[1], a[2], ..., a[n-2]]`.

Given the sorted rotated array `nums` of **unique** elements, return the minimum element of this array.

You must write an algorithm that runs in O(log n) time.

### Example 1:
```
Input: nums = [3,4,5,1,2]
Output: 1
Explanation: The original array was [1,2,3,4,5] rotated 3 times.
```

### Example 2:
```
Input: nums = [4,5,6,7,0,1,2]
Output: 0
Explanation: The original array was [0,1,2,4,5,6,7] and it was rotated 4 times.
```

### Example 3:
```
Input: nums = [11,13,15,17]
Output: 11
Explanation: The original array was [11,13,15,17] and it was rotated 4 times.
```

## The Twist

Finding the **minimum element** in a rotated sorted array. The minimum element is the point where the rotation occurs, and it's the only element that is smaller than its previous element.

## Algorithm

### Binary Search for Minimum:
1. Use binary search with `left` and `right` pointers
2. If the array is not rotated (nums[left] < nums[right]), return nums[left]
3. While `left < right`:
   - Calculate `mid = left + (right - left) / 2`
   - If `nums[mid] > nums[right]`, the minimum is in the right half (`left = mid + 1`)
   - Otherwise, the minimum is in the left half including `mid` (`right = mid`)
4. When loop ends, `left` points to the minimum element

## Complexity

- **Time**: O(log n) - binary search
- **Space**: O(1) - constant extra space

## Solution Code

```go
package main

func findMin(nums []int) int {
	left, right := 0, len(nums)-1
	
	// If array is not rotated, return first element
	if nums[left] < nums[right] {
		return nums[left]
	}
	
	for left < right {
		mid := left + (right-left)/2
		
		// If mid element is greater than rightmost element,
		// minimum must be in the right half
		if nums[mid] > nums[right] {
			left = mid + 1
		} else {
			// Otherwise, minimum is in the left half including mid
			right = mid
		}
	}
	
	return nums[left]
}
```

## Link

[LeetCode 0153 Find Minimum in Rotated Sorted Array](https://leetcode.com/problems/find-minimum-in-rotated-sorted-array/)
