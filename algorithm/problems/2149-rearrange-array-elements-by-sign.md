# 2149 Rearrange Array Elements by Sign

## Problem Description

You are given a 0-indexed integer array `nums`. You need to rearrange the array such that all positive integers appear before all negative integers.

Return the rearranged array.

### Example 1:
```
Input: nums = [3,1,-2,-5,2,-4]
Output: [3,1,2,-2,-5,-4]
Explanation: The positive integers [3,1,2] appear before the negative integers [-2,-5,-4].
```

### Example 2:
```
Input: nums = [-3,1,-2,-5,2,-4]
Output: [1,2,-3,-2,-5,-4]
Explanation: The positive integers [1,2] appear before the negative integers [-3,-2,-5,-4].
```

## Approach

This problem can be solved using a two-pointer approach:

1. Use two pointers, one starting from the beginning (`left`) and one from the end (`right`) of the array.
2. Move `left` forward until we find a negative number.
3. Move `right` backward until we find a positive number.
4. If `left` is still before `right`, swap the elements at these positions.
5. Continue until `left` is no longer before `right`.

## Solution Code

```go
func rearrangeArray(nums []int) []int {
    n := len(nums)
    left, right := 0, n-1
    
    for left < right {
        // Find the first negative number from the left
        for left < n && nums[left] > 0 {
            left++
        }
        
        // Find the first positive number from the right
        for right >= 0 && nums[right] < 0 {
            right--
        }
        
        // Swap if left is still before right
        if left < right {
            nums[left], nums[right] = nums[right], nums[left]
            left++
            right--
        }
    }
    
    return nums
}
```

## Complexity Analysis

- **Time**: O(n) - Each pointer traverses the array at most once
- **Space**: O(1) - We only use a few pointers regardless of the input size

## Link

[LeetCode 2149 Rearrange Array Elements by Sign](https://leetcode.com/problems/rearrange-array-elements-by-sign/)