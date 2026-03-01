# 0559 Maximum Depth of N-ary Tree

## Problem Description

Given a n-ary tree, find its maximum depth.

The maximum depth is the number of nodes along the longest path from the root node down to the farthest leaf node.

N-ary tree input serialization is represented in their level order traversal, and each group of children is separated by the null value.

### Example 1:
```
Input: root = [1,null,3,2,4,null,5,6]
Output: 3
```

### Example 2:
```
Input: root = [1,null,2,3,4,5,null,null,6,7,null,8,null,9,10,null,null,11,null,12,null,null,13,null,null,14]
Output: 5
```

## The Twist

N-ary trees have **multiple children** per node. We need to find the maximum depth across all child subtrees.

## Algorithm

### Recursive DFS:
1. If root is null, return 0
2. For each child, recursively calculate its depth
3. Return 1 + maximum of all child depths

### BFS Approach:
1. Use BFS to traverse the tree level by level
2. Count the number of levels traversed
3. Return the level count

## Complexity

- **Time**: O(n) - each node visited once
- **Space**: O(h) - recursion stack depth or queue width

## Link

[LeetCode 0559 Maximum Depth of N-ary Tree](https://leetcode.com/problems/maximum-depth-of-n-ary-tree/)
