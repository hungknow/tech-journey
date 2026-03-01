# 1818 Minimum Absolute Sum Difference

## Problem Description

You are given two arrays `nums1` and `nums2` of equal length `n`.

The absolute sum difference of arrays `nums1` and `nums2` is defined as the sum of `|nums1[i] - nums2[i]|` for all `0 <= i < n`.

You can replace at most one element in `nums1` with any element from `nums1`.

Return the minimum absolute sum difference after at most one replacement operation.

Since the answer may be large, return it modulo `10^9 + 7`.

### Example 1:
```
Input: nums1 = [1,7,5], nums2 = [2,3,5]
Output: 3
Explanation: Replace nums1[0] with nums1[1] to get [7,7,5].
The absolute sum difference becomes |7-2| + |7-3| + |5-5| = 5 + 4 + 0 = 9.
The minimum absolute sum difference is 3 (no replacement needed).
```

### Example 2:
```
Input: nums1 = [2,4,6,8,10], nums2 = [2,5,6,7,10]
Output: 3
Explanation: Replace nums1[3] with nums1[1] to get [2,4,6,4,10].
The absolute sum difference becomes |2-2| + |4-5| + |6-6| + |4-7| + |10-10| = 0 + 1 + 0 + 3 + 0 = 4.
The minimum absolute sum difference is 3.
```

## The Twist

Finding the **minimum absolute sum difference** after at most one replacement. This involves using binary search to efficiently find the best replacement value for each position.

## Algorithm

### Binary Search Approach:
1. Create a sorted copy of `nums1` for binary search
2. Calculate the initial sum of absolute differences
3. For each position `i`:
   - Use binary search to find the closest value in `nums1` to `nums2[i]`
   - Calculate the potential improvement in the sum difference
   - Keep track of the maximum improvement
4. Return the initial sum minus the maximum improvement

The key insight is that for each position, we can efficiently find the best replacement value using binary search on the sorted copy of `nums1`.

## Complexity

- **Time**: O(n log n) - sorting and binary searches
- **Space**: O(n) - space for the sorted copy

## Solution Code

```go
package main

import (
	"fmt"
	"sort"
)

const MOD = 1000000007

func minAbsoluteSumDiff(nums1 []int, nums2 []int) int {
	n := len(nums1)
	
	// Create a sorted copy of nums1 for binary search
	sortedNums1 := make([]int, n)
	copy(sortedNums1, nums1)
	sort.Ints(sortedNums1)
	
	// Calculate initial sum of absolute differences
	totalSum := 0
	for i := 0; i < n; i++ {
		totalSum += abs(nums1[i] - nums2[i])
	}
	
	// Find the maximum improvement possible
	maxImprovement := 0
	
	for i := 0; i < n; i++ {
		// Find the closest value to nums2[i] in sortedNums1
		idx := sort.SearchInts(sortedNums1, nums2[i])
		
		// Check the value at idx (if exists)
		if idx < n {
			improvement := abs(nums1[i] - nums2[i]) - abs(sortedNums1[idx] - nums2[i])
			if improvement > maxImprovement {
				maxImprovement = improvement
			}
		}
		
		// Check the value at idx-1 (if exists)
		if idx > 0 {
			improvement := abs(nums1[i] - nums2[i]) - abs(sortedNums1[idx-1] - nums2[i])
			if improvement > maxImprovement {
				maxImprovement = improvement
			}
		}
	}
	
	return (totalSum - maxImprovement) % MOD
}

func abs(x int) int {
	if x < 0 {
		return -x
	}
	return x
}
```

## Link

[LeetCode 1818 Minimum Absolute Sum Difference](https://leetcode.com/problems/minimum-absolute-sum-difference/)