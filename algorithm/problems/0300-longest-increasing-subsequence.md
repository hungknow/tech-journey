# 0300 Longest Increasing Subsequence

## Problem Description

Given an integer array `nums`, return the length of the longest strictly increasing subsequence.

### Example 1:
```
Input: nums = [10,9,2,5,3,7,101,18]
Output: 4
Explanation: The longest increasing subsequence is [2,3,7,101].
```

### Example 2:
```
Input: nums = [0,1,0,3,2,3]
Output: 4
```

### Example 3:
```
Input: nums = [7,7,7,7,7,7,7]
Output: 1
```

## The Twist

Finding the **longest increasing subsequence** efficiently. The O(n log n) solution uses binary search to maintain a tails array.

## Algorithm

### Binary Search with Tails Array:
1. Initialize an empty `tails` array
2. For each number in `nums`:
   - If `tails` is empty or number > last element, append it
   - Otherwise, find the first element in `tails` ≥ number using binary search
   - Replace that element with the current number
3. The length of `tails` is the length of the LIS

The `tails[i]` represents the smallest possible tail value for an increasing subsequence of length `i+1`.

## Complexity

- **Time**: O(n log n) - binary search for each element
- **Space**: O(n) - tails array

## Solution Code

```go
package main

import (
	"sort"
)

func lengthOfLIS(nums []int) int {
	if len(nums) == 0 {
		return 0
	}
	
	tails := []int{}
	
	for _, num := range nums {
		// Find the first element in tails >= num
		idx := sort.SearchInts(tails, num)
		
		if idx == len(tails) {
			// Extend the tails array
			tails = append(tails, num)
		} else {
			// Replace existing element
			tails[idx] = num
		}
	}
	
	return len(tails)
}
```

## Link

[LeetCode 0300 Longest Increasing Subsequence](https://leetcode.com/problems/longest-increasing-subsequence/)
