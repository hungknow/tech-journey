# 2970 Count the Number of Incremovable Subarrays I

## Problem Description

You are given a 0-indexed array `nums`. A subarray is called **incremovable** if removing it makes the remaining array strictly increasing.

Return the number of incremovable subarrays of `nums`.

Note that an empty subarray is also considered incremovable.

### Example 1:
```
Input: nums = [1,2,3,4]
Output: 10
Explanation: All subarrays are incremovable.
```

### Example 2:
```
Input: nums = [6,5,7,8]
Output: 7
Explanation: The incremovable subarrays are:
[], [6], [5], [6,5], [5,7], [7,8], [5,7,8]
```

### Example 3:
```
Input: nums = [8,7,6,6]
Output: 3
Explanation: The incremovable subarrays are:
[], [8], [8,7]
```

## Solution

This problem asks us to count the number of subarrays whose removal makes the remaining array strictly increasing. This is a two-pointer problem combined with array analysis.

### Approach

1. First, identify the longest prefix that is strictly increasing.
2. Identify the longest suffix that is strictly increasing.
3. For each possible subarray, we need to check if removing it leaves a strictly increasing array.
4. A subarray can be removed if:
   - The elements before it are strictly increasing
   - The elements after it are strictly increasing
   - The last element before the subarray is less than the first element after the subarray

Since this is the "I" version (easy), we can use a brute-force approach:
1. Check all possible subarrays
2. For each subarray, create a new array by removing it
3. Check if the resulting array is strictly increasing

### Code

```go
func incremovableSubarrayCount(nums []int) int {
    n := len(nums)
    count := 0
    
    // Check all possible subarrays
    for i := 0; i < n; i++ {
        for j := i; j < n; j++ {
            // Create a new array by removing subarray nums[i..j]
            remaining := make([]int, 0, n-(j-i+1))
            remaining = append(remaining, nums[:i]...)
            remaining = append(remaining, nums[j+1:]...)
            
            // Check if the remaining array is strictly increasing
            if isStrictlyIncreasing(remaining) {
                count++
            }
        }
    }
    
    return count
}

func isStrictlyIncreasing(arr []int) bool {
    for i := 1; i < len(arr); i++ {
        if arr[i] <= arr[i-1] {
            return false
        }
    }
    return true
}
```

### Complexity Analysis

- **Time Complexity**: O(n^3) - We check all O(n^2) subarrays, and for each, we check if the resulting array is strictly increasing in O(n) time
- **Space Complexity**: O(n) - We create a new array for each subarray check

Note: This brute-force approach is acceptable for the "I" version of the problem (easy difficulty). The "II" version would require a more optimized O(n) solution.

## Link

[LeetCode 2970 Count the Number of Incremovable Subarrays I](https://leetcode.com/problems/count-the-number-of-incremovable-subarrays-i/)