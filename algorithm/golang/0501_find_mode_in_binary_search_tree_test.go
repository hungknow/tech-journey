package algo_test

import (
	"reflect"
	"sort"
	"testing"

	"hungknow.com/algo"
	"hungknow.com/algo/models"
)

// Helper function to sort and compare int slices (since order of modes doesn't matter)
func sortedEqual(a, b []int) bool {
	if len(a) != len(b) {
		return false
	}

	// Create copies to avoid modifying original slices
	aCopy := make([]int, len(a))
	bCopy := make([]int, len(b))
	copy(aCopy, a)
	copy(bCopy, b)

	sort.Ints(aCopy)
	sort.Ints(bCopy)

	return reflect.DeepEqual(aCopy, bCopy)
}

func TestFindModeInBST_Example1(t *testing.T) {
	// Input: root = [1,null,2,2]
	// Tree structure:
	//     1
	//      \
	//       2
	//      /
	//     2
	// Output: [2]
	values := []interface{}{1, nil, 2, 2}
	root := models.BuildBinaryTreeFromIntArray(values)
	expected := []int{2}

	result := algo.FindModeInBST(root)

	if !sortedEqual(result, expected) {
		t.Errorf("Expected %v, but got %v", expected, result)
	}
}

func TestFindModeInBST_Example2(t *testing.T) {
	// Input: root = [0]
	// Output: [0]
	values := []interface{}{0}
	root := models.BuildBinaryTreeFromIntArray(values)
	expected := []int{0}

	result := algo.FindModeInBST(root)

	if !sortedEqual(result, expected) {
		t.Errorf("Expected %v, but got %v", expected, result)
	}
}

func TestFindModeInBST_EmptyTree(t *testing.T) {
	// Input: root = []
	// Output: []
	var root *models.BinaryTreeNode[int]
	expected := []int{}

	result := algo.FindModeInBST(root)

	if !sortedEqual(result, expected) {
		t.Errorf("Expected %v, but got %v", expected, result)
	}
}

func TestFindModeInBST_AllSameValues(t *testing.T) {
	// Tree structure:
	//     1
	//    / \
	//   1   1
	//  / \
	// 1   1
	// Output: [1]
	values := []interface{}{1, 1, 1, 1, nil, nil, nil}
	root := models.BuildBinaryTreeFromIntArray(values)
	expected := []int{1}

	result := algo.FindModeInBST(root)

	if !sortedEqual(result, expected) {
		t.Errorf("Expected %v, but got %v", expected, result)
	}
}

func TestFindModeInBST_MultipleModes(t *testing.T) {
	// Tree structure:
	//     1
	//    / \
	//   1   2
	//      / \
	//     2   3
	// Output: [1,2,3] (all appear twice)
	values := []interface{}{1, 1, 2, nil, nil, 2, 3}
	root := models.BuildBinaryTreeFromIntArray(values)
	expected := []int{1, 2}

	result := algo.FindModeInBST(root)

	if !sortedEqual(result, expected) {
		t.Errorf("Expected %v, but got %v", expected, result)
	}
}

func TestFindModeInBST_ComplexTree(t *testing.T) {
	// Tree structure:
	//       2
	//      / \
	//     1   3
	//    / \   \
	//   1   1   3
	// Output: [1] (1 appears 3 times, 2 appears once, 3 appears twice)
	values := []interface{}{2, 1, 3, 1, nil, nil, 3}
	root := models.BuildBinaryTreeFromIntArray(values)
	expected := []int{1, 3}

	result := algo.FindModeInBST(root)

	if !sortedEqual(result, expected) {
		t.Errorf("Expected %v, but got %v", expected, result)
	}
}

func TestFindModeInBSTUsingHash_Example1(t *testing.T) {
	// Input: root = [1,null,2,2]
	// Tree structure:
	//     1
	//      \
	//       2
	//      /
	//     2
	// Output: [2]
	values := []interface{}{1, nil, 2, 2}
	root := models.BuildBinaryTreeFromIntArray(values)
	expected := []int{2}

	result := algo.FindModeInBSTUsingHash(root)

	if !sortedEqual(result, expected) {
		t.Errorf("Expected %v, but got %v", expected, result)
	}
}

func TestFindModeInBSTUsingHash_Example2(t *testing.T) {
	// Input: root = [0]
	// Output: [0]
	values := []interface{}{0}
	root := models.BuildBinaryTreeFromIntArray(values)
	expected := []int{0}

	result := algo.FindModeInBSTUsingHash(root)

	if !sortedEqual(result, expected) {
		t.Errorf("Expected %v, but got %v", expected, result)
	}
}

func TestFindModeInBSTUsingHash_EmptyTree(t *testing.T) {
	// Input: root = []
	// Output: []
	var root *models.BinaryTreeNode[int]
	expected := []int{}

	result := algo.FindModeInBSTUsingHash(root)

	if !sortedEqual(result, expected) {
		t.Errorf("Expected %v, but got %v", expected, result)
	}
}

func TestFindModeInBSTUsingHash_AllSameValues(t *testing.T) {
	// Tree structure:
	//     1
	//    / \
	//   1   1
	//  / \
	// 1   1
	// Output: [1]
	values := []interface{}{1, 1, 1, 1, nil, nil, nil}
	root := models.BuildBinaryTreeFromIntArray(values)
	expected := []int{1}

	result := algo.FindModeInBSTUsingHash(root)

	if !sortedEqual(result, expected) {
		t.Errorf("Expected %v, but got %v", expected, result)
	}
}

func TestFindModeInBSTUsingHash_MultipleModes(t *testing.T) {
	// Tree structure:
	//     1
	//    / \
	//   1   2
	//      / \
	//     2   3
	// Output: [1,2,3] (all appear twice)
	values := []interface{}{1, 1, 2, nil, nil, 2, 3}
	root := models.BuildBinaryTreeFromIntArray(values)
	expected := []int{1, 2}

	result := algo.FindModeInBSTUsingHash(root)

	if !sortedEqual(result, expected) {
		t.Errorf("Expected %v, but got %v", expected, result)
	}
}

func TestFindModeInBST_BothApproachesMatch(t *testing.T) {
	// Test that both approaches produce the same result
	testCases := []struct {
		name   string
		values []interface{}
	}{
		{"Example1", []interface{}{1, nil, 2, 2}},
		{"Example2", []interface{}{0}},
		{"AllSameValues", []interface{}{1, 1, 1, 1, nil, nil, nil}},
		{"MultipleModes", []interface{}{1, 1, 2, nil, nil, 2, 3}},
		{"ComplexTree", []interface{}{2, 1, 3, 1, nil, nil, 3}},
		{"SingleNode", []interface{}{5}},
	}

	for _, tc := range testCases {
		t.Run(tc.name, func(t *testing.T) {
			root := models.BuildBinaryTreeFromIntArray(tc.values)

			resultInorder := algo.FindModeInBST(root)
			resultHash := algo.FindModeInBSTUsingHash(root)

			if !sortedEqual(resultInorder, resultHash) {
				t.Errorf("Results don't match: Inorder=%v, Hash=%v", resultInorder, resultHash)
			}
		})
	}
}
