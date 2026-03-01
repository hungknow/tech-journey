# 1671 Minimum Number of Removals to Make Mountain Array

## Problem Description

Given an integer array `nums`, return the minimum number of elements to remove to make the remaining array a mountain array.

### Example 1:
```
Input: nums = [1,3,1]
Output: 0
Explanation: The array is already a mountain array.
```

### Example 2:
```
Input: nums = [2,1,1,5,6,2,3,1]
Output: 3
Explanation: One solution is to remove the elements at indices 0, 1, and 5 to make the array [1,5,6,2,1].
```

## The Twist

Finding the **minimum removals** to make a mountain array. This is a variant of LIS where we need to find the longest mountain subsequence.

## Algorithm

### LIS from Both Sides:
1. Compute LIS length ending at each index from left to right
2. Compute LIS length starting at each index from right to left (reverse LIS)
3. For each index as potential peak:
   - If it can be a peak (both LIS > 1), calculate mountain length = leftLIS[i] + rightLIS[i] - 1
4. The answer is n - max(mountain length)

Use binary search to compute LIS efficiently.

## Complexity

- **Time**: O(n log n) - LIS computation with binary search
- **Space**: O(n) - LIS arrays

## Solution Code

```go
package main

import (
	"sort"
)

func minimumMountainRemovals(nums []int) int {
	n := len(nums)
	if n < 3 {
		return 0
	}
	
	// LIS from left to right
	leftLIS := make([]int, n)
	tails := []int{}
	
	for i := 0; i < n; i++ {
		idx := sort.SearchInts(tails, nums[i])
		if idx == len(tails) {
			tails = append(tails, nums[i])
		} else {
			tails[idx] = nums[i]
		}
		leftLIS[i] = idx + 1
	}
	
	// LIS from right to left (reverse)
	rightLIS := make([]int, n)
	tails = []int{}
	
	for i := n - 1; i >= 0; i-- {
		idx := sort.SearchInts(tails, nums[i])
		if idx == len(tails) {
			tails = append(tails, nums[i])
		} else {
			tails[idx] = nums[i]
		}
		rightLIS[i] = idx + 1
	}
	
	maxMountain := 0
	for i := 0; i < n; i++ {
		// Can be peak if both sides have at least 1 element
		if leftLIS[i] > 1 && rightLIS[i] > 1 {
			mountain := leftLIS[i] + rightLIS[i] - 1
			maxMountain = max(maxMountain, mountain)
		}
	}
	
	return n - maxMountain
}

func max(a, b int) int {
	if a > b {
		return a
	}
	return b
}
```

## Link

[LeetCode 1671 Minimum Number of Removals to Make Mountain Array](https://leetcode.com/problems/minimum-number-of-removals-to-make-mountain-array/)
