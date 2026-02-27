package algo

import "hungknow.com/algo/models"

// Problem: https://github.com/hungknow/tech-journey/blob/main/algorithm/problems/0099-recover-binary-search-tree.md
//
// You are given the root of a binary search tree (BST), where the values of exactly two
// nodes of the tree were swapped by mistake. Recover the tree without changing its structure.
//
// In a valid BST, inorder traversal should produce sorted values. We need to identify the
// two nodes that violate this property and swap their values.

// RecoverTree recovers a BST where exactly two nodes have been swapped.
// It uses inorder traversal to find the two misplaced nodes and swaps their values.
// Time: O(n), Space: O(h) where h is the height of the tree.
func RecoverTree(root *models.BinaryTreeNode[int]) {
	// TODO: Implement the function to recover the BST
	//
	// Algorithm:
	// 1. Perform inorder traversal while tracking previous node
	// 2. Find the first violation: node where prev.val > curr.val (first misplaced node)
	// 3. Find the second violation: the next node where prev.val > curr.val (second misplaced node)
	// 4. Swap the values of the two misplaced nodes
	RecoverTreeIterative(root)
}

func RecoverTreeIterative(root *models.BinaryTreeNode[int]) {
	current := root
	stack := []*models.BinaryTreeNode[int]{root}
	var wrongLink1, wrongLink2 *models.BinaryTreeNode[int]
	var lastNode *models.BinaryTreeNode[int]

	for current != nil || len(stack) > 0 {
		for current != nil {
			stack = append(stack, current)
			current = current.Left
		}

		current = stack[len(stack)-1]
		stack = stack[:len(stack)-1]

		if lastNode != nil && lastNode.Val > current.Val {
			if wrongLink1 == nil {
				wrongLink1 = lastNode
				wrongLink2 = current
			} else {
				wrongLink2 = current
			}
		}

		lastNode = current
		current = current.Right
	}

	if wrongLink1 != nil && wrongLink2 != nil {
		// Swap the value
		temp := wrongLink1.Val
		wrongLink1.Val = wrongLink2.Val
		wrongLink2.Val = temp
	}
}

// RecoverTreeMorris recovers a BST using Morris Traversal for O(1) space complexity.
// Time: O(n), Space: O(1).
func RecoverTreeMorris(root *models.BinaryTreeNode[int]) {
	// TODO: Implement using Morris Traversal
	//
	// Algorithm:
	// 1. Use Morris inorder traversal to find the two violations
	// 2. Track first, middle, and last nodes where BST property is violated
	// 3. Swap values between first and last (or first and middle if only one violation pair)
}
