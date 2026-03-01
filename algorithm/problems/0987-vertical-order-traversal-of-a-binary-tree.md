# 0987 Vertical Order Traversal of a Binary Tree

## Problem Description

Given the `root` of a binary tree, calculate the vertical order traversal of the binary tree.

For each node at position `(row, col)`, its left and right children will be at positions `(row + 1, col - 1)` and `(row + 1, col + 1)` respectively. The root of the tree is at `(0, 0)`.

Return the vertical order traversal of the binary tree as a list of lists. For each column, nodes should be sorted by their row (top to bottom). If two nodes are in the same row and column, sort by their values.

### Example 1:
```
Input: root = [3,9,20,null,null,15,7]
Output: [[9],[3,15],[20],[7]]
```

### Example 2:
```
Input: root = [1,2,3,4,5,6,7]
Output: [[4],[2],[1,5,6],[3],[7]]
```

## The Twist

Nodes at the same column need to be **sorted by row first, then by value**. This requires careful ordering during traversal.

## Algorithm

### DFS with Coordinate Tracking:
1. Use DFS to traverse the tree, tracking (row, col, value) for each node
2. Store nodes in a map: `col -> list of (row, value)`
3. Sort each column's list by row, then by value
4. Return sorted columns in order from leftmost to rightmost

### BFS Approach:
1. Use BFS to process nodes level by level
2. Track column index for each node
3. Group nodes by column
4. Sort within each column by row and value

## Complexity

- **Time**: O(n log n) - sorting nodes within columns
- **Space**: O(n) - storing all nodes

## Link

[LeetCode 0987 Vertical Order Traversal of a Binary Tree](https://leetcode.com/problems/vertical-order-traversal-of-a-binary-tree/)
