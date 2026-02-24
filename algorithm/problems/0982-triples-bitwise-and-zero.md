# 0982 Triples with Bitwise AND Equal To Zero

## Problem Description

Given an integer array `nums`, return the number of triples `(i, j, k)` such that `i != j`, `i != k`, and `j != k`, and `nums[i] & nums[j] & nums[k] == 0`.

The `&` operator denotes the bitwise AND operation.

### Example 1:
```
Input: nums = [2,2,2]
Output: 1
Explanation: The only valid triple is (0, 1, 2) since 2 & 2 & 2 = 2 != 0 is false, wait... actually 2 & 2 & 2 = 2, which is not 0. Let me recalculate.
Actually, for [2,2,2], there are no valid triples because 2 & 2 & 2 = 2 ≠ 0.
```

### Example 2:
```
Input: nums = [0,0,0]
Output: 27
Explanation: All triples are valid since 0 & 0 & 0 = 0.
```

## The Twist

Map stores the frequency of all `A[i] & A[j]` combinations. A secondary loop checks if `A[k] & key == 0`.

## Hash Table Usage

- **Key**: `and_result` (the bitwise AND of two elements)
- **Value**: `frequency` (how many pairs produce this AND result)

Algorithm:
1. Precompute all pairwise AND results and count their frequencies
2. For each element `nums[k]`:
   - For each AND result key, check if `key & nums[k] == 0`
   - If yes, add the frequency to the result
3. Return the total count

Optimization: Use Fast Wavelet Transform (FWT) for more efficient computation.

## Complexity

- **Time**: O(n² + n * m) where n is array length, m is number of unique AND results
- **Space**: O(m) - storing AND result frequencies

## Link

[LeetCode 0982 Triples with Bitwise AND Equal To Zero](https://leetcode.com/problems/triples-with-bitwise-and-equal-to-zero/)
