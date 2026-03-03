# 0580 Count Student Number in Departments

## Problem Description

Table: Student
```
+--------------+---------+
| Column Name  | Type    |
+--------------+---------+
| student_id   | int     |
| student_name | varchar |
| gender       | varchar |
| dept_id      | int     |
+--------------+---------+
student_id is the primary key column for this table.
dept_id is a foreign key reference to the Department table.
Each row of this table indicates the name of a student, their gender, and the department they are enrolled in.
```

Table: Department
```
+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| dept_id     | int     |
| dept_name   | varchar |
+-------------+---------+
dept_id is the primary key column for this table.
Each row of this table indicates the name of a department and its department id.
```

Write a SQL query to report the number of students in each department.

Return the result table ordered by student_number in descending order. In case of a tie, order them by dept_name alphabetically.

### Example 1:
```
Input: 
Student table:
+------------+--------------+--------+---------+
| student_id | student_name | gender | dept_id |
+------------+--------------+--------+---------+
| 1          | Jack         | M      | 1       |
| 2          | Jane         | F      | 1       |
| 3          | Mark         | M      | 2       |
+------------+--------------+--------+---------+
Department table:
+----------+-------------+
| dept_id  | dept_name   |
+----------+-------------+
| 1        | Engineering |
| 2        | Science     |
| 3        | Law         |
+----------+-------------+
Output: 
+-------------+----------------+
| dept_name   | student_number |
+-------------+----------------+
| Engineering | 2              |
| Science     | 1              |
| Law         | 0              |
+-------------+----------------+
```

## The Twist

This problem requires counting students in each department, including departments with zero students. The key is to use a LEFT JOIN from Department to Student to include all departments, even those with no students.

## Algorithm

1. Use a LEFT JOIN from Department to Student to include all departments.
2. Group by department and count the students.
3. Order by student count in descending order, then by department name in ascending order.

## Complexity

- **Time**: O(s + d log d) — where s is the number of students and d is the number of departments.
- **Space**: O(s + d) — for storing the join result.

## Solution Code

```sql
SELECT 
    d.dept_name,
    COUNT(s.student_id) AS student_number
FROM 
    Department d
LEFT JOIN 
    Student s ON d.dept_id = s.dept_id
GROUP BY 
    d.dept_id, d.dept_name
ORDER BY 
    student_number DESC, 
    d.dept_name ASC;
```

## Alternative Solution (using subquery)

```sql
SELECT 
    d.dept_name,
    (
        SELECT COUNT(*) 
        FROM Student s 
        WHERE s.dept_id = d.dept_id
    ) AS student_number
FROM 
    Department d
ORDER BY 
    student_number DESC, 
    d.dept_name ASC;
```

## Alternative Solution (using window function)

```sql
WITH DeptStudentCounts AS (
    SELECT 
        d.dept_name,
        COUNT(s.student_id) AS student_number,
        DENSE_RANK() OVER (ORDER BY COUNT(s.student_id) DESC, d.dept_name ASC) as rank
    FROM 
        Department d
    LEFT JOIN 
        Student s ON d.dept_id = s.dept_id
    GROUP BY 
        d.dept_id, d.dept_name
)
SELECT 
    dept_name,
    student_number
FROM 
    DeptStudentCounts
ORDER BY 
    student_number DESC, 
    dept_name ASC;
```

## Link

[LeetCode 580 Count Student Number in Departments](https://leetcode.com/problems/count-student-number-in-departments/)