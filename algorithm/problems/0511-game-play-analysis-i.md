# 0511 Game Play Analysis I

## Problem Description

Table: Activity
```
+--------------+---------+
| Column Name  | Type    |
+--------------+---------+
| player_id    | int     |
| device_id    | int     |
| event_date   | date    |
| games_played | int     |
+--------------+---------+
(player_id, event_date) is the primary key of this table.
This table shows the activity of players of different games.
Each row is a record of a player who logged in and played a number of games (possibly 0) before logging out on some day using some device.
```

Write a SQL query that reports for each player and date, how many games played so far by the player. That is, the total number of games played by the player until that date.

Return the result table in any order.

### Example 1:
```
Input: 
Activity table:
+-----------+-----------+------------+--------------+
| player_id | device_id | event_date | games_played |
+-----------+-----------+------------+--------------+
| 1         | 2         | 2016-03-01 | 5            |
| 1         | 2         | 2016-05-02 | 6            |
| 2         | 3         | 2017-06-25 | 1            |
| 3         | 1         | 2016-03-02 | 0            |
| 3         | 4         | 2018-07-03 | 5            |
+-----------+-----------+------------+--------------+
Output: 
+-----------+------------+---------------------+
| player_id | event_date | games_played_so_far |
+-----------+------------+---------------------+
| 1         | 2016-03-01 | 5                   |
| 1         | 2016-05-02 | 11                  |
| 2         | 2017-06-25 | 1                   |
| 3         | 2016-03-02 | 0                   |
| 3         | 2018-07-03 | 5                   |
+-----------+------------+---------------------+
Explanation: 
For the player with id 1, 5 + 6 = 11 games played by 2016-05-02.
For the player with id 2, 1 game played by 2017-06-25.
For the player with id 3, 0 + 5 = 5 games played by 2018-07-03.
```

## The Twist

This problem requires calculating a cumulative sum of games played for each player over time. The key is to use a window function with SUM() and PARTITION BY to create a running total for each player.

## Algorithm

1. Use the SUM() window function with OVER() clause.
2. Partition by player_id to calculate separate running totals for each player.
3. Order by event_date to ensure the cumulative sum is calculated in chronological order.
4. Select player_id, event_date, and the cumulative sum as games_played_so_far.

## Complexity

- **Time**: O(n) — for the window function operation.
- **Space**: O(n) — for storing the cumulative results.

## Solution Code

```sql
SELECT 
    player_id,
    event_date,
    SUM(games_played) OVER (PARTITION BY player_id ORDER BY event_date) AS games_played_so_far
FROM 
    Activity;
```

## Alternative Solution (using self-join)

```sql
SELECT 
    a1.player_id,
    a1.event_date,
    SUM(a2.games_played) AS games_played_so_far
FROM 
    Activity a1
JOIN 
    Activity a2 ON a1.player_id = a2.player_id AND a2.event_date <= a1.event_date
GROUP BY 
    a1.player_id, a1.event_date;
```

## Link

[LeetCode 511 Game Play Analysis I](https://leetcode.com/problems/game-play-analysis-i/)