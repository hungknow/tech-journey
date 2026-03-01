# 2529 Maximum Count of Positive Integer and Negative Integer

## Problem Description

You are given a sorted integer array `nums` that is sorted in non-decreasing order.

Return the maximum count of positive integers and negative integers in the array.

A positive integer is an integer greater than 0.
A negative integer is an integer less than 0.

### Example 1:
```
Input: nums = [-3,-2,-1,0,1,2,3]
Output: 3
Explanation: There are 3 negative integers (-3, -2, -1) and 3 positive integers (1, 2, 3).
The maximum count is 3.
```

### Example 2:
```
Input: nums = [-5,-4,-3,0,1,2]
Output: 3
Explanation: There are 3 negative integers (-5, -4, -3) and 2 positive integers (1, 2).
The maximum count is 3.
```

### Example 3:
```
Input: nums = [-2,-1,1,2,3,4]
Output: 2
Explanation: There are 2 negative integers (-2, -1) and 4 positive integers (1, 2, 3, 4).
The maximum count is 4.
```

## The Twist

Finding the **maximum count** of positive or negative integers efficiently. This involves using binary search to quickly locate the transition point between negative and positive numbers.

## Algorithm

### Binary Search Approach:
1. Use binary search to find the first non-negative number:
   - This gives us the count of negative numbers
2. Use binary search to find the first positive number:
   - This gives us the count of non-positive numbers
3. Calculate the count of positive numbers as `len(nums) - firstPositiveIndex`
4. Return the maximum of the two counts

The key insight is that since the array is sorted, we can use binary search to efficiently find the boundaries between negative, zero, and positive numbers.

## Complexity

- **Time**: O(log n) - two binary searches
- **Space**: O(1) - constant space

## Solution Code

```go
package main

import "fmt"

func maximumCount(nums []int) int {
	n := len(nums)
	
	// Binary search for the first non-negative number
	left := 0
	right := n
	for left < right {
		mid := left + (right-left)/2
		if nums[mid] < 0 {
			left = mid + 1
		} else {
			right = mid
		}
	}
	negativeCount := left
	
	// Binary search for the first positive number
	left = 0
	right = n
	for left < right {
		mid := left + (right-left)/2
		if nums[mid] <= 0 {
			left = mid + 1
		} else {
			right = mid
		}
	}
	positiveCount := n - left
	
	// Return the maximum count
	if negativeCount > positiveCount {
		return negativeCount
	}
	return positiveCount
}
```

## Link

[LeetCode 2529 Maximum Count of Positive Integer and Negative Integer](https://leetcode.com/problems/maximum-count-of-positive-integer-and-negative-integer/)