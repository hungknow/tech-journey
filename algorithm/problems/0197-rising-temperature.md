# 0197 Rising Temperature

## Problem Description

Table: Weather
```
+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| id            | int     |
| recordDate    | date    |
| temperature   | int     |
+---------------+---------+
id is the primary key for this table.
This table contains information about the temperature on a certain day.
```

Write a SQL query to find all dates' Id with higher temperature compared to its previous dates (yesterday).

Return the result table in any order.

### Example 1:
```
Input: 
Weather table:
+----+------------+-------------+
| id | recordDate | temperature |
+----+------------+-------------+
| 1  | 2015-01-01 | 10          |
| 2  | 2015-01-02 | 25          |
| 3  | 2015-01-03 | 20          |
| 4  | 2015-01-04 | 30          |
+----+------------+-------------+
Output: 
+----+
| id |
+----+
| 2  |
| 4  |
+----+
Explanation: 
In 2015-01-02, temperature was higher than the previous day (10 -> 25).
In 2015-01-04, temperature was higher than the previous day (20 -> 30).
```

## The Twist

This problem requires comparing each day's temperature with the previous day's temperature. The key is to use a self-join with a date difference of exactly one day, or use the DATEDIFF function to check for consecutive days.

## Algorithm

1. Use a self-join of the Weather table (w1 and w2).
2. Join on the condition that w1.recordDate is exactly one day after w2.recordDate.
3. Add condition that w1.temperature > w2.temperature.
4. Select the id from the current day (w1).

## Complexity

- **Time**: O(n^2) — due to the self-join.
- **Space**: O(n) — for the result set.

## Solution Code

```sql
SELECT 
    w1.id
FROM 
    Weather w1
JOIN 
    Weather w2 ON DATEDIFF(w1.recordDate, w2.recordDate) = 1
WHERE 
    w1.temperature > w2.temperature;
```

## Alternative Solution (using DATE_ADD)

```sql
SELECT 
    w1.id
FROM 
    Weather w1
JOIN 
    Weather w2 ON w1.recordDate = DATE_ADD(w2.recordDate, INTERVAL 1 DAY)
WHERE 
    w1.temperature > w2.temperature;
```

## Alternative Solution (using window functions)

```sql
WITH TempComparison AS (
    SELECT 
        id,
        temperature,
        recordDate,
        LAG(temperature) OVER (ORDER BY recordDate) as prev_temp,
        LAG(recordDate) OVER (ORDER BY recordDate) as prev_date
    FROM 
        Weather
)
SELECT 
    id
FROM 
    TempComparison
WHERE 
    temperature > prev_temp 
    AND DATEDIFF(recordDate, prev_date) = 1;
```

## Link

[LeetCode 197 Rising Temperature](https://leetcode.com/problems/rising-temperature/)