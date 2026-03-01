# 0558 Logical OR of Two Binary Grids Represented as Quad-Trees

## Problem Description

Each Quad-Tree node has a boolean value `isLeaf`, `val` (True if leaf, False otherwise), and four children `topLeft`, `topRight`, `bottomLeft`, `bottomRight`.

Given two Quad-Tree nodes representing binary grids, return a Quad-Tree node representing the logical OR of the two binary grids.

A grid `a` is logically ORed with grid `b` such that each cell of the resulting grid has value `a[i][j] | b[i][j]`.

### Example 1:
```
Input: quadTree1 = [0,1], quadTree2 = [1,1]
Output: [0,0,1,1]
```

### Example 2:
```
Input: quadTree1 = [1,1], quadTree2 = [1,1]
Output: [1,1]
```

### Example 3:
```
Input: quadTree1 = [0,0,1,1,0,0,1,1,1,1,1,1,1,1,1,1,1,1], quadTree2 = [0,0,1,1,0,0,1,1,1,1,1,1,1,1,1,1,1,1]
Output: [0,0,1,1,0,0,1,1,1,1,1,1,1,1,1,1,1]
```

## The Twist

We need to **perform logical OR** on two quad trees. The result can often be simplified (if all values are the same, it becomes a leaf).

## Algorithm

### Recursive OR:
1. If both nodes are leaves:
   - Return a new leaf with value = node1.val OR node2.val
2. Recursively compute OR for all four child pairs
3. If all four children are leaves with the same value:
   - Return a single leaf with that value
4. Otherwise, return an internal node with the four ORed children

## Complexity

- **Time**: O(n) - each node visited once
- **Space**: O(n) - storing the result tree

## Link

[LeetCode 0558 Logical OR of Two Binary Grids Represented as Quad-Trees](https://leetcode.com/problems/logical-or-of-two-binary-grids-represented-as-quad-trees/)
