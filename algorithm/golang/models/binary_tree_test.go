package models_test

import (
	"testing"

	"github.com/stretchr/testify/assert"

	"hungknow.com/algo/models"
)

func TestBuildBinaryTreeFromIntArray(t *testing.T) {
	tests := []struct {
		name     string
		input    []interface{}
		expected *models.BinaryTreeNode[int]
	}{
		{
			name:     "empty array returns nil",
			input:    []interface{}{},
			expected: nil,
		},
		{
			name:     "single node tree",
			input:    []interface{}{1},
			expected: &models.BinaryTreeNode[int]{Val: 1},
		},
		{
			name:  "tree with root and left child only",
			input: []interface{}{1, 2},
			expected: &models.BinaryTreeNode[int]{
				Val:  1,
				Left: &models.BinaryTreeNode[int]{Val: 2},
			},
		},
		{
			name:  "tree with root and right child only",
			input: []interface{}{1, nil, 3},
			expected: &models.BinaryTreeNode[int]{
				Val:   1,
				Right: &models.BinaryTreeNode[int]{Val: 3},
			},
		},
		{
			name:  "complete binary tree with 3 nodes",
			input: []interface{}{1, 2, 3},
			expected: &models.BinaryTreeNode[int]{
				Val:   1,
				Left:  &models.BinaryTreeNode[int]{Val: 2},
				Right: &models.BinaryTreeNode[int]{Val: 3},
			},
		},
		{
			name:  "complete binary tree with 7 nodes",
			input: []interface{}{1, 2, 3, 4, 5, 6, 7},
			expected: &models.BinaryTreeNode[int]{
				Val: 1,
				Left: &models.BinaryTreeNode[int]{
					Val:   2,
					Left:  &models.BinaryTreeNode[int]{Val: 4},
					Right: &models.BinaryTreeNode[int]{Val: 5},
				},
				Right: &models.BinaryTreeNode[int]{
					Val:   3,
					Left:  &models.BinaryTreeNode[int]{Val: 6},
					Right: &models.BinaryTreeNode[int]{Val: 7},
				},
			},
		},
		{
			name:  "tree with nil values in middle",
			input: []interface{}{1, 2, nil, 4},
			expected: &models.BinaryTreeNode[int]{
				Val: 1,
				Left: &models.BinaryTreeNode[int]{
					Val:  2,
					Left: &models.BinaryTreeNode[int]{Val: 4},
				},
			},
		},
		{
			name:  "tree with alternating nil and values",
			input: []interface{}{1, nil, 3, nil, nil, 6, 7},
			expected: &models.BinaryTreeNode[int]{
				Val:   1,
				Right: &models.BinaryTreeNode[int]{Val: 3},
			},
		},
		{
			name:  "left-skewed tree",
			input: []interface{}{1, 2, nil, 3, nil, nil, nil, 4},
			expected: &models.BinaryTreeNode[int]{
				Val: 1,
				Left: &models.BinaryTreeNode[int]{
					Val: 2,
					Left: &models.BinaryTreeNode[int]{
						Val: 3,
					},
				},
			},
		},
		{
			name:  "right-skewed tree",
			input: []interface{}{1, nil, 2, nil, nil, nil, 3},
			expected: &models.BinaryTreeNode[int]{
				Val:   1,
				Right: &models.BinaryTreeNode[int]{Val: 2},
			},
		},
		{
			name:  "tree with negative values",
			input: []interface{}{-1, -2, -3, -4, -5},
			expected: &models.BinaryTreeNode[int]{
				Val: -1,
				Left: &models.BinaryTreeNode[int]{
					Val:   -2,
					Left:  &models.BinaryTreeNode[int]{Val: -4},
					Right: &models.BinaryTreeNode[int]{Val: -5},
				},
				Right: &models.BinaryTreeNode[int]{Val: -3},
			},
		},
		{
			name:  "tree with zero values",
			input: []interface{}{0, 0, 0, 0},
			expected: &models.BinaryTreeNode[int]{
				Val: 0,
				Left: &models.BinaryTreeNode[int]{
					Val:  0,
					Left: &models.BinaryTreeNode[int]{Val: 0},
				},
				Right: &models.BinaryTreeNode[int]{Val: 0},
			},
		},
		{
			name:  "complete binary tree with 15 nodes",
			input: []interface{}{1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15},
			expected: &models.BinaryTreeNode[int]{
				Val: 1,
				Left: &models.BinaryTreeNode[int]{
					Val: 2,
					Left: &models.BinaryTreeNode[int]{
						Val:   4,
						Left:  &models.BinaryTreeNode[int]{Val: 8},
						Right: &models.BinaryTreeNode[int]{Val: 9},
					},
					Right: &models.BinaryTreeNode[int]{
						Val:   5,
						Left:  &models.BinaryTreeNode[int]{Val: 10},
						Right: &models.BinaryTreeNode[int]{Val: 11},
					},
				},
				Right: &models.BinaryTreeNode[int]{
					Val: 3,
					Left: &models.BinaryTreeNode[int]{
						Val:   6,
						Left:  &models.BinaryTreeNode[int]{Val: 12},
						Right: &models.BinaryTreeNode[int]{Val: 13},
					},
					Right: &models.BinaryTreeNode[int]{
						Val:   7,
						Left:  &models.BinaryTreeNode[int]{Val: 14},
						Right: &models.BinaryTreeNode[int]{Val: 15},
					},
				},
			},
		},
		{
			name:  "tree with mixed nil and values at deeper levels",
			input: []interface{}{1, 2, 3, nil, 5, 6, nil},
			expected: &models.BinaryTreeNode[int]{
				Val: 1,
				Left: &models.BinaryTreeNode[int]{
					Val:   2,
					Right: &models.BinaryTreeNode[int]{Val: 5},
				},
				Right: &models.BinaryTreeNode[int]{
					Val:  3,
					Left: &models.BinaryTreeNode[int]{Val: 6},
				},
			},
		},
		{
			name:  "tree with trailing nil values",
			input: []interface{}{1, 2, 3, nil, 5, 6, nil, nil, nil, nil, nil, nil, nil, 15},
			expected: &models.BinaryTreeNode[int]{
				Val: 1,
				Left: &models.BinaryTreeNode[int]{
					Val:   2,
					Right: &models.BinaryTreeNode[int]{Val: 5},
				},
				Right: &models.BinaryTreeNode[int]{
					Val:  3,
					Left: &models.BinaryTreeNode[int]{Val: 6},
				},
			},
		},
		{
			name:  "large complete binary tree",
			input: []interface{}{1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16},
			expected: &models.BinaryTreeNode[int]{
				Val: 1,
				Left: &models.BinaryTreeNode[int]{
					Val: 2,
					Left: &models.BinaryTreeNode[int]{
						Val: 4,
						Left: &models.BinaryTreeNode[int]{
							Val:   8,
							Left:  &models.BinaryTreeNode[int]{Val: 16},
							Right: nil,
						},
						Right: &models.BinaryTreeNode[int]{Val: 9},
					},
					Right: &models.BinaryTreeNode[int]{
						Val:   5,
						Left:  &models.BinaryTreeNode[int]{Val: 10},
						Right: &models.BinaryTreeNode[int]{Val: 11},
					},
				},
				Right: &models.BinaryTreeNode[int]{
					Val: 3,
					Left: &models.BinaryTreeNode[int]{
						Val:   6,
						Left:  &models.BinaryTreeNode[int]{Val: 12},
						Right: &models.BinaryTreeNode[int]{Val: 13},
					},
					Right: &models.BinaryTreeNode[int]{
						Val:   7,
						Left:  &models.BinaryTreeNode[int]{Val: 14},
						Right: &models.BinaryTreeNode[int]{Val: 15},
					},
				},
			},
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			result := models.BuildBinaryTreeFromIntArray(tt.input)
			assertEqualTrees(t, result, tt.expected)
		})
	}
}

// assertEqualTrees recursively compares two binary trees for equality
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
