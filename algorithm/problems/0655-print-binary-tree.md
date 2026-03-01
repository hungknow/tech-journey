# 0655 Print Binary Tree

## Problem Description

Print a binary tree in an m x n 2D string array following these rules:
- The row number `m` should be equal to the height of the given binary tree.
- The column number `n` should always be an odd number.
- The root node's value should be put in the exactly middle of the first row.
- The left and right subtrees should be put in the next two rows.
- The empty cells should be represented by an empty string `""`.
- The nodes of each level should be printed from left to right with exactly one space between two nodes.

### Example 1:
```
Input: root = [1,2]
Output:
[["","1","",""],
["2","",""]]
```

### Example 2:
```
Input: root = [1,2,3,null,4]
Output:
[["","","","1",""],
["","2","","","3",""],
["","","","","4","",""]]
```

## The Twist

We need to **format the tree as a 2D array** with proper spacing and alignment. The root should be centered, and children should be positioned below their parent.

## Algorithm

### BFS with Position Tracking:
1. Calculate the height of the tree
2. Use BFS to traverse level by level
3. For each level:
   - Calculate the positions of nodes to center them
   - Place nodes in their calculated positions
4. Fill empty cells with empty strings
5. Return the 2D array

### Recursive with Position Calculation:
1. Calculate the position of each node in the output
2. Use inorder or BFS to assign positions
3. Fill the 2D array based on calculated positions

## Complexity

- **Time**: O(n) - each node visited once
- **Space**: O(n) - storing the 2D array

## Link

[LeetCode 0655 Print Binary Tree](https://leetcode.com/problems/print-binary-tree/)
