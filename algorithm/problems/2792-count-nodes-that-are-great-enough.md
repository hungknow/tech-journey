# 2792 Count Nodes That Are Great Enough

## Problem Description

You are given a binary tree with `n` nodes where each node has a value `val`. A node is considered "great enough" if its value is strictly greater than the value of every node in its subtree.

Return the number of great nodes in the tree.

### Example 1:
```
Input: root = [5,4,3,7,6,2,8,1,9]
Output: 4
Explanation: 
Node 5 (value 5) is greater than all its children.
Node 4 (value 4) is not greater than any of its children.
Node 3 (value 3) is not greater than any of its children.
Node 6 (value 6) is greater than all its children.
Node 2 (value 2) is not greater than any of its children.
Node 7 (value 7) is greater than all its children.
Node 8 (value 8) is greater than all its children.
Node 1 (value 1) is not greater than any of its children.
Node 9 (value 9) is greater than all its children.
There are 4 great nodes.
```

### Example 2:
```
Input: root = [2,1,3]
Output: 0
Explanation: 
No node is greater than its children.
```

## Solution Approach

We need to count nodes that are "great enough" by comparing each node with all its descendants.

## Algorithm

1. Perform a post-order traversal of the tree.
2. For each node:
   - Initialize a flag `isGreat` = true.
   - For each child:
     - If the child's value > node's value, set `isGreat` to false.
   - If `isGreat` remains true, increment the count.
3. Return the count.

## Why This Works

By using post-order traversal, we check each node against all its descendants to determine if it's great enough.

## Complexity

- **Time**: O(n) - visiting each node once
- **Space**: O(h) - for the recursion stack

## Link

[LeetCode 2792 Count Nodes That Are Great Enough](https://leetcode.com/problems/count-nodes-that-great-enough/)