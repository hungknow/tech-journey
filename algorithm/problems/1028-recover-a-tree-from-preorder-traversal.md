# 1028 Recover a Tree From Preorder Traversal

## Problem Description

We run a preorder depth-first search (DFS) on the `root` of a binary tree.

At each node in this traversal, we output `D` dashes (where `D` is the depth of this node), then we output the value of this node. If the depth of a node is `D`, the depth of its immediate child is `D + 1`. The depth of the root node is `0`.

If a node has only one child, that child is guaranteed to be the left child.

Given the output `traversal` of this traversal, recover the tree and return its `root`.

### Example 1:
```
Input: traversal = "1-2--3--4-5--6--7"
Output: [1,2,5,3,4,6,7]
```

### Example 2:
```
Input: traversal = "1-2--3---4-5--6---7"
Output: [1,2,5,3,null,6,null,4,null,7]
```

### Example 3:
```
Input: traversal = "1-401--349---90--88"
Output: [1,401,null,349,88,90]
```

## The Twist

The traversal string encodes **depth information** using dashes. We need to parse this string and reconstruct the tree structure based on depth levels.

## Algorithm

### DFS with Depth Tracking:
1. Parse the traversal string into (depth, value) pairs
2. Use a stack to track nodes at each depth
3. For each (depth, value) pair:
   - Create new node with the value
   - Pop from stack until stack size equals depth
   - If stack is empty, this is the root
   - Else if the top node has no left child, set as left child
   - Else, set as right child
   - Push new node onto stack
4. Return root

## Complexity

- **Time**: O(n) - single pass through the string
- **Space**: O(n) - stack and tree storage

## Link

[LeetCode 1028 Recover a Tree From Preorder Traversal](https://leetcode.com/problems/recover-a-tree-from-preorder-traversal/)
