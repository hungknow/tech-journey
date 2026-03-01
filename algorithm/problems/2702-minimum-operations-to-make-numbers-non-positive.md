# 2702 Minimum Operations to Make Numbers Non-positive

## Problem Description

You are given an integer array `nums`.

In one operation, you can:
- Choose any element `nums[i]`
- Decrease it by any positive integer

Return the minimum number of operations needed to make all elements in `nums` non-positive.

### Example 1:
```
Input: nums = [1,2,3,4,5]
Output: 1
Explanation: Decrease nums[4] by 5 to make it 0.
All elements are now non-positive.
```

### Example 2:
```
Input: nums = [-1,-2,-3,-4,-5]
Output: 0
Explanation: All elements are already non-positive.
```

### Example 3:
```
Input: nums = [10,20,30]
Output: 1
Explanation: Decrease nums[2] by 30 to make it 0.
All elements are now non-positive.
```

## The Twist

Finding the **minimum operations** to make all numbers non-positive. This involves using binary search to efficiently determine the optimal operation strategy.

## Algorithm

### Binary Search Approach:
1. Sort the array in ascending order
2. Use binary search to determine the minimum number of operations:
   - For each candidate number of operations `k`, check if we can make all elements non-positive
   - Apply operations to the largest elements first for maximum efficiency
3. Return the minimum number of operations needed

The key insight is that we should always apply operations to the largest elements first, and binary search helps determine the optimal number of operations.

## Complexity

- **Time**: O(n log n) - sorting and binary search with operation counting
- **Space**: O(1) - constant space (ignoring space used by sorting)

## Solution Code

```go
package main

import (
	"fmt"
	"sort"
)

func minOperations(nums []int) int {
	// Sort the array in ascending order
	sort.Ints(nums)
	
	// Binary search for the minimum number of operations
	left := 0
	right := len(nums)
	
	result := right
	
	for left <= right {
		mid := left + (right-left)/2
		
		// Check if we can make all elements non-positive with mid operations
		if canMakeNonPositive(nums, mid) {
			result = mid
			right = mid - 1 // Try fewer operations
		} else {
			left = mid + 1 // Try more operations
		}
	}
	
	return result
}

func canMakeNonPositive(nums []int, operations int) bool {
	n := len(nums)
	
	// Apply operations to the largest elements first
	for i := n - 1; i >= 0 && operations > 0; i-- {
		if nums[i] <= 0 {
			continue
		}
		
		// Decrease nums[i] to 0 or less
		needed := nums[i]
		if needed <= operations {
			operations -= needed
		} else {
			return false
		}
	}
	
	// Check if all elements are non-positive
	for _, num := range nums {
		if num > 0 {
			return false
		}
	}
	
	return true
}
```

## Link

[LeetCode 2702 Minimum Operations to Make Numbers Non-positive](https://leetcode.com/problems/minimum-operations-to-make-numbers-non-positive/)