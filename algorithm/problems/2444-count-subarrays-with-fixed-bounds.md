# 2444 Count Subarrays With Fixed Bounds

## Problem Description

You are given an integer array `nums` and two integers `minK` and `maxK`. A fixed-bound subarray of `nums` is a subarray that satisfies the following conditions:

- The minimum value in the subarray is greater than or equal to `minK`.
- The maximum value in the subarray is less than or equal to `maxK`.

Return the number of fixed-bound subarrays.

A subarray is a contiguous non-empty sequence of elements within an array.

### Example 1:
```
Input: nums = [1,3,5,2,7,5], minK = 1, maxK = 5
Output: 2
Explanation: The fixed-bound subarrays are [1,3,5] and [1,3,5,2].
```

### Example 2:
```
Input: nums = [1,1,1,1], minK = 1, maxK = 1
Output: 6
Explanation: All subarrays are fixed-bound.
```

## Approach

This problem can be solved using a sliding window approach:

1. Use a sliding window to maintain a subarray where all elements are within the bounds [minK, maxK].
2. Expand the window to the right, adding the current element.
3. If the current element is outside the bounds, shrink the window from the left until all elements are within bounds.
4. For each valid window, count the number of subarrays ending at the current position that satisfy the bounds.

## Solution Code

```go
func countSubarrays(nums []int, minK int, maxK int) int64 {
    n := len(nums)
    result := int64(0)
    left := 0
    
    for right := 0; right < n; right++ {
        // If current element is outside the bounds, reset the window
        if nums[right] < minK || nums[right] > maxK {
            left = right + 1
            continue
        }
        
        // Count subarrays ending at right that satisfy the bounds
        // All subarrays starting from any position <= left and ending at right are valid
        result += int64(right - left + 1)
    }
    
    return result
}
```

## Complexity Analysis

- **Time**: O(n) - We traverse the array once with the sliding window
- **Space**: O(1) - We only use a few pointers regardless of the input size

## Link

[LeetCode 2444 Count Subarrays With Fixed Bounds](https://leetcode.com/problems/count-subarrays-with-fixed-bounds/)