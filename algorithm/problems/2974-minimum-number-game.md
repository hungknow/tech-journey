# 2974 Minimum Number Game

## Problem Description

You are given an integer array `nums`. You and your friend take turns choosing a number from the array. If the number chosen is the largest, you win.

If both choose the same number, the game is a draw.

### Example 1:
```
Input: nums = [1,3,5,2,4]
Output: true
Explanation: 
You choose 3, friend chooses 4, you choose 5, you lose.
```

### Example 2:
```
Input: Number: [1,2,3,4]
Output: false
Explanation: 
You choose 2, friend chooses 3, you choose 1, you lose.
```

## Solution Approach

This is a simple game where both players play optimally. The optimal strategy is to always choose the largest available number.

## Algorithm

1. While there are numbers in the array:
   - You and your friend each choose a number.
   - Remove the chosen number from the array.
   - If the array is empty, the game ends.
   - Determine the winner based on the final state.
2. Return the winner.

## Why This Works

By always choosing the largest available number, both players play optimally, which maximizes their chances of winning.

## Complexity

- **Time**: O(n²) - in the worst case, each turn removes one element
- **Space**: O(1) - constant extra space

## Link

[LeetCode 2974 Minimum Number Game](https://leetcode.com/problems/minimum-number-game/)