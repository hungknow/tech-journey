# 2302 Count Subarrays With Score Less Than K

## Problem Description

The score of a subarray `(i, j)` is defined as the sum of its elements.

Given an integer array `nums` and an integer `k`, return the number of subarrays whose score is strictly less than `k`.

### Example 1:
```
Input: nums = [2,1,3], k = 4
Output: 3
Explanation: The subarrays with score less than 4 are:
[2], [1], [3]
```

### Example 2:
```
Input: nums = [2,1,3], k = 5
Output: 5
Explanation: The subarrays with score less than 5 are:
[2], [1], [3], [2,1], [1,3]
```

## Approach

This problem can be solved using a sliding window approach:

1. Use a sliding window to maintain a subarray with sum less than `k`.
2. Expand the window to the right, adding the current element to the sum.
3. If the sum exceeds or equals `k`, shrink the window from the left until the sum is less than `k`.
4. For each valid window, all subarrays ending at the current position and starting from any position within the window are valid.

## Solution Code

```go
func countSubarrays(nums []int, k int) int64 {
    n := len(nums)
    left := 0
    currentSum := 0
    result := int64(0)
    
    for right := 0; right < n; right++ {
        // Add current element to the window
        currentSum += nums[right]
        
        // Shrink the window if sum >= k
        for currentSum >= k && left <= right {
            currentSum -= nums[left]
            left++
        }
        
        // All subarrays ending at right and starting from any position <= left are valid
        result += int64(right - left + 1)
    }
    
    return result
}
```

## Complexity Analysis

- **Time**: O(n) - Each element is added to and removed from the window at most once
- **Space**: O(1) - We only use a few variables regardless of the input size

## Link

[LeetCode 2302 Count Subarrays With Score Less Than K](https://leetcode.com/problems/count-subarrays-with-score-less-than-k/)