# 2348 Number of Zero-Filled Subarrays

## Problem Description

Given an integer array `nums`, return the number of subarrays filled with 0.

A subarray is a contiguous non-empty sequence of elements within an array.

### Example 1:
```
Input: nums = [1,0,0,0,0,1]
Output: 6
Explanation: 
There are 4 occurrences of [0] as a subarray.
There are 2 occurrences of [0,0] as a subarray.
There is 1 occurrence of [0,0,0] as a subarray.
There is 1 occurrence of [0,0,0,0] as a subarray.
No other subarray is filled with 0.
```

### Example 2:
```
Input: nums = [0,0,0,2,0,0]
Output: 9
Explanation: 
There are 5 occurrences of [0] as a subarray.
There are 3 occurrences of [0,0] as a subarray.
There is 1 occurrence of [0,0,0] as a subarray.
No other subarray is filled with 0.
```

## Approach

This problem can be solved using a sliding window approach:

1. Traverse the array and count consecutive zeros.
2. For each sequence of `k` consecutive zeros, the number of zero-filled subarrays is `k * (k + 1) / 2`.
3. Sum this value for all sequences of consecutive zeros.

## Solution Code

```go
func zeroFilledSubarray(nums []int) int64 {
    n := len(nums)
    result := int64(0)
    currentZeros := 0
    
    for i := 0; i < n; i++ {
        if nums[i] == 0 {
            currentZeros++
        } else {
            // Calculate the number of subarrays for the current sequence of zeros
            result += int64(currentZeros * (currentZeros + 1) / 2)
            currentZeros = 0
        }
    }
    
    // Calculate for the last sequence of zeros
    result += int64(currentZeros * (currentZeros + 1) / 2)
    
    return result
}
```

## Complexity Analysis

- **Time**: O(n) - We traverse the array once
- **Space**: O(1) - We only use a few variables regardless of the input size

## Link

[LeetCode 2348 Number of Zero-Filled Subarrays](https://leetcode.com/problems/number-of-zero-filled-subarrays/)