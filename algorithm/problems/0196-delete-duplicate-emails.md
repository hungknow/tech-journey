# 0196 Delete Duplicate Emails

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

Write a SQL query to delete all the duplicate emails, keeping only one unique email with the smallest id.

Note that you are supposed to write a DELETE statement and not a SELECT query.

After running your script, the answer shown is the number of affected rows (output), which will be the count of the deleted emails.

### Example 1:
```
Input: 
Person table:
+----+------------------+
| id | email            |
+----+------------------+
| 1  | john@example.com |
| 2  | bob@example.com  |
| 3  | john@example.com |
+----+------------------+
Output: 
1
Explanation: john@example.com is repeated two times. We keep the one with the smallest Id = 1.
```

### Example 2:
```
Input: 
Person table:
+----+------------------+
| id | email            |
+----+------------------+
| 1  | john@example.com |
| 2  | john@example.com |
| 3  | john@example.com |
+----+------------------+
Output: 
2
Explanation: john@example.com is repeated three times. We keep the one with the smallest Id = 1.
```

## The Twist

This problem requires deleting duplicate rows while keeping only the one with the smallest id. The key is to use a DELETE statement with a self-join or subquery to identify and remove duplicates.

## Algorithm

1. Use a DELETE statement with a self-join to identify duplicate emails.
2. Keep only the row with the smallest id for each email.
3. Delete all other duplicate rows.

## Complexity

- **Time**: O(n^2) — due to the self-join in the DELETE statement.
- **Space**: O(n) — for temporary storage during the operation.

## Solution Code

```sql
DELETE p1 
FROM 
    Person p1
INNER JOIN 
    Person p2 
WHERE 
    p1.email = p2.email 
    AND p1.id > p2.id;
```

## Alternative Solution (using subquery)

```sql
DELETE 
FROM Person 
WHERE id NOT IN (
    SELECT MIN(id) 
    FROM Person 
    GROUP BY email
);
```

## Alternative Solution (using window functions)

```sql
WITH RankedEmails AS (
    SELECT 
        id,
        ROW_NUMBER() OVER (PARTITION BY email ORDER BY id) as rn
    FROM 
        Person
)
DELETE 
FROM Person 
WHERE id IN (
    SELECT id 
    FROM RankedEmails 
    WHERE rn > 1
);
```

## Link

[LeetCode 196 Delete Duplicate Emails](https://leetcode.com/problems/delete-duplicate-emails/)