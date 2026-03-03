# 0175 Combine Two Tables

## Problem Description

Table: Person
```
+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| personId    | int     |
| lastName    | varchar |
| firstName   | varchar |
+-------------+---------+
personId is the primary key column for this table.
```

Table: Address
```
+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| addressId   | int     |
| personId    | int     |
| city        | varchar |
| state       | varchar |
+-------------+---------+
addressId is the primary key column for this table.
Each row of this table contains information about one person with a unique addressId.
```

Write a SQL query to report the first name, last name, city, and state of each person in the Person table. If the address of a personId is not present in the Address table, report null instead.

### Example 1:
```
Input: 
Person table:
+----------+----------+-----------+
| personId | lastName | firstName |
+----------+----------+-----------+
| 1        | Wang     | Allen     |
| 2        | Alice    | Bob       |
+----------+----------+-----------+
Address table:
+-----------+----------+---------------+------------+
| addressId | personId | city          | state      |
+-----------+----------+---------------+------------+
| 1         | 2        | New York City | New York   |
| 2         | 3        | Leetcode      | California |
+-----------+----------+---------------+------------+
Output: 
+-----------+----------+---------------+----------+
| firstName | lastName | city          | state    |
+-----------+----------+---------------+----------+
| Allen     | Wang     | null          | null     |
| Bob       | Alice    | New York City | New York |
+-----------+----------+---------------+----------+
Explanation: 
AddressId 1 contains information for the person with personId 2, which is Bob.
```

## The Twist

Use a LEFT JOIN to combine the Person and Address tables, ensuring all persons are included even if they don't have an address. The key is understanding when to use LEFT JOIN versus INNER JOIN.

## Algorithm

1. Use a LEFT JOIN to connect Person table with Address table on personId.
2. Select firstName, lastName from Person table and city, state from Address table.
3. Return the result with null values for persons without addresses.

## Complexity

- **Time**: O(m + n) — where m is the number of rows in Person table and n is the number of rows in Address table.
- **Space**: O(m + n) — for the result set.

## Solution Code

```sql
SELECT 
    firstName, 
    lastName, 
    city, 
    state 
FROM 
    Person 
LEFT JOIN 
    Address ON Person.personId = Address.personId;
```

## Link

[LeetCode 175 Combine Two Tables](https://leetcode.com/problems/combine-two-tables/)