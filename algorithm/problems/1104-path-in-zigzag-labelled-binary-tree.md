# 1104 Path In Zigzag Labelled Binary Tree

## Problem Description

In an infinite binary tree where every node has `0`, `1`, or `2` children:
- The left child of node `i` has value `2 * i`
- The right child of node `i` has value `2 * i + 1`

Given the `label` of a node in this tree, return the labels of the nodes on the path from the root to the node with that label. If no such node exists, return an empty array.

### Example 1:
```
Input: label = 4
Output: [1,3,4]
```

### Example 2:
```
Left: label = 14
Output: [15,13,2,5,10,3]
```

## The Twist

The tree has a **specific structure** where children are at predictable indices. We need to navigate from the root to the target label using the tree's structure.

## Algorithm

### Mathematical Approach:
1. Calculate the path from root to target label
2. The tree structure is:
   - Left child of node i is at index 2*i
   - Right child of node i is at index 2*i + 1
3. Find the path by working backwards:
   - If label is even: path = [label/2, label/2 + 1, label/2 + 2, ...] until 1
   - If label is odd: path = [(label-1)/2, (label-1)/2 + 1, ...] until 1
4. Return the path in order from root to target

### Binary Search:
1. Use binary search to find the node with the target label
2. Track the path from root to the found node
3. Return the path

## Complexity

- **Time**: O(log n) - binary search to find the node
- **Space**: O(1) - just storing the path

## Link

[LeetCode 1104 Path In Zigzag Labelled Binary Tree](https://leetcode.com/problems/path-in-zigzag-labelled-binary-tree/)
