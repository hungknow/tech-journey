# 0850 Rectangle Area II

## Problem Description

You are given a 2D integer array `axis` where `axis[i] = [xi, yi]` represents the coordinates of the `ith` rectangle on a 2D plane.

A rectangle on the X-Y plane is axis-aligned if its edges are parallel to the X and Y axes. This means it can be represented as four integers `[x1, y1, x2, y2]` where `(x1, y1)` is the coordinate of its bottom-left corner, and `(x2, y2)` is the coordinate of its top-right corner.

Return the total area covered by all axis-aligned rectangles.

### Example 1:
```
Input: axis = [[1,1,3,3],[3,1,4,2],[3,2,4,4],[1,3,2,4],[2,2,4,4]]
Output: 17
```

### Example 2:
```
Input: axis = [[0,0,2,2],[1,1,3,3],[2,0,3,1]]
Output: 6
```

### Example 3:
```
Input: axis = [[0,0,1,1],[1,0,2,1],[1,1,2,2],[2,0,3,1],[2,1,3,2]]
Output: 8
```

## The Twist

We need to calculate the **union area of overlapping rectangles**. A naive approach would be O(n²) to count overlaps. We need a more efficient method.

## Algorithm

### Line Sweep Algorithm:
1. Collect all unique X coordinates
2. Sort X coordinates
3. For each interval between consecutive X coordinates:
   - Use a segment tree or interval union to calculate covered Y range
   - Multiply by interval width
4. Sum up all contributions

### Using Segment Tree:
1. Use a 2D segment tree to track covered areas
2. For each rectangle, update the segment tree
3. Query the total covered area

### Using Coordinate Compression + Segment Tree:
1. Compress X and Y coordinates to reduce problem size
2. Use a segment tree over compressed coordinates
3. Update and query for each rectangle

## Complexity

- **Time**: O(n² log n) with segment tree
- **Space**: O(n²) - storing segment tree

## Link

[LeetCode 0850 Rectangle Area II](https://leetcode.com/problems/rectangle-area-ii/)
