# 0570 Managers with at Least 5 Direct Reports

## Problem Description

Table: Employee
```
+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| id          | int     |
| name        | varchar |
| position    | varchar |
| salary      | int     |
| managerId   | int     |
+-------------+---------+
id is the primary key column for this table.
Each row of this table indicates the ID of an employee, their name, position, salary, and the ID of their manager.
```

Write a SQL query to find the managers with at least five direct reports.

Return the result table in any order.

### Example 1:
```
Input: 
Employee table:
+----+-------+--------+--------+------------+
| id | name  | position | salary | managerId |
+----+-------+--------+--------+------------+
| 101 | John  | Manager| 100000 | null      |
| 102 | Dan   | Manager| 85000  | 101       |
| 103 | James | Manager| 80000  | 101       |
| 104 | Amy   | Manager| 90000  | 101       |
| 105 | Anne  | Manager| 75000  | 101       |
| 106 | Ron   | Manager| 95000  | 101       |
| 107 | Bob   | Manager| 70000  | 101       |
+----+-------+--------+--------+------------+
Output: 
+------+
| name |
+------+
| John |
+------+
```

## The Twist

This problem requires identifying managers who have at least five direct reports. The key is to use a self-join to count how many employees report to each manager and then filter for those with five or more reports.

## Algorithm

1. Use a self-join to connect employees with their managers.
2. Group by manager and count the number of direct reports.
3. Filter for managers with at least 5 direct reports.
4. Join with the Employee table to get the manager's name.

## Complexity

- **Time**: O(n) — for the self-join and grouping.
- **Space**: O(n) — for storing the grouped results.

## Solution Code

```sql
SELECT 
    e.name
FROM 
    Employee e
WHERE 
    e.id IN (
        SELECT 
            managerId
        FROM 
            Employee
        WHERE 
            managerId IS NOT NULL
        GROUP BY 
            managerId
        HAVING 
            COUNT(*) >= 5
    );
```

## Alternative Solution (using JOIN)

```sql
SELECT 
    m.name
FROM 
    Employee m
JOIN 
    Employee e ON m.id = e.managerId
WHERE 
    m.id IN (
        SELECT 
            managerId
        FROM 
            Employee
        GROUP BY 
            managerId
        HAVING 
            COUNT(*) >= 5
    );
```

## Alternative Solution (using window function)

```sql
WITH ManagerReports AS (
    SELECT 
        managerId,
        COUNT(*) OVER (PARTITION BY managerId) as report_count
    FROM 
        Employee
    WHERE 
        managerId IS NOT NULL
)
SELECT DISTINCT 
    e.name
FROM 
    Employee e
JOIN 
    ManagerReports mr ON e.id = mr.managerId
WHERE 
    mr.report_count >= 5;
```

## Link

[LeetCode 570 Managers with at Least 5 Direct Reports](https://leetcode.com/problems/managers-with-at-least-5-direct-reports/)