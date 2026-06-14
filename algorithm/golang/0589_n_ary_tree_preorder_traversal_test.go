package algo_test

import (
	"reflect"
	"testing"

	"hungknow.com/algo"
	"hungknow.com/algo/models"
)

func TestNaryTreePreorderTraversal0589_Example1(t *testing.T) {
	// Input: root = [1,null,3,2,4,null,5,6]
	// Tree structure:
	//       1
	//     / | \
	//    3  2  4
	//       / \
	//      5   6
	// Output: [1,3,5,6,2,4]
	input := []interface{}{1, nil, 3, 2, 4, nil, 5, 6}
	root := models.BuildNAryNodeFromIntArray(input)
	expected := []int{1, 3, 5, 6, 2, 4}

	result := algo.NaryTreePreorderTraversal0589(root)

	if !reflect.DeepEqual(result, expected) {
		t.Errorf("Expected %v, but got %v", expected, result)
	}
}

func TestNaryTreePreorderTraversal0589_Example2(t *testing.T) {
	// Input: root = [1,null,2,3,4,5,null,null,6,7,null,8,null,9,10,null,null,11,null,12,null,13,null,null,14]
	// Tree structure (level order):
	//              1
	//         /  /  \  \
	//        2   3   4   5
	//           / \  |  / \
	//          6   7 8 9   10
	//          |   | |  \
	//         11  12 13  14
	// Output: [1, 2, 3, 6, 7, 11, 14, 4, 8, 12, 5, 9, 13, 10]
	input := []interface{}{1, nil, 2, 3, 4, 5, nil, nil, 6, 7, nil, 8, nil, 9, 10, nil, nil, 11, nil, 12, nil, 13, nil, nil, 14}
	root := models.BuildNAryNodeFromIntArray(input)
	expected := []int{1, 2, 3, 6, 7, 11, 14, 4, 8, 12, 5, 9, 13, 10}

	result := algo.NaryTreePreorderTraversal0589(root)

	if !reflect.DeepEqual(result, expected) {
		t.Errorf("Expected %v, but got %v", expected, result)
	}
}

func TestNaryTreePreorderTraversal0589_EmptyTree(t *testing.T) {
	var root *models.NAryNode[int]
	expected := []int{}

	result := algo.NaryTreePreorderTraversal0589(root)

	if !reflect.DeepEqual(result, expected) {
		t.Errorf("Expected %v, but got %v", expected, result)
	}
}

func TestNaryTreePreorderTraversal0589_SingleNode(t *testing.T) {
	// Input: root = [1]
	// Output: [1]
	input := []interface{}{1}
	root := models.BuildNAryNodeFromIntArray(input)
	expected := []int{1}

	result := algo.NaryTreePreorderTraversal0589(root)

	if !reflect.DeepEqual(result, expected) {
		t.Errorf("Expected %v, but got %v", expected, result)
	}
}

func TestNaryTreePreorderTraversal0589_TwoLevels(t *testing.T) {
	// Input: root = [1,null,2,3]
	// Tree: 1 has children 2, 3
	// Output: [1,2,3]
	input := []interface{}{1, nil, 2, 3}
	root := models.BuildNAryNodeFromIntArray(input)
	expected := []int{1, 2, 3}

	result := algo.NaryTreePreorderTraversal0589(root)

	if !reflect.DeepEqual(result, expected) {
		t.Errorf("Expected %v, but got %v", expected, result)
	}
}

func TestNaryTreePreorderTraversal0589_ThreeLevels(t *testing.T) {
	// Input: root = [1,null,2,null,3,null,4]
	// Tree: 1 -> 2 -> 3 -> 4 (each has one child)
	// Output: [1,2,3,4]
	input := []interface{}{1, nil, 2, nil, 3, nil, 4}
	root := models.BuildNAryNodeFromIntArray(input)
	expected := []int{1, 2, 3, 4}

	result := algo.NaryTreePreorderTraversal0589(root)

	if !reflect.DeepEqual(result, expected) {
		t.Errorf("Expected %v, but got %v", expected, result)
	}
}
