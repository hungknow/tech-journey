# 1123 Lowest Common Ancestor of Deepest Leaves

## Problem Description

Given the `root` of a binary tree, return the lowest common ancestor (LCA) of the deepest leaves of the binary tree.

Consider the given binary tree where:
- A node is a descendant of itself.
- The depth of a node is the number of edges from the node to the tree's root node.
- The deepest leaves of the binary tree are the leaves that have the maximum depth.

### Example 1:
```
Input: root = [3,5,1,6,2,0,8,null,null,7,4]
Output: 2
Explanation: The deepest leaves are nodes with values 7 and 4, and their LCA is node with value 2.
```

### Example 2:
```
Input: root = [1]
Output: 1
```

### Example 3:
```
Input: root = [0,1,3,null,2]
Output: 3
```

## The Twist

We need to find the **LCA of all deepest leaves**. First, we need to identify which leaves are deepest, then find their LCA.

## Algorithm

### Two-Pass Approach:
1. First pass: Find the depth of all nodes and identify the maximum depth
2. Collect all nodes at maximum depth (deepest leaves)
3. Second pass: Find LCA of all collected deepest leaves
4. Return the LCA

### Single Pass with Tracking:
1. Use DFS to track depth and deepest leaves
2. For each node:
   - Track the first deepest leaf found at each depth
   - Keep track of LCA for each depth
3. Return the LCA of the deepest depth

## Complexity

- **Time**: O(n) - single or two passes
- **Space**: O(h) - recursion stack depth

## Link

[LeetCode 1123 Lowest Common Ancestor of Deepest Leaves](https://leetcode.com/problems/lowest-common-ancestor-of-deepest-leaves/)
