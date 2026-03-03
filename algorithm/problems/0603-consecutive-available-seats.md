# 0603 Consecutive Available Seats

## Problem Description

Table: Cinema
```
+-------------+------+
| Column Name | Type |
+-------------+------+
| seat_id     | int  |
| free        | bool |
+-------------+------+
seat_id is an auto-increment primary key column for this table.
free is a boolean column with values ('true', 'false').
```

Write a SQL query to report all the consecutive available seats.

The test cases are generated so that there are no two seats that are far apart (more than 3 seats apart).

Return the result table ordered by seat_id in ascending order.

### Example 1:
```
Input: 
Cinema table:
+---------+------+
| seat_id | free |
+---------+------+
| 1       | 1    |
| 2       | 0    |
| 3       | 1    |
| 4       | 1    |
| 5       | 1    |
+---------+------+
Output: 
+---------+
| seat_id |
+---------+
| 3       |
| 4       |
| 5       |
```

## The Twist

This problem requires finding consecutive available seats. The key is to use window functions or self-joins to identify seats that are available and have adjacent available seats.

## Algorithm

1. Use the LAG() window function to check if the previous seat was available.
2. Filter for seats that are available and have the previous seat also available.
3. Select the seat_id from the result.
4. Order by seat_id in ascending order.

## Complexity

- **Time**: O(n log n) — for the window function operation.
- **Space**: O(n) — for storing the window function results.

## Solution Code

```sql
SELECT 
    c1.seat_id
FROM 
    Cinema c1
JOIN 
    Cinema c2 ON c1.seat_id = c2.seat_id + 1
WHERE 
    c1.free = 1 AND c2.free = 1
ORDER BY 
    c1.seat_id;
```

## Alternative Solution (using window functions)

```sql
WITH AvailableSeats AS (
    SELECT 
        seat_id,
        free,
        LAG(free, 1) OVER (ORDER BY seat_id) as prev_free
    FROM 
        Cinema
)
SELECT 
    seat_id
FROM 
    AvailableSeats
WHERE 
    free = 1 AND prev_free = 1
ORDER BY 
    seat_id;
```

## Alternative Solution (using subquery)

```sql
SELECT 
    seat_id
FROM 
    Cinema c1
WHERE 
    free = 1 
    AND EXISTS (
        SELECT 1 
        FROM Cinema c2 
        WHERE c2.seat_id = c1.seat_id - 1 AND c2.free = 1
    )
ORDER BY 
    seat_id;
```

## Link

[LeetCode 603 Consecutive Available Seats](https://leetcode.com/problems/consecutive-available-seats/)