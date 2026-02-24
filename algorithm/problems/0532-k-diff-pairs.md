# 0532 K-diff Pairs in an Array

## Problem Description

Given an array of integers `nums` and an integer `k`, return the number of unique k-diff pairs in the array.

A k-diff pair is an integer pair `(nums[i], nums[j])` where:
- `0 <= i, j < nums.length`
- `i != j`
- `|nums[i] - nums[j]| == k`

Notice that `|val|` denotes the absolute value of `val`.

### Example 1:
```
Input: nums = [3,1,4,1,5], k = 2
Output: 2
Explanation: There are two 2-diff pairs, (1,3) and (3,5).
Even though there are two 1s in the input, we should only return the number of unique pairs.
```

### Example 2:
```
Input: nums = [1,2,3,4,5], k = 1
Output: 4
Explanation: There are four 1-diff pairs, (1,2), (2,3), (3,4) and (4,5).
```

### Example 3:
```
Input: nums = [1,3,1,5,4], k = 0
Output: 1
Explanation: There is one 0-diff pair (1,1).
```

## The Twist

Looking for specific **differences** rather than sums. The problem is about finding pairs where the absolute difference equals k, not where the sum equals a target.

## Hash Table Usage

- **Key**: `number` (the value from the array)
- **Value**: `frequency` (how many times this number appears)

For each unique number `num` in the map:
- If `k == 0`: count numbers with frequency >= 2 (same number, different indices)
- If `k > 0`: check if `num + k` exists in the map

## Complexity

- **Time**: O(n) - single pass to build frequency map, then iterate through unique keys
- **Space**: O(n) - storing unique numbers with their frequencies

## Link

[LeetCode 0532 K-diff Pairs in an Array](https://leetcode.com/problems/k-diff-pairs-in-an-array/)
