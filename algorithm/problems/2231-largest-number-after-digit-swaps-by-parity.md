# 2231 Largest Number After Digit Swaps by Parity

## Problem Description

You are given a non-negative integer `num`. You can swap any two digits of `num` that have the same parity (both odd or both even).

Perform exactly one swap and return the largest possible integer.

### Example 1:
```
Input: num = 2736
Output: 7236
Explanation: 
Swap 2 and 7: 7326
Swap 3 and 6: 7632
Swap 2 and 3: 7236
Swap 6 and 3: 7623
Swap 7 and 2: 7623
The largest possible integer is 7632.
```

### Example 2:
```
Input: num = 9973
Output: 9973
Explanation: 
No beneficial swap can improve the number.
```

## Solution Approach

We need to find the two digits that, when swapped, will produce the largest possible number. This can be solved by examining all possible swaps.

## Algorithm

1. Convert the number to a string for easy digit access.
2. Find the two digits that give the maximum value when swapped:
   - For each pair of digits (i, j) where i < j:
     - Consider swapping them and calculate the resulting number.
   - Keep track of the maximum number found.
3. Perform the optimal swap if it improves the number.
4. Return the maximum number found.

## Why This Works

By examining all possible single swaps, we guarantee finding the optimal solution.

## Complexity

- **Time**: O(d²) where d is the number of digits
- **Space**: O(1) - constant extra space

## Link

[LeetCode 2231 Largest Number After Digit Swaps by Parity](https://leetcode.com/problems/largest-number-after-digit-swaps-by-parity/)