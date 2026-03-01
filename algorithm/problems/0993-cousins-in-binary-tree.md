# 0993 Cousins in Binary Tree

## Problem Description

Given the `root` of a binary tree with unique values and the values of two different nodes in the tree `x` and `y`, return `true` if the nodes corresponding to the values `x` and `y` in the tree are cousins, or `false` otherwise.

Two nodes of a binary tree are cousins if they have the same depth with different parents.

### Example 1:
```
Input: root = [1,2,3,4], x = 4, y = 3
Output: false
```

### Example 2:
```
Input: root = [1,2,3,null,4,null,5], x = 5, y = 4
Output: true
```

### Example 3:
```
Input: root = [1,2,3,null,4], x = 2, y = 3
Output: false
```

## The Twist

Cousins must have the **same depth but different parents**. We need to find the depths and parents of the two target nodes.

## Algorithm

### BFS with Parent Tracking:
1. Use BFS to traverse the tree
2. Track the depth and parent of each node
3. Find the depth and parent of node with value x
4. Find the depth and parent of node with value y
5. Return true if depths are equal but parents are different

### Two-Pass DFS:
1. First pass: find depth and parent of node x
2. Second pass: find depth and parent of node y
3. Compare the results

## Complexity

- **Time**: O(n) - each node visited at most twice
- **Space**: O(n) - storing depth and parent for each node

## Link

[LeetCode 0993 Cousins in Binary Tree](https://leetcode.com/problems/cousins-in-binary-tree/)
