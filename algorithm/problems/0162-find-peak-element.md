# 0162 Find Peak Element

## Problem Description

A peak element is an element that is strictly greater than its neighbors.

Given an integer array `nums`, find a peak element. The array may be unsorted.

You must write an algorithm with O(log n) runtime complexity.

### Example 1:
```
Input: nums = [1,2,3,1]
Output: 2
Explanation: 3 is a peak element and your function should return the index number 2.
```

### Example 2:
```
Input: nums = [1,2,1,3,5,6,4]
Output: 5
Explanation: Your function can return either index number 1 where the peak element is 2, or index number 5 where the peak element is 6.
```

## The Twist

Finding a **peak element** in an unsorted array. The key insight is that if an element is not a peak, we can determine which direction to search based on the slope.

## Algorithm

### Binary Search on Slope:
1. Use binary search with `left = 0` and `right = len(nums) - 1`
2. While `left < right`:
   - Calculate `mid = left + (right-left) / 2`
   - If `nums[mid] > nums[mid+1]`, the peak is in the left half including `mid` (`right = mid`)
   - Otherwise, the peak is in the right half (`left = mid + 1`)
3. When loop ends, `left` points to a peak element

## Complexity

- **Time**: O(log n) - binary search
- **Space**: O(1) - constant extra space

## Solution Code

```go
package main

func findPeakElement(nums []int) int {
	left, right := 0, len(nums)-1
	
	for left < right {
		mid := left + (right-left)/2
		
		if nums[mid] > nums[mid+1] {
			right = mid
		} else {
			left = mid + 1
		}
	}
	
	return left
}
```

## Link

[LeetCode 0162 Find Peak Element](https://leetcode.com/problems/find-peak-element/)
