# 2972 Count the Number of Incremovable Subarrays II

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

This problem asks us to count the number of subarrays whose removal makes the remaining array strictly increasing. This is the "II" version (hard), so we need an optimized O(n) solution.

### Approach

1. First, find the longest prefix that is strictly increasing.
2. Find the longest suffix that is strictly increasing.
3. A subarray can be removed if:
   - The elements before it are strictly increasing
   - The elements after it are strictly increasing
   - The last element before the subarray is less than the first element after the subarray

The optimized approach:
1. Find the longest prefix that is strictly increasing (let's call it `left`).
2. Find the longest suffix that is strictly increasing (let's call it `right`).
3. If the entire array is strictly increasing, then all subarrays are incremovable, and the answer is n*(n+1)/2.
4. Otherwise, we need to count valid subarrays:
   - All subarrays that include the non-increasing part
   - All subarrays that bridge the prefix and suffix where the condition holds

### Code

```go
func incremovableSubarrayCount(nums []int) int64 {
    n := len(nums)
    
    // Find the longest prefix that is strictly increasing
    left := 0
    for left < n-1 && nums[left] < nums[left+1] {
        left++
    }
    
    // If the entire array is strictly increasing, all subarrays are incremovable
    if left == n-1 {
        return int64(n * (n + 1) / 2)
    }
    
    // Find the longest suffix that is strictly increasing
    right := n - 1
    for right > 0 && nums[right-1] < nums[right] {
        right--
    }
    
    // Start with subarrays that include the non-increasing part
    result := int64(right) // Subarrays starting from 0 to right-1
    
    // Now consider subarrays that bridge the prefix and suffix
    i := 0
    j := right
    for i <= left && j < n {
        if nums[j] > nums[i] {
            // We can remove any subarray from i+1 to j-1
            result += int64(n - j)
            i++
        } else {
            j++
        }
    }
    
    // Add 1 for the empty subarray
    return result + 1
}
```

### Complexity Analysis

- **Time Complexity**: O(n) - We make a constant number of passes through the array
- **Space Complexity**: O(1) - We only use constant extra space

## Link

[LeetCode 2972 Count the Number of Incremovable Subarrays II](https://leetcode.com/problems/count-the-number-of-incremovable-subarrays-ii/)