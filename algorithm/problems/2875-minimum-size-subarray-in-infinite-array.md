# 2875 Minimum Size Subarray in Infinite Array

## Problem Description

You are given an infinite array `nums` and an integer `k`.

A subarray is defined as a non-empty contiguous sequence of elements.

Return the minimum size of a subarray of size `k` that contains at most one occurrence of each number in the subarray.

### Example 1:
```
Input: nums = [1,2,3,4,5,6,2,2,2,3,4,5,6], k = 3
Output: 3
Explanation: The subarray [2,3,4] contains each number at most once and has size 3.
```

### Example 2:
```
Input: nums = [1,2,3,4,5,6,2,2,2,3,4,5,6], k = 4
Output: 4
Explanation: The subarray [2,3,4,5] contains each number at most once and has size 4.
```

## Approach

This problem can be solved using a sliding window approach:

1. Use a sliding window of size `k` to maintain a subarray.
2. Use a hash map to count the frequency of each element in the current window.
3. Expand the window to the right, adding the current element to the map.
4. If the current element's count exceeds 1, shrink the window from the left until the count is at most 1.
5. For each valid window, if the window size is exactly `k`, update the minimum size.

## Solution Code

```go
func minSizeSubarray(nums []int, k int) int {
    n := len(nums)
    if n < k {
        return 0
    }
    
    left := 0
    minSize := n + 1
    
    // Initialize the first window
    freq := make(map[int]int)
    for i := 0; i < k; i++ {
        freq[nums[i]]++
    }
    
    // Slide the window
    for right := k; right < n; right++ {
        // Remove the element leaving the window
        freq[nums[right-k]]--
        if freq[nums[right-k]] == 0 {
            delete(freq, nums[right-k])
        }
        
        // Add the new element
        freq[nums[right]]++
        
        // If the current element's count exceeds 1, shrink from the left
        for freq[nums[left]] > 1 {
            freq[nums[left]]--
            if freq[nums[left]] == 0 {
                delete(freq, nums[left])
            }
            left++
        }
        
        // Update the minimum size
        if right-left+1 == k && right-left+1 < minSize {
            minSize = right - left + 1
        }
    }
    
    if minSize == n+1 {
        return 0
    }
    
    return minSize
}
```

## Complexity Analysis

- **Time**: O(n) - Each element is added to and removed from the window at most once
- **Space**: O(k) - We store the frequency of at most k elements in the current window

## Link

[LeetCode 2875 Minimum Size Subarray in Infinite Array](https://leetcode.com/problems/minimum-size-subarray-in-infinite-array/)