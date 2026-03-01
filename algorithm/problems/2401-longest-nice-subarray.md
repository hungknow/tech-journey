# 2401 Longest Nice Subarray

## Problem Description

You are given an integer array `nums`. A subarray is nice if the absolute difference between any two elements in the subarray is less than or equal to 1.

Return the length of the longest nice subarray.

### Example 1:
```
Input: nums = [1,1,2,2,3]
Output: 3
Explanation: The longest nice subarray is [1,2,2] or [2,2,3].
```

### Example 2:
```
Input: nums = [1,2,2,3,4,4,5]
Output: 4
Explanation: The longest nice subarray is [2,2,3,4] or [2,3,4,4].
```

## Approach

This problem can be solved using a sliding window approach:

1. Use a sliding window to maintain a subarray where the difference between the maximum and minimum elements is at most 1.
2. Expand the window to the right, updating the maximum and minimum values.
3. If the difference exceeds 1, shrink the window from the left until the condition is satisfied again.
4. Keep track of the maximum window size encountered.

## Solution Code

```go
func longestNiceSubarray(nums []int) int {
    n := len(nums)
    left := 0
    maxLen := 0
    
    for right := 0; right < n; right++ {
        // Check if the current window is nice
        for left < right && nums[right] - nums[left] > 1 {
            left++
        }
        
        // Update the maximum window size
        if right-left+1 > maxLen {
            maxLen = right - left + 1
        }
    }
    
    return maxLen
}
```

## Complexity Analysis

- **Time**: O(n) - We traverse the array once with the sliding window
- **Space**: O(1) - We only use a few pointers regardless of the input size

## Link

[LeetCode 2401 Longest Nice Subarray](https://leetcode.com/problems/longest-nice-subarray/)