# 0586 Customer Placing the Largest Number of Orders

## Problem Description

Table: Orders
```
+-----------------+----------+
| Column Name     | Type     |
+-----------------+----------+
| order_number    | int      |
| customer_number | int      |
+-----------------+----------+
order_number is the primary key of this table.
This table contains information about the order ID and the customer ID.
```

Write a SQL query to find the customer_number for the customer who has placed the largest number of orders.

The test cases are generated so that exactly one customer will have placed the most orders.

### Example 1:
```
Input: 
Orders table:
+--------------+-----------------+
| order_number | customer_number |
+--------------+-----------------+
| 1            | 1               |
| 2            | 2               |
| 3            | 3               |
| 4            | 3               |
+--------------+-----------------+
Output: 
+-----------------+
| customer_number |
+-----------------+
| 3               |
```

## The Twist

This problem requires finding the customer with the most orders. The key is to count orders for each customer, order by count in descending order, and select the top customer.

## Algorithm

1. Group by customer_number and count the orders.
2. Order by the count in descending order.
3. Limit the result to the top customer.

## Complexity

- **Time**: O(n log n) — for sorting the order counts.
- **Space**: O(n) — for storing the grouped results.

## Solution Code

```sql
SELECT 
    customer_number
FROM 
    Orders
GROUP BY 
    customer_number
ORDER BY 
    COUNT(*) DESC
LIMIT 1;
```

## Alternative Solution (using subquery)

```sql
SELECT 
    customer_number
FROM 
    Orders
GROUP BY 
    customer_number
HAVING 
    COUNT(*) = (
        SELECT 
            COUNT(*)
        FROM 
            Orders
        GROUP BY 
            customer_number
        ORDER BY 
            COUNT(*) DESC
        LIMIT 1
    );
```

## Alternative Solution (using window function)

```sql
WITH OrderCounts AS (
    SELECT 
        customer_number,
        COUNT(*) as order_count,
        DENSE_RANK() OVER (ORDER BY COUNT(*) DESC) as rank
    FROM 
        Orders
    GROUP BY 
        customer_number
)
SELECT 
    customer_number
FROM 
    OrderCounts
WHERE 
    rank = 1;
```

## Link

[LeetCode 586 Customer Placing the Largest Number of Orders](https://leetcode.com/problems/customer-placing-the-largest-number-of-orders/)