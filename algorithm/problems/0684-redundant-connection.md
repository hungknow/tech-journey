# 0684 Redundant Connection

## Problem Description

In this problem, a tree is an undirected graph that is connected and has no cycles.

You are given a graph that started as a tree with `n` nodes labeled from `1` to `n`, and one additional edge added. The added edge has two different vertices chosen from `1` to `n`, and was not an edge that already existed.

The graph is represented as an array `edges` of length `n` where `edges[i] = [ai, bi]` indicates that there is an edge between nodes `ai` and `bi` in the graph.

Return an edge that can be removed so that the resulting graph is a tree of `n` nodes. If there are multiple answers, return the answer that occurs last in the input.

### Example 1:
```
Input: edges = [[1,2],[1,3],[2,3]]
Output: [2,3]
```

### Example 2:
```
Input: edges = [[1,2],[2,3],[3,4],[1,4],[1,5]]
Output: [1,4]
```

## The Twist

We need to find the **redundant edge** that creates a cycle. Since the original graph was a tree, adding one edge creates exactly one cycle. We need to find which edge completes the cycle.

## Algorithm

### Union-Find:
1. Initialize Union-Find with n nodes
2. For each edge:
   - If the two nodes are already connected, this edge is redundant (creates cycle)
   - Otherwise, union the two nodes
3. Return the first redundant edge found

### DFS Cycle Detection:
1. Build adjacency list from edges
2. Use DFS to detect when we encounter a visited node
3. Return the edge that causes the cycle

## Complexity

- **Time**: O(n * α(n)) - α is the inverse Ackermann function (nearly constant)
- **Space**: O(n) - Union-Find structures

## Link

[LeetCode 0684 Redundant Connection](https://leetcode.com/problems/redundant-connection/)
