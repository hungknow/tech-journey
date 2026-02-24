# 0447 Number of Boomerangs

## Problem Description

You are given `n` points in the plane that are all distinct, where `points[i] = [xi, yi]`.

A boomerang is a tuple of points `(i, j, k)` such that the distance between `i` and `j` equals the distance between `i` and `k`.

Return the number of boomerangs.

### Example 1:
```
Input: points = [[0,0],[1,0],[2,0]]
Output: 2
Explanation: The two boomerangs are [[1,0],[0,0],[2,0]] and [[1,0],[2,0],[0,0]].
```

### Example 2:
```
Input: points = [[1,1],[2,2],[3,3]]
Output: 2
```

### Example 3:
```
Input: points = [[1,1]]
Output: 0
```

## The Twist

Finding **equidistant points**. For each point, we need to find how many other points are at the same distance from it.

## Hash Table Usage

- **Key**: `squared_distance` (distance² to avoid floating point issues)
- **Value**: `count_of_points` (number of points at this distance from the current point)

Algorithm:
1. For each point i:
   - Calculate the squared distance to every other point j
   - Count how many points share each distance
   - For each distance with count k, add k * (k-1) to the result (permutations of 2)
2. Return the total count

Note: Use squared distance to avoid floating point precision issues.

## Complexity

- **Time**: O(n²) - for each point, calculate distance to all other points
- **Space**: O(n) - storing distances for each point

## Link

[LeetCode 0447 Number of Boomerangs](https://leetcode.com/problems/number-of-boomerangs/)
