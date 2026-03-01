# 0501 Find Mode in Binary Search Tree

## Problem Description

Given the `root` of a binary search tree (BST) with duplicates, return all the mode(s) (i.e., the most frequently occurred element) in it.

If the tree has more than one mode, return them in any order.

### Example 1:
```
Input: root = [1,null,2,2]
Output: [2]
```

### Example 2:
```
Input: root = [0]
Output: [0]
```

## The Twist

Finding the most frequent value in a BST. Since it's a BST, we can use inorder traversal to get sorted values, making it easier to count consecutive duplicates.

## Algorithm

### Inorder Traversal Approach:
1. Perform inorder traversal (sorted order for BST)
2. Track current value, current count, max count, and result list
3. For each node:
   - If value equals current value: increment count
   - Else: reset count to 1, update current value
   - If count > max count: update max, clear result, add current value
   - Else if count == max count: add current value to result
4. Return result

### Hash Map Approach:
1. Use a hash map to count frequencies of all values
2. Find the maximum frequency
3. Return all values with maximum frequency

## Complexity

- **Time**: O(n) - single traversal
- **Space**: O(1) for inorder approach, O(n) for hash map approach

## Link

[LeetCode 0501 Find Mode in Binary Search Tree](https://leetcode.com/problems/find-mode-in-binary-search-tree/)
