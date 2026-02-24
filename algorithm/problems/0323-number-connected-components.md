# 0323 Number of Connected Components in an Undirected Graph

## Problem Description

You have a graph of `n` nodes labeled from `0` to `n - 1`. You are given an integer `n` and an array `edges` where `edges[i] = [ai, bi]` indicates that there is an edge between nodes `ai` and `bi` in the graph.

Return the number of connected components in the graph.

### Example 1:
```
Input: n = 5, edges = [[0,1],[1,2],[3,4]]
Output: 2
```

### Example 2:
```
Input: n = 5, edges = [[0,1],[1,2],[2,3],[3,4]]
Output: 1
```

## The Twist

Hash map/array tracks **parent nodes** for Union-Find or adjacency lists for DFS/BFS. The hash table is used to efficiently manage and query connected components.

## Hash Table Usage

- **Key**: `node` (a node in the graph)
- **Value**: `parent_node` (the root of this node in the Union-Find structure)

Algorithm:
1. Initialize each node as its own parent
2. For each edge, union the two nodes
3. Count the number of unique roots (nodes that are their own parent)
4. Return the count

## Complexity

- **Time**: O(n + e * α(n)) where n is number of nodes, e is number of edges, α is the inverse Ackermann function
- **Space**: O(n) - storing parent array

## Link

[LeetCode 0323 Number of Connected Components in an Undirected Graph](https://leetcode.com/problems/number-of-connected-components-in-an-undirected-graph/)
