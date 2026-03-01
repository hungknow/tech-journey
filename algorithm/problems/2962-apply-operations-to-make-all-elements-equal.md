# 2962 Apply Operations to Make All Elements Equal

## Problem Description

You are given an integer array `nums` and an integer `k`.

You can apply the following operation any number of times:

Choose any element in the array and increase its value by 1.

Return the minimum number of operations needed to make all elements in the array equal.

### Example 1:
```
Input: nums = [1,2,3,4,5], k = 2
Output: 3
Explanation: Apply the operation to element at index 0 twice: [3,3,4,5]
Apply the operation to element at index 1 once: [1,3,4,5]
Apply the operation to element at index 2 once: [1,2,4,5]
Apply the operation to element at index 3 once: [1,2,5,5]
Apply the operations to element at index 4 once: [1,2,3,5]
Now all elements are equal.
```

### Example 2:
```
Input: nums = [1,2,3,4,5], k = 3
Output: 4
Explanation: Apply the operation to element at index 0 three times: [4,2,3,4]
Apply the operation to element at index 1 twice: [1,3,4,5]
Apply the operation to element at index 2 once: [1,2,4,5]
Apply the operation to element at index 3 once: [1,2,4,5]
Now all elements are equal.
```

## Approach

This problem can be solved using a greedy approach:

1. Find the maximum element in the array.
2. Calculate the total operations needed to make all elements equal to the maximum.
3. Return this total.

## Solution Code

```go
func minOperations(nums []int, k int) int {
    n := len(nums)
    if n == 0 {
        return 0
    }
    
    // Find the maximum element
    maxIndex := 0
    for i := 1; i < n; i++ {
        if nums[i] > nums[maxIndex] {
            maxIndex = i
        }
    }
    
    // Calculate the total operations needed
    total := 0
    for i := 0; i < n; i++ {
        total += nums[maxIndex] - nums[i]
    }
    
    return total
}
```

## Complexity Analysis

- **Time**: O(n) - We traverse the array twice (once to find the maximum, once to calculate the total)
- **Space**: O(1) - We only use a few variables regardless of the input size

## Link

[LeetCode 2962 Apply Operations to Make All Elements Equal](https://leetcode.com/problems/apply-operations-to-make-all-elements-equal/)