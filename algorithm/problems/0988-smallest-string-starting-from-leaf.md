# 0988 Smallest String Starting From Leaf

## Problem Description

Given the `root` of a binary tree, each node has a value consisting of digits from '0' to '9'.

Each path from a root to a leaf represents a number. Return the smallest number that can be formed by the concatenation of values along a root-to-leaf path.

### Example 1:
```
Input: root = [0,1,2,3,4,3,4]
Output: "0"
```

### Example 2:
```
Input: root = [2,2,1,null,1,0,null,0]
Output: "1"
```

### Example 3:
```
Input: root = [1]
Output: "1"
```

## The Twist

We need to find the **smallest numeric string** among all root-to-leaf paths. Since we're comparing strings lexicographically, shorter strings are naturally "smaller" if they are prefixes of longer strings.

## Algorithm

### DFS with String Building:
1. Use DFS to traverse all root-to-leaf paths
2. For each path:
   - Build the string by concatenating node values
   - Track the minimum string found
3. Return the minimum string

### Optimization:
1. Use a priority queue to explore paths in lexicographic order
2. Stop early if we find a path that can't be beaten

## Complexity

- **Time**: O(n * h) - each path has at most h nodes
- **Space**: O(h) - recursion stack depth

## Link

[LeetCode 0988 Smallest String Starting From Leaf](https://leetcode.com/problems/smallest-string-starting-from-leaf/)
