# 0653 Two Sum IV - Input is a BST

## Problem Description

Given the `root` of a Binary Search Tree and a target number `k`, return `true` if there exist two elements in the BST such that their sum is equal to the given target.

### Example 1:
```
Input: root = [5,3,6,2,4,null,7], k = 9
Output: true
```

### Example 2:
```
Input: root = [5,3,6,2,4,null,7], k = 28
Output: false
```

## The Twist

The input is a **BST**, which gives us sorted order information. We can use this property to efficiently find pairs, or use a hash set for simplicity.

## Algorithm

### Using Hash Set:
1. Perform any traversal (DFS/BFS)
2. For each node value:
   - Calculate complement = k - node.val
   - If complement exists in set, return true
   - Add node.val to set
3. Return false if no pair found

### Using Two Pointers (BST property):
1. Perform inorder traversal to get sorted array
2. Use two pointers at start and end
3. Move pointers based on sum compared to k

### Using BST Property Directly:
1. For each node, search for (k - node.val) in the BST
2. Skip the node itself during search

## Complexity

- **Time**: O(n) - single traversal
- **Space**: O(n) for hash set, O(h) for recursive approach

## Link

[LeetCode 0653 Two Sum IV - Input is a BST](https://leetcode.com/problems/two-sum-iv-input-is-a-bst/)
