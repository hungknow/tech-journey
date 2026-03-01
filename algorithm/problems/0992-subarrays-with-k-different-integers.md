# 0992 Subarrays with K Different Integers

## Problem Description

Given an integer array `nums` and an integer `k`, return the number of good subarrays of `nums`.

A subarray is good if it contains `k` distinct integers.

### Example 1:
```
Input: nums = [1,2,1,2,3], k = 2
Output: 7
Explanation: Subarrays with exactly 2 distinct integers are:
[1,2], [2,1], [1,2], [2,3], [1,2,1], [2,1,2], [1,2,1,2]
```

### Example 2:
```
Input: nums = [1,2,1,3,4], k = 3
Output: 3
Explanation: Subarrays with exactly 3 distinct integers are:
[1,2,1,3], [2,1,3], [1,3,4]
```

## Sliding Window Approach

This problem can be solved using a sliding window approach with a frequency map to track distinct elements in the current window.

### Algorithm Steps:

1. Initialize a frequency map to track elements in the current window
2. Initialize `left = 0`, `result = 0`, and `distinctCount = 0`
3. Iterate through the array with `right` pointer from 0 to n-1:
   - If `nums[right]` is not in the frequency map or its count is 0:
     - Increment `distinctCount`
   - Increment the count of `nums[right]` in the frequency map
   - While `distinctCount > k`:
     - Decrement the count of `nums[left]` in the frequency map
     - If the count becomes 0, decrement `distinctCount`
     - Increment `left`
   - If `distinctCount == k`:
     - Add `right - left + 1` to `result`
4. Return `result`

## Complexity

- **Time**: O(n) - we iterate through the array once
- **Space**: O(k) - space for the frequency map (at most k+1 keys)

## Solution Code

```go
package main

func subarraysWithKDistinct(nums []int, k int) int {
	n := len(nums)
	if n == 0 {
		return 0
	}
	
	// Frequency map for elements in the current window
	freq := make(map[int]int)
	left := 0
	result := 0
	distinctCount := 0
	
	for right := 0; right < n; right++ {
		// Add current element to the window
		if freq[nums[right]] == 0 {
			distinctCount++
		}
		freq[nums[right]]++
		
		// Shrink the window if we have more than k distinct elements
		for distinctCount > k {
			freq[nums[left]]--
			if freq[nums[left]] == 0 {
				distinctCount--
			}
			left++
		}
		
		// If we have exactly k distinct elements, all subarrays ending at right are valid
		if distinctCount == k {
			result += right - left + 1
		}
	}
	
	return result
}
```

## Link

[LeetCode 0992 Subarrays with K Different Integers](https://leetcode.com/problems/subarrays-with-k-different-integers/)