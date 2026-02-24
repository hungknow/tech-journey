# 0554 Brick Wall

## Problem Description

There is a rectangular brick wall in front of you. The wall is rectangular and has several rows of bricks. The bricks have the same height but different widths.

You want to draw a vertical line from the top to the bottom and cross the least number of bricks.

If the line goes through the edge between two bricks, it does not count as crossing a brick. You cannot draw a line just along one of the two vertical edges of the wall.

Given the 2D array `wall`, return the minimum number of crossed bricks after drawing such a vertical line.

### Example 1:
```
Input: wall = [[1,2,2,1],[3,1,2],[1,3,2],[2,4],[3,1,2],[1,3,1,1]]
Output: 2
```

### Example 2:
```
Input: wall = [[1],[1],[1]]
Output: 3
```

## The Twist

Finding the **path of least resistance** through a wall. We need to find where the most edges align vertically to minimize brick crossings.

## Hash Table Usage

- **Key**: `gap_distance_from_left_edge` (cumulative width where a gap occurs)
- **Value**: `count_of_gaps` (how many rows have a gap at this position)

Algorithm:
1. For each row in the wall:
   - Calculate cumulative width as we traverse bricks
   - For each gap position (not including the final edge), increment its count
2. Find the position with the maximum gap count
3. The minimum bricks crossed = total rows - max_gap_count

## Complexity

- **Time**: O(n) where n is total number of bricks
- **Space**: O(m) where m is the wall width (number of possible gap positions)

## Link

[LeetCode 0554 Brick Wall](https://leetcode.com/problems/brick-wall/)
