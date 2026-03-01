# 2009 Minimum Number of Operations to Make Array Continuous

## Problem Description

You are given an integer array `nums`. In one operation, you can replace any element in the array with any integer.

An array is continuous if it is possible to rearrange its elements to form a sequence of consecutive integers without duplicates.

Return the minimum number of operations to make the array continuous.

### Example 1:
```
Input: nums = [4,2,5,3]
Output: 0
Explanation: The array is already continuous.
```

### Example 2:
```
Input: nums = [1,2,3,5,6]
Output: 1
Explanation: Replace 5 with 4 to get [1,2,3,4,6], then replace 6 with 5 to get [1,2,3,4,5].
```

### Example 3:
```
Input: nums = [1,10,100,1000]
Output: 3
Explanation: Replace 10, 100, and 1000 with 2, 3, and 4 respectively to get [1,2,3,4].
```

## Approach

This problem can be solved using a sliding window approach combined with sorting:

1. First, sort the array and remove duplicates.
2. For each element, use a sliding window to find the longest subarray that can form a continuous sequence.
3. The window should satisfy the condition that `nums[right] - nums[left] < n`, where `n` is the original length of the array.
4. The minimum number of operations is `n - maxWindowLength`.

## Solution Code

```go
func minOperations(nums []int) int {
    n := len(nums)
    sort.Ints(nums)
    
    // Remove duplicates
    unique := make([]int, 0)
    for i := 0; i < n; i++ {
        if i == 0 || nums[i] != nums[i-1] {
            unique = append(unique, nums[i])
        }
    }
    
    maxWindow := 0
    left := 0
    m := len(unique)
    
    for right := 0; right < m; right++ {
        // Shrink the window if the range is too large
        for unique[right] - unique[left] >= n {
            left++
        }
        
        // Update the maximum window size
        windowSize := right - left + 1
        if windowSize > maxWindow {
            maxWindow = windowSize
        }
    }
    
    return n - maxWindow
}
```

## Complexity Analysis

- **Time**: O(n log n) - Sorting dominates the time complexity
- **Space**: O(n) - We store the unique elements

## Link

[LeetCode 2009 Minimum Number of Operations to Make Array Continuous](https://leetcode.com/problems/minimum-number-of-operations-to-make-array-continuous/)