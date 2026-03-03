# 0178 Rank Scores

## Problem Description

Table: Scores
```
+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| id          | int     |
| score       | decimal |
+-------------+---------+
id is the primary key for this table.
Each row of this table contains the score of a game. Score is a floating point value with two decimal places.
```

Write a SQL query to rank the scores. The ranking should be calculated according to the following rules:

- Scores should be ranked from highest to lowest.
- If there is a tie between scores, both should have the same ranking.
- Between two consecutive scores, there should be a gap in the ranking.

Return the result table ordered by score in descending order.

### Example 1:
```
Input: 
Scores table:
+----+-------+
| id | score |
+----+-------+
| 1  | 3.50  |
| 2  | 3.65  |
| 3  | 4.00  |
| 4  | 3.85  |
| 5  | 4.00  |
| 6  | 3.65  |
+----+-------+
Output: 
+-------+------+
| score | rank |
+-------+------+
| 4.00  | 1    |
| 4.00  | 1    |
| 3.85  | 2    |
| 3.65  | 3    |
| 3.65  | 3    |
| 3.50  | 4    |
+-------+------+
```

## The Twist

This problem requires implementing the standard competition ranking system (also known as "1224" ranking). Use window functions to calculate ranks with gaps for ties.

## Algorithm

1. Use DENSE_RANK() function to assign ranks based on score in descending order.
2. Select both score and rank columns.
3. Order the result by score in descending order.

## Complexity

- **Time**: O(n log n) — for sorting the scores.
- **Space**: O(n) — for storing the ranked scores.

## Solution Code

```sql
SELECT 
    score,
    DENSE_RANK() OVER (ORDER BY score DESC) as 'rank'
FROM 
    Scores;
```

## Alternative Solution (without window functions)

```sql
SELECT 
    s1.score,
    (SELECT COUNT(DISTINCT s2.score) 
     FROM Scores s2 
     WHERE s2.score > s1.score) + 1 as 'rank'
FROM 
    Scores s1
ORDER BY 
    s1.score DESC;
```

## Link

[LeetCode 178 Rank Scores](https://leetcode.com/problems/rank-scores/)