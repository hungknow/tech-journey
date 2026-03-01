# 1712 Ways to Split Array Into Three Subarrays

## Problem Description

Given an integer array `nums`, return the number of ways to split the array into three non-empty subarrays.

The subarrays are:
- The first subarray is from `nums[0]` to `nums[i]` (inclusive).
- The second subarray is from `nums[i+1]` to `nums[j]` (inclusive).
- The third subarray is from `nums[j+1]` to `nums[n-1]` (inclusive).

The sum of the elements in each subarray must be less than or equal to the sum of the elements in the next subarray.

### Example 1:
```
Input: nums = [1,2,2,2,5,0]
Output: 3
Explanation: There are three ways to split the array:
[1,2] | [2,2] | [5,0]
[1,2] | [2,2,5] | [0]
[1,2,2] | [2,5] | [0]
```

### Example 2:
```
Input: nums = [3,2,1]
Output: 0
Explanation: There is no way to split the array.
```

## Approach

This problem can be solved using prefix sums and a two-pointer approach:

1. First, calculate the prefix sum array.
2. For each possible middle split point `j`, find the range of valid left split points `i` such that:
   - The sum of the first subarray ≤ the sum of the second subarray
   - The sum of the second subarray ≤ the sum of the third subarray
3. Use binary search or two pointers to efficiently find these ranges.
4. Sum up the number of valid splits for all possible `j`.

## Solution Code

```go
func waysToSplit(nums []int) int {
    n := len(nums)
    prefix := make([]int, n+1)
    for i := 0; i < n; i++ {
        prefix[i+1] = prefix[i] + nums[i]
    }
    
    result := 0
    
    // For each possible middle split point j
    for j := 2; j < n; j++ {
        // Find the minimum i such that sum(0..i) <= sum(i+1..j-1)
        left := 1
        right := j - 1
        minI := j
        
        while left <= right {
            mid := (left + right) / 2
            if prefix[mid] <= prefix[j] - prefix[mid] {
                minI = mid
                left = mid + 1
            } else {
                right = mid - 1
            }
        }
        
        // Find the maximum i such that sum(i+1..j-1) <= sum(j..n-1)
        left = 1
        right = j - 1
        maxI := 0
        
        while left <= right {
            mid := (left + right) / 2
            if prefix[j] - prefix[mid] <= prefix[n] - prefix[j] {
                maxI = mid
                right = mid - 1
            } else {
                left = mid + 1
            }
        }
        
        // Add the number of valid i's
        if maxI >= minI {
            result += maxI - minI + 1
        }
    }
    
    return result
}
```

## Complexity Analysis

- **Time**: O(n log n) - For each possible middle split point, we perform binary search
- **Space**: O(n) - We store the prefix sum array

## Link

[LeetCode 1712 Ways to Split Array Into Three Subarrays](https://leetcode.com/problems/ways-to-split-array-into-three-subarrays/)