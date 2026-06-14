package algo

import "hungknow.com/algo/models"

// Problem: https://github.com/hungknow/tech-journey/blob/main/algorithm/problems/0501-find-mode-in-binary-search-tree.md
//
// Given the root of a binary search tree (BST) with duplicates, return all the mode(s)
// (i.e., the most frequently occurred element) in it.
//
// If the tree has more than one mode, return them in any order.

// FindModeInBST returns all the mode(s) (most frequently occurred element) in a BST with duplicates.
// This function uses the inorder traversal approach to efficiently find the modes.
// Time: O(n) where n is the number of nodes in the tree
// Space: O(1) additional space (excluding the output)
func FindModeInBST(root *models.BinaryTreeNode[int]) []int {
	queue := []*models.BinaryTreeNode[int]{}
	currentNode := root

	maxCount := 0
	currentCount := 0
	currentVal := 0
	firstNode := true
	results := []int{}

	for currentNode != nil || len(queue) > 0 {
		for currentNode != nil {
			queue = append(queue, currentNode)
			currentNode = currentNode.Left
		}

		currentNode = queue[len(queue)-1]
		queue = queue[:len(queue)-1]

		if firstNode || currentVal != currentNode.Val {
			currentVal = currentNode.Val
			currentCount = 1
			firstNode = false
		}

		if currentVal == currentNode.Val {
			currentCount++
		}
		if currentCount > maxCount {
			maxCount = currentCount
			results = []int{currentVal}
		} else if currentCount == maxCount {
			results = append(results, currentVal)
		}

		currentNode = currentNode.Right
	}

	return results
}

// FindModeInBSTUsingHash returns all the mode(s) using a hash map approach.
// Time: O(n) where n is the number of nodes in the tree
// Space: O(n) for the hash map
func FindModeInBSTUsingHash(root *models.BinaryTreeNode[int]) []int {
	freqMap := make(map[int]int)

	queue := make([]*models.BinaryTreeNode[int], 0)
	if root != nil {
		queue = append(queue, root)
	}

	for len(queue) > 0 {
		node := queue[len(queue)-1]
		queue = queue[:len(queue)-1]

		freqMap[node.Val]++

		if node.Right != nil {
			queue = append(queue, node.Right)
		}

		if node.Left != nil {
			queue = append(queue, node.Left)
		}
	}

	maxFreq := 0
	for _, freq := range freqMap {
		if freq > maxFreq {
			maxFreq = freq
		}
	}

	results := make([]int, 0)
	for val, freq := range freqMap {
		if freq == maxFreq {
			results = append(results, val)
		}
	}
	return results
}

// Solution0501A returns all the mode(s) (most frequently occurred element) in a BST with duplicates.
// This function uses the iterative inorder traversal approach to efficiently find the modes.
// Time: O(n) where n is the number of nodes in the tree
// Space: O(h) where h is the height of the tree (for the stack)
func Solution0501A(root *models.BinaryTreeNode[int]) []int {
	if root == nil {
		return []int{}
	}

	var result []int
	stack := make([]*models.BinaryTreeNode[int], 0)
	current := root
	currentVal := 0
	currentCount := 0
	maxCount := 0
	firstNode := true

	// Iterative inorder traversal
	for current != nil || len(stack) > 0 {
		// Go to the leftmost node
		for current != nil {
			stack = append(stack, current)
			current = current.Left
		}

		// Pop the node from stack
		current = stack[len(stack)-1]
		stack = stack[:len(stack)-1]

		// Process current node
		if firstNode || current.Val != currentVal {
			currentVal = current.Val
			currentCount = 1
			firstNode = false
		} else {
			currentCount++
		}

		if currentCount > maxCount {
			maxCount = currentCount
			result = []int{currentVal}
		} else if currentCount == maxCount {
			result = append(result, currentVal)
		}

		// Move to right subtree
		current = current.Right
	}

	return result
}

// Solution0501B returns all the mode(s) using a hash map approach with iterative traversal.
// Time: O(n) where n is the number of nodes in the tree
// Space: O(n) for the hash map and stack
func Solution0501B(root *models.BinaryTreeNode[int]) []int {
	if root == nil {
		return []int{}
	}

	// Count frequencies using a hash map
	freqMap := make(map[int]int)

	// Iterative traversal using a stack
	stack := make([]*models.BinaryTreeNode[int], 0)
	if root != nil {
		stack = append(stack, root)
	}

	for len(stack) > 0 {
		// Pop the node from stack
		node := stack[len(stack)-1]
		stack = stack[:len(stack)-1]

		// Count the frequency
		freqMap[node.Val]++

		// Push right child first (so left is processed first)
		if node.Right != nil {
			stack = append(stack, node.Right)
		}

		// Push left child
		if node.Left != nil {
			stack = append(stack, node.Left)
		}
	}

	// Find the maximum frequency
	maxFreq := 0
	for _, freq := range freqMap {
		if freq > maxFreq {
			maxFreq = freq
		}
	}

	// Collect all values with maximum frequency
	var result []int
	for val, freq := range freqMap {
		if freq == maxFreq {
			result = append(result, val)
		}
	}

	return result
}
