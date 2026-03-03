# 0578 Get Highest Answer Rate Question

## Problem Description

Table: SurveyLog
```
+-------------+------+
| Column Name | Type |
+-------------+------+
| id          | int  |
| action      | enum |
| question_id | int  |
| answer_id   | int  |
| q_num       | int  |
| timestamp   | int  |
+-------------+------+
This table may contain duplicate rows.
action is an ENUM type of ('show', 'answer', 'skip').
This table contains information about questions displayed in the survey, and user responses to them.
Note that answer_id is only applicable for 'answer' actions.
```

Write a SQL query to report the question that has the highest answer rate.

The answer rate is defined as the number of 'answer' actions divided by the total number of 'show' actions for a specific question.

Return the result table in any order.

### Example 1:
```
Input: 
SurveyLog table:
+------+--------+--------------+------------+-----------+------------+
| id   | action | question_id | answer_id  | q_num     | timestamp  |
+------+--------+--------------+------------+-----------+------------+
| 5    | show   | 285          | null       | 1         | 123        |
| 5    | answer | 285          | 124124     | 1         | 124        |
| 5    | show   | 369          | null       | 2         | 125        |
| 5    | skip   | 285          | null       | 1         | 126        |
+------+--------+--------------+------------+-----------+------------+
Output: 
+------------+
| question_id|
+------------+
| 285        |
+------------+
Explanation: 
Question 285 was shown 2 times and answered 1 time, so the answer rate is 1/2 = 0.5.
Question 369 was shown 1 time and answered 0 times, so the answer rate is 0/1 = 0.0.
Thus, question 285 has the highest answer rate.
```

## The Twist

This problem requires calculating the answer rate for each question and finding the one with the highest rate. The key is to count 'show' and 'answer' actions separately for each question, then calculate the ratio and find the maximum.

## Algorithm

1. Count the number of 'show' actions for each question.
2. Count the number of 'answer' actions for each question.
3. Join these counts and calculate the answer rate (answer_count / show_count).
4. Find the question with the highest answer rate.

## Complexity

- **Time**: O(n log n) — for sorting and calculating the answer rates.
- **Space**: O(n) — for storing the intermediate counts.

## Solution Code

```sql
SELECT 
    question_id
FROM 
    SurveyLog
GROUP BY 
    question_id
ORDER BY 
    SUM(CASE WHEN action = 'answer' THEN 1 ELSE 0 END) / 
    SUM(CASE WHEN action = 'show' THEN 1 ELSE 0 END) DESC
LIMIT 1;
```

## Alternative Solution (using subqueries)

```sql
SELECT 
    question_id
FROM (
    SELECT 
        question_id,
        SUM(CASE WHEN action = 'answer' THEN 1 ELSE 0 END) as answer_count,
        SUM(CASE WHEN action = 'show' THEN 1 ELSE 0 END) as show_count,
        SUM(CASE WHEN action = 'answer' THEN 1 ELSE 0 END) / 
        SUM(CASE WHEN action = 'show' THEN 1 ELSE 0 END) as answer_rate
    FROM 
        SurveyLog
    GROUP BY 
        question_id
) AS rates
ORDER BY 
    answer_rate DESC
LIMIT 1;
```

## Alternative Solution (using window functions)

```sql
WITH AnswerRates AS (
    SELECT 
        question_id,
        SUM(CASE WHEN action = 'answer' THEN 1 ELSE 0 END) as answer_count,
        SUM(CASE WHEN action = 'show' THEN 1 ELSE 0 END) as show_count,
        SUM(CASE WHEN action = 'answer' THEN 1 ELSE 0 END) / 
        SUM(CASE WHEN action = 'show' THEN 1 ELSE 0 END) as answer_rate,
        DENSE_RANK() OVER (ORDER BY SUM(CASE WHEN action = 'answer' THEN 1 ELSE 0 END) / 
                           SUM(CASE WHEN action = 'show' THEN 1 ELSE 0 END) DESC) as rank
    FROM 
        SurveyLog
    GROUP BY 
        question_id
)
SELECT 
    question_id
FROM 
    AnswerRates
WHERE 
    rank = 1;
```

## Link

[LeetCode 578 Get Highest Answer Rate Question](https://leetcode.com/problems/get-highest-answer-rate-question/)