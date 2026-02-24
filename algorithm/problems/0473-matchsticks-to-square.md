# 0473 Matchsticks to Square

## Problem Description

You are given an integer array `matchsticks` where `matchsticks[i]` is the length of the ith matchstick. You want to use all the matchsticks to make one square.

You should not break any matchstick, but you can link them up, and each matchstick must be used exactly one time.

Return `true` if you can make this square and `false` otherwise.

### Example 1:
```
Input: matchsticks = [1,1,2,2,2]
Output: true
Explanation: You can form a square with length 2, one side of the square came from two matchsticks of length 1.
```

### Example 2:
```
Input: matchsticks = [3,3,3,3,4]
Output: false
```

## The Twist

A Hash Map is used as a **memoization cache** to store visited states (represented by bitmasks of used matchsticks) during DFS. This prevents redundant calculations.

## Hash Table Usage

- **Key**: `bitmask_state` (a bitmask representing which matchsticks have been used)
- **Value**: `result` (whether this state can lead to a valid square)

Algorithm:
1. Calculate the target side length: `sum(matchsticks) / 4`
2. If sum is not divisible by 4, return false
3. Sort matchsticks in descending order for early pruning
4. Use DFS with backtracking to try placing matchsticks on each side
5. Use memoization to cache visited states
6. Return true if all matchsticks can be placed to form a square

## Complexity

- **Time**: O(n * s * 2^n) where n is number of matchsticks, s is target side length
- **Space**: O(n * (2^n + s)) - storing memoization cache

## Link

[LeetCode 0473 Matchsticks to Square](https://leetcode.com/problems/matchsticks-to-square/)
