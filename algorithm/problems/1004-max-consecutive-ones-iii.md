# 1004 Max Consecutive Ones III

## Problem Description

Given a binary array `nums` and an integer `k`, return the maximum number of consecutive `1`'s in the array if you can flip at most `k` `0`'s.

### Example 1:
```
Input: nums = [1,1,1,0,0,0,1,1,1,0], k = 2
Output: 6
Explanation: [1,1,1,0,0,1,1,1,1,0]
Bolded numbers were flipped from 0 to 1.
The longest subarray is underlined.
```

### Example 2:
```
Input: nums = [0,0,1,1,1,0,0], k = 0
Output: 4
```

## Sliding Window Approach

This problem can be solved using a sliding window approach. We maintain a window that can contain at most `k` zeros, which represents the maximum number of consecutive ones we can get by flipping those zeros.

### Algorithm Steps:

1. Initialize `left = 0`, `zeroCount = 0`, and `maxOnes = 0`
2. Iterate through the array with `right` pointer from 0 to n-1:
   - If `nums[right] == 0`, increment `zeroCount`
   - While `zeroCount > k`:
     - If `nums[left] == 0`, decrement `zeroCount`
     - Increment `left`
   - Update `maxOnes` with `max(maxOnes, right - left + 1)`
3. Return `maxOnes`

## Complexity

- **Time**: O(n) - we iterate through the array once
- **Space**: O(1) - constant space for pointers and variables

## Solution Code

```go
package main

func longestOnes(nums []int, k int) int {
	n := len(nums)
	left := 0
	zeroCount := 0
	maxOnes := 0
	
	for right := 0; right < n; right++ {
		// If we encounter a zero, increment the count
		if nums[right] == 0 {
			zeroCount++
		}
		
		// If we have more than k zeros, shrink the window
		for zeroCount > k {
			if nums[left] == 0 {
				zeroCount--
			}
			left++
		}
		
		// Update the maximum number of consecutive ones
		currentLength := right - left + 1
		if currentLength > maxOnes {
			maxOnes = currentLength
		}
	}
	
	return maxOnes
}
```

## Link

[LeetCode 1004 Max Consecutive Ones III](https://leetcode.com/problems/max-consecutive-ones-iii/)