# 0209 Minimum Size Subarray Sum

## Problem Description

Given an array of positive integers `nums` and a positive integer `target`, return the minimal length of a 
subarray of which the sum is greater than or equal to `target`. If there is no such subarray, return `0` instead.

### Example 1:
```
Input: target = 7, nums = [2,3,1,2,4,3]
Output: 2
Explanation: The subarray [4,3] has the minimal length under the problem constraint.
```

### Example 2:
```
Input: target = 4, nums = [1,4,4]
Output: 1
```

### Example 3:
```
Input: target = 11, nums = [1,1,1,1,1,1,1,1]
Output: 0
```

## Sliding Window Approach

This problem is a classic sliding window problem. We maintain a window that expands to include more elements until the sum meets or exceeds the target, then we try to shrink it from the left to find the minimal length.

### Algorithm Steps:

1. Initialize `left = 0`, `sum = 0`, and `minLength = infinity`
2. Iterate through the array with `right` pointer from 0 to n-1:
   - Add `nums[right]` to `sum`
   - While `sum >= target`:
     - Update `minLength` with `min(minLength, right - left + 1)`
     - Subtract `nums[left]` from `sum` and increment `left`
3. Return `minLength` if it was updated, otherwise return 0

## Complexity

- **Time**: O(n) - each element is visited at most twice (once by right pointer, once by left pointer)
- **Space**: O(1) - constant space for pointers and variables

## Solution Code

```go
package main

import (
	"math"
)

func minSubArrayLen(target int, nums []int) int {
	n := len(nums)
	left := 0
	sum := 0
	minLength := math.MaxInt32
	
	for right := 0; right < n; right++ {
		sum += nums[right]
		
		// Try to shrink the window from the left while sum >= target
		for sum >= target {
			// Update the minimum length
			currentLength := right - left + 1
			if currentLength < minLength {
				minLength = currentLength
			}
			
			// Shrink the window
			sum -= nums[left]
			left++
		}
	}
	
	// If minLength was never updated, return 0
	if minLength == math.MaxInt32 {
		return 0
	}
	
	return minLength
}
```

## Link

[LeetCode 0209 Minimum Size Subarray Sum](https://leetcode.com/problems/minimum-size-subarray-sum/)