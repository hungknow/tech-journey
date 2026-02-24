# 0314 Binary Tree Vertical Order Traversal

## Problem Description

Given the `root` of a binary tree, return the vertical order traversal of its nodes' values (i.e., from top to bottom, column by column).

If two nodes are in the same row and column, the order should be from left to right.

### Example 1:
```
Input: root = [3,9,20,null,null,15,7]
Output: [[9],[3,15],[20],[7]]
```

### Example 2:
```
Input: root = [3,9,8,4,0,1,7]
Output: [[4],[9],[3,0,1],[8],[7]]
```

## The Twist

Map stores `column_index -> [list_of_nodes]`. As you BFS down the tree, left children get `col-1` and right children get `col+1`.

## Hash Table Usage

- **Key**: `column_index` (the horizontal position in the tree)
- **Value**: `[list_of_nodes]` (all nodes at this column)

Algorithm:
1. Use BFS to traverse the tree level by level
2. Assign column index 0 to the root
3. For each node:
   - Add the node's value to its column list
   - Left child gets column - 1
   - Right child gets column + 1
4. Sort the columns and return the values in order

## Complexity

- **Time**: O(n log n) - BFS traversal + sorting columns
- **Space**: O(n) - storing all nodes in the map

## Link

[LeetCode 0314 Binary Tree Vertical Order Traversal](https://leetcode.com/problems/binary-tree-vertical-order-traversal/)
