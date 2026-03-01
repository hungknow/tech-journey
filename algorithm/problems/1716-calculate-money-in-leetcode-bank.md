# 1716 Calculate Money in Leetcode Bank

## Problem Description

Hercy wants to save money for his first car. He puts money in the Leetcode bank every day.

He starts by putting $1 on Monday, $2 on Tuesday, $3 on Wednesday, $4 on Thursday, $5 on Friday, and $6 on Saturday. He puts $0 on Sunday.

This pattern repeats every week. Given a number `n`, return the total amount of money he will have in the Leetcode bank after `n` days.

### Example 1:
```
Input: n = 4
Output: 10
Explanation: 
Day 1 (Monday): $1
Day 2 (Tuesday): $2
Day 3 (Wednesday): $3
Day 4 (Thursday): $4
Total: $1 + $2 + $3 + $4 = $10
```

### Example 2:
```
Input: n = 10
Output: 37
Explanation: 
Week 1: $1 + $2 + $3 + $4 + $5 + $6 + $0 = $21
Week 2: $1 + $2 + $3 = $6
Total: $21 + $6 = $27
```

## Solution Approach

The money deposited follows a weekly pattern. Each full week contributes a fixed amount, and the remaining days contribute based on their position in the week.

## Algorithm

1. Calculate the number of complete weeks: weeks = n // 7
2. Calculate the remaining days: days = n % 7
3. Calculate money from complete weeks: 
   - Each week contributes $21 (1+2+3+4+5+6+0)
   - For week i, the amount is $21 + 7*(i-1)
   - Total from complete weeks = weeks * 21 + 7 * (weeks * (weeks-1) / 2)
4. Calculate money from remaining days:
   - For the remaining days, add 1+2+...+days, plus the week increment
   - Total from remaining days = days * (days+1) / 2 + weeks * days
5. Return the sum

## Why This Works

The pattern increases by $1 for each day of the week, and each subsequent week adds $1 more to each day's deposit. This forms an arithmetic progression that we can calculate using formulas.

## Complexity

- **Time**: O(1) - constant time calculations
- **Space**: O(1) - constant extra space

## Link

[LeetCode 1716 Calculate Money in Leetcode Bank](https://leetcode.com/problems/calculate-money-in-leetcode-bank/)