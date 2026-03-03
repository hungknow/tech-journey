# 1650 Lowest Common Ancestor of a Binary Tree III

## Problem Description

Given two nodes of a binary tree p and q, return their lowest common ancestor (LCA). Each node has a reference to its parent node. (LeetCode Premium) This is equivalent to finding the intersection of two linked lists: the path from p to root and the path from q to root.

### Example 1:
```
Input: tree with p and q as two nodes
Output: LCA node
```

### Example 2:
```
Input: p = 5, q = 1 (in a tree)
Output: 3 (LCA)
```

## The Twist

From p and q, follow parent pointers toward the root. If you traverse "p's path" then "q's path" with one pointer, and "q's path" then "p's path" with the other, they meet at the LCA (same idea as Intersection of Two Linked Lists).

## Algorithm

1. Use two pointers a, b starting at p and q. Advance a = a.Parent (or nil then switch to q), b = b.Parent (or nil then switch to p). When a == b, that node is the LCA. Return a.

## Complexity

- **Time**: O(h) — height of tree, each path traversed at most twice.
- **Space**: O(1) — two pointers.

## Solution Code

```go
/**
 * type Node struct {
 *     Val int
 *     Left *Node
 *     Right *Node
 *     Parent *Node
 * }
 */
func lowestCommonAncestor(p *Node, q *Node) *Node {
	a, b := p, q
	for a != b {
		if a != nil {
			a = a.Parent
		} else {
			a = q
		}
		if b != nil {
			b = b.Parent
		} else {
			b = p
		}
	}
	return a
}
```

## Link

[LeetCode 1650 Lowest Common Ancestor of a Binary Tree III](https://leetcode.com/problems/lowest-common-ancestor-of-a-binary-tree-iii/)
