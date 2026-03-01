# 0308 Range Sum Query 2D - Mutable

## Problem Description

Given a 2D matrix `matrix`, handle multiple queries of the following types:
1. **Update** the value of a cell in `matrix`.
2. **Calculate the sum** of the elements of `matrix` inside the rectangle defined by its upper left corner `(row1, col1)` and lower right corner `(row2, col2)`.

Implement the `NumMatrix` class:
- `NumMatrix(int[][] matrix)` Initializes the object with the integer matrix `matrix`.
- `void update(int row, int col, int val)` Updates `matrix[row][col] = matrix[row][col] + val`.
- `int sumRegion(int row1, int col1, int row2, int col2)` Returns the sum of all elements `matrix[i][j]` such that `row1 <= i <= row2` and `col1 <= j <= col2`.

### Example 1:
```
Input
["NumMatrix", "sumRegion", "update", "sumRegion", "sumRegion", "update", "sumRegion"]
[[[[3, 0, 1, 4, 2], [5, 6, 3, 2, 1], [1, 2, 0, 1, 5], [4, 1, 0, 1, 7], [1, 0, 3, 2, 1]]], [2, 1, 4, 3], [3, 2, 2], [2, 1, 4, 3], [0, 2, 2], [2, 1, 4, 3]]
Output
[null, 8, null, 10, null, 14]
```

### Example 2:
```
Input
["NumMatrix", "sumRegion", "update", "sumRegion", "sumRegion", "update", "sumRegion"]
[[[[1, 2, 3], [4, 5, 6], [7, 8, 9]]], [0, 0, 2, 2], [1, 1, 10], [0, 0, 2, 2], [0, 0, 2, 2], [1, 1, -10], [0, 0, 2, 2]]
Output
[null, 12, null, 12, null, 2]
```

## The Twist

This is the **2D version** of the range sum query problem. We need a data structure that supports efficient 2D updates and range sum queries.

## Algorithm

### 2D Binary Indexed Tree (Fenwick Tree):
1. Build 2D BIT from initial matrix
2. **update**: Update 2D BIT at (row, col), propagate in both dimensions
3. **sumRegion**: Use inclusion-exclusion principle with 2D prefix sums

### 2D Segment Tree:
1. Build 2D segment tree from initial matrix
2. **update**: Update leaf and propagate in both dimensions
3. **sumRegion**: Query 2D segment tree for range sum

### Quad Tree:
1. Divide matrix into quadrants recursively
2. Each node stores sum of its region
3. **update**: Update relevant nodes and propagate
4. **sumRegion**: Combine sums of relevant regions

## Complexity

- **Constructor**: O(m * n)
- **update()**: O(log m * log n) for BIT/Segment Tree
- **sumRegion()**: O(log m * log n) for BIT/Segment Tree
- **Space**: O(m * n)

## Link

[LeetCode 0308 Range Sum Query 2D - Mutable](https://leetcode.com/problems/range-sum-query-2d-mutable/)
