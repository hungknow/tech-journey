# 0180 Consecutive Numbers

## Problem Description

Table: Logs
```
+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| id          | int     |
| num         | varchar |
+-------------+---------+
id is the primary key for this table.
id is an autoincrement column.
```

Write a SQL query to find all numbers that appear at least three times consecutively.

Return the result table in any order.

### Example 1:
```
Input: 
Logs table:
+----+-----+
| id | num |
+----+-----+
| 1  | 1   |
| 2  | 1   |
| 3  | 1   |
| 4  | 2   |
| 5  | 1   |
| 6  | 2   |
| 7  | 2   |
+----+-----+
Output: 
+-----------------+
| ConsecutiveNums |
+-----------------+
| 1               |
+-----------------+
Explanation: 1 is the only number that appears consecutively for at least three times.
```

## The Twist

This problem requires finding consecutive occurrences of the same value. The key insight is to use self-joins to check if a number appears at three consecutive id positions.

## Algorithm

1. Use three self-joins of the Logs table (l1, l2, l3).
2. Join them where l1.id = l2.id - 1 and l2.id = l3.id - 1 (consecutive ids).
3. Add condition that l1.num = l2.num = l3.num (same number).
4. Select the number (num) from any of the joined tables.
5. Use DISTINCT to avoid duplicates in the result.

## Complexity

- **Time**: O(n^2) — due to the self-joins.
- **Space**: O(n) — for the result set.

## Solution Code

```sql
SELECT DISTINCT 
    l1.num AS ConsecutiveNums
FROM 
    Logs l1,
    Logs l2,
    Logs l3
WHERE 
    l1.id = l2.id - 1 
    AND l2.id = l3.id - 1
    AND l1.num = l2.num 
    AND l2.num = l3.num;
```

## Alternative Solution (using window functions)

```sql
WITH NumberedLogs AS (
    SELECT 
        num,
        id,
        LAG(num, 1) OVER (ORDER BY id) as prev_num,
        LAG(num, 2) OVER (ORDER BY id) as prev_prev_num
    FROM 
        Logs
)
SELECT DISTINCT 
    num AS ConsecutiveNums
FROM 
    NumberedLogs
WHERE 
    num = prev_num 
    AND num = prev_prev_num;
```

## Link

[LeetCode 180 Consecutive Numbers](https://leetcode.com/problems/consecutive-numbers/)