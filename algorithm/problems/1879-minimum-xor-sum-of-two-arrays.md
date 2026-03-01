# 1879 Minimum XOR Sum of Two Arrays

## Problem Description

You are given two integer arrays `nums1` and `nums2` of the same length `n`.

You can reorder the elements of `nums2`.

The XOR sum of the two arrays is defined as `(nums1[0] XOR nums2[0]) + (nums1[1] XOR nums2[1]) + ... + (nums1[n-1] XOR nums2[n-1])`.

Return the minimum XOR sum possible after reordering `nums2`.

### Example 1:
```
Input: nums1 = [1,2], nums2 = [2,3]
Output: 2
```

### Example 2:
```
Input: nums1 = [1,0,3], nums2 = [5,3,1]
Output: 8
```

## Approach

This problem can be solved using Hungarian algorithm for minimum weight bipartite matching:

1. **Bipartite Matching**:
   - nums1 elements on one side, nums2 elements on the other
   - Edge weight is XOR value between elements

2. **Minimum Weight Matching**:
   - Use Hungarian algorithm to find minimum total weight
   - Each element in nums1 must be matched to exactly one element in nums2

3. **Dynamic Programming**:
   - Use DP with bitmask to track used elements from nums2
   - For each element in nums1, try all unused elements from nums2

4. **State Compression**:
   - Use bitmask to represent which elements from nums2 are used
   - DP[i][mask] = minimum XOR sum for first i elements of nums1

## Solution Code

```go
func minimumXORSum(nums1 []int, nums2 []int) int {
    n := len(nums1)
    if n == 0 {
        return 0
    }
    
    // DP with bitmask
    // dp[mask] represents minimum XOR sum for processed elements
    dp := make([]int, 1<<n)
    for i := 0; i < 1<<n; i++ {
        dp[i] = 1<<31 - 1 // Initialize with large value
    }
    dp[0] = 0
    
    for mask := 0; mask < 1<<n; mask++ {
        // Count how many elements from nums1 have been processed
        k := 0
        for i := 0; i < n; i++ {
            if mask&(1<<i) != 0 {
                k++
            }
        }
        
        if k >= n {
            continue
        }
        
        // Try to match nums1[k] with each unused element from nums2
        for j := 0; j < n; j++ {
            if mask&(1<<j) == 0 { // If nums2[j] is not used
                newMask := mask | (1 << j)
                dp[newMask] = min(dp[newMask], dp[mask]+(nums1[k]^nums2[j]))
            }
        }
    }
    
    return dp[(1<<n)-1]
}

func min(a, b int) int {
    if a < b {
        return a
    }
    return b
}
```

## Complexity Analysis

- **Time**: O(n * 2^n) where n is the length of the arrays
  - For each mask (2^n possibilities), we process up to n elements
- **Space**: O(2^n) for the DP array

## Link

[LeetCode 1879 Minimum XOR Sum of Two Arrays](https://leetcode.com/problems/minimum-xor-sum-of-two-arrays/)