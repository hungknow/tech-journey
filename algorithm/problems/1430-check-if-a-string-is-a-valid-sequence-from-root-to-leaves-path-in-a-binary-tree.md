# 1430 Check If a String Is a Valid Sequence from Root to Leaves Path in a Binary Tree

## Problem Description

Given the `root` of a binary tree and a string `s` consisting of only digits, return `true` if the string `s` is a valid sequence from root to some leaf node in the binary tree. Otherwise, return `false`.

### Example 1:
```
Input: root = [8,3,7], s = "8"
Output: true
```

### Example 2:
```
Input: root = [8,3,7], s = "0"
Output: false
```

### Example 3:
```
Input: root = [8,7,1], s = "78"
Output: true
```

## The Twist

We need to check if the **string matches any root-to-leaf path**. The string represents a path from root to a leaf node in the tree.

## Algorithm

### DFS with String Matching:
1. Use DFS to traverse all root-to-leaf paths
2. For each path:
   - Build the string representation of the path
   - Compare with the target string
   - Return true if any match found

### Using Trie:
1. Build a trie of all root-to-leaf paths
2. Traverse the trie to check if the target string exists
3. Return true if found, false otherwise

### Recursive String Building:
1. Define a helper that returns whether a string can be matched from a node
2. For each node:
   - If leaf node, check if remaining string matches node.val
   - Recursively try left and right subtrees
3. Return true if any path matches

## Complexity

- **Time**: O(n * m) - n is number of nodes, m is string length
- **Space**: O(n * m) - storing paths or trie

## Link

[LeetCode 1430 Check If a String Is a Valid Sequence from Root to Leaves Path in a Binary Tree](https://leetcode.com/problems/check-if-a-string-is-a-valid-sequence-from-root-to-leaves-path-in-a-binary-tree/)
