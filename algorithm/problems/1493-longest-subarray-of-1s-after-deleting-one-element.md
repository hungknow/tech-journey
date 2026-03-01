# 1493 Longest Subarray of 1's After Deleting One Element

## Problem Description

Given a binary array `nums`, you should delete one element from the array.

Return the size of the longest non-empty subarray containing only 1's. You can delete zero or one element.

### Example 1:
```
Input: nums = [1,1,0,1]
Output: 3
Explanation: After deleting the number in position 2, [1,1,1] contains 3 numbers.
```

### Example 2:
```
Input: nums = [0,1,1,1,0,1,1,0,1]
Output: 5
Explanation: After deleting the number in position 4, [0,1,1,1,1,1,0,1] longest subarray with 1's is [1,1,1,1,1].
```

### Example 3:
```
Input: nums = [1,1,1]
Output: 2
Explanation: You must delete one element.
```

## Approach

This problem can be solved using a sliding window approach:

1. Use a sliding window to maintain a subarray with at most one zero.
2. Expand the window to the right, and if we encounter a second zero, shrink the window from the left until we have at most one zero.
3. The maximum window size (minus 1 if we have a zero in the window) gives us the answer.

## Solution Code

```go
func longestSubarray(nums []int) int {
    n := len(nums)
    left := 0
    zeroCount := 0
    maxLen := 0
    
    for right := 0; right < n; right++ {
        // If we encounter a zero, increment the zero count
        if nums[right] == 0 {
            zeroCount++
        }
        
        // If we have more than one zero, shrink the window from the left
        for zeroCount > 1 {
            if nums[left] == 0 {
                zeroCount--
            }
            left++
        }
        
        // Update the maximum length
        // We subtract 1 because we need to delete one element
        maxLen = max(maxLen, right-left)
    }
    
    // If all elements are 1's, we must delete one element
    if zeroCount == 0 {
        return n - 1
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

## Complexity Analysis

- **Time**: O(n) - We traverse the array once with the sliding window
- **Space**: O(1) - We only use a few variables regardless of the input size

## Link

[LeetCode 1493 Longest Subarray of 1's After Deleting One Element](https://leetcode.com/problems/longest-subarray-of-1s-after-deleting-one-element/)