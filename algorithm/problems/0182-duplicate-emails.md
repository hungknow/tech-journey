# 0182 Duplicate Emails

## Problem Description

Table: Person
```
+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| id          | int     |
| email       | varchar |
+-------------+---------+
id is the primary key column for this table.
Each row of this table contains an email. The emails will not have uppercase letters.
```

Write a SQL query to report all the duplicate emails. Note that it's guaranteed that the email field is not NULL.

Return the result table in any order.

### Example 1:
```
Input: 
Person table:
+----+---------+
| id | email   |
+----+---------+
| 1  | a@b.com |
| 2  | c@d.com |
| 3  | a@b.com |
+----+---------+
Output:
+---------+
| email   |
+---------+
| a@b.com |
+---------+
Explanation: a@b.com is repeated two times.
```

## The Twist

This problem requires finding duplicate values in a table. The key is to use GROUP BY with HAVING COUNT(*) > 1 to identify emails that appear more than once.

## Algorithm

1. Group the Person table by email.
2. Use HAVING COUNT(*) > 1 to filter for emails that appear more than once.
3. Select the email column from the result.

## Complexity

- **Time**: O(n log n) — for grouping and sorting.
- **Space**: O(n) — for storing the grouped results.

## Solution Code

```sql
SELECT
    email
FROM
    Person
GROUP BY
    email
HAVING
    COUNT(*) > 1;
```

## Alternative Solution (using subquery)

```sql
SELECT DISTINCT
    p1.email
FROM
    Person p1
JOIN
    Person p2 ON p1.email = p2.email AND p1.id != p2.id;
```

## Alternative Solution (using window functions)

```sql
WITH EmailCounts AS (
    SELECT
        email,
        COUNT(*) OVER (PARTITION BY email) as email_count
    FROM
        Person
)
SELECT DISTINCT
    email
FROM
    EmailCounts
WHERE
    email_count > 1;
```

## Link

[LeetCode 182 Duplicate Emails](https://leetcode.com/problems/duplicate-emails/)