# 0548 Split Array with Equal Sum

## Problem Description

Given an integer array `nums`, return `true` if you can split it into three non-empty parts with equal sum.

Formally, we can split the array if we can find indices `i + 1 < j` with:
- `sum(nums[0..i]) == sum(nums[i+1..j]) == sum(nums[j+1..n-1])`

### Example 1:
```
Input: nums = [1,2,3,0,3]
Output: true
Explanation:
- i = 0, j = 1: sum(nums[0..0]) = 1, sum(nums[1..1]) = 2, sum(nums[2..3]) = 3
```

### Example 2:
```
Input: nums = [1,2,1,2,1,2,1,2,1]
Output: true
```

### Example 3:
```
Input: nums = [1,2,3,4,5]
Output: false
```

## The Twist

We need to find **two split points** that divide the array into three parts with equal sums. A brute force O(n²) approach would check all possible pairs.

## Algorithm

### Prefix Sum Approach:
1. Calculate prefix sums for the array
2. Use a hash set to store possible first split sums
3. For each possible second split:
   - Check if the first part sum exists in the set
   - Check if the third part sum equals the first two
4. Return true if any valid split found

### Two-Pointer Approach:
1. Calculate total sum
2. Use two pointers to find valid splits
3. First pointer finds where prefix sum = total/3
4. Second pointer finds where remaining prefix sum = 2*total/3

## Complexity

- **Time**: O(n²) naive, O(n) with hash set
- **Space**: O(n) - storing prefix sums

## Link

[LeetCode 0548 Split Array with Equal Sum](https://leetcode.com/problems/split-array-with-equal-sum/)
