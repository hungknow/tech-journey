# 0226 Invert Binary Tree

## Problem Description

Given the `root` of a binary tree, invert the tree, and return its root.

### Example 1:
```
Input: root = [4,2,7,1,3,6,9]
Output: [4,7,2,9,6,3,1]
```

### Example 2:
```
Input: root = [2,1,3]
Output: [2,3,1]
```

### Example 3:
```
Input: root = []
Output: []
```

## The Twist

Inverting a binary tree means **swapping left and right children** at every node. This is a simple but fundamental tree operation.

## Algorithm

### Recursive Approach:
1. If root is null, return null
2. Swap left and right children
3. Recursively invert left subtree
4. Recursively invert right subtree
5. Return root

### Iterative Approach (using queue):
1. Use BFS to traverse the tree level by level
2. For each node, swap its left and right children
3. Continue until all nodes are processed

## Complexity

- **Time**: O(n) - each node visited once
- **Space**: O(h) recursive, O(w) iterative (queue width)

## Solution Code

### Go

```go
package main

/**
 * Definition for a binary tree node.
 * type TreeNode struct {
 *     Val   int
 *     Left  *TreeNode
 *     Right *TreeNode
 * }
 */
func invertTree(root *TreeNode) *TreeNode {
	if root == nil {
		return nil
	}
	root.Left, root.Right = invertTree(root.Right), invertTree(root.Left)
	return root
}

// Iterative BFS approach
func invertTreeIterative(root *TreeNode) *TreeNode {
	if root == nil {
		return nil
	}
	queue := []*TreeNode{root}
	for len(queue) > 0 {
		node := queue[0]
		queue = queue[1:]
		node.Left, node.Right = node.Right, node.Left
		if node.Left != nil {
			queue = append(queue, node.Left)
		}
		if node.Right != nil {
			queue = append(queue, node.Right)
		}
	}
	return root
}
```

### Rust

```rust
use std::cell::RefCell;
use std::collections::VecDeque;
use std::rc::Rc;

// Recursive approach
impl Solution {
    pub fn invert_tree(root: Option<Rc<RefCell<TreeNode>>>) -> Option<Rc<RefCell<TreeNode>>> {
        let node = root?;
        let mut n = node.borrow_mut();
        let left = n.left.clone();
        let right = n.right.clone();
        n.left = Self::invert_tree(right);
        n.right = Self::invert_tree(left);
        drop(n);
        Some(node)
    }
}

// Iterative BFS approach
impl Solution {
    pub fn invert_tree_iterative(root: Option<Rc<RefCell<TreeNode>>>) -> Option<Rc<RefCell<TreeNode>>> {
        let mut queue = VecDeque::new();
        if let Some(node) = root.as_ref() {
            queue.push_back(Rc::clone(node));
        }
        while let Some(node) = queue.pop_front() {
            let mut n = node.borrow_mut();
            let left = n.left.take();
            let right = n.right.take();
            if let Some(child) = left.as_ref() {
                queue.push_back(Rc::clone(child));
            }
            if let Some(child) = right.as_ref() {
                queue.push_back(Rc::clone(child));
            }
            n.left = right;
            n.right = left;
        }
        root
    }
}
```

## Link

[LeetCode 0226 Invert Binary Tree](https://leetcode.com/problems/invert-binary-tree/)
