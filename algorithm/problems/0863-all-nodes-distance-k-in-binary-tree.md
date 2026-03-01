# 0863 All Nodes Distance K in Binary Tree

## Problem Description

Given the `root` of a binary tree, an integer `target`, and an integer `k`, return an array of the values of all nodes that have a distance `k` from the `target` node.

You can return the answer in any order.

The distance between two nodes is the number of edges on the path between them.

### Example 1:
```
Input: root = [3,5,1,6,2,0,8,null,null,7,4], target = 5, k = 2
Output: [7,4,1]
```

### Example 2:
```
Input: root = [1], target = 1, k = 3
Output: []
```

## The Twist

We need to find all nodes at **exactly distance k** from the target. Since it's a tree (not necessarily a BST), we can't use BST properties. We need to build a graph representation and use BFS.

## Algorithm

### BFS from Target:
1. Build adjacency list from the tree
2. Start BFS from the target node
3. Track distance from target for each node
4. When we reach distance k, collect all nodes at that level
5. Return the collected nodes

### DFS with Parent Tracking:
1. Build a map from node to its parent
2. Use DFS to traverse from target
3. Track distance from target
4. Collect all nodes at distance k
5. Return the collected nodes

## Complexity

- **Time**: O(n) - each node visited at most once
- **Space**: O(n) - adjacency list and visited set

## Link

[LeetCode 0863 All Nodes Distance K in Binary Tree](https://leetcode.com/problems/all-nodes-distance-k-in-binary-tree/)
