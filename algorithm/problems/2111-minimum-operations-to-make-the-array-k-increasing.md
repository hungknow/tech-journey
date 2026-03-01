# 2111 Minimum Operations to Make the Array K-Increasing

## Problem Description

You are given a non-decreasing array `arr` and an integer `k`.

An array is k-increasing if for every `i` where `k <= i <= n-1`, `arr[i-k] <= arr[i]`.

For example, if `k = 2`, then the array `[3, 1, 2, 4]` is k-increasing because:
- `arr[0] <= arr[2]` (3 <= 2) is false
- `arr[1] <= arr[3]` (1 <= 4) is true

But the array `[3, 1, 2, 3, 4]` is k-increasing because:
- `arr[0] <= arr[2]` (3 <= 2) is false
- `arr[1] <= arr[3]` (1 <= 3) is true
- `arr[2] <= arr[4]` (2 <= 4) is true

Return the minimum number of operations required to make the array k-increasing.

### Example 1:
```
Input: arr = [5,4,3,2,1], k = 1
Output: 4
Explanation:
For k = 1, the array [5,4,3,2,1] is not k-increasing.
We need to perform 4 operations to make it k-increasing:
- Increase arr[0] to 6
- Increase arr[1] to 6
- Increase arr[2] to 6
- Increase arr[3] to 6
The array becomes [6,6,6,6,1].
```

## The Twist

Finding the **minimum operations** to make an array k-increasing. This involves finding LIS for each of the k subsequences.

## Algorithm

### LIS for Each Subsequence:
1. Split the array into k independent subsequences:
   - Subsequence 0: arr[0], arr[k], arr[2k], ...
   - Subsequence 1: arr[1], arr[k+1], arr[2k+1], ...
   - ...
2. For each subsequence, find the Longest Non-Decreasing Subsequence (LNDS)
3. The answer is sum of (len(subsequence) - LNDS length) for all subsequences

## Complexity

- **Time**: O(n log(n/k)) - LIS computation for each subsequence
- **Space**: O(n/k) - tails array for each subsequence

## Solution Code

```go
package main

import (
	"sort"
)

func kIncreasing(arr []int, k int) int {
	operations := 0
	n := len(arr)
	
	// Process each of the k subsequences
	for start := 0; start < k; start++ {
		subsequence := []int{}
		for i := start; i < n; i += k {
			subsequence = append(subsequence, arr[i])
		}
		
		// Find LNDS length for this subsequence
		lnds := findLNDS(subsequence)
		operations += len(subsequence) - lnds
	}
	
	return operations
}

func findLNDS(nums []int) int {
	if len(nums) == 0 {
		return 0
	}
	
	tails := []int{}
	
	for _, num := range nums {
		// For non-decreasing, use upper_bound
		idx := sort.SearchInts(tails, num+1)
		
		if idx == len(tails) {
			tails = append(tails, num)
		} else {
			tails[idx] = num
		}
	}
	
	return len(tails)
}
```

## Link

[LeetCode 2111 Minimum Operations to Make the Array K-Increasing](https://leetcode.com/problems/minimum-operations-to-make-the-array-k-increasing/)
