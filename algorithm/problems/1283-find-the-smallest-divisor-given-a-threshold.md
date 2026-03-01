# 1283 Find the Smallest Divisor Given a Threshold

## Problem Description

Given an integer array `nums` and an integer `threshold`, we need to find the smallest positive integer `divisor` such that when we divide every element of the array by `divisor` and take the ceiling of the result, the sum of the results is less than or equal to `threshold`.

Each result of the division is rounded up to the nearest integer (i.e. `7/3 = 3`).

### Example 1:
```
Input: nums = [1,2,5,9], threshold = 6
Output: 5
Explanation: We can get a sum to 6 (ceil(1/5) + ceil(2/5) + ceil(5/5) + ceil(9/5) = 1+1+1+2 = 6) using divisor 5.
```

### Example 2:
```
Input: nums = [2,3,5,7,11], threshold = 11
Output: 3
```

### Example 3:
```
Input: nums = [19], threshold = 5
Output: 4
```

## The Twist

Finding the **smallest divisor** that keeps the sum of ceil divisions ≤ threshold. This is a binary search on answer problem.

## Algorithm

### Binary Search on Divisor:
1. The answer is between 1 and max(nums)
2. Binary search on this range:
   - For each `mid`, calculate the sum of ceil(nums[i]/mid)
   - If sum ≤ threshold, try smaller divisor (`right = mid`)
   - Otherwise, need larger divisor (`left = mid + 1`)
3. When loop ends, `left` is the minimum feasible divisor

To calculate ceil(a/b): `(a + b - 1) / b`

## Complexity

- **Time**: O(n log(max(nums)))
- **Space**: O(1) - constant extra space

## Solution Code

```go
package main

func smallestDivisor(nums []int, threshold int) int {
	left, right := 1, 0
	
	// Find the maximum element
	for _, num := range nums {
		right = max(right, num)
	}
	
	// Binary search for the smallest feasible divisor
	for left < right {
		mid := left + (right-left)/2
		
		if canDivide(nums, threshold, mid) {
			right = mid
		} else {
			left = mid + 1
		}
	}
	
	return left
}

func canDivide(nums []int, threshold, divisor int) bool {
	sum := 0
	
	for _, num := range nums {
		// Calculate ceil(num/divisor)
		ceilDiv := (num + divisor - 1) / divisor
		sum += ceilDiv
		
		if sum > threshold {
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

[LeetCode 1283 Find the Smallest Divisor Given a Threshold](https://leetcode.com/problems/find-the-smallest-divisor-given-a-threshold/)
