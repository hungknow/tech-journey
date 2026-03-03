# 0184 Department Highest Salary

## Problem Description

Table: Employee
```
+--------------+---------+
| Column Name  | Type    |
+--------------+---------+
| id           | int     |
| name         | varchar |
| salary       | int     |
| departmentId | int     |
+--------------+---------+
id is the primary key column for this table.
departmentId is a foreign key reference to the Department table.
Each row of this table indicates the ID of an employee, their name, salary, and the ID of their department.
```

Table: Department
```
+--------------+---------+
| Column Name  | Type    |
+--------------+---------+
| id           | int     |
| name         | varchar |
+--------------+---------+
id is the primary key column for this table.
Each row of this table indicates the ID of a department and its name.
```

Write a SQL query to find employees who have the highest salary in each of the departments.

Return the result table in any order.

### Example 1:
```
Input: 
Employee table:
+----+-------+--------+--------------+
| id | name  | salary | departmentId |
+----+-------+--------+--------------+
| 1  | Joe   | 70000  | 1            |
| 2  | Jim   | 90000  | 1            |
| 3  | Henry | 80000  | 2            |
| 4  | Sam   | 60000  | 2            |
| 5  | Max   | 90000  | 1            |
+----+-------+--------+--------------+
Department table:
+----+-------+
| id | name  |
+----+-------+
| 1  | IT    |
| 2  | Sales |
+----+-------+
Output: 
+------------+----------+--------+
| Department | Employee | Salary |
+------------+----------+--------+
| IT         | Jim      | 90000  |
| Sales      | Henry    | 80000  |
| IT         | Max      | 90000  |
+------------+----------+--------+
Explanation: Max and Jim both have the highest salary in the IT department and Henry has the highest salary in the Sales department.
```

## The Twist

This problem requires finding the maximum salary for each department and then returning all employees who earn that maximum salary. The key is to use a subquery or window function to identify the highest salary in each department.

## Algorithm

1. Find the maximum salary for each department.
2. Join this result with the Employee table to find employees who earn the maximum salary in their department.
3. Join with the Department table to get the department name.

## Complexity

- **Time**: O(n^2) — due to the subquery or window function.
- **Space**: O(n) — for storing intermediate results.

## Solution Code

```sql
SELECT 
    d.name AS Department,
    e.name AS Employee,
    e.salary AS Salary
FROM 
    Employee e
JOIN 
    Department d ON e.departmentId = d.id
WHERE 
    (e.departmentId, e.salary) IN (
        SELECT 
            departmentId, 
            MAX(salary)
        FROM 
            Employee
        GROUP BY 
            departmentId
    );
```

## Alternative Solution (using window functions)

```sql
WITH RankedEmployees AS (
    SELECT 
        e.name AS Employee,
        e.salary AS Salary,
        e.departmentId,
        d.name AS Department,
        DENSE_RANK() OVER (PARTITION BY e.departmentId ORDER BY e.salary DESC) as rank
    FROM 
        Employee e
    JOIN 
        Department d ON e.departmentId = d.id
)
SELECT 
    Department,
    Employee,
    Salary
FROM 
    RankedEmployees
WHERE 
    rank = 1;
```

## Link

[LeetCode 184 Department Highest Salary](https://leetcode.com/problems/department-highest-salary/)