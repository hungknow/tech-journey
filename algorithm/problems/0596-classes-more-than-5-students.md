# 0596 Classes More Than 5 Students

## Problem Description

Table: Courses
```
+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| student     | varchar |
| class       | varchar |
+-------------+---------+
(student, class) is the primary key column for this table.
Each row of this table indicates the name of a student and the class in which they are enrolled.
```

Write a SQL query to find all the classes that have at least five students.

Return the result table in any order.

### Example 1:
```
Input: 
Courses table:
+---------+----------+
| student | class    |
+---------+----------+
| A       | Math     |
| B       | English  |
| C       | Math     |
| D       | Biology  |
| E       | Math     |
| F       | Computer |
| G       | Math     |
| H       | Math     |
| I       | Math     |
+---------+----------+
Output: 
+---------+
| class   |
+---------+
| Math    |
+---------+
```

## The Twist

This problem requires finding classes with at least 5 students. The key is to group by class and use HAVING COUNT(*) >= 5 to filter the results.

## Algorithm

1. Group the Courses table by class.
2. Use HAVING COUNT(*) >= 5 to filter for classes with at least 5 students.
3. Select the class from the result.

## Complexity

- **Time**: O(n log n) — for grouping and sorting.
- **Space**: O(n) — for storing the grouped results.

## Solution Code

```sql
SELECT 
    class
FROM 
    Courses
GROUP BY 
    class
HAVING 
    COUNT(*) >= 5;
```

## Alternative Solution (using subquery)

```sql
SELECT DISTINCT 
    c1.class
FROM 
    Courses c1
WHERE 
    (
        SELECT COUNT(*) 
        FROM Courses c2 
        WHERE c2.class = c1.class
    ) >= 5;
```

## Alternative Solution (using window function)

```sql
WITH ClassCounts AS (
    SELECT 
        class,
        COUNT(*) as student_count
    FROM 
        Courses
    GROUP BY 
        class
)
SELECT 
    class
FROM 
    ClassCounts
WHERE 
    student_count >= 5;
```

## Link

[LeetCode 596 Classes More Than 5 Students](https://leetcode.com/problems/classes-more-than-5-students/)