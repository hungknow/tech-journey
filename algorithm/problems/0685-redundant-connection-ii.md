# 0685 Redundant Connection II

## Problem Description

In this problem, a rooted tree is a directed graph such that there is exactly one node (the root) for which all other nodes are descendants of this node, plus every node has exactly one parent, except for the root node which has no parents.

The given input is a directed graph that started as a rooted tree with `n` nodes (with distinct values from `1` to `n`), and one additional directed edge added. The added edge has two different vertices chosen from `1` to `n`, and was not an edge that already existed.

Return an edge that can be removed so that the resulting graph is a rooted tree of `n` nodes. If there are multiple answers, return the answer that occurs last in the input.

### Example 1:
```
Input: edges = [[1,2],[1,3],[2,3]]
Output: [2,3]
```

### Example 2:
```
Input: edges = [[1,2],[2,3],[3,4],[4,1],[1,5]]
Output: [1,5]
```

### Example 3:
```
Input: edges = [[1,2],[2,3],[3,4],[4,1],[1,5],[3,5]]
Output: [3,5]
```

## The Twist

This is the **directed version** of the redundant connection problem. We need to find the edge that creates a cycle in a directed tree.

## Algorithm

### Union-Find with In-degree Tracking:
1. Initialize Union-Find with n nodes
2. Track in-degree of each node
3. Find the root (node with in-degree 0)
4. For each edge:
   - If the two nodes are already connected, this edge is redundant
   - Otherwise, union the two nodes
5. Return the first redundant edge found

### DFS with Parent Tracking:
1. Build adjacency list from edges
2. Use DFS to detect when we encounter a visited node
3. Track parent relationships to ensure we find the correct redundant edge

## Complexity

- **Time**: O(n * α(n)) - α is the inverse Ackermann function (nearly constant)
- **Space**: O(n) - Union-Find structures

## Link

[LeetCode 0685 Redundant Connection II](https://leetcode.com/problems/redundant-connection-ii/)
