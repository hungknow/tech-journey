# 0540 Single Element in a Sorted Array

## Problem Description

You are given a sorted array consisting of only integers where every element appears exactly twice, except for one element which appears exactly once.

Return the single element that appears only once.

You must write an algorithm with O(log n) runtime complexity and O(1) space.

### Example 1:
```
Input: nums = [1,1,2,3,3,4,4,8,8]
Output: 2
```

### Example 2:
```
Input: nums = [3,3,7,7,10,11,11]
Output: 10
```

## The Twist

Finding the **single element** in a sorted array where all other elements appear exactly twice. The key insight is that pairs are aligned in a specific way, and the single element breaks this pattern.

## Algorithm

### Binary Search Using Index Properties:
1. Use binary search with `left` and `right` pointers
2. While `left < right`:
   - Calculate `mid = left + (right - left) / 2`
   - Ensure `mid` is even (if odd, decrement by 1)
   - Compare `nums[mid]` with `nums[mid + 1]`:
     - If they are equal, the single element is in the right half (`left = mid + 2`)
     - If they are not equal, the single element is in the left half (`right = mid`)
3. When loop ends, `left` points to the single element

The key insight: Before the single element, pairs start at even indices. After the single element, pairs start at odd indices.

## Complexity

- **Time**: O(log n) - binary search
- **Space**: O(1) - constant extra space

## Solution Code

```go
package main

func singleNonDuplicate(nums []int) int {
	left, right := 0, len(nums)-1
	
	for left < right {
		mid := left + (right-left)/2
		
		// Ensure mid is even
		if mid%2 == 1 {
			mid--
		}
		
		// If the pair is intact, single element is in right half
		if nums[mid] == nums[mid+1] {
			left = mid + 2
		} else {
			// Pair is broken, single element is in left half
			right = mid
		}
	}
	
	return nums[left]
}
```

## Link

[LeetCode 0540 Single Element in a Sorted Array](https://leetcode.com/problems/single-element-in-a-sorted-array/)
