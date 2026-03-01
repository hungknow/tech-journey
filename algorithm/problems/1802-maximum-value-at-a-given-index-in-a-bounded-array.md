# 1802 Maximum Value at a Given Index in a Bounded Array

## Problem Description

You are given three positive integers: `n`, `index`, and `maxSum`. You want to construct an array `nums` of length `n` where:

1. `nums[i]` is a positive integer for all `0 <= i < n`
2. The absolute difference between any two adjacent elements is at most 1
3. The sum of all elements in `nums` does not exceed `maxSum`

Return the maximum possible value of `nums[index]` under these constraints.

### Example 1:
```
Input: n = 4, index = 2, maxSum = 6
Output: 2
Explanation: nums = [1,2,2,1] is a valid array. The maximum value at index 2 is 2.
```

### Example 2:
```
Input: n = 6, index = 1, maxSum = 10
Output: 3
```

## The Twist

Finding the **maximum value at a given index** in a bounded array. This involves using binary search to determine the maximum possible value while ensuring the sum constraint is satisfied.

## Algorithm

### Binary Search Approach:
1. Use binary search to find the maximum value at the given index
2. For each candidate value `x` at the target index:
   - Calculate the minimum possible sum of the array if `nums[index] = x`
   - The elements to the left of the index form a decreasing sequence (or stay at 1)
   - The elements to the right of the index form a decreasing sequence (or stay at 1)
   - Calculate the sum of these sequences using arithmetic series formulas
3. If the total sum ≤ `maxSum`, try a larger value; otherwise, try a smaller value
4. Return the maximum valid value

The key insight is that for a given value at the target index, we can calculate the minimum possible sum of the entire array, allowing us to use binary search efficiently.

## Complexity

- **Time**: O(log(maxSum)) - binary search operations
- **Space**: O(1) - constant space

## Solution Code

```go
package main

import (
	"fmt"
)

func maxValue(n int, index int, maxSum int) int {
	// Binary search for the maximum value
	left := 1
	right := maxSum
	
	for left <= right {
		mid := left + (right-left)/2
		
		// Calculate the minimum sum if nums[index] = mid
		sum := calculateSum(n, index, mid)
		
		if sum <= maxSum {
			left = mid + 1
		} else {
			right = mid - 1
		}
	}
	
	return right
}

func calculateSum(n, index, value int) int {
	// Calculate sum on the left side of index
	leftSum := 0
	leftCount := index
	if value > leftCount {
		// Form a complete decreasing sequence: value-1, value-2, ..., value-leftCount
		leftSum = (value-1 + value-leftCount) * leftCount / 2
	} else {
		// Form a sequence that reaches 1: value-1, value-2, ..., 1, 1, 1, ...
		leftSum = (value-1 + 1) * (value-1) / 2
		leftSum += leftCount - (value - 1)
	}
	
	// Calculate sum on the right side of index
	rightSum := 0
	rightCount := n - index - 1
	if value > rightCount {
		// Form a complete decreasing sequence: value-1, value-2, ..., value-rightCount
		rightSum = (value-1 + value-rightCount) * rightCount / 2
	} else {
		// Form a sequence that reaches 1: value-1, value-2, ..., 1, 1, 1, ...
		rightSum = (value-1 + 1) * (value-1) / 2
		rightSum += rightCount - (value - 1)
	}
	
	// Total sum includes the value at index
	return leftSum + value + rightSum
}
```

## Link

[LeetCode 1802 Maximum Value at a Given Index in a Bounded Array](https://leetcode.com/problems/maximum-value-at-a-given-index-in-a-bounded-array/)