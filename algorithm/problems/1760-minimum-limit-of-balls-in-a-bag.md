# 1760 Minimum Limit of Balls in a Bag

## Problem Description

You are given an integer array `nums` where `nums[i]` represents the number of balls in the `ith` bag. You are also given an integer `maxOperations`.

You have two operations available:
1. Divide a bag with `x` balls into two bags with `y` and `z` balls, where `x = y + z` and `y` and `z` are positive integers.
2. Do nothing.

You can perform the first operation at most `maxOperations` times.

Return the minimum possible size of the largest bag after performing the operations.

### Example 1:
```
Input: nums = [9], maxOperations = 2
Output: 3
Explanation: 
- Divide the bag with 9 balls into two bags of sizes 6 and 3. [9] -> [6,3].
- Divide the bag with 6 balls into two bags of sizes 3 and 3. [6,3] -> [3,3,3].
The bag with the most balls has a size of 3.
```

### Example 2:
```
Input: nums = [2,4,8,2], maxOperations = 4
Output: 2
```

## The Twist

Finding the **minimum possible maximum bag size** after operations. This is a binary search on answer problem where we check if we can achieve a certain maximum bag size.

## Algorithm

### Binary Search on Maximum Bag Size:
1. The answer is between 1 and max(nums)
2. Binary search on this range:
   - For each `mid`, calculate the minimum operations needed to ensure no bag exceeds `mid`
   - For each bag with `x` balls, operations needed = ceil(x/mid) - 1
   - If total operations ≤ maxOperations, try smaller maximum (`right = mid`)
   - Otherwise, need larger maximum (`left = mid + 1`)
3. When loop ends, `left` is the minimum feasible maximum bag size

## Complexity

- **Time**: O(n log(max(nums)))
- **Space**: O(1) - constant extra space

## Solution Code

```go
package main

import (
	"math"
)

func minimumSize(nums []int, maxOperations int) int {
	left, right := 1, 0
	
	// Find the maximum bag size
	for _, num := range nums {
		right = max(right, num)
	}
	
	// Binary search for the minimum feasible maximum bag size
	for left < right {
		mid := left + (right-left)/2
		
		if canAchieveMaxSize(nums, maxOperations, mid) {
			right = mid
		} else {
			left = mid + 1
		}
	}
	
	return left
}

func canAchieveMaxSize(nums []int, maxOperations, maxSize int) bool {
	operations := 0
	
	for _, num := range nums {
		// Operations needed for this bag: ceil(num/maxSize) - 1
		needed := (num + maxSize - 1) / maxSize - 1
		operations += needed
		
		if operations > maxOperations {
			return false
		}
	}
	
	return true
}

func max(a, b int) int {
	if a > b {
		return a
	}
	return b
}
```

## Link

[LeetCode 1760 Minimum Limit of Balls in a Bag](https://leetcode.com/problems/minimum-limit-of-balls-in-a-bag/)
