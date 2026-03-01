# 2448 Minimum Cost to Make Array Equal

## Problem Description

You are given two integer arrays `nums` and `cost`, where `cost[i]` is the cost of incrementing or decrementing `nums[i]` by 1.

Return the minimum total cost to make all elements in `nums` equal.

### Example 1:
```
Input: nums = [1,3,5,2], cost = [2,3,1,14]
Output: 8
Explanation: Make all elements equal to 2:
- Increment nums[0] by 1 (cost = 2)
- Decrement nums[1] by 1 (cost = 3)
- Decrement nums[2] by 3 (cost = 3)
Total cost = 2 + 3 + 3 = 8
```

### Example 2:
```
Input: nums = [1,2,3], cost = [1,2,3]
Output: 4
Explanation: Make all elements equal to 2:
- Increment nums[0] by 1 (cost = 1)
- Decrement nums[2] by 1 (cost = 3)
Total cost = 1 + 3 = 4
```

## The Twist

Finding the **minimum cost** to make all array elements equal. This involves using binary search to efficiently determine the optimal target value.

## Algorithm

### Binary Search Approach:
1. Create pairs of (num, cost) and sort by num
2. Create prefix sums of costs for efficient calculations
3. Use binary search to find the optimal target value:
   - For each candidate target, calculate the total cost to make all elements equal to this target
   - The cost function is convex, so binary search can find the minimum
4. Return the minimum cost found

The key insight is that the cost function is convex (has a single minimum), allowing us to use binary search to find the optimal target value efficiently.

## Complexity

- **Time**: O(n log n) - sorting and binary search with cost calculations
- **Space**: O(n) - space for sorted pairs and prefix sums

## Solution Code

```go
package main

import (
	"fmt"
	"sort"
)

func minCost(nums []int, cost []int) int64 {
	n := len(nums)
	pairs := make([][2]int, n)
	
	// Create pairs and sort by num
	for i := 0; i < n; i++ {
		pairs[i] = [2]int{nums[i], cost[i]}
	}
	sort.Slice(pairs, func(i, j int) bool {
		return pairs[i][0] < pairs[j][0]
	})
	
	// Extract sorted nums and costs
	sortedNums := make([]int, n)
	sortedCosts := make([]int, n)
	for i := 0; i < n; i++ {
		sortedNums[i] = pairs[i][0]
		sortedCosts[i] = pairs[i][1]
	}
	
	// Create prefix sums of costs
	prefixCosts := make([]int64, n+1)
	for i := 0; i < n; i++ {
		prefixCosts[i+1] = prefixCosts[i] + int64(sortedCosts[i])
	}
	
	// Binary search for the optimal target
	left := sortedNums[0]
	right := sortedNums[n-1]
	
	var result int64
	
	for left <= right {
		mid := left + (right-left)/2
		
		// Find the position where nums[i] > mid
		pos := sort.SearchInts(sortedNums, mid+1)
		
		// Calculate cost to make all elements equal to mid
		// Cost for elements < mid: (mid - nums[i]) * cost[i]
		leftCost := int64(mid) * int64(pos) - (prefixCosts[pos] - prefixCosts[0])
		
		// Cost for elements > mid: (nums[i] - mid) * cost[i]
		rightCost := (prefixCosts[n] - prefixCosts[pos]) - int64(mid) * int64(n-pos)
		
		totalCost := leftCost + rightCost
		
		// Check if we're at the minimum
		if pos > 0 && pos < n {
			// Check neighboring values to ensure we're at the minimum
			midLeft := mid - 1
			posLeft := sort.SearchInts(sortedNums, midLeft+1)
			leftCostLeft := int64(midLeft) * int64(posLeft) - (prefixCosts[posLeft] - prefixCosts[0])
			rightCostLeft := (prefixCosts[n] - prefixCosts[posLeft]) - int64(midLeft) * int64(n-posLeft)
			totalCostLeft := leftCostLeft + rightCostLeft
			
			if totalCostLeft < totalCost {
				right = mid - 1
				result = totalCostLeft
				continue
			}
			
			midRight := mid + 1
			posRight := sort.SearchInts(sortedNums, midRight+1)
			leftCostRight := int64(midRight) * int64(posRight) - (prefixCosts[posRight] - prefixCosts[0])
			rightCostRight := (prefixCosts[n] - prefixCosts[posRight]) - int64(midRight) * int64(n-posRight)
			totalCostRight := leftCostRight + rightCostRight
			
			if totalCostRight < totalCost {
				left = mid + 1
				result = totalCostRight
				continue
			}
		}
		
		result = totalCost
		break
	}
	
	return result
}
```

## Link

[LeetCode 2448 Minimum Cost to Make Array Equal](https://leetcode.com/problems/minimum-cost-to-make-array-equal/)