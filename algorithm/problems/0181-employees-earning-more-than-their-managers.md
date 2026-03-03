# 0181 Employees Earning More Than Their Managers

## Problem Description

Table: Employee
```
+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| id          | int     |
| name        | varchar |
| salary      | int     |
| managerId   | int     |
+-------------+---------+
id is the primary key column for this table.
Each row of this table indicates the ID of an employee, their name, salary, and the ID of their manager.
```

Write a SQL query to find the employees who earn more than their managers.

Return the result table in any order.

### Example 1:
```
Input: 
Employee table:
+----+-------+--------+-----------+
| id | name  | salary | managerId |
+----+-------+--------+-----------+
| 1  | Joe   | 70000  | 3         |
| 2  | Henry | 80000  | 4         |
| 3  | Sam   | 60000  | Null      |
| 4  | Max   | 90000  | Null      |
+----+-------+--------+-----------+
Output: 
+----------+
| Employee |
+----------+
| Joe      |
+----------+
Explanation: Joe is the only employee who earns more than his manager.
```

## The Twist

This problem requires a self-join to compare an employee's salary with their manager's salary. The key is understanding how to join a table with itself using the managerId and id columns.

## Algorithm

1. Use a self-join of the Employee table, joining on employee.managerId = manager.id.
2. Add a condition to filter where employee.salary > manager.salary.
3. Select the employee's name from the result.

## Complexity

- **Time**: O(n^2) — due to the self-join.
- **Space**: O(n) — for the result set.

## Solution Code

```sql
SELECT 
    e1.name AS Employee
FROM 
    Employee e1
JOIN 
    Employee e2 ON e1.managerId = e2.id
WHERE 
    e1.salary > e2.salary;
```

## Alternative Solution (using subquery)

```sql
SELECT 
    name AS Employee
FROM 
    Employee e1
WHERE 
    salary > (
        SELECT salary 
        FROM Employee 
        WHERE id = e1.managerId
    );
```

## Link

[LeetCode 181 Employees Earning More Than Their Managers](https://leetcode.com/problems/employees-earning-more-than-their-managers/)