# 2513 Minimize the Maximum of Two Arrays

## Problem Description

You are given two integer arrays `nums1` and `nums2` of equal length `n`.

You want to minimize the maximum value among all elements of both arrays after performing at most `k` operations.

In each operation, you can:
- Choose an index `i` and decrement `nums1[i]` by 1
- Choose an index `j` and increment `nums2[j]` by 1

Return the minimum possible value of `max(max(nums1), max(nums2))` after at most `k` operations.

### Example 1:
```
Input: nums1 = [4,5,9], nums2 = [1,2,6], k = 3
Output: 8
Explanation: 
- Decrement nums1[2] by 1: [4,5,8], [1,2,6]
- Decrement nums1[2] by 1: [4,5,7], [1,2,6]
- Increment nums2[2] by 1: [4,5,7], [1,2,7]
Maximum value is max(7, 7) = 7
```

### Example 2:
```
Input: nums1 = [1,3,5], nums2 = [2,4,6], k = 10
Output: 5
Explanation: We can balance the arrays to minimize the maximum value.
```

## The Twist

Finding the **minimum possible maximum** value after limited operations. This involves using binary search to efficiently determine the optimal target value.

## Algorithm

### Binary Search Approach:
1. Use binary search on the possible maximum value (from min current max to max current max)
2. For each candidate maximum `x`:
   - Calculate how many operations are needed to ensure all elements in `nums1` ≤ `x`
   - Calculate how many operations are needed to ensure all elements in `nums2` ≤ `x`
   - Check if the total operations ≤ `k`
3. If we can achieve maximum `x`, try a smaller value; otherwise, try a larger value
4. Return the minimum achievable maximum

The key insight is that if we can achieve a maximum value of `x`, we can also achieve any maximum value greater than `x`, enabling binary search.

## Complexity

- **Time**: O(n log(max(nums1, nums2))) - binary search with operation counting
- **Space**: O(1) - constant space

## Solution Code

```go
package main

import "fmt"

func minimizeArrayValue(nums1 []int, nums2 []int, k int) int {
	// Find the current maximum in both arrays
	currentMax := 0
	for _, num := range nums1 {
		if num > currentMax {
			currentMax = num
		}
	}
	for _, num := range nums2 {
		if num > currentMax {
			currentMax = num
		}
	}
	
	// Binary search for the minimum possible maximum
	left := 0
	right := currentMax
	
	result := currentMax
	
	for left <= right {
		mid := left + (right-left)/2
		
		// Calculate operations needed to achieve maximum mid
		operations := 0
		
		// Operations needed for nums1 (decrement values > mid)
		for _, num := range nums1 {
			if num > mid {
				operations += num - mid
			}
		}
		
		// Operations needed for nums2 (decrement values > mid)
		for _, num := range nums2 {
			if num > mid {
				operations += num - mid
			}
		}
		
		if operations <= k {
			result = mid
			right = mid - 1 // Try smaller maximum
		} else {
			left = mid + 1 // Try larger maximum
		}
	}
	
	return result
}
```

## Link

[LeetCode 2513 Minimize the Maximum of Two Arrays](https://leetcode.com/problems/minimize-the-maximum-of-two-arrays/)