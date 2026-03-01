# 0862 Shortest Subarray with Sum at Least K

## Problem Description

Given an integer array `nums` and an integer `k`, return the length of the shortest non-empty subarray of `nums` with sum at least `k`. If there is no such subarray, return `-1`.

A subarray is a contiguous part of an array.

### Example 1:
```
Input: nums = [1], k = 1
Output: 1
```

### Example 2:
```
Input: nums = [1,2], k = 4
Output: -1
```

### Example 3:
```
Input: nums = [2,-1,2], k = 3
Output: 3
```

## Monotonic Deque Approach

This problem can be efficiently solved using a monotonic deque approach combined with prefix sums. We maintain a deque that stores indices of prefix sums in increasing order.

### Algorithm Steps:

1. Compute the prefix sum array where `prefix[i]` is the sum of the first `i` elements
2. Initialize a deque and `result = infinity`
3. Iterate through the prefix sum array:
   - While the deque is not empty and `prefix[i] - prefix[deque[0]] >= k`:
     - Update `result` with `min(result, i - deque[0])`
     - Remove the front element from the deque
   - While the deque is not empty and `prefix[i] <= prefix[deque[len(deque)-1]]`:
     - Remove the last element from the deque (maintains monotonicity)
   - Add `i` to the back of the deque
4. Return `result` if it was updated, otherwise return -1

## Complexity

- **Time**: O(n) - each index is added and removed from the deque at most once
- **Space**: O(n) - for the prefix sum array and deque

## Solution Code

```go
package main

import (
	"math"
)

func shortestSubarray(nums []int, k int) int {
	n := len(nums)
	
	// Compute prefix sums
	prefix := make([]int, n+1)
	for i := 0; i < n; i++ {
		prefix[i+1] = prefix[i] + nums[i]
	}
	
	// Initialize deque and result
	deque := make([]int, 0)
	result := math.MaxInt32
	
	for i := 0; i <= n; i++ {
		// Check if we can form a valid subarray
		for len(deque) > 0 && prefix[i]-prefix[deque[0]] >= k {
			// Update result with current subarray length
			currentLength := i - deque[0]
			if currentLength < result {
				result = currentLength
			}
			// Remove the front element
			deque = deque[1:]
		}
		
		// Maintain monotonicity of the deque
		for len(deque) > 0 && prefix[i] <= prefix[deque[len(deque)-1]] {
			deque = deque[:len(deque)-1]
		}
		
		// Add current index to the deque
		deque = append(deque, i)
	}
	
	if result == math.MaxInt32 {
		return -1
	}
	
	return result
}
```

## Link

[LeetCode 0862 Shortest Subarray with Sum at Least K](https://leetcode.com/problems/shortest-subarray-with-sum-at-least-k/)