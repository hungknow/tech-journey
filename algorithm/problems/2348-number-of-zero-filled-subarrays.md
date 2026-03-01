# 2348 Number of Zero-Filled Subarrays

## Problem Description

Given an integer array `nums`, return the number of subarrays filled with `0`. A subarray is a contiguous non-empty sequence of elements within an array.

### Example 1:
```
Input: nums = [1,0,0,0,0,1]
Output: 10
Explanation: There are 4 subarrays with 3 consecutive zeros:
[0,0,0], [0,0,0,0], [0,0,0,0], [0,0,0,0]
And 6 subarrays with 2 consecutive zeros:
[0,0], [0,0], [0,0], [0,0], [0,0], [0,0]
```

### Example 2:
```
Input: nums = [0,0,0,2,0,0]
Output: 9
```

### Example 3:
```
Input: nums = [2,10,2019]
Output: 0
```

## Two Pointers Approach

This problem can be efficiently solved by identifying consecutive zero sequences and calculating the number of subarrays within each sequence. For a sequence of `k` consecutive zeros, there are `k * (k + 1) / 2` zero-filled subarrays.

### Algorithm Steps:

1. Initialize a counter for the result
2. Initialize a variable `currentZeros` to track the length of the current zero sequence
3. Iterate through the array:
   - If the current element is 0, increment `currentZeros`
   - Otherwise:
     - Add the number of subarrays in the current zero sequence to the result
     - Reset `currentZeros` to 0
4. After the loop, add the number of subarrays in the last zero sequence (if any)
5. Return the result

## Complexity

- **Time**: O(n) - we traverse the array once
- **Space**: O(1) - constant space for counters

## Solution Code

```go
package main

func zeroFilledSubarray(nums []int) int64 {
    result := int64(0)
    currentZeros := 0
    
    for _, num := range nums {
        if num == 0 {
            currentZeros++
        } else {
            // Add the number of subarrays in the current zero sequence
            result += int64(currentZeros * (currentZeros + 1) / 2)
            currentZeros = 0
        }
    }
    
    // Add the number of subarrays in the last zero sequence (if any)
    result += int64(currentZeros * (currentZeros + 1) / 2)
    
    return result
}
```

## Alternative Approach (Sliding Window)

An alternative approach is to use a sliding window to identify zero-filled subarrays, though this is less efficient for this specific problem.

## Alternative Solution Code

```go
package main

func zeroFilledSubarray(nums []int) int64 {
    result := int64(0)
    
    for i := 0; i < len(nums); i++ {
        if nums[i] == 0 {
            // Count the length of the zero-filled subarray starting at i
            length := 0
            for j := i; j < len(nums) && nums[j] == 0; j++ {
                length++
            }
            
            // Add the number of subarrays in this zero sequence
            result += int64(length * (length + 1) / 2)
            
            // Skip the entire zero sequence
            i += length - 1
        }
    }
    
    return result
}
```

## Link

[LeetCode 2348 Number of Zero-Filled Subarrays](https://leetcode.com/problems/number-of-zero-filled-subarrays/)