# 1008 Construct Binary Search Tree from Preorder Traversal

## Problem Description

Given an array of integers `preorder`, which represents the preorder traversal of a binary search tree (BST), construct the tree and return its root.

It is guaranteed that there is always possible to find a binary search tree with the given requirements for the given test cases.

### Example 1:
```
Input: preorder = [8,5,1,7,10,12]
Output: [8,5,10,1,7,null,12]
```

### Example 2:
```
Input: preorder = [1,3]
Output: [1,null,3]
```

## The Twist

For a BST, preorder traversal gives us **sorted order information**. The first element is the root, and subsequent elements are either in the left subtree (smaller) or right subtree (larger).

## Algorithm

### Recursive Approach:
1. First element is the root
2. Find the first element greater than root - this starts the right subtree
3. Recursively construct left subtree from elements before that point
4. Recursively construct right subtree from elements after that point

### Using Upper Bound (O(n)):
1. Use a global index and recursive function with upper bound
2. For each recursive call:
   - If index >= length or preorder[index] > upper bound, return null
   - Create node with preorder[index], increment index
   - Set left child with upper bound = node.val
   - Set right child with upper bound = upper bound
3. Return root

### Using Stack (O(n)):
1. Use a stack to maintain nodes in decreasing order
2. For each value in preorder:
   - Create new node
   - Pop from stack while value > stack.top's value (these are left children)
   - If stack not empty, the last popped node's right = new node
   - Else, the last node's left = new node
3. Push new node onto stack

## Complexity

- **Time**: O(n) with stack or upper bound approach
- **Space**: O(n) - recursion stack or explicit stack

## Link

[LeetCode 1008 Construct Binary Search Tree from Preorder Traversal](https://leetcode.com/problems/construct-binary-search-tree-from-preorder-traversal/)
