package algo_test

import (
	"testing"

	"github.com/stretchr/testify/assert"

	"hungknow.com/algo"
	"hungknow.com/algo/models"
)

// Helper function to perform inorder traversal and collect values
func inorderTraversal(root *models.BinaryTreeNode[int]) []int {
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

// Helper function to check if a tree is a valid BST
func isValidBST(root *models.BinaryTreeNode[int]) bool {
	return validateBST(root, nil, nil)
}

func validateBST(node *models.BinaryTreeNode[int], min, max *int) bool {
	if node == nil {
		return true
	}

	if min != nil && node.Val <= *min {
		return false
	}
	if max != nil && node.Val >= *max {
		return false
	}

	return validateBST(node.Left, min, &node.Val) && validateBST(node.Right, &node.Val, max)
}

// Helper function to compare two trees
func assertEqualTrees(t *testing.T, actual, expected *models.BinaryTreeNode[int]) {
	if expected == nil {
		assert.Nil(t, actual)
		return
	}

	if actual == nil {
		t.Errorf("expected node to exist, but got nil")
		return
	}

	assert.Equal(t, expected.Val, actual.Val)
	assertEqualTrees(t, actual.Left, expected.Left)
	assertEqualTrees(t, actual.Right, expected.Right)
}

func TestRecoverTree_Example1(t *testing.T) {
	// Input: root = [1,3,null,null,2]
	// Output: [3,1,null,null,2]
	// Explanation: 2 and 3 were swapped.
	input := []interface{}{1, 3, nil, nil, 2}
	root := models.BuildBinaryTreeFromIntArray(input)

	// Before recovery, inorder should be [3,2,1] (not sorted)
	beforeRecovery := inorderTraversal(root)
	t.Logf("Before recovery: %v", beforeRecovery)

	algo.RecoverTree(root)

	// After recovery, inorder should be [1,2,3] (sorted)
	afterRecovery := inorderTraversal(root)
	expectedInorder := []int{1, 2, 3}
	assert.Equal(t, expectedInorder, afterRecovery)
	assert.True(t, isValidBST(root), "Tree should be a valid BST after recovery")
}

func TestRecoverTree_Example2(t *testing.T) {
	// Input: root = [3,1,4,null,null,2]
	// Output: [2,1,4,null,null,3]
	// Explanation: 2 and 3 were swapped.
	input := []interface{}{3, 1, 4, nil, nil, 2}
	root := models.BuildBinaryTreeFromIntArray(input)

	// Before recovery, inorder should be [1,3,2,4] (not sorted)
	beforeRecovery := inorderTraversal(root)
	t.Logf("Before recovery: %v", beforeRecovery)

	algo.RecoverTree(root)

	// After recovery, inorder should be [1,2,3,4] (sorted)
	afterRecovery := inorderTraversal(root)
	expectedInorder := []int{1, 2, 3, 4}
	assert.Equal(t, expectedInorder, afterRecovery)
	assert.True(t, isValidBST(root), "Tree should be a valid BST after recovery")
}

func TestRecoverTree_AdjacentNodesSwapped(t *testing.T) {
	// Test case where adjacent nodes are swapped
	// Valid BST: [2,1,3] -> Swapped: [1,2,3] (root and left child swapped)
	input := []interface{}{2, 1, 3}
	root := models.BuildBinaryTreeFromIntArray(input)

	// Swap root and left child values
	root.Val, root.Left.Val = root.Left.Val, root.Val

	// Before recovery, inorder should be [2,1,3] (not sorted)
	beforeRecovery := inorderTraversal(root)
	t.Logf("Before recovery: %v", beforeRecovery)

	algo.RecoverTree(root)

	// After recovery, inorder should be [1,2,3] (sorted)
	afterRecovery := inorderTraversal(root)
	expectedInorder := []int{1, 2, 3}
	assert.Equal(t, expectedInorder, afterRecovery)
	assert.True(t, isValidBST(root), "Tree should be a valid BST after recovery")
}

func TestRecoverTree_NonAdjacentNodesSwapped(t *testing.T) {
	// Test case where non-adjacent nodes are swapped
	// Valid BST: [4,2,6,1,3,5,7] -> Swap 2 and 6
	input := []interface{}{4, 2, 6, 1, 3, 5, 7}
	root := models.BuildBinaryTreeFromIntArray(input)

	// Swap left child (2) and right child (6) of root
	root.Left.Val, root.Right.Val = root.Right.Val, root.Left.Val

	// Before recovery, inorder should be [1,6,3,4,5,2,7] (not sorted)
	beforeRecovery := inorderTraversal(root)
	t.Logf("Before recovery: %v", beforeRecovery)

	algo.RecoverTree(root)

	// After recovery, inorder should be [1,2,3,4,5,6,7] (sorted)
	afterRecovery := inorderTraversal(root)
	expectedInorder := []int{1, 2, 3, 4, 5, 6, 7}
	assert.Equal(t, expectedInorder, afterRecovery)
	assert.True(t, isValidBST(root), "Tree should be a valid BST after recovery")
}

func TestRecoverTree_LeafNodesSwapped(t *testing.T) {
	// Test case where two leaf nodes are swapped
	// Valid BST: [3,1,5,null,2,4,6] -> Swap 2 and 4
	input := []interface{}{3, 1, 5, nil, 2, 4, 6}
	root := models.BuildBinaryTreeFromIntArray(input)

	// Find and swap leaf nodes 2 and 4
	leftLeaf := root.Left.Right
	rightLeaf := root.Right.Left
	leftLeaf.Val, rightLeaf.Val = rightLeaf.Val, leftLeaf.Val

	// Before recovery, inorder should be [1,4,3,2,5,6] (not sorted)
	beforeRecovery := inorderTraversal(root)
	t.Logf("Before recovery: %v", beforeRecovery)

	algo.RecoverTree(root)

	// After recovery, inorder should be [1,2,3,4,5,6] (sorted)
	afterRecovery := inorderTraversal(root)
	expectedInorder := []int{1, 2, 3, 4, 5, 6}
	assert.Equal(t, expectedInorder, afterRecovery)
	assert.True(t, isValidBST(root), "Tree should be a valid BST after recovery")
}

func TestRecoverTree_TwoNodesOnly(t *testing.T) {
	// Test case with only two nodes
	// Valid BST: [1,null,2] -> Swapped: [2,null,1]
	input := []interface{}{1, nil, 2}
	root := models.BuildBinaryTreeFromIntArray(input)

	// Swap root and right child values
	root.Val, root.Right.Val = root.Right.Val, root.Val

	// Before recovery, inorder should be [2,1] (not sorted)
	beforeRecovery := inorderTraversal(root)
	t.Logf("Before recovery: %v", beforeRecovery)

	algo.RecoverTree(root)

	// After recovery, inorder should be [1,2] (sorted)
	afterRecovery := inorderTraversal(root)
	expectedInorder := []int{1, 2}
	assert.Equal(t, expectedInorder, afterRecovery)
	assert.True(t, isValidBST(root), "Tree should be a valid BST after recovery")
}

func TestRecoverTree_LeftSkewedTree(t *testing.T) {
	// Test case with left-skewed tree
	// Valid BST: [4,3,null,2,null,1] -> Swap 1 and 4
	input := []interface{}{4, 3, nil, 2, nil, 1}
	root := models.BuildBinaryTreeFromIntArray(input)

	// Swap root (4) and deepest leaf (1)
	deepest := root.Left.Left.Left
	root.Val, deepest.Val = deepest.Val, root.Val

	// Before recovery, inorder should be [1,2,3,4] (not sorted)
	beforeRecovery := inorderTraversal(root)
	t.Logf("Before recovery: %v", beforeRecovery)

	algo.RecoverTree(root)

	// After recovery, inorder should be [1,2,3,4] (sorted)
	afterRecovery := inorderTraversal(root)
	expectedInorder := []int{1, 2, 3, 4}
	assert.Equal(t, expectedInorder, afterRecovery)
	assert.True(t, isValidBST(root), "Tree should be a valid BST after recovery")
}

func TestRecoverTree_RightSkewedTree(t *testing.T) {
	// Test case with right-skewed tree
	// Valid BST: [1,null,2,null,3,null,4] -> Swap 1 and 4
	input := []interface{}{1, nil, 2, nil, nil, nil, 3, nil, nil, nil, nil, nil, nil, 4}
	root := models.BuildBinaryTreeFromIntArray(input)

	// Swap root (1) and deepest leaf (4)
	deepest := root.Right.Right.Right
	root.Val, deepest.Val = deepest.Val, root.Val

	// Before recovery, inorder should be [4,2,3,1] (not sorted)
	beforeRecovery := inorderTraversal(root)
	t.Logf("Before recovery: %v", beforeRecovery)

	algo.RecoverTree(root)

	// After recovery, inorder should be [1,2,3,4] (sorted)
	afterRecovery := inorderTraversal(root)
	expectedInorder := []int{1, 2, 3, 4}
	assert.Equal(t, expectedInorder, afterRecovery)
	assert.True(t, isValidBST(root), "Tree should be a valid BST after recovery")
}

func TestRecoverTree_NegativeValues(t *testing.T) {
	// Test case with negative values
	// Valid BST: [-2,-4,-1,-5,-3,null,0] -> Swap -5 and 0
	input := []interface{}{-2, -4, -1, -5, -3, nil, 0}
	root := models.BuildBinaryTreeFromIntArray(input)

	// Swap -5 and 0
	leftLeaf := root.Left.Left
	rightLeaf := root.Right.Right
	leftLeaf.Val, rightLeaf.Val = rightLeaf.Val, leftLeaf.Val

	// Before recovery, inorder should be [0,-5,-4,-3,-2,-1] (not sorted)
	beforeRecovery := inorderTraversal(root)
	t.Logf("Before recovery: %v", beforeRecovery)

	algo.RecoverTree(root)

	// After recovery, inorder should be [-5,-4,-3,-2,-1,0] (sorted)
	afterRecovery := inorderTraversal(root)
	expectedInorder := []int{-5, -4, -3, -2, -1, 0}
	assert.Equal(t, expectedInorder, afterRecovery)
	assert.True(t, isValidBST(root), "Tree should be a valid BST after recovery")
}

func TestRecoverTree_LargeTree(t *testing.T) {
	// Test case with a larger tree
	// Valid BST: [8,4,12,2,6,10,14,1,3,5,7,9,11,13,15] -> Swap 3 and 13
	input := []interface{}{8, 4, 12, 2, 6, 10, 14, 1, 3, 5, 7, 9, 11, 13, 15}
	root := models.BuildBinaryTreeFromIntArray(input)

	// Find and swap 3 and 13
	node3 := root.Left.Left.Right
	node13 := root.Right.Right.Left
	node3.Val, node13.Val = node13.Val, node3.Val

	// Before recovery, inorder should be [1,2,13,4,5,6,7,8,9,10,11,12,3,14,15] (not sorted)
	beforeRecovery := inorderTraversal(root)
	t.Logf("Before recovery: %v", beforeRecovery)

	algo.RecoverTree(root)

	// After recovery, inorder should be [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15] (sorted)
	afterRecovery := inorderTraversal(root)
	expectedInorder := []int{1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15}
	assert.Equal(t, expectedInorder, afterRecovery)
	assert.True(t, isValidBST(root), "Tree should be a valid BST after recovery")
}

func TestRecoverTreeMorris_Example1(t *testing.T) {
	// Input: root = [1,3,null,null,2]
	// Output: [3,1,null,null,2]
	// Explanation: 2 and 3 were swapped.
	input := []interface{}{1, 3, nil, nil, 2}
	root := models.BuildBinaryTreeFromIntArray(input)

	// Before recovery, inorder should be [3,2,1] (not sorted)
	beforeRecovery := inorderTraversal(root)
	t.Logf("Before recovery: %v", beforeRecovery)

	algo.RecoverTreeMorris(root)

	// After recovery, inorder should be [1,2,3] (sorted)
	afterRecovery := inorderTraversal(root)
	expectedInorder := []int{1, 2, 3}
	assert.Equal(t, expectedInorder, afterRecovery)
	assert.True(t, isValidBST(root), "Tree should be a valid BST after recovery")
}

func TestRecoverTreeMorris_Example2(t *testing.T) {
	// Input: root = [3,1,4,null,null,2]
	// Output: [2,1,4,null,null,3]
	// Explanation: 2 and 3 were swapped.
	input := []interface{}{3, 1, 4, nil, nil, 2}
	root := models.BuildBinaryTreeFromIntArray(input)

	// Before recovery, inorder should be [1,3,2,4] (not sorted)
	beforeRecovery := inorderTraversal(root)
	t.Logf("Before recovery: %v", beforeRecovery)

	algo.RecoverTreeMorris(root)

	// After recovery, inorder should be [1,2,3,4] (sorted)
	afterRecovery := inorderTraversal(root)
	expectedInorder := []int{1, 2, 3, 4}
	assert.Equal(t, expectedInorder, afterRecovery)
	assert.True(t, isValidBST(root), "Tree should be a valid BST after recovery")
}

func TestRecoverTreeMorris_AdjacentNodesSwapped(t *testing.T) {
	// Test case where adjacent nodes are swapped
	// Valid BST: [2,1,3] -> Swapped: [1,2,3] (root and left child swapped)
	input := []interface{}{2, 1, 3}
	root := models.BuildBinaryTreeFromIntArray(input)

	// Swap root and left child values
	root.Val, root.Left.Val = root.Left.Val, root.Val

	// Before recovery, inorder should be [2,1,3] (not sorted)
	beforeRecovery := inorderTraversal(root)
	t.Logf("Before recovery: %v", beforeRecovery)

	algo.RecoverTreeMorris(root)

	// After recovery, inorder should be [1,2,3] (sorted)
	afterRecovery := inorderTraversal(root)
	expectedInorder := []int{1, 2, 3}
	assert.Equal(t, expectedInorder, afterRecovery)
	assert.True(t, isValidBST(root), "Tree should be a valid BST after recovery")
}

func TestRecoverTreeMorris_NonAdjacentNodesSwapped(t *testing.T) {
	// Test case where non-adjacent nodes are swapped
	// Valid BST: [4,2,6,1,3,5,7] -> Swap 2 and 6
	input := []interface{}{4, 2, 6, 1, 3, 5, 7}
	root := models.BuildBinaryTreeFromIntArray(input)

	// Swap left child (2) and right child (6) of root
	root.Left.Val, root.Right.Val = root.Right.Val, root.Left.Val

	// Before recovery, inorder should be [1,6,3,4,5,2,7] (not sorted)
	beforeRecovery := inorderTraversal(root)
	t.Logf("Before recovery: %v", beforeRecovery)

	algo.RecoverTreeMorris(root)

	// After recovery, inorder should be [1,2,3,4,5,6,7] (sorted)
	afterRecovery := inorderTraversal(root)
	expectedInorder := []int{1, 2, 3, 4, 5, 6, 7}
	assert.Equal(t, expectedInorder, afterRecovery)
	assert.True(t, isValidBST(root), "Tree should be a valid BST after recovery")
}

func TestRecoverTreeMorris_LeafNodesSwapped(t *testing.T) {
	// Test case where two leaf nodes are swapped
	// Valid BST: [3,1,5,null,2,4,6] -> Swap 2 and 4
	input := []interface{}{3, 1, 5, nil, 2, 4, 6}
	root := models.BuildBinaryTreeFromIntArray(input)

	// Find and swap leaf nodes 2 and 4
	leftLeaf := root.Left.Right
	rightLeaf := root.Right.Left
	leftLeaf.Val, rightLeaf.Val = rightLeaf.Val, leftLeaf.Val

	// Before recovery, inorder should be [1,4,3,2,5,6] (not sorted)
	beforeRecovery := inorderTraversal(root)
	t.Logf("Before recovery: %v", beforeRecovery)

	algo.RecoverTreeMorris(root)

	// After recovery, inorder should be [1,2,3,4,5,6] (sorted)
	afterRecovery := inorderTraversal(root)
	expectedInorder := []int{1, 2, 3, 4, 5, 6}
	assert.Equal(t, expectedInorder, afterRecovery)
	assert.True(t, isValidBST(root), "Tree should be a valid BST after recovery")
}

func TestRecoverTreeMorris_TwoNodesOnly(t *testing.T) {
	// Test case with only two nodes
	// Valid BST: [1,null,2] -> Swapped: [2,null,1]
	input := []interface{}{1, nil, 2}
	root := models.BuildBinaryTreeFromIntArray(input)

	// Swap root and right child values
	root.Val, root.Right.Val = root.Right.Val, root.Val

	// Before recovery, inorder should be [2,1] (not sorted)
	beforeRecovery := inorderTraversal(root)
	t.Logf("Before recovery: %v", beforeRecovery)

	algo.RecoverTreeMorris(root)

	// After recovery, inorder should be [1,2] (sorted)
	afterRecovery := inorderTraversal(root)
	expectedInorder := []int{1, 2}
	assert.Equal(t, expectedInorder, afterRecovery)
	assert.True(t, isValidBST(root), "Tree should be a valid BST after recovery")
}

func TestRecoverTreeMorris_LeftSkewedTree(t *testing.T) {
	// Test case with left-skewed tree
	// Valid BST: [4,3,null,2,null,1] -> Swap 1 and 4
	input := []interface{}{4, 3, nil, 2, nil, 1}
	root := models.BuildBinaryTreeFromIntArray(input)

	// Swap root (4) and deepest leaf (1)
	deepest := root.Left.Left.Left
	root.Val, deepest.Val = deepest.Val, root.Val

	// Before recovery, inorder should be [1,2,3,4] (not sorted)
	beforeRecovery := inorderTraversal(root)
	t.Logf("Before recovery: %v", beforeRecovery)

	algo.RecoverTreeMorris(root)

	// After recovery, inorder should be [1,2,3,4] (sorted)
	afterRecovery := inorderTraversal(root)
	expectedInorder := []int{1, 2, 3, 4}
	assert.Equal(t, expectedInorder, afterRecovery)
	assert.True(t, isValidBST(root), "Tree should be a valid BST after recovery")
}

func TestRecoverTreeMorris_RightSkewedTree(t *testing.T) {
	// Test case with right-skewed tree
	// Valid BST: [1,null,2,null,3,null,4] -> Swap 1 and 4
	input := []interface{}{1, nil, 2, nil, nil, nil, 3, nil, nil, nil, nil, nil, nil, 4}
	root := models.BuildBinaryTreeFromIntArray(input)

	// Swap root (1) and deepest leaf (4)
	deepest := root.Right.Right.Right
	root.Val, deepest.Val = deepest.Val, root.Val

	// Before recovery, inorder should be [4,2,3,1] (not sorted)
	beforeRecovery := inorderTraversal(root)
	t.Logf("Before recovery: %v", beforeRecovery)

	algo.RecoverTreeMorris(root)

	// After recovery, inorder should be [1,2,3,4] (sorted)
	afterRecovery := inorderTraversal(root)
	expectedInorder := []int{1, 2, 3, 4}
	assert.Equal(t, expectedInorder, afterRecovery)
	assert.True(t, isValidBST(root), "Tree should be a valid BST after recovery")
}

func TestRecoverTreeMorris_NegativeValues(t *testing.T) {
	// Test case with negative values
	// Valid BST: [-2,-4,-1,-5,-3,null,0] -> Swap -5 and 0
	input := []interface{}{-2, -4, -1, -5, -3, nil, 0}
	root := models.BuildBinaryTreeFromIntArray(input)

	// Swap -5 and 0
	leftLeaf := root.Left.Left
	rightLeaf := root.Right.Right
	leftLeaf.Val, rightLeaf.Val = rightLeaf.Val, leftLeaf.Val

	// Before recovery, inorder should be [0,-5,-4,-3,-2,-1] (not sorted)
	beforeRecovery := inorderTraversal(root)
	t.Logf("Before recovery: %v", beforeRecovery)

	algo.RecoverTreeMorris(root)

	// After recovery, inorder should be [-5,-4,-3,-2,-1,0] (sorted)
	afterRecovery := inorderTraversal(root)
	expectedInorder := []int{-5, -4, -3, -2, -1, 0}
	assert.Equal(t, expectedInorder, afterRecovery)
	assert.True(t, isValidBST(root), "Tree should be a valid BST after recovery")
}

func TestRecoverTreeMorris_LargeTree(t *testing.T) {
	// Test case with a larger tree
	// Valid BST: [8,4,12,2,6,10,14,1,3,5,7,9,11,13,15] -> Swap 3 and 13
	input := []interface{}{8, 4, 12, 2, 6, 10, 14, 1, 3, 5, 7, 9, 11, 13, 15}
	root := models.BuildBinaryTreeFromIntArray(input)

	// Find and swap 3 and 13
	node3 := root.Left.Left.Right
	node13 := root.Right.Right.Left
	node3.Val, node13.Val = node13.Val, node3.Val

	// Before recovery, inorder should be [1,2,13,4,5,6,7,8,9,10,11,12,3,14,15] (not sorted)
	beforeRecovery := inorderTraversal(root)
	t.Logf("Before recovery: %v", beforeRecovery)

	algo.RecoverTreeMorris(root)

	// After recovery, inorder should be [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15] (sorted)
	afterRecovery := inorderTraversal(root)
	expectedInorder := []int{1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15}
	assert.Equal(t, expectedInorder, afterRecovery)
	assert.True(t, isValidBST(root), "Tree should be a valid BST after recovery")
}
