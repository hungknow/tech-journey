# 0563 Binary Tree Tilt

## Problem Description

Given the `root` of a binary tree, return the sum of every tree node's tilt.

The tilt of a tree node is defined as the absolute difference between the sum of all left subtree node values and the sum of all right subtree node values. If a node does not have a left child, then the sum of the left subtree node values is treated as 0. The rule is similar if the node does not have a right child.

### Example 1:
```
Input: root = [1,2,3]
Output: 1
Explanation:
Tilt of node 2 : |0-0| = 0
Tilt of node 3 : |0-0| = 0
Tilt of node 1 : |2-3| = 1
Sum of every tilt : 0 + 0 + 1 = 1
```

### Example 2:
```
Input: root = [4,2,9,3,5,null,7]
Output: 15
Explanation:
Tilt of node 3 : |0-0| = 0
Tilt of node 5 : |0-0| = 0
Tilt of node 7 : |0-0| = 0
Tilt of node 2 : |3-5| = 2
Tilt of node 9 : |0-7| = 7
Tilt of node 4 : |(3+5+2)-(9+7)| = |10-16| = 6
Sum of every tilt : 0 + 0 + 0 + 2 + 7 + 6 = 15
```

## The Twist

We need to compute the **sum of each subtree** to calculate the tilt at each node. This requires post-order traversal to compute sums bottom-up.

## Algorithm

### Post-order DFS:
1. Define a helper function that returns the sum of the subtree
2. At each node:
   - Recursively get sum of left and right subtrees
   - Calculate tilt = |left_sum - right_sum|
   - Add tilt to global sum
   - Return left_sum + right_sum + node.val
3. Return the global tilt sum

## Complexity

- **Time**: O(n) - each node visited once
- **Space**: O(h) - recursion stack depth

## Link

[LeetCode 0563 Binary Tree Tilt](https://leetcode.com/problems/binary-tree-tilt/)
