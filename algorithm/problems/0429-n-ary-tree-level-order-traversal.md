# 0429 N-ary Tree Level Order Traversal

## Problem Description

Given an n-ary tree, return the level order traversal of its nodes' values.

N-ary tree input serialization is represented in their level order traversal, and each group of children is separated by the null value.

### Example 1:
```
Input: root = [1,null,3,2,4,null,5,6]
Output: [[1],[3,2,4],[5,6]]
```

### Example 2:
```
Input: root = [1,null,2,3,4,5,null,null,6,7,null,8,null,9,10,null,null,11,null,12,null,13,null,null,14]
Output: [[1],[2,3,4,5],[6,7,8,9,10],[11,12,13],[14]]
```

## The Twist

N-ary trees have **multiple children** per node instead of just left and right. We need to handle variable number of children while maintaining level order.

## Algorithm

### BFS Approach:
1. Use a queue, starting with root
2. While queue is not empty:
   - Get the current level size
   - Process all nodes at this level
   - Add each node's value to level result
   - Enqueue all children of nodes at this level
3. Add level result to final answer

## Complexity

- **Time**: O(n) - each node visited once
- **Space**: O(w) - maximum width of the tree (queue size)

## Link

[LeetCode 0429 N-ary Tree Level Order Traversal](https://leetcode.com/problems/n-ary-tree-level-order-traversal/)
