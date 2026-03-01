# 0410 Split Array Largest Sum

## Problem Description

Given an integer array `nums` and an integer `k`, split the array into `k` non-empty subarrays. Write an algorithm to minimize the largest sum among these `k` subarrays.

### Example 1:
```
Input: nums = [7,2,5,10,8], k = 2
Output: 18
Explanation: Split nums into [7,2,5] and [10,8]. The largest sum among these subarrays is 18.
```

### Example 2:
```
Input: nums = [1,2,3,4,5], k = 2
Output: 9
Explanation: Split nums into [1,2,3,4] and [5]. The largest sum among these subarrays is 9.
```

## The Twist

Finding the **minimum possible maximum subarray sum** when splitting into `k` subarrays. This is a classic binary search on answer problem.

## Algorithm

### Binary Search on Answer:
1. The answer is between `max(nums)` (minimum possible) and `sum(nums)` (maximum possible)
2. Binary search on this range:
   - For each `mid`, check if we can split the array into ≤ k subarrays with max sum ≤ `mid`
   - If yes, try smaller maximum (`high = mid`)
   - If no, need larger maximum (`low = mid + 1`)
3. When loop ends, `low` is the minimum possible maximum

To check feasibility, greedily accumulate elements until adding the next would exceed `mid`, then start a new subarray.

## Complexity

- **Time**: O(n log(sum(nums) - max(nums)))
- **Space**: O(1) - constant extra space

## Solution Code

```go
package main

func splitArray(nums []int, k int) int {
	if len(nums) == 0 {
		return 0
	}
	
	low, high := 0, 0
	
	// Find the minimum and maximum possible values
	for _, num := range nums {
		low = max(low, num)    // At least one element per subarray
		high += num            // All elements in one subarray
	}
	
	// Binary search for the minimum possible maximum
	for low < high {
		mid := low + (high-low)/2
		
		if canSplit(nums, k, mid) {
			high = mid
		} else {
			low = mid + 1
		}
	}
	
	return low
}

func canSplit(nums []int, k int, maxSum int) bool {
	subarrays := 1
	currentSum := 0
	
	for _, num := range nums {
		if currentSum+num > maxSum {
			subarrays++
			currentSum = num
			
			if subarrays > k {
				return false
			}
		} else {
			currentSum += num
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

[LeetCode 0410 Split Array Largest Sum](https://leetcode.com/problems/split-array-largest-sum/)
