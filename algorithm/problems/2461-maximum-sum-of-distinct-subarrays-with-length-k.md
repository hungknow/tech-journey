# 2461 Maximum Sum of Distinct Subarrays With Length K

## Problem Description

You are given an integer array `nums` and an integer `k`. Find the maximum sum of a distinct subarray of length `k`.

A subarray is distinct if all its elements are unique.

### Example 1:
```
Input: nums = [1,2,3,4,5], k = 3
Output: 12
Explanation: The distinct subarray of length 3 with the maximum sum is [3,4,5].
```

### Example 2:
```
Input: nums = [5,5,5,5,5], k = 2
Output: 0
Explanation: No distinct subarray of length 2 exists.
```

## Approach

This problem can be solved using a sliding window approach:

1. Use a sliding window of size `k` to maintain a subarray with distinct elements.
2. Use a hash set to track the elements in the current window.
3. Expand the window to the right, adding the current element to the set.
4. If the current element is already in the set, shrink the window from the left until the element is no longer in the set.
5. Keep track of the maximum sum encountered for windows of size `k`.

## Solution Code

```go
func maximumSubarraySum(nums []int, k int) int64 {
    n := len(nums)
    if n < k {
        return 0
    }
    
    seen := make(map[int]bool)
    currentSum := int64(0)
    maxSum := int64(0)
    
    // Initialize the first window
    for i := 0; i < k; i++ {
        seen[nums[i]] = true
        currentSum += int64(nums[i])
    }
    maxSum = currentSum
    
    // Slide the window
    for i := k; i < n; i++ {
        // Remove the leftmost element
        leftElement := nums[i-k]
        seen[leftElement] = false
        currentSum -= int64(leftElement)
        
        // Add the new element
        rightElement := nums[i]
        if seen[rightElement] {
            // The new element is already in the window, shrink from left until it's unique
            for seen[rightElement] {
                leftElement := nums[i-k+1]
                seen[leftElement] = false
                currentSum -= int64(leftElement)
                i-k++ // This is a bit tricky, but we're effectively moving the left pointer
            }
        }
        
        seen[rightElement] = true
        currentSum += int64(rightElement)
        
        if currentSum > maxSum {
            maxSum = currentSum
        }
    }
    
    return maxSum
}
```

## Complexity Analysis

- **Time**: O(n) - Each element is added to and removed from the set at most once
- **Space**: O(k) - The set stores at most `k` distinct elements

## Link

[LeetCode 2461 Maximum Sum of Distinct Subarrays With Length K](https://leetcode.com/problems/maximum-sum-of-distinct-subarrays-with-length-k/)