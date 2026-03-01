# 1110 Delete Nodes And Return Forest

## Problem Description

Given the `root` of a binary tree and an array `to_delete` containing unique values. Return the forest after deleting all nodes with values in `to_delete`.

The forest is a collection of disjoint trees where each tree is a valid binary tree.

### Example 1:
```
Input: root = [1,2,3,4,5,6,7], to_delete = [3,5]
Output: [[1,2,null,4],[6,7]]
Explanation: After deleting nodes 3 and 5, we have two trees:
- Tree 1: [1,2,null,4]
- Tree 2: [6,7]
```

## The Twist

Deleting nodes from a binary tree and returning a **forest**. This requires careful tree traversal and reconstruction.

## Algorithm

### Postorder Traversal with Filtering:
1. Perform postorder traversal of the tree
2. For each node, if its value is in `to_delete`, skip it
3. Collect all non-deleted nodes
4. Reconstruct the forest from the collected nodes

The key insight is to use postorder traversal so we process children before parents.

## Complexity

- **Time**: O(n) - single tree traversal
- **Space**: O(n + h) - storing the forest where h is tree height

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

func delNodes(root *TreeNode, to_delete []int) []*TreeNode {
	if root == nil {
		return []*TreeNode{}
	}
	
	// Create a set for quick lookup
	deleteSet := make(map[int]bool)
	for _, val := range to_delete {
		deleteSet[val] = true
	}
	
	var forest []*TreeNode
	var nodes []*TreeNode
	
	// Postorder traversal
	postorder(root, &nodes, deleteSet)
	
	// Reconstruct forest from collected nodes
	for _, node := range nodes {
		if node != nil {
			forest = append(forest, node)
		}
	}
	
	return forest
}

func postorder(node *TreeNode, nodes *[]*TreeNode, deleteSet map[int]bool) {
	if node == nil {
		return
	}
	
	postorder(node.Left, nodes, deleteSet)
	postorder(node.Right, nodes, deleteSet)
	
	if !deleteSet[node.Val] {
		*nodes = append(*nodes, node)
	}
}

func buildTree(nodes []*TreeNode) *TreeNode {
	if len(nodes) == 0 {
		return nil
	}
	
	root := nodes[0]
	nodes[0] = nil
	
	for i := 1; i < len(nodes); i++ {
		if nodes[i] != nil {
			insertNode(root, nodes[i])
		}
	}
	
	return root
}

func insertNode(root, node *TreeNode) {
	if node.Val < root.Val {
		if root.Left == nil {
			root.Left = node
		} else {
			insertNode(root.Left, node)
		}
	} else {
		if root.Right == nil {
			root.Right = node
		} else {
			insertNode(root.Right, node)
		}
	}
}
```

## Link

[LeetCode 1110 Delete Nodes And Return Forest](https://leetcode.com/problems/delete-nodes-and-return-forest/)
