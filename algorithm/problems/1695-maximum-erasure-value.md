# 1695 Maximum Erasure Value

## Problem Description

You are given an array of positive integers `nums` and want to erase a subarray containing unique elements. The score you get from erasing the subarray is equal to the sum of its elements.

Return the maximum score you can get by erasing exactly one subarray.

An array `b` is called to be a subarray of `a` if it forms a contiguous subsequence of `a`.

### Example 1:
```
Input: nums = [4,2,4,5,6]
Output: 17
Explanation: The optimal subarray is [2,4,5,6].
```

### Example 2:
```
Input: nums = [5,2,1,2,5,2,1,2,5]
Output: 8
Explanation: The optimal subarray is [2,1,2] or [1,2,2].
```

## Approach

This problem can be solved using a sliding window approach combined with a hash set to track unique elements:

1. Use a sliding window to maintain a subarray with all unique elements.
2. Expand the window to the right, adding the current element to a set.
3. If the current element is already in the set, shrink the window from the left until the element is no longer in the set.
4. Keep track of the maximum sum encountered during this process.

## Solution Code

```go
func maximumUniqueSubarray(nums []int) int {
    n := len(nums)
    seen := make(map[int]bool)
    left := 0
    currentSum := 0
    maxSum := 0
    
    for right := 0; right < n; right++ {
        // If the current element is already in the window, shrink from the left
        for seen[nums[right]] {
            seen[nums[left]] = false
            currentSum -= nums[left]
            left++
        }
        
        // Add the current element to the window
        seen[nums[right]] = true
        currentSum += nums[right]
        
        // Update the maximum sum
        if currentSum > maxSum {
            maxSum = currentSum
        }
    }
    
    return maxSum
}
```

## Complexity Analysis

- **Time**: O(n) - Each element is added to and removed from the set at most once
- **Space**: O(n) - In the worst case, we store all elements in the set

## Link

[LeetCode 1695 Maximum Erasure Value](https://leetcode.com/problems/maximum-erasure-value/)