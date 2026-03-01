# 2226 Maximum Candies Allocated to K Children

## Problem Description

You are given an integer array `candies`, where each `candies[i]` represents a pile of candies with `candies[i]` candies in it.

You want to distribute candies to `k` children such that:
1. Each child gets exactly one pile of candies
2. Each pile can be split into any number of smaller piles
3. All children must receive the same number of candies

Return the maximum number of candies each child can get.

### Example 1:
```
Input: candies = [5,8,6], k = 3
Output: 5
Explanation: 
- Split the first pile into 3 piles of [1,2,2]
- Give one pile to each child
Each child gets 5/3 = 1.666... candies, so the maximum integer is 1.
```

### Example 2:
```
Input: candies = [2,5,12,5], k = 4
Output: 3
Explanation: 
- Split the third pile into 4 piles of [3,3,3,3]
- Give one pile to each child
Each child gets 3 candies.
```

## The Twist

Finding the **maximum candies** each child can get. This involves using binary search to efficiently determine the optimal distribution strategy.

## Algorithm

### Binary Search Approach:
1. Use binary search on the number of candies per child (from 1 to the maximum pile size)
2. For each candidate number `x`:
   - Calculate how many children can receive `x` candies from each pile
   - For each pile with `c` candies, it can serve `c / x` children
   - Sum these values to get the total number of children that can be served
3. If the total children served ≥ `k`, try a larger number of candies; otherwise, try a smaller number
4. Return the maximum valid number of candies per child

The key insight is that if we can serve `k` children with `x` candies each, we can also serve `k` children with any number of candies less than `x`, enabling binary search.

## Complexity

- **Time**: O(n log(max(candies))) - binary search with candy counting
- **Space**: O(1) - constant space

## Solution Code

```go
package main

import "fmt"

func maximumCandies(candies []int, k int64) int {
	// Binary search for the maximum number of candies per child
	left := 1
	right := 0
	
	// Find the maximum pile size as upper bound
	for _, candy := range candies {
		if candy > right {
			right = candy
		}
	}
	
	result := 0
	
	for left <= right {
		mid := left + (right-left)/2
		
		// Calculate how many children can be served with mid candies each
		childrenServed := int64(0)
		for _, candy := range candies {
			childrenServed += int64(candy) / int64(mid)
		}
		
		if childrenServed >= k {
			result = mid
			left = mid + 1 // Try more candies per child
		} else {
			right = mid - 1 // Try fewer candies per child
		}
	}
	
	return result
}
```

## Link

[LeetCode 2226 Maximum Candies Allocated to K Children](https://leetcode.com/problems/maximum-candies-allocated-to-k-children/)