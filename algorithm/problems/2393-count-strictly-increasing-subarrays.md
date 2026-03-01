# 2393 Count Strictly Increasing Subarrays

## Problem Description

Given an integer array `nums`, return the number of strictly increasing subarrays.

A subarray is a contiguous non-empty sequence of elements within an array.

### Example 1:
```
Input: nums = [1,2,3,4]
Output: 10
Explanation: All subarrays are strictly increasing.
```

### Example 2:
```
Input: nums = [1,2,2,3]
Output: 6
Explanation: The strictly increasing subarrays are:
[1], [2], [3], [1,2], [2,3], [1,2,3]
```

## Approach

This problem can be solved using a sliding window approach:

1. Traverse the array and maintain the length of the current strictly increasing sequence.
2. For each position, if the current element is greater than the previous one, extend the current sequence.
3. Otherwise, start a new sequence from the current position.
4. The number of strictly increasing subarrays ending at each position is equal to the length of the current sequence.
5. Sum these values for all positions to get the total count.

## Solution Code

```go
func countIncreasingSubarrays(nums []int) int64 {
    n := len(nums)
    if n == 0 {
        return 0
    }
    
    result := int64(0)
    currentLength := 1
    
    // The first element forms a subarray of length 1
    result += int64(currentLength)
    
    for i := 1; i < n; i++ {
        if nums[i] > nums[i-1] {
            // Extend the current strictly increasing sequence
            currentLength++
        } else {
            // Start a new sequence
            currentLength = 1
        }
        
        // Add the number of subarrays ending at current position
        result += int64(currentLength)
    }
    
    return result
}
```

## Complexity Analysis

- **Time**: O(n) - We traverse the array once
- **Space**: O(1) - We only use a few variables regardless of the input size

## Link

[LeetCode 2393 Count Strictly Increasing Subarrays](https://leetcode.com/problems/count-strictly-increasing-subarrays/)