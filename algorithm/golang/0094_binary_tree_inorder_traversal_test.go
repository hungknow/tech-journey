package algo_test

import (
	"reflect"
	"testing"

	"hungknow.com/algo"
	"hungknow.com/algo/models"
)

// Helper function to create a tree from array representation
// null values in the array represent nil nodes
func buildTree(values []interface{}) *models.BinaryTreeNode[int] {
	if len(values) == 0 || values[0] == nil {
		return nil
	}

	root := &models.BinaryTreeNode[int]{Val: values[0].(int)}
	queue := []*models.BinaryTreeNode[int]{root}
	i := 1

	for len(queue) > 0 && i < len(values) {
		node := queue[0]
		queue = queue[1:]

		// Left child
		if i < len(values) {
			if values[i] != nil {
				node.Left = &models.BinaryTreeNode[int]{Val: values[i].(int)}
				queue = append(queue, node.Left)
			}
			i++
		}

		// Right child
		if i < len(values) {
			if values[i] != nil {
				node.Right = &models.BinaryTreeNode[int]{Val: values[i].(int)}
				queue = append(queue, node.Right)
			}
			i++
		}
	}

	return root
}

func TestInorderTraversal_Example1(t *testing.T) {
	// Input: root = [1,null,2,3]
	// Tree structure:
	//     1
	//      \
	//       2
	//      /
	//     3
	// Output: [1,3,2]
	values := []interface{}{1, nil, 2, 3}
	root := models.BuildBinaryTreeFromIntArray(values)
	expected := []int{1, 3, 2}

	result := algo.InorderTraversal(root)

	if !reflect.DeepEqual(result, expected) {
		t.Errorf("Expected %v, but got %v", expected, result)
	}
}

func TestInorderTraversal_Example2(t *testing.T) {
	// Input: root = []
	// Output: []
	var root *models.BinaryTreeNode[int]
	expected := []int{}

	result := algo.InorderTraversal(root)

	if !reflect.DeepEqual(result, expected) {
		t.Errorf("Expected %v, but got %v", expected, result)
	}
}

func TestInorderTraversal_Example3(t *testing.T) {
	// Input: root = [1]
	// Output: [1]
	values := []interface{}{1}
	root := buildTree(values)
	expected := []int{1}

	result := algo.InorderTraversal(root)

	if !reflect.DeepEqual(result, expected) {
		t.Errorf("Expected %v, but got %v", expected, result)
	}
}

func TestInorderTraversal_CompleteTree(t *testing.T) {
	// Tree structure:
	//       4
	//      / \
	//     2   6
	//    / \ / \
	//   1  3 5  7
	// Output: [1,2,3,4,5,6,7]
	values := []interface{}{4, 2, 6, 1, 3, 5, 7}
	root := buildTree(values)
	expected := []int{1, 2, 3, 4, 5, 6, 7}

	result := algo.InorderTraversal(root)

	if !reflect.DeepEqual(result, expected) {
		t.Errorf("Expected %v, but got %v", expected, result)
	}
}

func TestInorderTraversal_LeftSkewed(t *testing.T) {
	// Tree structure:
	//     3
	//    /
	//   2
	//  /
	// 1
	// Output: [1,2,3]
	values := []interface{}{3, 2, nil, 1}
	root := buildTree(values)
	expected := []int{1, 2, 3}

	result := algo.InorderTraversal(root)

	if !reflect.DeepEqual(result, expected) {
		t.Errorf("Expected %v, but got %v", expected, result)
	}
}

func TestInorderTraversal_RightSkewed(t *testing.T) {
	// Tree structure:
	// 1
	//  \
	//   2
	//    \
	//     3
	// Output: [1,2,3]
	values := []interface{}{1, nil, 2, nil, 3}
	root := buildTree(values)
	expected := []int{1, 2, 3}

	result := algo.InorderTraversal(root)

	if !reflect.DeepEqual(result, expected) {
		t.Errorf("Expected %v, but got %v", expected, result)
	}
}

func TestInorderTraversal_Recursive_Example1(t *testing.T) {
	values := []interface{}{1, nil, 2, 3}
	root := buildTree(values)
	expected := []int{1, 3, 2}

	result := algo.InorderTraversalRecursive(root)

	if !reflect.DeepEqual(result, expected) {
		t.Errorf("Expected %v, but got %v", expected, result)
	}
}

func TestInorderTraversal_Recursive_Empty(t *testing.T) {
	var root *models.BinaryTreeNode[int]
	expected := []int{}

	result := algo.InorderTraversalRecursive(root)

	if !reflect.DeepEqual(result, expected) {
		t.Errorf("Expected %v, but got %v", expected, result)
	}
}

func TestInorderTraversal_Recursive_SingleNode(t *testing.T) {
	values := []interface{}{1}
	root := buildTree(values)
	expected := []int{1}

	result := algo.InorderTraversalRecursive(root)

	if !reflect.DeepEqual(result, expected) {
		t.Errorf("Expected %v, but got %v", expected, result)
	}
}

func TestInorderTraversal_Iterative_Example1(t *testing.T) {
	values := []interface{}{1, nil, 2, 3}
	root := buildTree(values)
	expected := []int{1, 3, 2}

	result := algo.InorderTraversalIterative(root)

	if !reflect.DeepEqual(result, expected) {
		t.Errorf("Expected %v, but got %v", expected, result)
	}
}

func TestInorderTraversal_Iterative_Empty(t *testing.T) {
	var root *models.BinaryTreeNode[int]
	expected := []int{}

	result := algo.InorderTraversalIterative(root)

	if !reflect.DeepEqual(result, expected) {
		t.Errorf("Expected %v, but got %v", expected, result)
	}
}

func TestInorderTraversal_Iterative_SingleNode(t *testing.T) {
	values := []interface{}{1}
	root := buildTree(values)
	expected := []int{1}

	result := algo.InorderTraversalIterative(root)

	if !reflect.DeepEqual(result, expected) {
		t.Errorf("Expected %v, but got %v", expected, result)
	}
}

func TestInorderTraversal_AllApproachesMatch(t *testing.T) {
	// Test that all three approaches produce the same result
	testCases := []struct {
		name   string
		values []interface{}
	}{
		{"Example1", []interface{}{1, nil, 2, nil, nil, 3}},
		{"CompleteTree", []interface{}{4, 2, 6, 1, 3, 5, 7}},
		{"LeftSkewed", []interface{}{3, 2, nil, 1}},
		{"RightSkewed", []interface{}{1, nil, 2, nil, 3}},
		{"SingleNode", []interface{}{1}},
		{"Empty", []interface{}{}},
	}

	for _, tc := range testCases {
		t.Run(tc.name, func(t *testing.T) {
			root := buildTree(tc.values)

			resultMorris := algo.InorderTraversal(root)
			resultRecursive := algo.InorderTraversalRecursive(root)
			resultIterative := algo.InorderTraversalIterative(root)

			if !reflect.DeepEqual(resultMorris, resultRecursive) {
				t.Errorf("Morris and Recursive results don't match: Morris=%v, Recursive=%v", resultMorris, resultRecursive)
			}
			if !reflect.DeepEqual(resultMorris, resultIterative) {
				t.Errorf("Morris and Iterative results don't match: Morris=%v, Iterative=%v", resultMorris, resultIterative)
			}
		})
	}
}
