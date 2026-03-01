# 0894 All Possible Full Binary Trees

## Problem Description

Given an integer `n`, return all the structurally unique **Full Binary Trees** (FBT) that have exactly `n` nodes.

### Example 1:
```
Input: n = 3
Output: [[0,null,0,0],[0,null,0,0],[0,0,0,null,null]]
Explanation: All the possible full binary trees with 3 nodes are shown.
```

### Example 2:
```
Input: n = 1
Output: [[0,null,null]]
```

## The Twist

Generating all **structurally unique full binary trees** with `n` nodes. This is a recursive problem where we build all possible left and right subtrees.

## Algorithm

### Recursive Tree Construction:
1. For each possible number of nodes in left subtree (from 0 to n-1):
   - Recursively generate all possible left subtrees
2. For each possible number of nodes in right subtree (from 0 to n-1-leftNodes):
   - Recursively generate all possible right subtrees
3. Combine current node with each combination of left and right subtrees
4. Use memoization to avoid recomputation

## Complexity

- **Time**: O(4^n / n^(3/2)) - Catalan number of trees
- **Space**: O(4^n / n^(3/2)) - storing all trees

## Solution Code

```go
package main

func allPossibleFBT(n int) [][]*TreeNode {
	if n == 0 {
		return [][]*TreeNode{nil}
	}
	
	memo := make(map[int][][]*TreeNode)
	return generateTrees(1, n, memo)
}

func generateTrees(start, end int, memo map[int][][]*TreeNode) [][]*TreeNode {
	if start > end {
		return [][]*TreeNode{nil}
	}
	
	if key, exists := memo[start]; exists {
		return memo[start]
	}
	
	var result [][]*TreeNode
	
	for leftNodes := 0; leftNodes <= end-start; leftNodes++ {
		rightNodes := end - start - leftNodes
		leftSubtrees := generateTrees(start, start+leftNodes, memo)
		rightSubtrees := generateTrees(start+leftNodes+1, end, memo)
		
		for _, left := range leftSubtrees {
			for _, right := range rightSubtrees {
				node := &TreeNode{Val: start, Left: left, Right: right}
				result = append(result, node)
			}
		}
	}
	
	memo[start] = result
	return result
}

type TreeNode struct {
	Val   int
	Left  *TreeNode
	Right *TreeNode
}
```

## Link

[LeetCode 0894 All Possible Full Binary Trees](https://leetcode.com/problems/all-possible-full-binary-trees/)
