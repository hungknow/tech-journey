# 0701 Insert into a Binary Search Tree

## Problem Description

You are given the `root` node of a binary search tree (BST) and a `value` to insert into the tree. Return the root node of the BST after the insertion. It is guaranteed that the new value does not exist in the original BST.

Notice that there may exist multiple valid ways for the insertion, as long as the tree remains a BST. You can return any of them.

### Example 1:
```
Input: root = [4,2,7,1,3], val = 5
Output: [4,2,7,1,3,5]
```

### Example 2:
```
Input: root = [40,20,60,10,30,50,70], val = 25
Output: [40,20,60,10,30,50,70,null,null,25]
```

## The Twist

Standard BST insertion - we find the **appropriate leaf position** and insert the new node there. Multiple valid positions may exist.

## Algorithm

### Recursive Approach:
1. If root is null, return new node with val
2. If val < root.val:
   - root.left = insert(root.left, val)
3. Else:
   - root.right = insert(root.right, val)
4. Return root

### Iterative Approach:
1. If root is null, return new node
2. Find the appropriate parent node
3. Insert new node as left or right child based on comparison
4. Return root

## Complexity

- **Time**: O(h) - h is the height of the tree (O(log n) for balanced, O(n) for skewed)
- **Space**: O(h) recursive, O(1) iterative

## Link

[LeetCode 0701 Insert into a Binary Search Tree](https://leetcode.com/problems/insert-into-a-binary-search-tree/)
