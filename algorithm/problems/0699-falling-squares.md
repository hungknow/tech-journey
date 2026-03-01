# 0699 Falling Squares

## Problem Description

There are several squares being dropped onto the X-axis of a 2D plane.

You are given a 2D integer array `positions` where `positions[i] = [left_i, side_length_i]` represents the `ith` dropped square with its left edge aligned with `X = left_i` and side length `side_length_i`.

Return an array of the heights of each square in the order they are dropped.

### Example 1:
```
Input: positions = [[1,2],[2,3],[6,1]]
Output: [2,5,5]
```

### Example 2:
```
Input: positions = [[100,100],[200,100]]
Output: [100,100]
```

### Example 3:
```
Input: positions = [[1,5],[2,3],[5,3]]
Output: [5,5,5]
```

## The Twist

Each square **rests on previously dropped squares**. The height of a dropped square is the maximum height of any square it overlaps with, plus its own height.

## Algorithm

### Segment Tree:
1. Use a segment tree to track the maximum height at each X position
2. For each dropped square:
   - Query the segment tree for maximum height in the range [left, left + side_length]
   - Calculate new height: max_height + side_length
   - Update the segment tree with this new height for the entire range
3. Return all calculated heights

### Using Sorted Intervals:
1. Sort squares by their left position
2. Use a data structure to track intervals and their heights
3. For each square, find overlapping intervals and calculate maximum height
4. Update the interval structure with the new square

## Complexity

- **Time**: O(n² log n) with segment tree, O(n²) with sorted intervals
- **Space**: O(n) - storing heights and segment tree

## Link

[LeetCode 0699 Falling Squares](https://leetcode.com/problems/falling-squares/)
