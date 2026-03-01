# 0930 Binary Subarrays With Sum

## Problem Description

Given a binary array `nums` and an integer `goal`, return the number of non-empty subarrays with sum is `goal`.

A subarray is a contiguous part of the array.

### Example 1:
```
Input: nums = [1,0,1,0,1], goal = 2
Output: 4
Explanation: 
The 4 subarrays are bolded and underlined below:
[<u>1,0,1</u>,0,1]
[<u>1,0,1,0</u>]
[0,<u>1,0,1</u>]
[1,0,<u>1,0,1</u>]
```

### Example 2:
```
Input: nums = [0,0,0,0,0], goal = 0
Output: 15
```

## Sliding Window Approach

This problem can be solved efficiently using a sliding window approach. Since the array contains only 0s and 1s, we can optimize by counting the number of 1s in the window.

### Algorithm Steps:

1. Initialize `left = 0`, `currentSum = 0`, `result = 0`, and `countOnes = 0` (number of 1s in the entire array)
2. Count the total number of 1s in the array
3. Iterate through the array with `right` pointer from 0 to n-1:
   - Add `nums[right]` to `currentSum`
   - While `currentSum > goal`:
     - Subtract `nums[left]` from `currentSum`
     - Increment `left`
   - If `currentSum == goal`:
     - Calculate the number of possible subarrays ending at `right`:
       - If `nums[right] == 1`: The number of subarrays is the number of 0s after the last 1 + 1
       - If `nums[right] == 0`: The number of subarrays is the number of consecutive 0s at the end
     - Add this count to `result`
4. Return `result`

## Complexity

- **Time**: O(n) - we iterate through the array once
- **Space**: O(1) - constant space for pointers and variables

## Solution Code

```go
package main

func numSubarraysWithSum(nums []int, goal int) int {
	n := len(nums)
	left := 0
	currentSum := 0
	result := 0
	
	// Count the number of 1s in the array
	countOnes := 0
	for _, num := range nums {
		countOnes += num
	}
	
	for right := 0; right < n; right++ {
		currentSum += nums[right]
		
		// Shrink the window if the sum exceeds the goal
		for left <= right && currentSum > goal {
			currentSum -= nums[left]
			left++
		}
		
		// If we found a valid sum
		if currentSum == goal {
			if nums[right] == 1 {
				// Count consecutive zeros after the last 1
				temp := right + 1
				for temp < n && nums[temp] == 0 {
					temp++
				}
				result += temp - right
			} else {
				// Count consecutive zeros at the end
				temp := right
				for temp >= left && nums[temp] == 0 {
					temp--
				}
				result += right - temp
			}
		}
	}
	
	return result
}
```

## Alternative Prefix Sum Approach

Another approach is to use prefix sums with a hash map to store the frequency of prefix sums.

### Algorithm Steps:

1. Initialize `prefixSum = 0`, `result = 0`, and a hash map `sumCount` with `{0: 1}`
2. Iterate through the array:
   - Add the current element to `prefixSum`
   - If `prefixSum - goal` exists in `sumCount`, add its frequency to `result`
   - Increment the frequency of `prefixSum` in `sumCount`
3. Return `result`

## Alternative Solution Code

```go
package main

func numSubarraysWithSum(nums []int, goal int) int {
	prefixSum := 0
	result := 0
	sumCount := make(map[int]int)
	sumCount[0] = 1
	
	for _, num := range nums {
		prefixSum += num
		
		// Check if there's a prefix sum that would give us the goal
		if count, exists := sumCount[prefixSum-goal]; exists {
			result += count
		}
		
		// Update the frequency of the current prefix sum
		sumCount[prefixSum]++
	}
	
	return result
}
```

## Link

[LeetCode 0930 Binary Subarrays With Sum](https://leetcode.com/problems/binary-subarrays-with-sum/)