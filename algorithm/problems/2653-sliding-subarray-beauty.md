# 2653 Sliding Subarray Beauty

## Problem Description

You are given an integer array `nums` and an integer `k`.

The beauty of a subarray is defined as the median of the subarray.

Return the maximum beauty of any subarray of size `k`.

### Example 1:
```
Input: nums = [1,2,3,4,5,6], k = 3
Output: 3
Explanation: The subarray [3,4,5] has a median of 4.
```

### Example 2:
```
Input: nums = [1,2,3,4,5,6], k = 2
Output: 3.5
Explanation: The subarray [3,4] has a median of 3.5.
```

## Approach

This problem can be solved using a sliding window approach:

1. Use a sliding window of size `k` to maintain a subarray.
2. For each window, find the median:
   - If `k` is odd, the median is the middle element.
   - If `k` is even, the median is the average of the two middle elements.
3. Keep track of the maximum median encountered.

## Solution Code

```go
func maximumSubarraySum(nums []int, k int) float64 {
    n := len(nums)
    if n < k {
        return 0
    }
    
    // Sort a copy of the array to easily find the median
    sorted := make([]int, k)
    copy(sorted, nums)
    sort.Ints(sorted)
    
    maxMedian := float64(0)
    
    // Initialize the first window
    for i := 0; i < k; i++ {
        sorted[i] = nums[i]
    }
    sort.Ints(sorted)
    
    if k%2 == 1 {
        maxMedian = float64(sorted[k/2])
    } else {
        maxMedian = float64(sorted[k/2-1]+sorted[k/2]) / 2.0
    }
    
    // Slide the window
    for i := k; i < n; i++ {
        // Find and remove the element leaving the window
        leftIndex := -1
        for j := 0; j < k; j++ {
            if sorted[j] == nums[i-k] {
                leftIndex = j
                break
            }
        }
        
        // Remove the element and insert the new element
        if leftIndex != -1 {
            sorted = append(sorted[:leftIndex], sorted[leftIndex+1:]...)
        }
        sorted = append(sorted, nums[i])
        sort.Ints(sorted)
        
        // Calculate the median of the current window
        var median float64
        if k%2 == 1 {
            median = float64(sorted[k/2])
        } else {
            median = float64(sorted[k/2-1]+sorted[k/2]) / 2.0
        }
        
        if median > maxMedian {
            maxMedian = median
        }
    }
    
    return maxMedian
}
```

## Complexity Analysis

- **Time**: O(n * k log k) - For each window, we sort k elements
- **Space**: O(k) - We store a copy of the current window

## Link

[LeetCode 2653 Sliding Subarray Beauty](https://leetcode.com/problems/sliding-subarray-beauty/)