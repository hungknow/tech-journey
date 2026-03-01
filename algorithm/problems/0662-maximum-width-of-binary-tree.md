# 0662 Maximum Width of Binary Tree

## Problem Description

Given the `root` of a binary tree, return the maximum width of the binary tree.

The maximum width of a binary tree is the maximum width among all levels.

The width of one level is defined as the length between the end-nodes (the leftmost and rightmost non-null nodes in the level, where the null nodes between the end-nodes that would be present in a complete binary tree extending to that level are also counted into the length calculation).

### Example 1:
```
Input: root = [1,3,2,5,3,null,9]
Output: 4
Explanation: The maximum width exists in the third level with length 4 (5,3,null,9).
```

### Example 2:
```
Input: root = [1,3,2,5]
Output: 2
```

### Example 3:
```
Input: root = [1,3,2,5,null,null,9,6,null,null,7]
Output: 8
```

## The Twist

The width includes **null nodes between the leftmost and rightmost** nodes. This means we need to track the positions of all nodes, including nulls.

## Algorithm

### BFS with Index Tracking:
1. Use BFS with each node storing its index
2. For each level:
   - Track the minimum and maximum index of non-null nodes
   - Calculate width: max_index - min_index + 1
3. Return the maximum width across all levels

### Using Position Calculation:
1. Assign position 0 to root
2. For each node, left child gets position 2*parent_pos, right child gets 2*parent_pos + 1
3. Track min and max positions at each level

## Complexity

- **Time**: O(n) - each node visited once
- **Space**: O(w) - queue width for BFS

## Link

[LeetCode 0662 Maximum Width of Binary Tree](https://leetcode.com/problems/maximum-width-of-binary-tree/)
