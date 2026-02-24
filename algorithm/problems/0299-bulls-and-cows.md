# 0299 Bulls and Cows

## Problem Description

You are playing the Bulls and Cows game with your friend.

You write down a secret number and ask your friend to guess what the number is. When your friend makes a guess, you provide a hint with the following info:

- The number of "bulls" (digits in the guess that are in the correct position)
- The number of "cows" (digits in the guess that are in your secret number but are located in the wrong position)

Given the secret number `secret` and your friend's guess `guess`, return the hint for your friend's guess.

The hint should be formatted as "xAyB", where x is the number of bulls and y is the number of cows. Note that both secret and guess may contain duplicate digits.

### Example 1:
```
Input: secret = "1807", guess = "7810"
Output: "1A3B"
Explanation: Bulls are "8", Cows are "0", "1" and "7".
```

### Example 2:
```
Input: secret = "1123", guess = "0111"
Output: "1A1B"
Explanation: The 1 at index 0 is a bull. The 1s at indices 1, 2, and 3 are counted as cows.
```

## The Twist

Map (or array) tracks the frequencies of characters in the "secret" and "guess" that didn't perfectly align, to calculate partial matches (cows).

## Hash Table Usage

- **Key**: `digit` (0-9)
- **Value**: `count` (frequency of unmatched digits)

Algorithm:
1. First pass: Count bulls (exact matches) and build frequency maps for unmatched digits
2. Second pass: Calculate cows as the sum of minimum counts for each digit
3. Return the hint string

## Complexity

- **Time**: O(n) - single pass through the strings
- **Space**: O(1) - at most 10 digits (0-9)

## Link

[LeetCode 0299 Bulls and Cows](https://leetcode.com/problems/bulls-and-cows/)
