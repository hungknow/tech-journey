# 0577 Employee Bonus

## Problem Description

Table: Employee
```
+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| empId       | int     |
| name        | varchar |
| supervisor  | int     |
| salary      | int     |
+-------------+---------+
empId is the primary key column for this table.
Each row of this table indicates the name of an employee, their salary, and their supervisor's empId.
```

Table: Bonus
```
+-------------+------+
| Column Name | Type |
+-------------+------+
| empId       | int  |
| bonus       | int  |
+-------------+------+
empId is the primary key column for this table.
Each row of this table contains the bonus amount for an employee.
```

Write a SQL query to report the name and bonus amount of each employee with a bonus less than 1000.

Return the result table in any order.

### Example 1:
```
Input: 
Employee table:
+-------+--------+------------+--------+
| empId | name   | supervisor | salary |
+-------+--------+------------+--------+
| 3     | Brad   | null       | 4000   |
| 1     | John   | 3          | 1000   |
| 2     | Dan    | 3          | 2000   |
| 4     | Thomas | 3          | 4000   |
+-------+--------+------------+--------+
Bonus table:
+-------+-------+
| empId | bonus |
+-------+-------+
| 2     | 500   |
| 4     | 2000  |
+-------+-------+
Output: 
+------+-------+
| name | bonus |
+------+-------+
| Brad | null  |
| John | null  |
| Dan  | 500   |
+------+-------+
```

## The Twist

This problem requires finding employees with a bonus less than 1000, including those with no bonus (NULL). The key is to use a LEFT JOIN from Employee to Bonus to include all employees, even those without a bonus.

## Algorithm

1. Use a LEFT JOIN from Employee to Bonus to include all employees.
2. Filter for employees with bonus < 1000 OR bonus IS NULL.
3. Select the employee name and bonus amount.

## Complexity

- **Time**: O(n) — for the join operation.
- **Space**: O(n) — for the result set.

## Solution Code

```sql
SELECT 
    e.name,
    b.bonus
FROM 
    Employee e
LEFT JOIN 
    Bonus b ON e.empId = b.empId
WHERE 
    b.bonus < 1000 OR b.bonus IS NULL;
```

## Alternative Solution (using COALESCE)

```sql
SELECT 
    e.name,
    b.bonus
FROM 
    Employee e
LEFT JOIN 
    Bonus b ON e.empId = b.empId
WHERE 
    COALESCE(b.bonus, 0) < 1000;
```

## Alternative Solution (using subquery)

```sql
SELECT 
    name,
    (SELECT bonus FROM Bonus WHERE empId = Employee.empId) AS bonus
FROM 
    Employee
WHERE 
    (SELECT bonus FROM Bonus WHERE empId = Employee.empId) < 1000 
    OR (SELECT bonus FROM Bonus WHERE empId = Employee.empId) IS NULL;
```

## Link

[LeetCode 577 Employee Bonus](https://leetcode.com/problems/employee-bonus/)