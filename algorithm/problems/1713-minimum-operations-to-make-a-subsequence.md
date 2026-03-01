# 1713 Minimum Operations to Make a Subsequence

## Problem Description

You are given an array `target` and an array `arr`. In one operation, you can select any element from `arr` and increment it by 1.

Return the minimum number of operations required to make `target` a subsequence of `arr`.

### Example 1:
```
Input: target = [1,2,3,4], arr = [1,3,2,4]
Output: 2
Explanation: We need to increment arr[1] and arr[2] by 1 to make target a subsequence.
```

### Example 2:
```
Input: target = [4,5,6], arr = [3,4,5,6]
Output: 0
Explanation: target is already a subsequence of arr.
```

## The Twist

Finding the **minimum operations** to make target a subsequence. This is a variant of LIS where we need to match target elements with arr elements.

## Algorithm

### Mapping + LIS:
1. Create a mapping from value to its index in target
2. Filter arr to only include elements that exist in target, preserving order
3. For each element in filtered arr, map it to its index in target
4. Find the Longest Increasing Subsequence (LIS) of these indices
5. The answer is len(target) - LIS length

The LIS represents the maximum number of target elements already in correct order.

## Complexity

- **Time**: O(n log n) - LIS computation with binary search
- **Space**: O(n) - mapping and filtered array

## Solution Code

```go
package main

import (
	"sort"
)

func minOperations(target []int, arr []int) int {
	// Create mapping from value to index in target
	valueToIndex := make(map[int]int)
	for i, val := range target {
		valueToIndex[val] = i
	}
	
	// Filter arr to only include elements in target
	filtered := []int{}
	for _, val := range arr {
		if idx, exists := valueToIndex[val]; exists {
			filtered = append(filtered, idx)
		}
	}
	
	// Find LIS of filtered indices
	tails := []int{}
	for _, idx := range filtered {
		pos := sort.SearchInts(tails, idx)
		if pos == len(tails) {
			tails = append(tails, idx)
		} else {
			tails[pos] = idx
		}
	}
	
	return len(target) - len(tails)
}
```

## Link

[LeetCode 1713 Minimum Operations to Make a Subsequence](https://leetcode.com/problems/minimum-operations-to-make-a-subsequence/)
