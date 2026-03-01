# 2537 Count the Number of Good Subarrays

## Problem Description

You are given an integer array `nums` and an integer `k`.

A subarray is good if it contains exactly `k` odd numbers.

Return the number of good subarrays.

### Example 1:
```
Input: nums = [1,1,2,1,1], k = 3
Output: 2
Explanation: The good subarrays are [1,1,2] and [2,1,1].
```

### Example 2:
```
Input: nums = [2,2,2,1,2,2,1,2,2], k = 2
Output: 16
Explanation: All subarrays with exactly 2 odd numbers are good.
```

## Approach

This problem can be solved using a sliding window approach:

1. First, convert the array to a binary array where 1 represents an odd number and 0 represents an even number.
2. Use a sliding window to find all subarrays with exactly `k` odd numbers.
3. For each position, expand the window to include the current element and count the number of odd numbers.
4. If the count exceeds `k`, shrink the window from the left until the count is exactly `k`.
5. For each valid window, count the number of subarrays ending at the current position with exactly `k` odd numbers.

## Solution Code

```go
func countGoodSubarrays(nums []int, k int) int64 {
    n := len(nums)
    result := int64(0)
    left := 0
    oddCount := 0
    
    for right := 0; right < n; right++ {
        // Add current element to the window
        if nums[right]%2 == 1 {
            oddCount++
        }
        
        // If we have more than k odd numbers, shrink from the left
        for oddCount > k {
            if nums[left]%2 == 1 {
                oddCount--
            }
            left++
        }
        
        // If we have exactly k odd numbers, count subarrays ending at right
        if oddCount == k {
            result += int64(right - left + 1)
        }
    }
    
    return result
}
```

## Complexity Analysis

- **Time**: O(n) - Each element is added to and removed from the window at most once
- **Space**: O(1) - We only use a few pointers regardless of the input size

## Link

[LeetCode 2537 Count the Number of Good Subarrays](https://leetcode.com/problems/count-the-number-of-good-subarrays/)