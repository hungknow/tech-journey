# 0149 Max Points on a Line

## Problem Description

Given an array of points where `points[i] = [xi, yi]` represents a point on the X-Y plane, return the maximum number of points that lie on the same straight line.

### Example 1:
```
Input: points = [[1,1],[2,2],[3,3]]
Output: 3
```

### Example 2:
```
Input: points = [[1,1],[3,2],[5,3],[4,1],[2,3],[1,4]]
Output: 4
```

## The Twist

Finding **collinear points**. For each point, we need to find how many other points lie on the same line passing through it.

## Hash Table Usage

- **Key**: `slope` (strictly reduced fraction of dy/dx)
- **Value**: `count_of_points` (number of points with this slope from the current point)

Algorithm:
1. For each point i:
   - Calculate the slope to every other point j
   - Use the reduced fraction (dy/gcd, dx/gcd) as the key
   - Count how many points share each slope
   - Track the maximum count for this point
2. Return the overall maximum + 1 (including the point itself)

Special cases:
- Vertical lines: dx = 0, use a special key like "inf"
- Duplicate points: count separately

## Complexity

- **Time**: O(n²) - for each point, calculate slope to all other points
- **Space**: O(n) - storing slopes for each point

## Link

[LeetCode 0149 Max Points on a Line](https://leetcode.com/problems/max-points-on-a-line/)
