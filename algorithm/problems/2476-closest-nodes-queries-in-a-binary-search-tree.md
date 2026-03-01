# 2476 Closest Nodes Queries in a Binary Search Tree

## Problem Description

You are given the root of a binary search tree (BST) and an array `queries`.

For each query `queries[i]`, find the node in the BST with the value closest to `queries[i]`. If there are two nodes with equal distance, return the node with the smaller value.

Return a list of answers where `answer[i]` is the value of the node closest to `queries[i]`.

### Example 1:
```
Input: root = [4,2,5,1,3], queries = [3,6,8]
Output: [3,5,5]
Explanation:
- For query 3: the closest node is 3 (distance 0)
- For query 6: the closest nodes are 5 (distance 1) and 7 (doesn't exist), so return 5
- For query 8: the closest node is 5 (distance 3)
```

### Example 2:
```
Input: root = [1,2,3], queries = [2,3,4]
Output: [2,3,3]
Explanation:
- For query 2: the closest node is 2 (distance 0)
- For query 3: the closest node is 3 (distance 0)
- For query 4: the closest node is 3 (distance 1)
```

## The Twist

Finding the **closest nodes** for multiple queries in a BST. This involves using binary search to efficiently locate the closest values for each query.

## Algorithm

### Binary Search Approach:
1. Perform an in-order traversal to get all node values in sorted order
2. For each query:
   - Use binary search to find the insertion position of the query value
   - Check the value at the insertion position and the previous position
   - Return the one with the smaller distance to the query
3. Return the results for all queries

The key insight is that by performing an in-order traversal, we get a sorted array of all node values, allowing us to use binary search to efficiently find the closest value for each query.

## Complexity

- **Time**: O(n + q log n) - in-order traversal and binary searches
- **Space**: O(n) - space for the sorted values

## Solution Code

```go
package main

import (
	"fmt"
	"sort"
)

type TreeNode struct {
	Val   int
	Left  *TreeNode
	Right *TreeNode
}

func closestNodes(root *TreeNode, queries []int) [][]int {
	// In-order traversal to get all node values in sorted order
	var values []int
	var inorder func(node *TreeNode)
	inorder = func(node *TreeNode) {
		if node == nil {
			return
		}
		inorder(node.Left)
		values = append(values, node.Val)
		inorder(node.Right)
	}
	inorder(root)
	
	result := make([][]int, len(queries))
	
	for i, query := range queries {
		// Binary search for the closest value
		pos := sort.SearchInts(values, query)
		
		closest := -1
		minDiff := 1 << 30
		
		// Check value at position pos (if exists)
		if pos < len(values) {
			diff := values[pos] - query
			if diff < 0 {
				diff = -diff
			}
			if diff < minDiff {
				minDiff = diff
				closest = values[pos]
			}
		}
		
		// Check value at position pos-1 (if exists)
		if pos > 0 {
			diff := values[pos-1] - query
			if diff < 0 {
				diff = -diff
			}
			if diff < minDiff {
				minDiff = diff
				closest = values[pos-1]
			}
		}
		
		result[i] = []int{closest}
	}
	
	return result
}
```

## Link

[LeetCode 2476 Closest Nodes Queries in a Binary Search Tree](https://leetcode.com/problems/closest-nodes-queries-in-a-binary-search-tree/)