# 2799 Count Complete Subarrays in an Array

## Problem Description

You are given an integer array `nums`.

A subarray is complete if it contains all distinct elements.

Return the number of complete subarrays.

### Example 1:
```
Input: nums = [1,3,5,7,9]
Output: 9
Explanation: All subarrays are complete.
```

### Example 2:
```
Input: nums = [2,2,2,2,2]
Output: 5
Explanation: The complete subarrays are:
[2], [2,2], [2,2,2], [2,2,2,2], [2,2,2,2,2]
```

## Approach

This problem can be solved using a sliding window approach:

1. Use a sliding window to maintain a subarray with all distinct elements.
2. Use a hash set to track the elements in the current window.
3. Expand the window to the right, adding the current element to the set.
4. If the current element is already in the set, shrink the window from the left until the element is no longer in the set.
5. For each valid window, count the number of subarrays ending at the current position that satisfy the condition.

## Solution Code

```go
func countCompleteSubarrays(nums []int) int64 {
    n := len(nums)
    result := int64(0)
    
    for i := 0; i < n; i++ {
        seen := make(map[int]bool)
        for j := i; j < n; j++ {
            if seen[nums[j]] {
                break
            }
            seen[nums[j]] = true
        }
        
        // Count subarrays ending at i that are complete
        for k := i; k >= 0 && seen[nums[k]]; k-- {
            result += int64(i - k + 1)
        }
    }
    
    return result
}
```

## Complexity Analysis

- **Time**: O(n^2) - For each position, we might check all previous elements
- **Space**: O(n) - We store the elements in the current window

## Link

[LeetCode 2799 Count Complete Subarrays in an Array](https://leetcode.com/problems/count-complete-subarrays-in-an-array/)