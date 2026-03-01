# 1145 Binary Tree Coloring Game

## Problem Description

Two players play a turn-based game on a binary tree. You are given the `root` of the binary tree and `n` which is the number of nodes in the tree.

The players take turns coloring a node and its adjacent (left child, right child, and parent) red or blue. Note that the root node is colored red initially.

A node is colored red if either:
- It is the root
- It has a red parent
- It has two red children

Otherwise, it is colored blue.

Return `true` if the second player can win the game by coloring the root red, or `false` if the first player can win the both play optimally.

### Example 1:
```
Input: root = [1,2,3,4,5,6,7,8,9,10], n = 11
Output: false
```

### Example 2:
```
Input: root = [1,2,3], n = 3
Output: true
```

### Example 3:
```
Input: root = [1,2,3,4,5,6,7,8,9,10], n = 10
Output: true
```

## The Twist

The second player wins if they can **color the root red**. This happens if the first player cannot prevent it. We need to determine if the root can be colored red by the second player.

## Algorithm

### DFS with Node Counting:
1. Count the number of nodes in the left and right subtrees of the root
2. If either count is greater than half of remaining nodes, second player can color root red
3. Return true if second player can win, false otherwise

### Using Graph Theory:
1. The game is equivalent to: can the first player partition the tree into two equal halves?
2. If yes, second player wins (can color root red)
3. Otherwise, first player wins
4. Check if tree can be partitioned into equal halves

## Complexity

- **Time**: O(n) - single traversal to count nodes
- **Space**: O(h) - recursion stack depth

## Link

[LeetCode 1145 Binary Tree Coloring Game](https://leetcode.com/problems/binary-tree-coloring-game/)
