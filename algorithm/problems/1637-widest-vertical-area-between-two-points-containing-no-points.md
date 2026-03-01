# 1637 Widest Vertical Area Between Two Points Containing No Points

## Problem Description

Given `n` points in the plane where `x[i]` is the x-coordinate of the ith point, find the maximum width of a vertical area between two points such that no points are inside the area.

A vertical area is defined by two lines with the same x-coordinate. The width of the area is the difference between the x-coordinates of the two lines.

### Example 1:
```
Input: x = [8,7,9]
Output: 1
Explanation: The vertical area is between x = 7 and x = 8.
```

### Example 2:
```
Input: x = [1,3,1,3,1,3,9]
Output: 0
Explanation: The vertical area is between x = 3 and x = 3.
```

## Solution Approach

To find the widest vertical area with no points, we need to find the maximum gap between consecutive x-coordinates after sorting.

## Algorithm

1. Sort the array of x-coordinates.
2. Initialize `maxWidth` = 0.
3. Iterate through the sorted array:
   - For each consecutive pair of points, calculate the difference.
   - Update `maxWidth` with the maximum of itself and the current difference.
4. Return `maxWidth`.

## Why This Works

After sorting, the vertical area between two consecutive x-coordinates contains no other points. The widest such area is simply the maximum gap between consecutive points.

## Complexity

- **Time**: O(n log n) - dominated by sorting
- **Space**: O(1) - we can sort in-place (or O(n) if using extra space for sorting)

## Link

[LeetCode 1637 Widest Vertical Area Between Two Points Containing No Points](https://leetcode.com/problems/widest-vertical-area-between-two-points-containing-no-points/)