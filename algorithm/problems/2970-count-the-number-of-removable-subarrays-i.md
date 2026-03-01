# 2970 Count the Number of Removable Subarrays I

## Problem Description

You are given an integer array `nums` and an integer `p`.

A subarray is removable if we can remove exactly one element from the subarray and the remaining elements are non-decreasing.

Return the number of removable subarrays.

### Example 1:
```
Input: nums = [1,2,3,4,5], p = 2
Output: 4
Explanation: The removable subarrays are:
[1,2], [2,3], [3,4], [4,5]
```

### Example 2:
```
Input: nums = [1,2,3,4,5], p = 3
Output: 3
Explanation: The removable subarrays are:
[1,2,3], [2,3,4], [3,4], [4,5]
```

## Approach

This problem can be solved using a sliding window approach:

1. Use a sliding window to maintain a subarray where the elements are non-decreasing.
2. Expand the window to the right, adding the current element.
3. If the current element is smaller than the previous element, the subarray is not non-decreasing.
4. If the current element is not smaller, shrink the window from the left until the subarray is non-decreasing.
5. For each valid window, count the number of subarrays ending at the current position that satisfy the condition.

## Solution Code

```go
func countRemovableSubarrays(nums []int, p int) int64 {
    n := len(nums)
    result := int64(0)
    
    for i := 0; i < n; i++ {
        left := i
        
        // Expand the window to the right
        for right := i; right < n; right++ {
            if nums[right] < nums[right-1] {
                break
            }
        }
        
        // Count subarrays ending at i that are non-decreasing
        if right-left+1 > result {
            result += int64(right - left)
        }
    }
    
    return result
}
```

## Complexity Analysis

- **Time**: O(n^2) - For each position, we might expand the window to the entire array
- **Space**: O(1) - We only use a few pointers regardless of the input size

## Link

[LeetCode 2970 Count the Number of Removable Subarrays I](https://leetcode.com/problems/count-the-number-of-removable-subarrays-i/)