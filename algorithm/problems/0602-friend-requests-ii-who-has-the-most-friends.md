# 0602 Friend Requests II: Who Has the Most Friends

## Problem Description

Table: FriendRequest
```
+----------------+---------+
| Column Name    | Type    |
+----------------+---------+
| sender_id      | int     |
| send_to_id     | int     |
| request_date   | date    |
+----------------+---------+
This table may contain duplicates (This means it is possible to receive multiple friend requests from the same person).
This table contains the sender ID, the receiver ID, and the date of the request.
```

Table: RequestAccepted
```
+----------------+---------+
| Column Name    | Type    |
+----------------+---------+
| requester_id   | int     |
| accepter_id    | int     |
| accept_date    | date    |
+----------------+---------+
This table may contain duplicates (This means it is possible to accept multiple friend requests from the same person).
This table contains the requester ID, the accepter ID, and the date of acceptance.
```

Write a SQL query to find the people who have the most friends and the most friends count.

The test cases are generated so that there is only one person who has the most friends.

The result should contain only one row with the person who has the most friends and their friend count.

### Example 1:
```
Input: 
FriendRequest table:
+-----------+------------+--------------+
| sender_id | send_to_id | request_date |
+-----------+------------+--------------+
| 1         | 2          | 2016_06-01   |
| 1         | 3          | 2016_06-01   |
| 1         | 4          | 2016_06-01   |
| 2         | 3          | 2016_06-02   |
| 3         | 4          | 2016_06-09   |
+-----------+------------+--------------+
RequestAccepted table:
+--------------+-------------+-------------+
| requester_id | accepter_id | accept_date |
+--------------+-------------+-------------+
| 1            | 2           | 2016_06-03  |
| 1            | 3           | 2016_06-08  |
| 2            | 3           | 2016_06-08  |
| 3            | 4           | 2016_06-09  |
| 3            | 4           | 2016_06-10  |
+--------------+-------------+-------------+
Output: 
+------+------+
| id   | num  |
+------+------+
| 3    | 3    |
+------+------+
Explanation: 
Person with id = 3 has 3 friends (2, 1, 4).
```

## The Twist

This problem requires finding the person with the most friends, considering both friend requests sent and accepted. The key is to count unique friends for each person by combining data from both tables.

## Algorithm

1. Create a combined list of all friendships from both FriendRequest and RequestAccepted tables.
2. For each person, count their unique friends (both as sender/requester and receiver/accepter).
3. Find the person with the maximum friend count.
4. Return the person's ID and friend count.

## Complexity

- **Time**: O(n log n) — for sorting and counting unique friends.
- **Space**: O(n) — for storing the friendship relationships.

## Solution Code

```sql
WITH AllFriendships AS (
    SELECT 
        sender_id AS user_id,
        send_to_id AS friend_id
    FROM 
        FriendRequest
    UNION
    SELECT 
        send_to_id AS user_id,
        sender_id AS friend_id
    FROM 
        FriendRequest
    UNION
    SELECT 
        requester_id AS user_id,
        accepter_id AS friend_id
    FROM 
        RequestAccepted
    UNION
    SELECT 
        accepter_id AS user_id,
        requester_id AS friend_id
    FROM 
        RequestAccepted
),
FriendCounts AS (
    SELECT 
        user_id,
        COUNT(DISTINCT friend_id) AS friend_count
    FROM 
        AllFriendships
    GROUP BY 
        user_id
)
SELECT 
    user_id AS id,
    friend_count AS num
FROM 
    FriendCounts
ORDER BY 
    friend_count DESC
LIMIT 1;
```

## Alternative Solution (using subqueries)

```sql
SELECT 
    user_id AS id,
    friend_count AS num
FROM (
    SELECT 
        user_id,
        COUNT(DISTINCT friend_id) AS friend_count
    FROM (
        SELECT sender_id AS user_id, send_to_id AS friend_id FROM FriendRequest
        UNION ALL
        SELECT send_to_id AS user_id, sender_id AS friend_id FROM FriendRequest
        UNION ALL
        SELECT requester_id AS user_id, accepter_id AS friend_id FROM RequestAccepted
        UNION ALL
        SELECT accepter_id AS user_id, requester_id AS friend_id FROM RequestAccepted
    ) AS all_friends
    GROUP BY user_id
) AS friend_counts
ORDER BY friend_count DESC
LIMIT 1;
```

## Link

[LeetCode 602 Friend Requests II: Who Has the Most Friends](https://leetcode.com/problems/friend-requests-ii-who-has-the-most-friends/)