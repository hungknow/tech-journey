# 1443 Minimum Time to Collect All Apples in a Tree

## Problem Description

You are given the `root` of a directed tree with `n` nodes labeled from `0` to `n - 1`. You are given a 2D integer array `hasApple` where `hasApple[i]` indicates if node `i` has an apple.

Return the minimum time in seconds to collect all apples in the tree.

### Example 1:
```
Input: n = 7, edges = [[0,1],[0,2],[0,3],[1,4],[2,5],[3,6]], hasApple = [false,false,true,false,true,true,true,false,false]
Output: 8
```

### Example 2:
```
Input: n = 7, edges = [[0,1],[0,2],[0,3],[1,4],[2,5],[3,6]], hasApple = [true,false,true,true,true,true,true,false]
Output: 6
```

### Example 3:
```
Input: n = 7, edges = [[0,1],[0,2],[0,3],[0,4],[0,5],[0,6]], hasApple = [false,false,true,false,true,false,true,false]
Output: 4
```

## The Twist

We need to find the **minimum time to visit all apple nodes** starting from any node. This is equivalent to finding the shortest path that covers all apple nodes.

## Algorithm

### BFS from All Apple Nodes:
1. Collect all apple node indices into a set
2. Use BFS from each apple node to find the maximum distance to other apple nodes
3. The answer is the maximum distance found

### DFS with Distance Tracking:
1. Use DFS to calculate the distance from each apple node to all other apple nodes
2. Track the maximum distance found
3. Return the maximum distance

### Using Two BFS Passes:
1. First BFS: Find the farthest apple node from each apple node
2. Second BFS: Find the farthest node from that farthest node
3. The sum of these two distances is the answer

## Complexity

- **Time**: O(n) - each edge visited at most twice
- **Space**: O(n) - adjacency list and visited set

## Link

[LeetCode 1443 Minimum Time to Collect All Apples in a Tree](https://leetcode.com/problems/minimum-time-to-collect-all-apples-in-a-tree/)
