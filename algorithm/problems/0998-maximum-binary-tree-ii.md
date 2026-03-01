# 0998 Maximum Binary Tree II

## Problem Description

A maximum binary tree is a tree where every node has no more than two children.

Given the `root` of a maximum binary tree, insert a value into the tree in a way that makes the tree remain a maximum binary tree.

You can insert the value at any position in the tree.

Return the `root` of the modified tree. It is guaranteed that the new value does not exist in the original tree.

### Example 1:
```
Input: root = [5,2,4,null,1], val = 3
Output: [5,2,4,null,1,null,3]
```

### Example 2:
```
Input: root = [5,2,4,null,1], val = 4
Output: [5,2,4,null,1,3]
```

### Example 3:
```
Input: root = [2,1,3], val = 4
Output: [2,1,4,3]
```

## The Twist

We need to insert a new value into a **maximum binary tree** while maintaining the maximum property. The new node should be placed such that the tree remains a max-heap.

## Algorithm

### Recursive Insert:
1. If root is null, return new node with val
2. If val > root.val:
   - Insert into right subtree
3. Else:
   - Insert into left subtree
4. Return root

### Iterative Approach:
1. Traverse down the tree to find the insertion point
2. Create new node and insert it at the appropriate position
3. Return the modified root

## Complexity

- **Time**: O(h) - h is the height of the tree
- **Space**: O(1) - no additional space needed

## Link

[LeetCode 0998 Maximum Binary Tree II](https://leetcode.com/problems/maximum-binary-tree-ii/)
