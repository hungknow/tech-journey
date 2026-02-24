# 0873 Length of Longest Fibonacci Subsequence

## Problem Description

Given a strictly increasing array `arr` of positive integers, return the length of the longest Fibonacci-like subsequence of `arr`.

A Fibonacci-like sequence is a sequence where `X1 + X2 = X3`, `X2 + X3 = X4`, etc.

A subsequence is derived from another sequence `arr` by deleting any number of elements (including none) from `arr`, without changing the order of the remaining elements.

### Example 1:
```
Input: arr = [1,2,3,4,5,6,7,8]
Output: 5
Explanation: The longest subsequence that is Fibonacci-like is [1,2,3,5,8].
```

### Example 2:
```
Input: arr = [1,3,7,11,12,14,18]
Output: 3
Explanation: The longest subsequence that is Fibonacci-like is [1,11,12], [3,11,14], or [7,11,18].
```

## The Twist

A Hash Set stores all numbers. For any pair `i` and `j`, you check if `arr[i] + arr[j]` exists in the set to continue the sequence.

## Hash Table Usage

- **Key**: `number` (a value from the array)
- **Value**: `index` (the position of this number in the array)

Algorithm:
1. Create a map from values to their indices
2. Use dynamic programming: `dp[i][j]` = length of Fibonacci sequence ending at indices i, j
3. For each pair (i, j) where i < j:
   - Check if `arr[i] + arr[j]` exists in the map
   - If yes, update `dp[j][k] = dp[i][j] + 1` where k is the index of the sum
4. Track the maximum sequence length found
5. Return the maximum (or 0 if no sequence of length >= 3 exists)

## Complexity

- **Time**: O(n²) - checking all pairs of indices
- **Space**: O(n²) - storing DP table for all pairs

## Link

[LeetCode 0873 Length of Longest Fibonacci Subsequence](https://leetcode.com/problems/length-of-longest-fibonacci-subsequence/)
