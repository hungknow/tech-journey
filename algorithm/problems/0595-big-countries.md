# 0595 Big Countries

## Problem Description

Table: World
```
+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| name        | varchar |
| continent   | varchar |
| area        | int     |
| population  | int     |
| gdp         | bigint  |
+-------------+---------+
name is the primary key column for this table.
Each row of this table contains information about a country.
```

Write a SQL query to find the name, population, and area of the big countries.

A country is big if it has an area of at least three million (i.e., 3000000 km2) or a population of at least twenty-five million (i.e., 25000000).

Return the result table in any order.

### Example 1:
```
Input: 
World table:
+-------------+-----------+---------+------------+--------------+
| name        | continent | area    | population | gdp          |
+-------------+-----------+---------+------------+--------------+
| Afghanistan | Asia      | 652230  | 25500100   | 20343000000  |
| Albania     | Europe    | 28748   | 2831741    | 12960000000  |
| Algeria     | Africa    | 2381741 | 37100000   | 188681000000 |
| Andorra     | Europe    | 468     | 78115      | 3712000000   |
| Angola      | Africa    | 1246700 | 20609294   | 100990000000 |
+-------------+-----------+---------+------------+--------------+
Output: 
+-------------+------------+---------+
| name        | population | area    |
+-------------+------------+---------+
| Afghanistan | 25500100   | 652230  |
| Algeria     | 37100000   | 2381741 |
+-------------+------------+---------+
```

## The Twist

This problem requires filtering countries based on either area or population criteria. The key is to use the OR operator to check both conditions.

## Algorithm

1. Select the name, population, and area from the World table.
2. Filter for countries where area >= 3000000 OR population >= 25000000.

## Complexity

- **Time**: O(n) — for scanning the World table.
- **Space**: O(n) — for the result set.

## Solution Code

```sql
SELECT 
    name,
    population,
    area
FROM 
    World
WHERE 
    area >= 3000000 OR population >= 25000000;
```

## Alternative Solution (using UNION)

```sql
SELECT 
    name,
    population,
    area
FROM 
    World
WHERE 
    area >= 3000000
UNION
SELECT 
    name,
    population,
    area
FROM 
    World
WHERE 
    population >= 25000000;
```

## Alternative Solution (using CASE)

```sql
SELECT 
    name,
    population,
    area
FROM 
    World
WHERE 
    CASE 
        WHEN area >= 3000000 THEN 1
        WHEN population >= 25000000 THEN 1
        ELSE 0
    END = 1;
```

## Link

[LeetCode 595 Big Countries](https://leetcode.com/problems/big-countries/)