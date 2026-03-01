# 2968 Apply Operations to Maximize Frequency Score

## Problem Description

You are given an integer array `nums` and an integer `k`. You can perform the following operation on the array any number of times:

- Choose any element `nums[i]` and increase it by `1`.

The frequency score of an array is defined as the maximum frequency of any element in the array.

Return the maximum possible frequency score of the array after performing at most `k` operations.

### Example 1:
```
Input: nums = [1,2,4], k = 5
Output: 3
Explanation: Increase the first element three times and the second element two times to make the array [4,4,4]. The frequency score is 3.
```

### Example 2:
```
Input: nums = [1,4,8,13], k = 5
Output: 2
Explanation: Increase the first element three times to make the array [4,4,8,13]. The frequency score is 2.
```

### Example 3:
```
Input: nums = [3,9,6], k = 2
Output: 1
```

## Solution

This problem asks us to maximize the frequency of any element in the array by performing at most `k` increment operations. This is a sliding window problem combined with sorting.

### Approach

1. First, sort the array in non-decreasing order.
2. Use a sliding window approach with two pointers, `left` and `right`.
3. For each window `[left, right]`, we want to make all elements equal to `nums[right]`.
4. Calculate the total operations needed to make all elements in the window equal to `nums[right]`.
5. If the operations exceed `k`, move the `left` pointer to reduce the window size.
6. Keep track of the maximum window size, which represents the maximum frequency we can achieve.

The key insight is that to make all elements in a window equal to the rightmost element, we need to calculate the sum of differences between `nums[right]` and each element in the window.

### Code

```go
func maxFrequencyScore(nums []int, k int) int {
    sort.Ints(nums)
    
    left := 0
    maxFreq := 1
    totalOps := 0
    
    for right := 1; right < len(nums); right++ {
        // Calculate operations needed to make nums[left..right-1] equal to nums[right]
        totalOps += (nums[right] - nums[right-1]) * (right - left)
        
        // If we need more than k operations, move left pointer
        for totalOps > k {
            totalOps -= nums[right] - nums[left]
            left++
        }
        
        // Update the maximum frequency
        maxFreq = max(maxFreq, right-left+1)
    }
    
    return maxFreq
}

func max(a, b int) int {
    if a > b {
        return a
    }
    return b
}
```

### Complexity Analysis

- **Time Complexity**: O(n log n) - Sorting takes O(n log n) and the sliding window takes O(n)
- **Space Complexity**: O(1) - We only use constant extra space

## Link

[LeetCode 2968 Apply Operations to Maximize Frequency Score](https://leetcode.com/problems/apply-operations-to-maximize-frequency-score/)