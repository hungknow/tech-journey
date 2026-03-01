# 2831 Find the Longest Equal Subarray

## Problem Description

You are given an integer array `nums` and an integer `k`.

A subarray is equal if all its elements are equal.

Return the length of the longest equal subarray.

### Example 1:
```
Input: nums = [1,2,3,4,5,6,7,8,9,10], k = 3
Output: 3
Explanation: The longest equal subarray is [3,3,3], with length 3.
```

### Example 2:
```
Input: nums = [1,1,1,1,1], k = 1
Output: 4
Explanation: The longest equal subarray is [1,1,1,1], with length 4.
```

## Approach

This problem can be solved using a sliding window approach:

1. Use a sliding window to maintain a subarray where all elements are equal.
2. Expand the window to the right, adding the current element.
3. If the current element is different from the first element in the window, shrink the window from the left until all elements are equal.
4. Keep track of the maximum window size encountered.

## Solution Code

```go
func longestEqualSubarray(nums []int, k int) int {
    n := len(nums)
    if n == 0 {
        return 0
    }
    
    left := 0
    maxLen := 0
    
    for right := 0; right < n; right++ {
        // If the current element is different from the first element, shrink from the left
        if nums[right] != nums[left] {
            left = right
            continue
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

- **Time**: O(n) - Each element is added to and removed from the window at most once
- **Space**: O(1) - We only use a few pointers regardless of the input size

## Link

[LeetCode 2831 Find the Longest Equal Subarray](https://leetcode.com/problems/find-the-longest-equal-subarray/)