# 2958 Length of Longest Subarray With at Most K Frequency

## Problem Description

You are given an integer array `nums` and an integer `k`.

The frequency of an element `x` in a subarray is the number of times `x` appears in the subarray.

Return the length of the longest subarray of `nums` such that the frequency of each element in the subarray is less than or equal to `k`.

### Example 1:
```
Input: nums = [1,2,3,1,2,3,1,2], k = 2
Output: 6
Explanation: The longest subarray is [1,2,3,1,2,3] where each element appears at most 2 times.
```

### Example 2:
```
Input: nums = [1,2,3,4,5,6], k = 1
Output: 6
Explanation: The longest subarray is [1,2,3,4,5,6] where each element appears at most 1 time.
```

### Example 3:
```
Input: nums = [1,1,1,1,1], k = 2
Output: 2
Explanation: The longest subarray is [1,1] where the element 1 appears exactly 2 times.
```

## Solution

This problem asks us to find the longest subarray where the frequency of each element is at most `k`. This is a classic sliding window problem.

### Approach

1. Use a sliding window approach with two pointers, `left` and `right`.
2. Maintain a frequency map to count the occurrences of each element in the current window.
3. Expand the window by moving the `right` pointer and updating the frequency map.
4. If any element's frequency exceeds `k`, shrink the window from the left until all frequencies are at most `k`.
5. Keep track of the maximum window size encountered.

### Code

```go
func maxSubarrayLength(nums []int, k int) int {
    freq := make(map[int]int)
    left := 0
    maxLen := 0
    
    for right := 0; right < len(nums); right++ {
        // Add the current element to the frequency map
        freq[nums[right]]++
        
        // If the frequency of the current element exceeds k, shrink the window
        for freq[nums[right]] > k {
            freq[nums[left]]--
            left++
        }
        
        // Update the maximum length
        maxLen = max(maxLen, right-left+1)
    }
    
    return maxLen
}

func max(a, b int) int {
    if a > b {
        return a
    }
    return b
}
```

### Complexity Analysis

- **Time Complexity**: O(n) - We iterate through the array once with the sliding window
- **Space Complexity**: O(n) - In the worst case, the frequency map can contain all distinct elements in the array

## Link

[LeetCode 2958 Length of Longest Subarray With at Most K Frequency](https://leetcode.com/problems/length-of-longest-subarray-with-at-most-k-frequency/)