# 1469 Find All The Lonely Nodes

## Problem Description

Given the `root` of a binary tree, return a list of all the lonely nodes in the tree. A lonely node is a node that is the only child of its parent.

### Example 1:
```
Input: root = [7,2,3,4,null,5,6,null,7]
Output: [6,7]
```

### Example 2:
```
Input: root = [11,null,99,88,77,null,null,66,null,55]
Output: [77,88,99]
```

### Example 3:
```
Input: root = [1,1,1,1,1]
Output: []
```

## The Twist

A lonely node has **only one child** (or no children). We need to find all nodes that have 0 or 1 child.

## Algorithm

### DFS with Child Counting:
1. For each node, count its children
2. If child count is 0 or 1, add node to result list
3. Return the result list

### BFS Level Order Traversal:
1. Use BFS to traverse the tree level by level
2. For each node, check if it has 0 or 1 child
3. If yes, add node to result list
4. Return the result list

### Iterative Approach:
1. Use a stack for DFS or use simple iteration
2. For each node, check its left and right children
3. If both are null or only one exists, add to result
4. Return the result list

## Complexity

- **Time**: O(n) - each node visited once
- **Space**: O(n) - storing result list

## Link

[LeetCode 1469 Find All The Lonely Nodes](https://leetcode.com/problems/find-all-the-lonely-nodes/)
