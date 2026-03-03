# 0185 Department Top Three Salaries

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

Write a SQL query to find employees who are earning the top three salaries in each of the departments.

Return the result table in any order.

### Example 1:
```
Input: 
Employee table:
+----+-------+--------+--------------+
| id | name  | salary | departmentId |
+----+-------+--------+--------------+
| 1  | Joe   | 85000  | 1            |
| 2  | Henry | 80000  | 2            |
| 3  | Sam   | 60000  | 2            |
| 4  | Max   | 90000  | 1            |
| 5  | Janet | 69000  | 1            |
| 6  | Randy | 85000  | 1            |
| 7  | Will  | 70000  | 1            |
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
| IT         | Max      | 90000  |
| IT         | Joe      | 85000  |
| IT         | Randy    | 85000  |
| IT         | Will     | 70000  |
| Sales      | Henry    | 80000  |
| Sales      | Sam      | 60000  |
+------------+----------+--------+
Explanation: 
In the IT department:
- Max earns the highest salary
- Joe and Randy earn the second highest salary
- Will earns the third highest salary

In the Sales department:
- Henry earns the highest salary
- Sam earns the second highest salary
- There is no third highest salary
```

## The Twist

This problem requires finding the top three salaries in each department, handling ties correctly. The key is to use DENSE_RANK() window function to rank employees by salary within each department.

## Algorithm

1. Use DENSE_RANK() window function to rank employees by salary within each department (partition by departmentId, order by salary desc).
2. Filter for employees with rank <= 3.
3. Join with the Department table to get department names.

## Complexity

- **Time**: O(n log n) — for sorting and window function operations.
- **Space**: O(n) — for storing the ranked results.

## Solution Code

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
    rank <= 3;
```

## Alternative Solution (using subquery)

```sql
SELECT 
    d.name AS Department,
    e1.name AS Employee,
    e1.salary AS Salary
FROM 
    Employee e1
JOIN 
    Department d ON e1.departmentId = d.id
WHERE 
    (
        SELECT COUNT(DISTINCT e2.salary)
        FROM Employee e2
        WHERE e2.departmentId = e1.departmentId AND e2.salary > e1.salary
    ) < 3;
```

## Link

[LeetCode 185 Department Top Three Salaries](https://leetcode.com/problems/department-top-three-salaries/)