# 0979 Distribute Coins in Binary Tree

## Problem Description

You are given the `root` of a binary tree with `n` nodes where each node in the tree has `node.val` coins. There are `n` coins in total throughout the whole tree.

In one move, we may choose two adjacent nodes and move one coin from one node to the other. The move may be from parent to child, or from child to parent.

Return the minimum number of moves required to make every node have exactly one coin.

### Example 1:
```
Input: root = [3,0,0]
Output: 2
```

### Example 2:
```
Input: root = [0,3,0]
Output: 3
```

## The Twist

We need to **distribute coins evenly** across all nodes. Each move transfers one coin between adjacent nodes. The goal is to minimize total moves.

## Algorithm

### Post-order DFS:
1. Define a helper that returns (excess, moves) for a subtree
2. For each node:
   - Get excess from left and right children
   - Calculate node's excess: node.val - 1 (coins needed at this node)
   - Total excess = left_excess + right_excess + node_excess
   - Moves needed: abs(left_excess) + abs(right_excess) + abs(node_excess - total_excess)
   - Return (total_excess, moves)
3. Return the moves from the root

### Greedy Approach:
1. Use post-order traversal
2. For each node, calculate how many coins it needs to give/receive
3. Track the total moves needed to balance the tree

## Complexity

- **Time**: O(n) - single traversal
- **Space**: O(h) - recursion stack depth

## Link

[LeetCode 0979 Distribute Coins in Binary Tree](https://leetcode.com/problems/distribute-coins-in-binary-tree/)
