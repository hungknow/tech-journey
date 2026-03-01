# 1918 Kth Smallest Subarray Sum

## Problem Description

You are given an integer array `nums` and an integer `k`.

The subarray sum of a subarray is the sum of all elements in the subarray.

Return the `kth` smallest subarray sum among all possible subarrays of `nums`.

### Example 1:
```
Input: nums = [2,1,3], k = 4
Output: 3
Explanation: The subarray sums are [2,1,3,3,4,6]. The 4th smallest sum is 3.
```

### Example 2:
```
Input: nums = [1,2,3], k = 6
Output: 6
Explanation: The subarray sums are [1,2,3,3,5,6]. The 6th smallest sum is 6.
```

## The Twist

Finding the **kth smallest subarray sum** efficiently without generating all subarrays. This involves using binary search to determine the kth smallest sum by counting how many subarrays have sums less than or equal to a given value.

## Algorithm

### Binary Search Approach:
1. Use binary search on possible subarray sums (from the minimum element to the sum of all elements)
2. For each candidate sum `mid`:
   - Count how many subarrays have sums ≤ `mid`
   - Use a sliding window technique to count efficiently
3. If the count ≥ `k`, try a smaller sum; otherwise, try a larger sum
4. Return the smallest sum for which at least `k` subarrays have sums ≤ that value

The key insight is that we can count how many subarrays have sums ≤ a given value without enumerating all subarrays, enabling efficient binary search.

## Complexity

- **Time**: O(n log(sum(nums))) - binary search with sliding window counting
- **Space**: O(1) - constant space

## Solution Code

```go
package main

import "fmt"

func kthSmallestSubarraySum(nums []int, k int) int {
	// Binary search for the kth smallest subarray sum
	left := 1 // Minimum possible sum (smallest element)
	right := 0 // Maximum possible sum (sum of all elements)
	
	for _, num := range nums {
		right += num
	}
	
	result := 0
	
	for left <= right {
		mid := left + (right-left)/2
		
		// Count how many subarrays have sums <= mid
		count := countSubarrays(nums, mid)
		
		if count >= k {
			result = mid
			right = mid - 1 // Try smaller sum
		} else {
			left = mid + 1 // Try larger sum
		}
	}
	
	return result
}

func countSubarrays(nums []int, target int) int {
	count := 0
	currentSum := 0
	left := 0
	
	for right := 0; right < len(nums); right++ {
		currentSum += nums[right]
		
		// Shrink window from the left while sum > target
		for currentSum > target && left <= right {
			currentSum -= nums[left]
			left++
		}
		
		// All subarrays ending at right with start >= left have sums <= target
		count += right - left + 1
	}
	
	return count
}
```

## Link

[LeetCode 1918 Kth Smallest Subarray Sum](https://leetcode.com/problems/kth-smallest-subarray-sum/)