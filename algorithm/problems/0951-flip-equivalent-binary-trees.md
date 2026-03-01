# 0951 Flip Equivalent Binary Trees

## Problem Description

For a binary tree T, we can define the flip operation as: choose any node, and swap the left and right child subtrees.

A binary tree X is flip equivalent to T if we can make X equal to T by some number of flip operations.

Given the roots of two binary trees `root1` and `root2`, return `true` if the two trees are flip equivalent, or `false` otherwise.

### Example 1:
```
Input: root1 = [1,2,3,4,5,6,null,null,7,8], root2 = [1,3,2,6,4,5,8,7]
Output: true
```

### Example 2:
```
Input: root1 = [], root2 = []
Output: true
```

### Example 3:
```
Input: root1 = [], root2 = [1]
Output: false
```

## The Twist

Two trees are flip equivalent if they can be made identical by **swapping left and right children** at any nodes. This is similar to checking if trees are isomorphic with the added flexibility of flipping.

## Algorithm

### Recursive Comparison:
1. If both trees are null, return true
2. If only one is null, return false
3. If values differ, return false
4. Check if (flipEquivalent(left1, left2) AND flipEquivalent(right1, right2)) OR (flipEquivalent(left1, right2) AND flipEquivalent(right1, left2))

### Using Canonical Representation:
1. Define a canonical form for each tree (e.g., always flip to make left subtree "smaller")
2. Compare canonical forms of both trees
3. Return true if they match

## Complexity

- **Time**: O(min(m, n)) - where m and n are sizes of the two trees
- **Space**: O(h) - recursion stack depth

## Link

[LeetCode 0951 Flip Equivalent Binary Trees](https://leetcode.com/problems/flip-equivalent-binary-trees/)
