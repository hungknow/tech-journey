package algo_test

import (
	"reflect"
	"testing"

	"hungknow.com/algo"
	"hungknow.com/algo/models"
)

func TestPostorderTraversal_Example1(t *testing.T) {
	// Input: root = [1,null,2,3]
	// Tree structure:
	//     1
	//      \
	//       2
	//      /
	//     3
	// Output: [3,2,1]
	values := []interface{}{1, nil, 2, 3}
	root := models.BuildBinaryTreeFromIntArray(values)
	expected := []int{3, 2, 1}

	result := algo.PostorderTraversal(root)

	if !reflect.DeepEqual(result, expected) {
		t.Errorf("Expected %v, but got %v", expected, result)
	}
}

func TestPostorderTraversal_Example2(t *testing.T) {
	// Input: root = []
	// Output: []
	var root *models.BinaryTreeNode[int]
	expected := []int{}

	result := algo.PostorderTraversal(root)

	if !reflect.DeepEqual(result, expected) {
		t.Errorf("Expected %v, but got %v", expected, result)
	}
}

func TestPostorderTraversal_Example3(t *testing.T) {
	// Input: root = [1]
	// Output: [1]
	values := []interface{}{1}
	root := models.BuildBinaryTreeFromIntArray(values)
	expected := []int{1}

	result := algo.PostorderTraversal(root)

	if !reflect.DeepEqual(result, expected) {
		t.Errorf("Expected %v, but got %v", expected, result)
	}
}

func TestPostorderTraversal_CompleteTree(t *testing.T) {
	// Tree structure:
	//       4
	//      / \
	//     2   6
	//    / \ / \
	//   1  3 5  7
	// Output: [1,3,2,5,7,6,4]
	values := []interface{}{4, 2, 6, 1, 3, 5, 7}
	root := models.BuildBinaryTreeFromIntArray(values)
	expected := []int{1, 3, 2, 5, 7, 6, 4}

	result := algo.PostorderTraversal(root)

	if !reflect.DeepEqual(result, expected) {
		t.Errorf("Expected %v, but got %v", expected, result)
	}
}

func TestPostorderTraversal_LeftSkewed(t *testing.T) {
	// Tree structure:
	//     3
	//    /
	//   2
	//  /
	// 1
	// Output: [1,2,3]
	values := []interface{}{3, 2, nil, 1}
	root := models.BuildBinaryTreeFromIntArray(values)
	expected := []int{1, 2, 3}

	result := algo.PostorderTraversal(root)

	if !reflect.DeepEqual(result, expected) {
		t.Errorf("Expected %v, but got %v", expected, result)
	}
}

func TestPostorderTraversal_RightSkewed(t *testing.T) {
	// Tree structure:
	// 1
	//  \
	//   2
	//    \
	//     3
	// Output: [3,2,1]
	values := []interface{}{1, nil, 2, nil, 3}
	root := models.BuildBinaryTreeFromIntArray(values)
	expected := []int{3, 2, 1}

	result := algo.PostorderTraversal(root)

	if !reflect.DeepEqual(result, expected) {
		t.Errorf("Expected %v, but got %v", expected, result)
	}
}

func TestPostorderTraversal_Iterative_Example1(t *testing.T) {
	values := []interface{}{1, nil, 2, 3}
	root := models.BuildBinaryTreeFromIntArray(values)
	expected := []int{3, 2, 1}

	result := algo.PostorderTraversalIterative(root)

	if !reflect.DeepEqual(result, expected) {
		t.Errorf("Expected %v, but got %v", expected, result)
	}
}

func TestPostorderTraversal_Iterative_Empty(t *testing.T) {
	var root *models.BinaryTreeNode[int]
	expected := []int{}

	result := algo.PostorderTraversalIterative(root)

	if !reflect.DeepEqual(result, expected) {
		t.Errorf("Expected %v, but got %v", expected, result)
	}
}

func TestPostorderTraversal_Iterative_SingleNode(t *testing.T) {
	values := []interface{}{1}
	root := models.BuildBinaryTreeFromIntArray(values)
	expected := []int{1}

	result := algo.PostorderTraversalIterative(root)

	if !reflect.DeepEqual(result, expected) {
		t.Errorf("Expected %v, but got %v", expected, result)
	}
}
