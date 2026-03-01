# 0222 Count Complete Tree Nodes

## Problem Description

Given the `root` of a complete binary tree, return the number of the nodes in the tree.

### Example 1:
```
Input: root = [1,2,3,4,5,6]
Output: 6
```

### Example 2:
```
Input: root = []
Output: 0
```

### Example 3:
```
Input: root = [1]
Output: 1
```

## The Twist

Counting nodes in a **complete binary tree** efficiently. The key insight is to use the tree's properties to avoid traversing all nodes.

## Algorithm

### Binary Search on Tree Height:
1. Calculate the height of the leftmost path (always exists in complete tree)
2. Calculate the height of the rightmost path
3. If heights are equal, the tree is perfect: nodes = 2^h - 1
4. Otherwise, recursively count nodes in subtrees:
   - Count nodes in left subtree
   - Count nodes in right subtree
   - Add 1 for current node

## Complexity

- **Time**: O(log n * log n) - binary search on tree levels
- **Space**: O(log n) - recursion depth

## Solution Code

```go
package main

/**
 * Definition for a binary tree node.
 * type TreeNode struct {
 *     Val int
 *     Left *TreeNode
 *     Right *TreeNode
 * }
 */
func countNodes(root *TreeNode) int {
	if root == nil {
		return 0
	}
	
	leftHeight := getLeftHeight(root)
	rightHeight := getRightHeight(root)
	
	if leftHeight == rightHeight {
		// Perfect binary tree
		return (1 << leftHeight) - 1
	}
	
	// Not perfect, count recursively
	return 1 + countNodes(root.Left) + countNodes(root.Right)
}

func getLeftHeight(node *TreeNode) int {
	height := 0
	for node != nil {
		height++
		node = node.Left
	}
	return height
}

func getRightHeight(node *TreeNode) int {
	height := 0
	for node != nil {
		height++
		node = node.Right
	}
	return height
}
```

## Link

[LeetCode 0222 Count Complete Tree Nodes](https://leetcode.com/problems/count-complete-tree-nodes/)
