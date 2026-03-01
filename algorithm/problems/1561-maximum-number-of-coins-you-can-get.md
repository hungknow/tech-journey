# 1561 Maximum Number of Coins You Can Get

## Problem Description

There are `3n` piles of coins of varying size, you and your friends will take piles of coins as follows:

- In each step, you will choose **any** `3` piles of coins.
- Your friends will take the pile with the **maximum** number of coins.
- You will take the pile with the **second maximum** number of coins.
- Your other friend will take the pile with the **minimum** number of coins.
- Repeat the process until there are no more piles of coins.

Return an array of the maximum number of coins you can get.

### Example 1:
```
Input: piles = [2,4,1,2,7,8]
Output: [8]
Explanation: 
Choose the piles with coins [2,7,8]. Your friends take 8 and you take 7.
Choose the piles with coins [2,1,2]. Your friends take 2 and you take 2.
The total number of coins you can get is 7 + 2 = 9.
```

### Example 2:
```
Input: piles = [2,4,5]
Output: [4]
Explanation: 
Choose the piles with coins [2,4,5]. Your friends take 5 and you take 4.
The total number of coins you can get is 4.
```

## Solution Approach

To maximize the number of coins you get, you should always aim to get the second largest pile in each step. This can be achieved by sorting the piles and strategically selecting them.

## Algorithm

1. Sort the piles in descending order.
2. Initialize `result` = 0.
3. For `i` from 1 to `n-1` (stepping by 2):
   - Add `piles[i]` to `result`.
4. Return `result`.

## Why This Works

After sorting in descending order, the optimal strategy is to let your friends take the largest pile, you take the second largest, and the other friend take the smallest. By repeating this process, you'll accumulate the sum of every second element starting from index 1.

## Complexity

- **Time**: O(n log n) - dominated by sorting
- **Space**: O(1) - we can sort in-place (or O(n) if using extra space for sorting)

## Link

[LeetCode 1561 Maximum Number of Coins You Can Get](https://leetcode.com/problems/maximum-number-of-coins-you-can-get/)