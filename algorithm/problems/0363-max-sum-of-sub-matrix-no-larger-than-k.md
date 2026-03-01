# 0363 Max Sum of Sub-matrix No Larger Than K

## Problem Description

Given an `m x n` matrix `matrix` and an integer `k`, return the max sum of a rectangle in the matrix such that its sum is no larger than `k`.

### Example 1:
```
Input: matrix = [[1,0,1],[0,-2,3]], k = 2
Output: 2
Explanation: Because the sum of the blue rectangle [[0, 1], [-2, 3]] is 2, and 2 is the max number no larger than k (2).
```

### Example 2:
```
Input: matrix = [[2,2,-1]], k = 3
Output: 3
```

## The Twist

Finding the **maximum sub-matrix sum** that doesn't exceed `k`. This requires converting the 2D problem to 1D and using binary search with a prefix sum set.

## Algorithm

### 2D to 1D Reduction with Binary Search:
1. Iterate over all pairs of rows (top and bottom boundaries)
2. For each row pair, compute the column sums between those rows
3. For each column sum array, find the maximum subarray sum ≤ k:
   - Compute prefix sums
   - Use a sorted set to store prefix sums
   - For each prefix sum, find the smallest prefix sum ≥ (current - k)
   - The difference gives a valid subarray sum

## Complexity

- **Time**: O(min(m, n)² * max(m, n) * log(max(m, n)))
- **Space**: O(max(m, n)) - for prefix sums and sorted set

## Solution Code

```go
package main

import (
	"sort"
)

func maxSumSubmatrix(matrix [][]int, k int) int {
	if len(matrix) == 0 || len(matrix[0]) == 0 {
		return 0
	}
	
	m, n := len(matrix), len(matrix[0])
	result := -1 << 31
	
	// Iterate over the smaller dimension for better performance
	if m > n {
		// Transpose the matrix
		transposed := make([][]int, n)
		for i := 0; i < n; i++ {
			transposed[i] = make([]int, m)
			for j := 0; j < m; j++ {
				transposed[i][j] = matrix[j][i]
			}
		}
		matrix = transposed
		m, n = n, m
	}
	
	// Iterate over all pairs of rows
	for top := 0; top < m; top++ {
		colSums := make([]int, n)
		
		for bottom := top; bottom < m; bottom++ {
			// Update column sums for the current row pair
			for col := 0; col < n; col++ {
				colSums[col] += matrix[bottom][col]
			}
			
			// Find maximum subarray sum <= k in colSums
			result = max(result, maxSumSubarrayNoMoreThanK(colSums, k))
			
			if result == k {
				return k // Early exit if we found the optimal solution
			}
		}
	}
	
	return result
}

func maxSumSubarrayNoMoreThanK(nums []int, k int) int {
	maxSum := -1 << 31
	prefixSum := 0
	
	// Sorted set to store prefix sums
	prefixSums := []int{0}
	
	for _, num := range nums {
		prefixSum += num
		
		// Find the smallest prefix sum >= prefixSum - k
		target := prefixSum - k
		idx := sort.SearchInts(prefixSums, target)
		
		if idx < len(prefixSums) {
			maxSum = max(maxSum, prefixSum-prefixSums[idx])
		}
		
		// Insert current prefix sum in sorted order
		insertPos := sort.SearchInts(prefixSums, prefixSum)
		prefixSums = append(prefixSums, 0)
		copy(prefixSums[insertPos+1:], prefixSums[insertPos:])
		prefixSums[insertPos] = prefixSum
	}
	
	return maxSum
}

func max(a, b int) int {
	if a > b {
		return a
	}
	return b
}
```

## Link

[LeetCode 0363 Max Sum of Sub-matrix No Larger Than K](https://leetcode.com/problems/max-sum-of-sub-matrix-no-larger-than-k/)
