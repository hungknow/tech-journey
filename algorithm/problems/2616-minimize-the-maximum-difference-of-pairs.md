# 2616 Minimize the Maximum Difference of Pairs

## Problem Description

You are given an integer array `nums` and an integer `p`. You need to find `p` pairs of indices `(i, j)` where `i < j`.

The score of a pair is the absolute difference between the elements at those indices.

Return the minimum possible maximum score among all possible ways to form `p` pairs.

### Example 1:
```
Input: nums = [10,1,2,7,1,3], p = 2
Output: 1
Explanation: Pair (1,4) with score |1-1| = 0 and pair (2,3) with score |2-7| = 5.
The maximum score is 5.
But we can do better: pair (1,5) with score |1-3| = 2 and pair (2,4) with score |2-1| = 1.
The maximum score is 2.
Actually, the minimum possible maximum score is 1.
```

### Example 2:
```
Input: nums = [4,5,2,1], p = 2
Output: 1
Explanation: Pair (1,3) with score |5-1| = 4 and pair (2,4) with score |2-1| = 1.
The maximum score is 4.
But we can do better: pair (1,2) with score |5-2| = 3 and pair (3,4) with score |1-1| = 0.
The maximum score is 3.
Actually, the minimum possible maximum score is 1.
```

## The Twist

Finding the **minimum maximum difference** among pairs. This involves using binary search to efficiently determine the optimal pairing strategy.

## Algorithm

### Binary Search Approach:
1. Sort the array to minimize differences
2. Use binary search on the possible maximum difference values
3. For each candidate maximum difference `x`:
   - Check if we can form `p` pairs with all differences ≤ `x`
   - Use a greedy approach to form pairs
4. If we can form `p` pairs with maximum difference ≤ `x`, try a smaller `x`; otherwise, try a larger `x`
5. Return the minimum achievable maximum difference

The key insight is that if we can form `p` pairs with maximum difference ≤ `x`, we can also form `p` pairs with maximum difference ≤ any value larger than `x`, enabling binary search.

## Complexity

- **Time**: O(n log n + n log(maxDiff)) - sorting and binary search with pairing check
- **Space**: O(1) - constant space (ignoring space used by sorting)

## Solution Code

```go
package main

import (
	"fmt"
	"sort"
)

func minimizeMax(nums []int, p int) int {
	// Sort the array to minimize differences
	sort.Ints(nums)
	
	// Binary search for the minimum possible maximum difference
	left := 0
	right := nums[len(nums)-1] - nums[0]
	
	result := right
	
	for left <= right {
		mid := left + (right-left)/2
		
		// Check if we can form p pairs with maximum difference <= mid
		if canFormPairs(nums, p, mid) {
			result = mid
			right = mid - 1 // Try smaller maximum difference
		} else {
			left = mid + 1 // Try larger maximum difference
		}
	}
	
	return result
}

func canFormPairs(nums []int, p, maxDiff int) bool {
	count := 0
	i := 0
	
	// Greedily form pairs
	for i < len(nums)-1 && count < p {
		if nums[i+1]-nums[i] <= maxDiff {
			count++
			i += 2 // Skip both elements as they're paired
		} else {
			i++ // Skip this element and try to pair the next one
		}
	}
	
	return count >= p
}
```

## Link

[LeetCode 2616 Minimize the Maximum Difference of Pairs](https://leetcode.com/problems/minimize-the-maximum-difference-of-pairs/)