# 2958 Length of Longest Subarray With At Most K Different Integers

## Problem Description

You are given an integer array `nums` and an integer `k`.

Return the length of the longest subarray that contains at most `k` different integers.

### Example 1:
```
Input: nums = [1,2,1,2,3,4,5], k = 2
Output: 3
Explanation: The subarray [1,2,1] has 2 different integers (1 and 2) and length 3.
```

### Example 2:
```
Input: nums = [1,2,3,4,5,6], k = 3
Output: 3
Explanation: The subarray [1,2,3] has 3 different integers (1, 2, and 3) and length 3.
```

## Approach

This problem can be solved using a sliding window approach:

1. Use a sliding window to maintain a subarray with at most `k` different integers.
2. Use a hash set to track the unique elements in the current window.
3. Expand the window to the right, adding the current element to the set.
4. If the current element is already in the set, shrink the window from the left until the element is no longer in the set.
5. For each valid window, if the size of the set is at most `k`, update the maximum window size.

## Solution Code

```go
func longestSubarray(nums []int, k int) int {
    n := len(nums)
    if n == 0 {
        return 0
    }
    
    left := 0
    maxLen := 0
    
    // Initialize the first window
    unique := make(map[int]bool)
    for i := 0; i < k; i++ {
        unique[nums[i]] = true
    }
    
    // Calculate the length for the first window
    if len(unique) <= k {
        maxLen = k
    }
    
    // Slide the window
    for right := k; right < n; right++ {
        // Remove the element leaving the window
        if unique[nums[right-k]] {
            delete(unique, nums[right-k])
        }
        
        // Add the new element
        unique[nums[right]] = true
        
        // Update the maximum window size
        if len(unique) > k {
            maxLen = k
        }
    }
    
    return maxLen
}
```

## Complexity Analysis

- **Time**: O(n) - Each element is added to and removed from the window at most once
- **Space**: O(k) - We store the unique elements in the current window

## Link

[LeetCode 2958 Length of Longest Subarray With At Most K Different Integers](https://leetcode.com/problems/length-of-longest-subarray-with-at-most-k-different-integers/)