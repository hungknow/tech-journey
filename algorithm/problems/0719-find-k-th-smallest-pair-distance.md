# 0719 Find K-th Smallest Pair Distance

## Problem Description

Given an integer array `nums` and an integer `k`, return the kth smallest distance pair.

The distance of a pair (a, b) is defined as the absolute difference between the two elements.

### Example 1:
```
Input: nums = [1,3,1], k = 1
Output: 0
Explanation: Here are all the pairs:
(1,3) -> 2
(1,1) -> 0
(3,1) -> 2
Then the 1st smallest distance pair is (1,1), and its distance is 0.
```

### Example 2:
```
Input: nums = [1,6,1], k = 3
Output: 5
```

## The Twist

Finding the **kth smallest pair distance** efficiently. This is a binary search on answer problem where we count pairs with distance ≤ mid.

## Algorithm

### Binary Search on Distance:
1. Sort the array
2. The answer is between 0 and max(nums) - min(nums)
3. Binary search on this range:
   - For each `mid`, count how many pairs have distance ≤ `mid`
   - Use two pointers to count efficiently
   - If count ≥ k, try smaller distance (`right = mid`)
   - Otherwise, need larger distance (`left = mid + 1`)
4. When loop ends, `left` is the kth smallest distance

## Complexity

- **Time**: O(n log n + n log w) where w is the value range
- **Space**: O(1) - constant extra space

## Solution Code

```go
package main

import (
	"sort"
)

func smallestDistancePair(nums []int, k int) int {
	sort.Ints(nums)
	
	left, right := 0, nums[len(nums)-1] - nums[0]
	
	for left < right {
		mid := left + (right-left)/2
		
		if countPairs(nums, mid) >= k {
			right = mid
		} else {
			left = mid + 1
		}
	}
	
	return left
}

func countPairs(nums []int, maxDist int) int {
	count := 0
	left := 0
	
	for right := 0; right < len(nums); right++ {
		for nums[right] - nums[left] > maxDist {
			left++
		}
		count += right - left
	}
	
	return count
}
```

## Link

[LeetCode 0719 Find K-th Smallest Pair Distance](https://leetcode.com/problems/find-k-th-smallest-pair-distance/)
