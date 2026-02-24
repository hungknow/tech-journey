# 0202 Happy Number

## Problem Description

Write an algorithm to determine if a number `n` is happy.

A happy number is a number defined by the following process:
- Starting with any positive integer, replace the number by the sum of the squares of its digits.
- Repeat the process until the number equals 1 (where it will stay), or it loops endlessly in a cycle which does not include 1.
- Those numbers for which this process ends in 1 are happy.

Return `true` if `n` is a happy number, and `false` if not.

### Example 1:
```
Input: n = 19
Output: true
Explanation:
1² + 9² = 82
8² + 2² = 68
6² + 8² = 100
1² + 0² + 0² = 1
```

### Example 2:
```
Input: n = 2
Output: false
```

## The Twist

Number transformations can **loop infinitely**. We need to detect cycles to avoid infinite loops.

## Hash Table Usage

- **Key**: `sum_of_squares` (the result of the transformation)
- **Value**: `true` (or just use a set)

Algorithm:
1. Use a hash set to track all seen numbers
2. While n is not 1:
   - Calculate the sum of squares of digits
   - If this sum is already in the set, we've found a cycle (not happy)
   - Otherwise, add it to the set and continue
3. If we reach 1, return true

## Complexity

- **Time**: O(log n) - the number of digits decreases with each transformation
- **Space**: O(log n) - storing at most log n unique values

## Link

[LeetCode 0202 Happy Number](https://leetcode.com/problems/happy-number/)
