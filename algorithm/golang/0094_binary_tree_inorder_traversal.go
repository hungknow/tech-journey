package algo

import "hungknow.com/algo/models"

// Problem: https://github.com/hungknow/tech-journey/blob/main/algorithm/problems/0094-binary-tree-inorder-traversal.md
//
// Given the root of a binary tree, return the inorder traversal of its nodes' values.
//
// Inorder traversal visits nodes in the order: left subtree → root → right subtree.

// InorderTraversal returns the inorder traversal of a binary tree using Morris Traversal.
// Morris Traversal achieves O(n) time complexity and O(1) space complexity.
func InorderTraversal(root *models.BinaryTreeNode[int]) []int {
	result := make([]int, 0)
	current := root

	for current != nil {
		if current.Left == nil {
			// No left child, visit current node and move to right
			result = append(result, current.Val)
			current = current.Right
		} else {
			// Find the rightmost node in the left subtree
			predecessor := current.Left
			for predecessor.Right != nil && predecessor.Right != current {
				predecessor = predecessor.Right
			}

			if predecessor.Right == nil {
				// Make current the right child of its inorder predecessor
				predecessor.Right = current
				current = current.Left
			} else {
				// Revert the changes made to restore the original tree
				predecessor.Right = nil
				result = append(result, current.Val)
				current = current.Right
			}
		}
	}

	return result
}

// InorderTraversalRecursive returns the inorder traversal using recursive approach.
// Time: O(n), Space: O(h) where h is the height of the tree.
func InorderTraversalRecursive(root *models.BinaryTreeNode[int]) []int {
	result := make([]int, 0)
	inorderHelper(root, &result)
	return result
}

func inorderHelper(node *models.BinaryTreeNode[int], result *[]int) {
	if node == nil {
		return
	}
	inorderHelper(node.Left, result)
	*result = append(*result, node.Val)
	inorderHelper(node.Right, result)
}

// InorderTraversalIterative returns the inorder traversal using iterative approach with stack.
// Time: O(n), Space: O(h) where h is the height of the tree.
func InorderTraversalIterative(root *models.BinaryTreeNode[int]) []int {
	result := make([]int, 0)
	var stack []*models.BinaryTreeNode[int]
	current := root

	for current != nil || len(stack) > 0 {
		// Go to the leftmost node
		for current != nil {
			stack = append(stack, current)
			current = current.Left
		}

		// Pop the node from stack
		current = stack[len(stack)-1]
		stack = stack[:len(stack)-1]

		// Visit the node
		result = append(result, current.Val)

		// Move to right subtree
		current = current.Right
	}

	return result
}

func InOrderTraversalRecursive(root *models.BinaryTreeNode[int]) []int {
	visitedInt := make([]int, 0)
	inOrderTraversalRecursive(root, &visitedInt)

	return visitedInt
}

func inOrderTraversalRecursive(root *models.BinaryTreeNode[int], result *[]int) {
	if root == nil {
		return
	}
	// Left
	inOrderTraversalRecursive(root.Left, result)

	// Root
	*result = append(*result, root.Val)

	// Right
	inOrderTraversalRecursive(root.Right, result)
}

func InOrderTraversalIterative(root *models.BinaryTreeNode[int]) []int {
	var stack []*models.BinaryTreeNode[int]
	current := root
	visitedInts := make([]int, 0)

	for current != nil && len(stack) > 0 {
		// Append node until there's no more left
		for current.Left != nil {
			stack = append(stack, current.Left)
			current = current.Left
		}

		// The last node is the current node, remove it
		current = stack[len(stack)-1]
		stack = stack[:len(stack)-1]

		visitedInts = append(visitedInts, current.Val)

		// Use the right node
		current = current.Right
	}

	return visitedInts
}
