# 0575 Distribute Candies

## Problem Description

Alice has `n` candies, where the ith candy is of type `candyType[i]`. Alice noticed that she started to gain weight, so she visited a doctor.

The doctor advised Alice to only eat `n / 2` of the candies she has (n is always even). Alice likes her candies very much, and she wants to eat the maximum number of different types of candies.

Given the integer array `candyType` of length `n`, return the maximum number of different types of candies she can eat if she only eats `n / 2` of them.

### Example 1:
```
Input: candyType = [1,1,2,2,3,3]
Output: 3
Explanation: Alice can only eat 6 / 2 = 3 candies. Since there are 3 types, she can eat one of each type.
```

### Example 2:
```
Input: candyType = [1,1,2,3]
Output: 2
Explanation: Alice can only eat 4 / 2 = 2 candies. Even though there are 3 types, she can only eat 2.
```

### Example 3:
```
Input: candyType = [6,6,6,6]
Output: 1
Explanation: Alice can only eat 4 / 2 = 2 candies. Even though she can eat 2 candies, she only has 1 type.
```

## The Twist

A Hash Set absorbs all candies to instantly give the **count of unique candy types**. The answer is the minimum of unique types and `n/2`.

## Hash Table Usage

- **Key**: `candy_type` (the type of candy)
- **Value**: `true` (or just use a set)

Algorithm:
1. Add all candy types to a hash set
2. The number of unique types is the set size
3. Return `min(unique_types, n / 2)`

## Complexity

- **Time**: O(n) - single pass through the array
- **Space**: O(n) - storing up to n unique candy types

## Link

[LeetCode 0575 Distribute Candies](https://leetcode.com/problems/distribute-candies/)
