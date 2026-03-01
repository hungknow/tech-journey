# 0016 3Sum Closest

## Problem Description

Given an integer array `nums` of length `n` and an integer `target`, find three integers in `nums` such that the sum is closest to `target`.

Return the sum of the three integers.

You may assume that each input would have exactly one solution.

### Example 1:
```
Input: nums = [-1,2,1,-4], target = 1
Output: 2
Explanation: The sum that is closest to the target is 2. (-1 + 2 + 1 = 2).
```

### Example 2:
```
Input: nums = [0,0,0], target = 1
Output: 0
Explanation: The sum that is closest to the target is 0. (0 + 0 + 0 = 0).
```

## Two Pointers Approach

Similar to 3Sum, we can use the two-pointer technique after sorting the array. The key difference is that we're looking for the sum closest to the target rather than exactly equal to zero.

### Algorithm Steps:

1. Sort the input array `nums`
2. Initialize `closest` to the sum of the first three elements (or a very large value)
3. Iterate through the array with index `i` from 0 to n-3
   - Use two pointers `left = i+1` and `right = n-1`
   - Calculate the current sum: `current = nums[i] + nums[left] + nums[right]`
   - If `current` is closer to target than `closest`, update `closest`
   - If `current` is less than target, increment `left` pointer
   - If `current` is greater than target, decrement `right` pointer
   - If `current` equals target, we've found the exact match, return immediately

## Complexity

- **Time**: O(n²) - sorting takes O(n log n) and the two-pointer approach takes O(n²)
- **Space**: O(1) - excluding the space for sorting

## Solution Code

```go
package main

import (
	"math"
	"sort"
)

func threeSumClosest(nums []int, target int) int {
	sort.Ints(nums)
	n := len(nums)
	closest := nums[0] + nums[1] + nums[2]
	
	for i := 0; i < n-2; i++ {
		left, right := i+1, n-1
		
		for left < right {
			current := nums[i] + nums[left] + nums[right]
			
			// If we found the exact target, return immediately
			if current == target {
				return target
			}
			
			// Update closest if current is closer to target
			if math.Abs(float64(current-target)) < math.Abs(float64(closest-target)) {
				closest = current
			}
			
			// Move pointers based on comparison with target
			if current < target {
				left++
			} else {
				right--
			}
		}
	}
	
	return closest
}
```

## Link

[LeetCode 0016 3Sum Closest](https://leetcode.com/problems/3sum-closest/)