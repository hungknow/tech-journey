# 0183 Customers Who Never Order

## Problem Description

Table: Customers
```
+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| id          | int     |
| name        | varchar |
+-------------+---------+
id is the primary key column for this table.
Each row of this table indicates the ID and name of a customer.
```

Table: Orders
```
+-------------+------+
| Column Name | Type |
+-------------+------+
| id          | int  |
| customerId  | int  |
+-------------+------+
id is the primary key column for this table.
customerId is a foreign key referencing the id from the Customers table.
Each row of this table indicates the ID of an order and the ID of the customer who ordered it.
```

Write a SQL query to report all customers who never order anything.

Return the result table in any order.

### Example 1:
```
Input: 
Customers table:
+----+-------+
| id | name  |
+----+-------+
| 1  | Joe   |
| 2  | Henry |
| 3  | Sam   |
| 4  | Max   |
+----+-------+
Orders table:
+----+------------+
| id | customerId |
+----+------------+
| 1  | 3          |
| 2  | 1          |
+----+------------+
Output: 
+-----------+
| Customers |
+-----------+
| Henry     |
| Max       |
+-----------+
```

## The Twist

This problem requires finding customers who don't have any corresponding orders. The key is to use a LEFT JOIN from Customers to Orders and then filter for NULL values in the Orders table.

## Algorithm

1. Use a LEFT JOIN from Customers to Orders on customer.id = orders.customerId.
2. Filter for rows where orders.customerId IS NULL (customers with no orders).
3. Select the customer name from the result.

## Complexity

- **Time**: O(m + n) — where m is the number of customers and n is the number of orders.
- **Space**: O(m + n) — for the join result.

## Solution Code

```sql
SELECT 
    c.name AS Customers
FROM 
    Customers c
LEFT JOIN 
    Orders o ON c.id = o.customerId
WHERE 
    o.customerId IS NULL;
```

## Alternative Solution (using subquery with NOT IN)

```sql
SELECT 
    name AS Customers
FROM 
    Customers
WHERE 
    id NOT IN (SELECT DISTINCT customerId FROM Orders);
```

## Alternative Solution (using subquery with NOT EXISTS)

```sql
SELECT 
    name AS Customers
FROM 
    Customers c
WHERE 
    NOT EXISTS (SELECT 1 FROM Orders o WHERE o.customerId = c.id);
```

## Link

[LeetCode 183 Customers Who Never Order](https://leetcode.com/problems/customers-who-never-order/)