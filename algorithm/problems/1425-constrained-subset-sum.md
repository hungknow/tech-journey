# 1425 Constrained Subset Sum

## Problem Description

Given an integer array `nums` and an integer `k`, return the maximum sum of a non-empty subsequence of the array such that for every two consecutive integers in the subsequence, `nums[i]` and `nums[j]`, where `i < j`, the condition `j - i <= k` is satisfied.

A subsequence of an array is obtained by deleting some number of elements (can be zero) from the array, leaving the remaining elements in their original order.

### Example 1:
```
Input: nums = [10,2,-10,5,20], k = 2
Output: 27
Explanation: The subsequence is [10, 2, 5, 20].
```

### Example 2:
```
Input: nums = [-1,-2,-3], k = 1
Output: -1
Explanation: The subsequence must be non-empty, so we choose the largest element.
```

### Example 3:
```
Input: nums = [10,-2,-10,-5,20], k = 3
Output: 23
Explanation: The subsequence is [10, -2, -5, 20].
```

## Approach

This problem can be solved using dynamic programming combined with a monotonic deque:

1. Let `dp[i]` be the maximum sum of a subsequence ending at index `i`.
2. `dp[i] = nums[i] + max(0, max(dp[j]) for j in [i-k, i-1])`
3. We need to efficiently find the maximum `dp[j]` in the sliding window of size `k`.
4. Use a monotonic deque to maintain the indices of potential maximum values in the `dp` array.

## Solution Code

```go
func constrainedSubsetSum(nums []int, k int) int {
    n := len(nums)
    dp := make([]int, n)
    deque := []int{} // Stores indices
    
    maxSum := math.MinInt32
    
    for i := 0; i < n; i++ {
        // Remove indices that are out of the window
        for len(deque) > 0 && deque[0] < i-k {
            deque = deque[1:]
        }
        
        // Calculate dp[i]
        if len(deque) > 0 {
            dp[i] = max(nums[i], nums[i] + dp[deque[0]])
        } else {
            dp[i] = nums[i]
        }
        
        // Maintain monotonic decreasing deque
        for len(deque) > 0 && dp[i] >= dp[deque[len(deque)-1]] {
            deque = deque[:len(deque)-1]
        }
        
        deque = append(deque, i)
        maxSum = max(maxSum, dp[i])
    }
    
    return maxSum
}

func max(a, b int) int {
    if a > b {
        return a
    }
    return b
}
```

## Complexity Analysis

- **Time**: O(n) - Each element is processed at most twice (once when added to the deque and once when removed)
- **Space**: O(k) - The deque stores at most k elements

## Link

[LeetCode 1425 Constrained Subset Sum](https://leetcode.com/problems/constrained-subset-sum/)