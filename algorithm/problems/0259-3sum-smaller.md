# 0259 3Sum Smaller

## Problem Description

Given an array of `n` integers `nums` and an integer `target`, find the number of index triplets `i`, `j`, and `k` such that `0 <= i < j < k < n` and `nums[i] + nums[j] + nums[k] < target`.

### Example 1:
```
Input: nums = [-2,0,1,3], target = 2
Output: 2
Explanation: Because there are two triplets which sums are less than 2:
[-2,0,1]
[-2,0,3]
```

### Example 2:
```
Input: nums = [], target = 0
Output: 0
```

### Example 3:
```
Input: nums = [0], target = 0
Output: 0
```

## Two Pointers Approach

This problem is a variation of 3Sum, but instead of finding exact sums, we're counting the number of triplets with sums less than the target. The two-pointer technique is perfect for this.

### Algorithm Steps:

1. Sort the input array `nums`
2. Initialize `count = 0`
3. Iterate through the array with index `i` from 0 to n-3
   - Use two pointers `left = i+1` and `right = n-1`
   - Calculate the current sum: `current = nums[i] + nums[left] + nums[right]`
   - If `current < target`:
     - All elements between `left` and `right` will also form valid triplets with `i` and `left`
     - Add `right - left` to `count`
     - Increment `left` to explore more possibilities
   - If `current >= target`:
     - Decrement `right` to reduce the sum

## Complexity

- **Time**: O(n²) - sorting takes O(n log n) and the two-pointer approach takes O(n²)
- **Space**: O(1) - excluding the space for sorting

## Solution Code

```go
package main

import (
	"sort"
)

func threeSumSmaller(nums []int, target int) int {
	sort.Ints(nums)
	count := 0
	n := len(nums)
	
	for i := 0; i < n-2; i++ {
		left, right := i+1, n-1
		
		for left < right {
			current := nums[i] + nums[left] + nums[right]
			
			if current < target {
				// All elements between left and right will form valid triplets with i and left
				count += right - left
				left++
			} else {
				// Sum is too large, need to decrease it
				right--
			}
		}
	}
	
	return count
}
```

## Link

[LeetCode 0259 3Sum Smaller](https://leetcode.com/problems/3sum-smaller/)