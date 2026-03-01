# 0623 Add One Row to Tree

## Problem Description

Given the `root` of a binary tree and two integers `val` and `depth`, add a row of nodes with value `val` at the given depth `depth`.

Note that the `root` node is at depth `1`.

### Example 1:
```
Input: root = [4,2,6,3,1,5], val = 1, depth = 2
Output: [4,2,6,3,1,5,null,null,null,1,1,1]
```

### Example 2:
```
Input: root = [4,2,null,3,1], val = 1, depth = 3
Output: [4,2,null,3,1,1]
```

## The Twist

We need to **insert a new level** of nodes at the specified depth. Existing nodes at that depth should be replaced with the new nodes.

## Algorithm

### DFS with Depth Tracking:
1. Use DFS to traverse the tree
2. Track the current depth
3. When reaching the target depth:
   - Create new nodes for the row
   - Replace existing children with new nodes
4. Continue traversal to ensure all nodes at that depth are replaced

### BFS Approach:
1. Use BFS to reach the target depth
2. Replace all nodes at that depth with new nodes
3. Return the modified tree

## Complexity

- **Time**: O(n) - each node visited once
- **Space**: O(n) - storing the new nodes

## Link

[LeetCode 0623 Add One Row to Tree](https://leetcode.com/problems/add-one-row-to-tree/)
