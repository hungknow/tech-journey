# 2555 Maximize Win From Two Segments

## Problem Description

You are given an integer array `nums` and an integer `k`.

You want to select two non-overlapping segments of length `k` from the array to maximize the sum of the elements in these segments.

Return the maximum possible sum of the two segments.

### Example 1:
```
Input: nums = [1,2,3,4,5,6], k = 2
Output: 11
Explanation: The optimal segments are [5,6] and [3,4], with a total sum of 11.
```

### Example 2:
```
Input: nums = [1,2,3,4,5,6], k = 3
Output: 16
Explanation: The optimal segments are [4,5,6] and [1,2,3], with a total sum of 16.
```

## Approach

This problem can be solved using a sliding window approach combined with dynamic programming:

1. First, compute prefix sums to efficiently calculate the sum of any subarray.
2. For each possible segment of length `k`, calculate its sum.
3. For each pair of non-overlapping segments, calculate their total sum.
4. Keep track of the maximum total sum encountered.

## Solution Code

```go
func maximizeWin(nums []int, k int) int {
    n := len(nums)
    if n < 2*k {
        return 0
    }
    
    // Compute prefix sums
    prefix := make([]int, n+1)
    for i := 0; i < n; i++ {
        prefix[i+1] = prefix[i] + nums[i]
    }
    
    maxSum := 0
    
    // Try all possible first segments
    for i := 0; i <= n-2*k; i++ {
        sum1 := prefix[i+k] - prefix[i]
        
        // Try all possible second segments after the first one
        for j := i + k; j <= n-k; j++ {
            sum2 := prefix[j+k] - prefix[j]
            
            total := sum1 + sum2
            if total > maxSum {
                maxSum = total
            }
        }
    }
    
    return maxSum
}
```

## Complexity Analysis

- **Time**: O(n^2) - We try all possible pairs of segments
- **Space**: O(n) - We store the prefix sums

## Link

[LeetCode 2555 Maximize Win From Two Segments](https://leetcode.com/problems/maximize-win-from-two-segments/)