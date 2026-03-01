# 1483 Kth Ancestor of a Tree Node

## Problem Description

You are given a tree with `n` nodes numbered from `0` to `n - 1` in the form of a parent array `parent` where `parent[i]` is the parent of the `i`th node. The root of the tree is node `0`.

Implement the class `TreeAncestor`:

- `TreeAncestor(int n, int[] parent)` Initializes the object with the number of nodes in the tree and the parent array.
- `int getKthAncestor(int node, int k)` Returns the kth ancestor of the given node. If there is no such ancestor, return -1.

### Example 1:
```
Input
["TreeAncestor","getKthAncestor","getKthAncestor","getKthAncestor"]
[[7,[-1,0,0,1,1,2,2]],[3,1],[5,2],[6,3]]
Output
[null,1,0,-1]

Explanation
TreeAncestor treeAncestor = new TreeAncestor(7, [-1, 0, 0, 1, 1, 2, 2]);
treeAncestor.getKthAncestor(3, 1);  // returns 1 which is the parent of 3
treeAncestor.getKthAncestor(5, 2);  // returns 0 which is the grandparent of 5
treeAncestor.getKthAncestor(6, 3);  // returns -1 because there is no such ancestor
```

## The Twist

Implementing an efficient data structure to find the kth ancestor of a node in a tree, supporting multiple queries efficiently.

## Algorithm

### Binary Lifting Approach:
1. Preprocess the tree to create a binary lifting table
2. For each node, store its 2^j-th ancestor for all j up to log(n)
3. For TreeAncestor(n, parent):
   - Initialize a table of size n x log(n)
   - Fill the table using dynamic programming:
     - table[i][0] = parent[i]
     - table[i][j] = table[table[i][j-1]][j-1] if table[i][j-1] != -1
4. For getKthAncestor(node, k):
   - For each bit set in k:
     - Move up the tree by 2^j where j is the bit position
     - If the ancestor doesn't exist, return -1
   - Return the final ancestor

The key insight is using binary lifting to jump up the tree in powers of two, enabling O(log n) query time.

## Complexity

- **Time**: 
  - TreeAncestor constructor: O(n * logn)
  - getKthAncestor: O(logn)
- **Space**: O(n * logn) for the binary lifting table

## Solution Code

```go
package main

type TreeAncestor struct {
	up    [][]int
	logN  int
}

func Constructor(n int, parent []int) TreeAncestor {
	// Calculate logN
	logN := 1
	for (1 << logN) <= n {
		logN++
	}
	
	// Initialize binary lifting table
	up := make([][]int, n)
	for i := range up {
		up[i] = make([]int, logN)
		for j := range up[i] {
			up[i][j] = -1
		}
	}
	
	// Fill the table
	for i := 0; i < n; i++ {
		up[i][0] = parent[i]
	}
	
	for j := 1; j < logN; j++ {
		for i := 0; i < n; i++ {
			if up[i][j-1] != -1 {
				up[i][j] = up[up[i][j-1]][j-1]
			}
		}
	}
	
	return TreeAncestor{
		up:   up,
		logN: logN,
	}
}

func (this *TreeAncestor) GetKthAncestor(node int, k int) int {
	for j := 0; j < this.logN; j++ {
		if (k & (1 << j)) != 0 {
			node = this.up[node][j]
			if node == -1 {
				return -1
			}
		}
	}
	return node
}

/**
 * Your TreeAncestor object will be instantiated and called as such:
 * obj := Constructor(n, parent);
 * param_1 := obj.GetKthAncestor(node,k);
 */
```

## Link

[LeetCode 1483 Kth Ancestor of a Tree Node](https://leetcode.com/problems/kth-ancestor-of-a-tree-node/)