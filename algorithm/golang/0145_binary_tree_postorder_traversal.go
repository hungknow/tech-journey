package algo

import "hungknow.com/algo/models"

// Problem: https://github.com/hungknow/tech-journey/blob/main/algorithm/problems/0145-binary-tree-postorder-traversal.md
//
// Given the root of a binary tree, return the postorder traversal of its nodes' values.
//
// Postorder traversal visits nodes in the order: left subtree → right subtree → root.
// This is useful for deleting a tree or evaluating postfix expressions.

// PostorderTraversal returns the postorder traversal of a binary tree using iterative approach with two stacks.
// Time: O(n), Space: O(n).
func PostorderTraversal(root *models.BinaryTreeNode[int]) []int {
	return PostorderTraversalIterative(root)
}

// PostorderTraversalIterative returns the postorder traversal using iterative approach with single stack.
// Uses a visited flag to track when a node should be added to result.
// Time: O(n), Space: O(h) where h is the height of the tree.
func PostorderTraversalIterative(root *models.BinaryTreeNode[int]) []int {
	if root == nil {
		return []int{}
	}

	type visitedBinaryTreeNode struct {
		Visited bool
		Node    *models.BinaryTreeNode[int]
	}

	results := make([]int, 0)
	queue := []visitedBinaryTreeNode{{
		Visited: false,
		Node:    root,
	}}

	for len(queue) > 0 {
		current := queue[len(queue)-1]
		queue = queue[:len(queue)-1]

		if current.Node == nil {
			continue
		}

		if current.Visited {
			results = append(results, current.Node.Val)
		} else {
			queue = append(queue, visitedBinaryTreeNode{
				Visited: true,
				Node:    current.Node,
			})
			if current.Node.Right != nil {
				queue = append(queue, visitedBinaryTreeNode{
					Visited: false,
					Node:    current.Node.Right,
				})
			}
			if current.Node.Left != nil {
				queue = append(queue, visitedBinaryTreeNode{
					Visited: false,
					Node:    current.Node.Left,
				})
			}

		}
	}

	return results
}

// PostorderTraversalMorris returns the postorder traversal using Morris Traversal.
// Achieves O(n) time complexity and O(1) space complexity.
// Time: O(n), Space: O(1).
func PostorderTraversalMorris(root *models.BinaryTreeNode[int]) []int {
	// TODO: Implement Morris Traversal for postorder
	//
	// Algorithm:
	// 1. Use modified Morris traversal by creating a dummy node as the new root
	// 2. The dummy node's left child is the original root
	// 3. Perform a modified inorder traversal that reverses right edges
	// 4. After visiting a subtree, reverse back to restore the tree
	return []int{}
}
