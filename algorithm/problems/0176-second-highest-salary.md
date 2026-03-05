# 0176 Second Highest Salary

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

Write a SQL query to report the second highest salary from the Employee table. If there is no second highest salary, the query should return null.

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
Output: 
+---------------------+
| SecondHighestSalary |
+---------------------+
| 200                 |
+---------------------+
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
Output: 
+---------------------+
| SecondHighestSalary |
+---------------------+
| null                |
+---------------------+
```

## The Twist

Finding the second highest value requires handling duplicates and null cases. Use DISTINCT to eliminate duplicate salaries and then find the second highest value using either LIMIT/OFFSET or a subquery with MAX.

## Algorithm

1. Use DISTINCT to get unique salary values.
2. Sort these unique salaries in descending order.
3. Use LIMIT 1 OFFSET 1 to get the second highest salary.
4. Handle the case where there might not be a second highest salary by using IFNULL or COALESCE.

## Complexity

- **Time**: O(n log n) — for sorting the unique salaries.
- **Space**: O(n) — for storing the unique salary values.

## Solution Code

```sql
SELECT 
    IFNULL(
        (SELECT DISTINCT Salary
         FROM Employee
         ORDER BY Salary DESC
         LIMIT 1 OFFSET 1), 
    NULL) AS SecondHighestSalary;
```

## Alternative Solution

```sql
SELECT 
    MAX(Salary) AS SecondHighestSalary
FROM Employee
WHERE Salary < (SELECT MAX(Salary) FROM Employee);
```

## COALESCE Solution

```sql
SELECT 
    COALESCE(
        (SELECT DISTINCT Salary
         FROM Employee
         ORDER BY Salary DESC
         LIMIT 1 OFFSET 1), 
    NULL) AS SecondHighestSalary;
```

## Link

[LeetCode 176 Second Highest Salary](https://leetcode.com/problems/second-highest-salary/)