# 0869 Reordered Power of 2

## Problem Description

You are given an integer `n`. Return `true` if and only if it can be reordered such that its leading digit is not zero and it is a power of 2.

### Example 1:
```
Input: n = 1
Output: true
```

### Example 2:
```
Input: n = 10
Output: false
```

### Example 3:
```
Input: n = 16
Output: true
```

### Example 4:
```
Input: n = 24
Output: false
```

### Example 5:
```
Input: n = 46
Output: true
```

## The Twist

Checking if digits can form a **power of 2**. Instead of generating all permutations, we can compare the digit count signature of `n` against all powers of 2.

## Hash Table Usage

- **Key**: `digit_count_signature` (sorted character count of the number)
- **Value**: `true` (or just use a set)

Algorithm:
1. Precompute all powers of 2 up to 10^9 (since n ≤ 10^9)
2. For each power of 2, compute its digit count signature (e.g., 46 → "1246", 64 → "1246")
3. Store all signatures in a set
4. Compute the signature of `n` and check if it exists in the set

## Complexity

- **Time**: O(1) - constant number of powers of 2 (up to 30) and constant digit count (up to 10)
- **Space**: O(1) - storing at most 30 signatures

## Link

[LeetCode 0869 Reordered Power of 2](https://leetcode.com/problems/reordered-power-of-2/)
