# 0584 Find Customer Referee

## Problem Description

Table: Customer
```
+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| id          | int     |
| name        | varchar |
| referee_id  | int     |
+-------------+---------+
id is the primary key column for this table.
Each row of this table indicates the id of a customer, their name, and the id of the customer who referred them.
```

Write a SQL query to find the names of the customer that are not referred by the customer with id = 2.

Return the result table in any order.

### Example 1:
```
Input: 
Customer table:
+----+------+------------+
| id | name | referee_id |
+----+------+------------+
| 1  | Will | null       |
| 2  | Jane | null       |
| 3  | Alex | 2          |
| 4  | Bill | null       |
| 5  | Zack | 1          |
| 6  | Mark | 2          |
+----+------+------------+
Output: 
+------+
| name |
+------+
| Will |
| Jane |
| Bill |
| Zack |
+------+
```

## The Twist

This problem requires finding customers who are not referred by customer with id = 2. The key is to handle both NULL values and specific referee_id values in the WHERE clause.

## Algorithm

1. Select the name from the Customer table.
2. Filter for customers where referee_id is not 2.
3. Include customers with NULL referee_id using OR referee_id IS NULL.

## Complexity

- **Time**: O(n) — for scanning the Customer table.
- **Space**: O(n) — for the result set.

## Solution Code

```sql
SELECT 
    name
FROM 
    Customer
WHERE 
    referee_id != 2 OR referee_id IS NULL;
```

## Alternative Solution (using COALESCE)

```sql
SELECT 
    name
FROM 
    Customer
WHERE 
    COALESCE(referee_id, 0) != 2;
```

## Alternative Solution (using NOT IN)

```sql
SELECT 
    name
FROM 
    Customer
WHERE 
    id NOT IN (
        SELECT id 
        FROM Customer 
        WHERE referee_id = 2
    );
```

## Link

[LeetCode 584 Find Customer Referee](https://leetcode.com/problems/find-customer-referee/)