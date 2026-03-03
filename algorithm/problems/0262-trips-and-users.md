# 0262 Trips and Users

## Problem Description

Table: Users
```
+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| id          | int     |
| name        | varchar |
| is_banned   | enum    |
| role        | enum    |
+-------------+---------+
id is the primary key column for this table.
The table holds all users. Each user has a unique id.
name is the name of the user.
is_banned is an enum type of ('No', 'Yes').
role is an enum type of ('client', 'driver', 'partner').
```

Table: Trips
```
+--------------+------+
| Column Name  | Type |
+--------------+------+
| id           | int  |
| client_id    | int  |
| driver_id    | int  |
| city_id      | int  |
| status       | enum |
| request_at   | date |
+--------------+------+
id is the primary key column for this table.
The table holds all taxi trips.
Each trip has a unique id.
client_id and driver_id are foreign keys to the Users table.
status is an enum type of ('completed', 'cancelled_by_driver', 'cancelled_by_client').
```

Write a SQL query to find the cancellation rate of requests with unbanned users (both client and driver must not be banned) between October 1, 2013 and October 3, 2013.

The cancellation rate is computed by dividing the number of canceled (by client or driver) requests with unbanned users by the total number of requests with unbanned users on that day.

Return the result table in any order. Round Cancellation Rate to two decimal points.

### Example 1:
```
Input: 
Users table:
+----+--------+-----------+--------+
| id | name   | is_banned | role   |
+----+--------+-----------+--------+
| 1  | Alice  | No        | client |
| 2  | Bob    | Yes       | client |
| 3  | Charlie| No        | client |
| 4  | David  | No        | client |
| 5  | Eve    | No        | driver |
| 6  | Frank  | No        | driver |
| 7  | Grace  | No        | driver |
+----+--------+-----------+--------+
Trips table:
+----+-----------+-----------+---------+---------------------+------------+
| id | client_id | driver_id | city_id | status              | request_at |
+----+-----------+-----------+---------+---------------------+------------+
| 1  | 1         | 5         | 1       | completed           | 2013-10-01 |
| 2  | 1         | 6         | 1       | cancelled_by_driver | 2013-10-01 |
| 3  | 1         | 7         | 1       | completed           | 2013-10-01 |
| 4  | 2         | 5         | 1       | completed           | 2013-10-01 |
| 5  | 3         | 5         | 1       | completed           | 2013-10-01 |
| 6  | 4         | 5         | 1       | cancelled_by_client| 2013-10-01 |
| 7  | 5         | 6         | 2       | completed           | 2013-10-02 |
| 8  | 6         | 7         | 2       | cancelled_by_driver | 2013-10-02 |
| 9  | 7         | 6         | 2       | completed           | 2013-10-02 |
| 10 | 8         | 7         | 2       | completed           | 2013-10-02 |
| 11 | 9         | 6         | 3       | completed           | 2013-10-03 |
| 12 | 10        | 7         | 3       | completed           | 2013-10-03 |
| 13 | 11        | 6         | 3       | completed           | 2013-10-03 |
| 14 | 12        | 7         | 3       | completed           | 2013-10-03 |
+----+-----------+-----------+---------+---------------------+------------+
Output: 
+------------+-------------------+
| Day        | Cancellation Rate |
+------------+-------------------+
| 2013-10-01 | 0.33              |
| 2013-10-02 | 0.00              |
| 2013-10-03 | 0.00              |
+------------+-------------------+
Explanation: 
On 2013-10-01:
  - There were 4 requests in total, 2 of which were cancelled.
  - However, the request with id=2 was made by a banned client (id=2), so it should be ignored.
  - The request with id=6 was made by a banned driver (id=6), so it should be ignored.
  - So there is only 1 cancelled request out of 3 valid requests, thus the cancellation rate is 1/3 = 0.33

On 2013-10-02:
  - There were 3 requests in total, 1 of which was cancelled.
  - However, the request with id=8 was made by a banned client (id=6), so it should be ignored.
  - So there is only 0 cancelled request out of 2 valid requests, thus the cancellation rate is 0/2 = 0.00

On 2013-10-03:
  - There were 3 requests in total, 0 of which were cancelled.
  - So the cancellation rate is 0/3 = 0.00
```

## The Twist

This problem requires filtering out trips involving banned users and then calculating the cancellation rate for each day. The key is to join the Trips table with the Users table twice (once for clients and once for drivers) to check if both are not banned.

## Algorithm

1. Join the Trips table with the Users table twice (for client and driver) to check if both are not banned.
2. Filter for trips between October 1, 2013 and October 3, 2013.
3. Group by date and calculate the cancellation rate by dividing the count of cancelled trips by the total count of trips.
4. Round the result to two decimal places.

## Complexity

- **Time**: O((t * u) + t log t) — where t is the number of trips and u is the number of users.
- **Space**: O(t) — for storing the filtered trips.

## Solution Code

```sql
SELECT 
    T.request_at AS Day,
    ROUND(
        SUM(
            CASE 
                WHEN T.status IN ('cancelled_by_driver', 'cancelled_by_client') 
                THEN 1 
                ELSE 0 
            END
        ) / COUNT(*), 
        2
    ) AS 'Cancellation Rate'
FROM 
    Trips T
JOIN 
    Users C ON T.client_id = C.id AND C.is_banned = 'No'
JOIN 
    Users D ON T.driver_id = D.id AND D.is_banned = 'No'
WHERE 
    T.request_at BETWEEN '2013-10-01' AND '2013-10-03'
GROUP BY 
    T.request_at;
```

## Alternative Solution (using subqueries)

```sql
SELECT 
    request_at AS Day,
    ROUND(
        cancelled_count / total_count, 
        2
    ) AS 'Cancellation Rate'
FROM (
    SELECT 
        request_at,
        SUM(CASE WHEN status IN ('cancelled_by_driver', 'cancelled_by_client') THEN 1 ELSE 0 END) as cancelled_count,
        COUNT(*) as total_count
    FROM 
        Trips
    WHERE 
        client_id IN (SELECT id FROM Users WHERE is_banned = 'No')
        AND driver_id IN (SELECT id FROM Users WHERE is_banned = 'No')
        AND request_at BETWEEN '2013-10-01' AND '2013-10-03'
    GROUP BY 
        request_at
) AS subquery;
```

## Link

[LeetCode 262 Trips and Users](https://leetcode.com/problems/trips-and-users/)