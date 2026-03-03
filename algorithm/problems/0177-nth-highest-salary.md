# 0177 Nth Highest Salary

## Problem Description

Table: Employee
```
+-------------+------+
| Column Name | Type |
+-------------+------+
| id          | int  |
| salary      | int  |
+-------------+------+
id is the primary key column for this table.
Each row of this table contains information about the salary of an employee.
```

Write a SQL query to report the nth highest salary from the Employee table. If there is no nth highest salary, the query should return null.

### Example 1:
```
Input: 
Employee table:
+----+--------+
| id | salary |
+----+--------+
| 1  | 100    |
| 2  | 200    |
| 3  | 300    |
+----+--------+
n = 2
Output: 
+------------------------+
| getNthHighestSalary(2) |
+------------------------+
| 200                    |
+------------------------+
```

### Example 2:
```
Input: 
Employee table:
+----+--------+
| id | salary |
+----+--------+
| 1  | 100    |
+----+--------+
n = 2
Output: 
+------------------------+
| getNthHighestSalary(2) |
+------------------------+
| null                   |
+------------------------+
```

## The Twist

This is a generalization of the "Second Highest Salary" problem. The challenge is to create a function that can find the nth highest salary for any given n. Use DENSE_RANK() window function or LIMIT/OFFSET with a variable.

## Algorithm

1. Use DENSE_RANK() window function to rank salaries in descending order.
2. Filter for the nth rank.
3. Handle the case where there might not be an nth highest salary.

## Complexity

- **Time**: O(n log n) — for sorting the salaries.
- **Space**: O(n) — for storing the ranked salaries.

## Solution Code

```sql
CREATE FUNCTION getNthHighestSalary(N INT) RETURNS INT
BEGIN
    DECLARE M INT;
    SET M = N - 1;
    RETURN (
        SELECT DISTINCT salary
        FROM Employee
        ORDER BY salary DESC
        LIMIT 1 OFFSET M
    );
END;
```

## Alternative Solution (using DENSE_RANK)

```sql
CREATE FUNCTION getNthHighestSalary(N INT) RETURNS INT
BEGIN
    RETURN (
        SELECT (
            SELECT DISTINCT salary
            FROM (
                SELECT salary, DENSE_RANK() OVER (ORDER BY salary DESC) as rank
                FROM Employee
            ) as temp
            WHERE rank = N
        )
    );
END;
```

## Link

[LeetCode 177 Nth Highest Salary](https://leetcode.com/problems/nth-highest-salary/)