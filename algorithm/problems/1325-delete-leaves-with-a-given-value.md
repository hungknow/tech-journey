# 1325 Delete Leaves With a Given Value

## Problem Description

Given a binary tree `root` and an integer `target`, delete all the leaf nodes with value `target`.

Note that once you delete a leaf node with value `target`, if its parent node becomes a leaf node and has value `target`, it should also be deleted (you would continue this process).

### Example 1:
```
Input: root = [1,2,3,2,null,2,4], target = 2
Output: [1,null,3,null,4]
Explanation: Leaf nodes with value 2 are removed, then the parent node with value 2 becomes a leaf and is also removed.
```

### Example 2:
```
Input: root = [1,3,3,3,2], target = 3
Output: [1,3,null,null,2]
```

### Example 3:
```
Input: root = [1,2,null,2,null,2], target = 2
Output: [1]
```

## The Twist

We need to **recursively delete** leaves - after deleting a leaf, the parent might become a new leaf that also needs to be deleted. This requires post-order traversal.

## Algorithm

### Post-order DFS:
1. If root is null, return null
2. Recursively process left and right subtrees
3. After processing, check if current node is a leaf with value target:
   - If yes (no children and val == target), return null
   - Else, return the node
4. Return the processed root

## Complexity

- **Time**: O(n) - each node visited at most twice
- **Space**: O(h) - recursion stack depth

## Link

[LeetCode 1325 Delete Leaves With a Given Value](https://leetcode.com/problems/delete-leaves-with-a-given-value/)
