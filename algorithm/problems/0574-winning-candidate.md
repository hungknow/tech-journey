# 0574 Winning Candidate

## Problem Description

Table: Candidate
```
+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| id          | int     |
| name        | varchar |
+-------------+---------+
id is the primary key column for this table.
Each row of this table contains information about a candidate.
```

Table: Vote
```
+-------------+------+
| Column Name | Type |
+-------------+------+
| id          | int  |
| candidateId | int  |
+-------------+------+
id is the primary key column for this table.
Each row of this table contains information about a voter and their vote for a candidate.
```

Write a SQL query to find the name of the winning candidate (the candidate who received the most votes).

Return the result table in any order.

### Example 1:
```
Input: 
Candidate table:
+----+------+
| id | name |
+----+------+
| 1  | A    |
| 2  | B    |
| 3  | C    |
+----+------+
Vote table:
+----+-------------+
| id | candidateId |
+----+-------------+
| 1  | 2           |
| 2  | 2           |
| 3  | 3           |
| 4  | 2           |
| 5  | 3           |
+----+-------------+
Output: 
+------+
| name |
+------+
| B    |
+------+
Explanation: 
Candidate B received 3 votes, which is more than any other candidate.
```

## The Twist

This problem requires finding the candidate with the most votes. The key is to count votes for each candidate, order by count in descending order, and select the top candidate.

## Algorithm

1. Join the Vote table with the Candidate table.
2. Group by candidate and count the votes.
3. Order by vote count in descending order.
4. Limit the result to the top candidate.

## Complexity

- **Time**: O(n log n) — for sorting the vote counts.
- **Space**: O(n) — for storing the grouped results.

## Solution Code

```sql
SELECT 
    c.name
FROM 
    Candidate c
JOIN 
    Vote v ON c.id = v.candidateId
GROUP BY 
    c.id, c.name
ORDER BY 
    COUNT(*) DESC
LIMIT 1;
```

## Alternative Solution (using subquery)

```sql
SELECT 
    name
FROM 
    Candidate
WHERE 
    id = (
        SELECT 
            candidateId
        FROM 
            Vote
        GROUP BY 
            candidateId
        ORDER BY 
            COUNT(*) DESC
        LIMIT 1
    );
```

## Alternative Solution (using window function)

```sql
WITH VoteCounts AS (
    SELECT 
        c.name,
        COUNT(*) as vote_count,
        DENSE_RANK() OVER (ORDER BY COUNT(*) DESC) as rank
    FROM 
        Candidate c
    JOIN 
        Vote v ON c.id = v.candidateId
    GROUP BY 
        c.id, c.name
)
SELECT 
    name
FROM 
    VoteCounts
WHERE 
    rank = 1;
```

## Link

[LeetCode 574 Winning Candidate](https://leetcode.com/problems/winning-candidate/)