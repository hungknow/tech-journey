# 0356 Line Reflection

## Problem Description

Given `n` points on a 2D plane, find if there is such a line parallel to the y-axis that reflects the given points.

### Example 1:
```
Input: points = [[1,1],[-1,1]]
Output: true
Explanation: There is a line at x = 0 that reflects both points.
```

### Example 2:
```
Input: points = [[1,1],[-1,-1]]
Output: false
```

## The Twist

Finding a **Y-axis line of symmetry**. We need to check if all points have their mirrored counterpart across some vertical line.

## Hash Table Usage

- **Key**: `point` (x, y coordinates as a tuple or string)
- **Value**: `true` (or just use a set)

Algorithm:
1. Store all points in a hash set
2. Find the minimum and maximum x values
3. Calculate the theoretical center line: `center = (min_x + max_x) / 2`
4. For each point (x, y):
   - Calculate the mirrored x: `mirrored_x = 2 * center - x`
   - Check if (mirrored_x, y) exists in the set
   - If any point doesn't have its mirror, return false
5. If all points have mirrors, return true

## Complexity

- **Time**: O(n) - single pass to find min/max, single pass to check mirrors
- **Space**: O(n) - storing all points in the set

## Link

[LeetCode 0356 Line Reflection](https://leetcode.com/problems/line-reflection/)
