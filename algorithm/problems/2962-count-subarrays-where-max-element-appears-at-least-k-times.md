# 2962 Count Subarrays Where Max Element Appears at Least K Times

## Problem Description

You are given an integer array `nums` and an integer `k`.

Return the number of subarrays where the maximum element appears at least `k` times in that subarray.

### Example 1:
```
Input: nums = [1,3,2,3,3], k = 2
Output: 6
Explanation: The subarrays where the maximum element (3) appears at least 2 times are:
[1,3,2,3], [1,3,2,3,3], [3,2,3], [3,2,3,3], [2,3,3], [3,3]
```

### Example 2:
```
Input: nums = [1,4,2,1], k = 3
Output: 0
Explanation: No subarray has the maximum element (4) appearing at least 3 times.
```

### Example 3:
```
Input: nums = [3,3,3], k = 2
Output: 6
Explanation: All subarrays have the maximum element (3) appearing at least 2 times.
```

## Solution

This problem asks us to count the number of subarrays where the maximum element appears at least `k` times. This is a sliding window problem combined with frequency counting.

### Approach

1. First, find the maximum value in the array.
2. Use a sliding window approach with two pointers, `left` and `right`.
3. Maintain a count of how many times the maximum element appears in the current window.
4. When the count of maximum elements is at least `k`, all subarrays ending at `right` and starting from any index between `left` and the position where we first reached `k` maximum elements are valid.
5. Keep track of the total count of valid subarrays.

The key insight is that once we have at least `k` maximum elements in our window, any subarray that includes these `k` elements and ends at the current `right` pointer is valid.

### Code

```go
func countSubarrays(nums []int, k int) int64 {
    // Find the maximum value in the array
    maxVal := 0
    for _, num := range nums {
        if num > maxVal {
            maxVal = num
        }
    }
    
    var result int64
    left := 0
    count := 0 // Count of maxVal in the current window
    
    for right := 0; right < len(nums); right++ {
        if nums[right] == maxVal {
            count++
        }
        
        // If we have at least k maxVal elements, we can count valid subarrays
        for count >= k {
            // All subarrays starting from any index between left and right
            // and ending at right are valid
            result += int64(len(nums) - right)
            
            // Move left pointer to find more subarrays
            if nums[left] == maxVal {
                count--
            }
            left++
        }
    }
    
    return result
}
```

### Complexity Analysis

- **Time Complexity**: O(n) - We iterate through the array once with the sliding window
- **Space Complexity**: O(1) - We only use constant extra space

## Link

[LeetCode 2962 Count Subarrays Where Max Element Appears at Least K Times](https://leetcode.com/problems/count-subarrays-where-max-element-appears-at-least-k-times/)