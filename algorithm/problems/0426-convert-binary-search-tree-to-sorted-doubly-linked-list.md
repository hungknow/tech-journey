# 0426 Convert Binary Search Tree to Sorted Doubly Linked List

## Problem Description

Convert a Binary Search Tree (BST) to a sorted Doubly Linked List (DLL) in-place.

The left and right pointers in nodes are to be used as previous and next pointers respectively in your DLL. The DLL should be in the same order as an inorder traversal of the BST.

Return the head of your DLL.

### Example 1:
```
Input: root = [4,2,5,1,3]
Output: [1,2,3,4,5]
Explanation: The DLL is: 1 <-> 2 <-> 3 <-> 4 <-> 5
```

### Example 2:
```
Input: root = [2,1,3]
Output: [1,2,3]
```

### Example 3:
```
Input: root = []
Output: []
```

## The Twist

We need to convert **in-place**, meaning we reuse the existing node pointers without creating new nodes. The DLL should be circular or not depending on the specific variant.

## Algorithm

### Inorder Traversal with Pointers:
1. Perform inorder traversal
2. Keep track of `prev` node (last visited)
3. For each node:
   - Set node.left = prev
   - If prev exists, set prev.right = node
   - Update prev = node
4. After traversal, connect head and tail if circular

### Morris Traversal (O(1) space):
1. Use Morris inorder traversal to visit nodes
2. Maintain prev pointer
3. Link nodes as we visit them
4. Return the leftmost node as head

## Complexity

- **Time**: O(n) - single traversal
- **Space**: O(h) recursive, O(1) with Morris Traversal

## Link

[LeetCode 0426 Convert Binary Search Tree to Sorted Doubly Linked List](https://leetcode.com/problems/convert-binary-search-tree-to-sorted-doubly-linked-list/)
