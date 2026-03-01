# 0035 Search Insert Position

## Problem Description

Given a sorted array of distinct integers and a target value, return the index if the target is found. If not, return the index where it would be if it were inserted in order.

You must write an algorithm with O(log n) runtime complexity.

### Example 1:
```
Input: nums = [1,3,5,6], target = 5
Output: 2
```

### Example 2:
```
Input: nums = [1,3,5,6], target = 2
Output: 1
```

### Example 3:
```
Input: nums = [1,3,5,6], target = 7
Output: 4
```

## The Twist

Finding the **insertion position** for a target in a sorted array. The result is the leftmost position where the target could be inserted while maintaining sorted order.

## Algorithm

### Binary Search for Insert Position:
1. Use standard binary search with `left` and `right` pointers
2. When `nums[mid] == target`, return `mid`
3. When `nums[mid] < target`, search right half (`left = mid + 1`)
4. When `nums[mid] > target`, search left half (`right = mid - 1`)
5. If target is not found, `left` will point to the correct insertion position

## Complexity

- **Time**: O(log n) - binary search
- **Space**: O(1) - constant extra space

## Solution Code

```go
package main

func searchInsert(nums []int, target int) int {
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
	
	return left // Insertion position
}
```

## Link

[LeetCode 0035 Search Insert Position](https://leetcode.com/problems/search-insert-position/)
