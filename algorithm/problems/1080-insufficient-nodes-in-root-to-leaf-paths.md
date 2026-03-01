# 1080 Insufficient Nodes in Root to Leaf Paths

## Problem Description

Given the `root` of a binary tree and an integer `limit`, delete all insufficient nodes in the tree and return the modified tree.

A node is insufficient if every root-to-leaf path that goes through this node has a sum strictly less than `limit`.

Return the root of the modified tree after all such insufficient nodes have been deleted.

### Example 1:
```
Input: root = [1,2,3,4,-99,-98,-97,null,-98,null,null,97,-99,null,-98], limit = 1
Output: [null,2,3,4,null,null,null,null,97]
```

### Example 2:
```
Input: root = [1,2,3,4,-99,-98,-97,null,-98,null,null,null,97,-99], limit = 2
Output: [1,2,3,4,null,null,null,null,null,null,null,97]
```

### Example 3:
```
Input: root = [1,2,-2,-2,-2], limit = 2
Output: [1]
```

## The Twist

We need to **prune nodes** where every path through them has sum < limit. This requires checking all paths through each node.

## Algorithm

### Post-order DFS with Path Sum Tracking:
1. Define a helper that returns (new_node, keep) where:
   - keep = true if node should be kept
   - keep = true only if all paths through node have sum >= limit
2. For each node:
   - Calculate max path sum through left subtree
   - Calculate max path sum through right subtree
   - Node is kept if: (node.val + max_left >= limit) OR (node.val + max_right >= limit)
   - Recursively prune left and right children
3. Return the pruned tree

### Using Path Sum Calculation:
1. For each node, calculate the maximum path sum from root to any leaf in its subtree
2. If max_path_sum + node.val < limit, delete this node
3. Recursively prune children

## Complexity

- **Time**: O(n²) - for each node, calculating max path sum is O(n)
- **Space**: O(h) - recursion stack depth

## Link

[LeetCode 1080 Insufficient Nodes in Root to Leaf Paths](https://leetcode.com/problems/insufficient-nodes-in-root-to-leaf-paths/)
