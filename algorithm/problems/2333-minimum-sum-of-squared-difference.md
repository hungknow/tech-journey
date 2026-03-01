# 2333 Minimum Sum of Squared Difference

## Problem Description

You are given two integer arrays `nums1` and `nums2` of equal length `n`.

You are allowed to perform the following operation any number of times:
- Choose an index `i` and increase `nums1[i]` by 1 and decrease `nums2[i]` by 1, or vice versa

Return the minimum possible sum of squared differences after performing at most `k1` operations on `nums1` and at most `k2` operations on `nums2`.

The squared difference between `nums1[i]` and `nums2[i]` is defined as `(nums1[i] - nums2[i])^2`.

### Example 1:
```
Input: nums1 = [1,2,3,4], nums2 = [2,10,20,19], k1 = 0, k2 = 1
Output: 579
Explanation: We can decrease nums2[3] by 1 to get [1,2,3,4] and [2,10,20,18].
The sum of squared differences is 1^2 + 8^2 + 17^2 + 14^2 = 579.
```

### Example 2:
```
Input: nums1 = [1,4,10,12], nums2 = [5,8,6,9], k1 = 4, k2 = 1
Output: 43
Explanation: We can perform operations to minimize the sum of squared differences.
```

## The Twist

Finding the **minimum sum of squared differences** after limited operations. This involves using binary search to efficiently determine the optimal distribution of operations.

## Algorithm

### Binary Search Approach:
1. Calculate the initial differences between corresponding elements
2. Use binary search to determine the optimal threshold value:
   - For each possible threshold, calculate how many operations are needed to bring all differences below this threshold
   - Use a priority queue to always apply operations to the largest differences first
3. Calculate the minimum sum of squared differences after applying operations

The key insight is that we should always apply operations to the largest differences first, and binary search helps determine the optimal stopping point.

## Complexity

- **Time**: O(n log n + n log(maxDiff)) - sorting and binary search with heap operations
- **Space**: O(n) - space for heap and difference array

## Solution Code

```go
package main

import (
	"container/heap"
	"fmt"
	"math"
)

type MaxHeap []int

func (h MaxHeap) Len() int           { return len(h) }
func (h MaxHeap) Less(i, j int) bool { return h[i] > h[j] }
func (h MaxHeap) Swap(i, j int)      { h[i], h[j] = h[j], h[i] }

func (h *MaxHeap) Push(x interface{}) {
	*h = append(*h, x.(int))
}

func (h *MaxHeap) Pop() interface{} {
	old := *h
	n := len(old)
	x := old[n-1]
	*h = old[0 : n-1]
	return x
}

func minSumSquareDiff(nums1 []int, nums2 []int, k1 int, k2 int) int64 {
	n := len(nums1)
	diffs := make([]int, n)
	
	// Calculate initial differences
	for i := 0; i < n; i++ {
		diffs[i] = int(math.Abs(float64(nums1[i] - nums2[i])))
	}
	
	// Create a max heap of differences
	maxHeap := &MaxHeap{}
	heap.Init(maxHeap)
	for _, diff := range diffs {
		heap.Push(maxHeap, diff)
	}
	
	// Apply operations to largest differences first
	totalOps := k1 + k2
	for totalOps > 0 && (*maxHeap)[0] > 0 {
		// Get the largest difference
		maxDiff := heap.Pop(maxHeap).(int)
		
		// Calculate how many operations to apply
		ops := totalOps
		if maxHeap.Len() > 0 {
			nextDiff := (*maxHeap)[0]
			ops = min(totalOps, maxDiff-nextDiff+1)
		}
		
		// Apply operations
		newDiff := max(0, maxDiff-ops)
		heap.Push(maxHeap, newDiff)
		totalOps -= ops
	}
	
	// Calculate the sum of squared differences
	result := int64(0)
	for _, diff := range diffs {
		result += int64(diff * diff)
	}
	
	return result
}

func min(a, b int) int {
	if a < b {
		return a
	}
	return b
}

func max(a, b int) int {
	if a > b {
		return a
	}
	return b
}
```

## Link

[LeetCode 2333 Minimum Sum of Squared Difference](https://leetcode.com/problems/minimum-sum-of-squared-difference/)