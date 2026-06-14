package algo

import "hungknow.com/algo/models"

// Problem: https://github.com/hungknow/tech-journey/blob/main/algorithm/problems/0589-n-ary-tree-preorder-traversal.md
//
// Given the root of an n-ary tree, return the preorder traversal of its nodes' values.
//
// N-ary tree input serialization is represented in their level order traversal,
// and each group of children is separated by the null value.

// NaryTreePreorderTraversal0589 returns the preorder traversal of an n-ary tree.
// Implement this function yourself.
func NaryTreePreorderTraversal0589(root *models.NAryNode[int]) []int {
	results := make([]int, 0)
	queue := []*models.NAryNode[int]{root}
	if root == nil {
		return results
	}

	for len(queue) > 0 {
		node := queue[len(queue)-1]
		queue = queue[:len(queue)-1]

		results = append(results, node.Val)

		for idx := len(node.Children) - 1; idx >= 0; idx-- {
			queue = append(queue, node.Children[idx])
		}
	}
	return results
}

// NaryTreePreorderTraversal0589Recursive is the reference solution using recursion.
// Time: O(n), Space: O(h) where h is the height of the tree.
func NaryTreePreorderTraversal0589Recursive(root *models.NAryNode[int]) []int {
	result := make([]int, 0)

	if root == nil {
		return result
	}

	// Add root value to result
	result = append(result, root.Val)

	// Recursively traverse all children
	for _, child := range root.Children {
		result = append(result, NaryTreePreorderTraversal0589Recursive(child)...)
	}

	return result
}

// NaryTreePreorderTraversal0589Iterative is the reference solution using a stack.
// Time: O(n), Space: O(n) for the stack.
func NaryTreePreorderTraversal0589Iterative(root *models.NAryNode[int]) []int {
	result := make([]int, 0)

	if root == nil {
		return result
	}

	// Initialize stack with root
	stack := []*models.NAryNode[int]{root}

	for len(stack) > 0 {
		// Pop the last node
		node := stack[len(stack)-1]
		stack = stack[:len(stack)-1]

		// Add node value to result
		result = append(result, node.Val)

		// Push children onto stack in reverse order (so leftmost is processed first)
		for i := len(node.Children) - 1; i >= 0; i-- {
			stack = append(stack, node.Children[i])
		}
	}

	return result
}
