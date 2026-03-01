# 1984 Minimum Difference Between Highest and Lowest of K Scores

## Problem Description

You are given a list of scores of a student, `nums`. The student has `k` scores to choose from.

Return the minimum difference between the highest and lowest scores of exactly `k` scores from the list.

### Example 1:
```
Input: nums = [90], k = 1
Output: 0
Explanation: There is only one score, so the difference is 0.
```

### Example 2:
```
Input: nums = [9,4,1,7], k = 2
Output: 2
Explanation: Choose scores 9 and 7, the difference is 2.
```

## Approach

This problem can be solved using sorting and a sliding window approach:

1. First, sort the array in ascending order.
2. Use a sliding window of size `k` to find the minimum difference between the first and last elements of the window.
3. The minimum difference is the answer.

## Solution Code

```go
func minimumDifference(nums []int, k int) int {
    n := len(nums)
    if k <= 1 {
        return 0
    }
    
    // Sort the array
    sort.Ints(nums)
    
    // Initialize with a large value
    minDiff := 1 << 31 - 1
    
    // Use sliding window of size k
    for i := 0; i <= n-k; i++ {
        diff := nums[i+k-1] - nums[i]
        if diff < minDiff {
            minDiff = diff
        }
    }
    
    return minDiff
}
```

## Complexity Analysis

- **Time**: O(n log n) - Sorting dominates the time complexity
- **Space**: O(1) - We only use a few variables regardless of the input size

## Link

[LeetCode 1984 Minimum Difference Between Highest and Lowest of K Scores](https://leetcode.com/problems/minimum-difference-between-highest-and-lowest-of-k-scores/)