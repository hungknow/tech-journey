# 0617 Merge Two Binary Trees

## Problem Description

You are given two binary trees `root1` and `root2`.

Merge them into a new binary tree. The merge rule is: if two nodes overlap, then sum node values up as the new value of the merged node. Otherwise, the NOT null node will be used as the node of the new tree.

Return the merged tree.

### Example 1:
```
Input: root1 = [1,3,2,5], root2 = [2,1,3,null,4,null,7]
Output: [3,4,5,5,4,null,7]
```

### Example 2:
```
Input: root1 = [1], root2 = [1,2]
Output: [2,2]
```

## The Twist

We need to **merge two trees node by node**. If both nodes exist, sum their values. If only one exists, use that node.

## Algorithm

### Recursive Merge:
1. If both trees are null, return null
2. If only one tree is null, return the other tree
3. Create a new node with value = root1.val + root2.val
4. Recursively merge left children
5. Recursively merge right children
6. Return the merged node

## Complexity

- **Time**: O(min(m, n)) - where m and n are sizes of the two trees
- **Space**: O(min(m, n)) - recursion stack depth

## Link

[LeetCode 0617 Merge Two Binary Trees](https://leetcode.com/problems/merge-two-binary-trees/)
