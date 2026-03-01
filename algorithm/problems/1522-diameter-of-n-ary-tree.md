# 1522 Diameter of N-Ary Tree

## Problem Description

Given a root of an N-ary tree, you need to calculate the length of the diameter of the tree.

The diameter of an N-ary tree is the length of the longest path between any two nodes in the tree. This path may or may not pass through the root.

The length of a path between two nodes is represented by the number of edges between them.

### Example 1:
```
Input: root = [1,null,3,2,4,null,5,6]
Output: 3
Explanation: The longest path is [5,3,4,2] or [6,3,4,2] with length 3.
```

### Example 2:
```
Input: root = [1,null,2,null,3,4,null,5,null,6]
Output: 4
Explanation: The longest path is [6,5,4,3,2] with length 4.
```

## The Twist

N-ary trees have **multiple children** per node. The longest path is the sum of the two longest paths from any node to its descendants.

## Algorithm

### DFS with Height Tracking:
1. For each node, calculate the height of each child subtree
2. Sort the heights in descending order
3. The diameter through this node = sum of top 2 heights (or top 1 if only 1 child)
4. Track the maximum diameter seen
5. Return the height of this subtree (max height + 1)

### Recursive Approach:
1. Define a helper function that returns the height of the subtree
2. At each node:
   - Get heights of all child subtrees
   - Sort heights descending
   - Update global max diameter if sum of top 2 > current max
   - Return max height + 1
3. Return the global max diameter

## Complexity

- **Time**: O(n * k) where n is nodes, k is max children (due to sorting)
- **Space**: O(h) - recursion stack depth

## Link

[LeetCode 1522 Diameter of N-Ary Tree](https://leetcode.com/problems/diameter-of-n-ary-tree/)
