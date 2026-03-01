# 1448 Count Good Nodes in Binary Tree

## Problem Description

Given the `root` of a binary tree, return the number of good nodes in the binary tree.

A good node is a node where there is no path from the root to that node where any node on the path has a value greater than the node's value.

### Example 1:
Input: root = [3,1,4,3,null,7]
Output: 3
Explanation: Nodes 3, 7 are good nodes.
```

### Example 2:
Input: root = [1,2,3,null,1]
Output: 1
Explanation: Only node 1 is good.
```

### Example 3:
Input: root = [2,1,3,null,4,7]
Output: 2
Explanation: Nodes 2 and 7 are good nodes.
```

## The Twist

A node is good if **no ancestor has a greater value**. This requires checking the path from root to each node for all ancestors.

## Algorithm

### DFS with Ancestor Tracking:
1. For each node, use DFS to check all nodes on the path from root
2. For each node on the path:
   - If any node has value greater than current node, this node is not good
3. Count all nodes that pass the check

### Using Post-order with Max Tracking:
1. For each node, calculate the maximum value on the path from root
2. If node.val == max_on_path, the node is good
3. Count all such nodes

### Using Inorder Traversal:
1. Perform inorder traversal
2. Track the maximum value seen so far
3. For each node, if node.val >= max_so_far, increment count

## Complexity

- **Time**: O(n²) naive, O(n) with tracking
- **Space**: O(h) - recursion stack depth

## Link

[LeetCode 1448 Count Good Nodes in Binary Tree](https://leetcode.com/problems/count-good-nodes-in-binary-tree/)
