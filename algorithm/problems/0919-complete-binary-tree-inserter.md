# 0919 Complete Binary Tree Inserter

## Problem Description

A complete binary tree is a binary tree in which every level, except possibly the last, is completely filled, and all nodes in the last level are as far left as possible.

Design an algorithm to insert a new node to a complete binary tree while keeping it complete after each insertion.

Implement the `CBTInserter` class:
- `CBTInserter(TreeNode root)` Initializes the data structure with the `root` of the complete binary tree.
- `int insert(int v)` Inserts a `TreeNode` with the value `int` into the tree and returns the value of the parent of the inserted node.
- `TreeNode get_root()` Returns the root node of the complete binary tree.

### Example 1:
```
Input
["CBTInserter", "insert", "insert", "get_root"]
[[[1, 2]], [3], [4], []]
Output
[null, 1, 2, [1, 2, 3, 4]]
```

## The Twist

We need to maintain the **complete binary tree property** after each insertion. This requires tracking the next available parent position.

## Algorithm

### Using Queue (BFS):
1. Constructor: Use BFS to find the first node with missing child(ren)
2. `insert`:
   - Create new node with value v
   - If current node has no left child, insert as left
   - Else, insert as right and move to next node in queue
   - Add new node to queue
   - Return parent's value
3. `get_root`: Return the stored root

### Using Level Order Tracking:
1. Track the number of nodes and the tree structure
2. Calculate the position for new insertion based on node count
3. Navigate to the parent and insert

## Complexity

- **Constructor**: O(n) - BFS traversal
- **insert()**: O(1) - amortized
- **get_root()**: O(1)
- **Space**: O(n) - storing the tree and queue

## Link

[LeetCode 0919 Complete Binary Tree Inserter](https://leetcode.com/problems/complete-binary-tree-inserter/)
