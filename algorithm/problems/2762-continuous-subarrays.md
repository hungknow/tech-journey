# 2762 Continuous Subarrays

## Problem Description

You are given an integer array `nums`. A continuous subarray is defined as a subarray where the difference between any two adjacent elements is at most 1.

Return the number of continuous subarrays.

### Example 1:
```
Input: nums = [1,2,3]
Output: 6
Explanation: All subarrays are continuous.
```

### Example 2:
```
Input: nums = [5,4,6,2,3]
Output: 9
Explanation: The continuous subarrays are:
[5], [4], [6], [2], [3], [5,4], [4,6], [6,2], [2,3]
```

## Approach

This problem can be solved using a sliding window approach:

1. Traverse the array and count the number of continuous subarrays.
2. For each position, expand the window to the left and right as long as the difference between adjacent elements is at most 1.
3. Use a hash set to track the elements in the current window.
4. For each valid window, count the number of subarrays ending at the current position that satisfy the condition.

## Solution Code

```go
func countContinuousSubarrays(nums []int) int64 {
    n := len(nums)
    result := int64(0)
    
    for i := 0; i < n; i++ {
        left, right := i, i
        seen := make(map[int]bool)
        seen[nums[i]] = true
        
        // Expand to the left
        for left > 0 && nums[left-1] >= nums[left]-1 && nums[left-1] <= nums[left]+1 {
            left--
            seen[nums[left]] = true
        }
        
        // Expand to the right
        for right < n-1 && nums[right+1] >= nums[right]-1 && nums[right+1] <= nums[right]+1 {
            right++
            seen[nums[right]] = true
        }
        
        // Count subarrays ending at i that are continuous
        for j := left; j <= right; j++ {
            if seen[nums[j]] {
                result++
            }
        }
    }
    
    return result
}
```

## Complexity Analysis

- **Time**: O(n^2) - For each position, we might expand the window to the entire array
- **Space**: O(n) - We store the elements in the current window

## Link

[LeetCode 2762 Continuous Subarrays](https://leetcode.com/problems/continuous-subarrays/)