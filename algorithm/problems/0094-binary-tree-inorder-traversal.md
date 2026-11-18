# 0094 Binary Tree Inorder Traversal

## Problem Description

Given the `root` of a binary tree, return the inorder traversal of its nodes' values.

### Example 1:
```
Input: root = [1,null,2,3]
Output: [1,3,2]
```

### Example 2:
```
Input: root = []
Output: []
```

### Example 3:
```
Input: root = [1]
Output: [1]
```

## The Twist

Inorder traversal visits nodes in the order: **left subtree → root → right subtree**. This produces a sorted order for BSTs. The challenge is to implement this efficiently, possibly using Morris Traversal for O(1) space.

## Algorithm

### Recursive Approach:
1. If root is null, return empty list
2. Recursively traverse left subtree
3. Visit root (add to result)
4. Recursively traverse right subtree

### Iterative Approach (using stack):
1. Use a stack to track nodes
2. While stack is not empty or current node is not null:
   - Go as left as possible, pushing nodes onto stack
   - Pop node, add to result
   - Move to right subtree

### Morris Traversal (O(1) space):
1. While current node is not null:
   - If current has no left child: add current to result, move to right
   - Else: find the rightmost node in left subtree
     - If its right is null: link it to current, move to left
     - Else: remove link, add current to result, move to right

## Complexity

- **Time**: O(n) - each node visited once
- **Space**: O(h) for recursive/stack, O(1) for Morris Traversal

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

// Recursive approach
func inorderTraversal(root *TreeNode) []int {
	var result []int
	var inorder func(node *TreeNode)
	inorder = func(node *TreeNode) {
		if node == nil {
			return
		}
		inorder(node.Left)
		result = append(result, node.Val)
		inorder(node.Right)
	}
	inorder(root)
	return result
}

// Iterative approach using a stack
func inorderTraversalIterative(root *TreeNode) []int {
	var result []int
	var stack []*TreeNode
	current := root
	for current != nil || len(stack) > 0 {
		// Go as left as possible, pushing nodes onto the stack
		for current != nil {
			stack = append(stack, current)
			current = current.Left
		}
		// Pop the top node, visit it, then move to its right subtree
		current = stack[len(stack)-1]
		stack = stack[:len(stack)-1]
		result = append(result, current.Val)
		current = current.Right
	}
	return result
}

// Morris Traversal (O(1) space)
func inorderTraversalMorris(root *TreeNode) []int {
	var result []int
	current := root
	for current != nil {
		if current.Left == nil {
			result = append(result, current.Val)
			current = current.Right
		} else {
			// Find the rightmost node in the left subtree (predecessor)
			predecessor := current.Left
			for predecessor.Right != nil && predecessor.Right != current {
				predecessor = predecessor.Right
			}
			if predecessor.Right == nil {
				// Create a temporary link back to current, then go left
				predecessor.Right = current
				current = current.Left
			} else {
				// Remove the temporary link, visit current, then go right
				predecessor.Right = nil
				result = append(result, current.Val)
				current = current.Right
			}
		}
	}
	return result
}
```

### Rust

```rust
use std::cell::RefCell;
use std::rc::Rc;

// Recursive approach
impl Solution {
    pub fn inorder_traversal(root: Option<Rc<RefCell<TreeNode>>>) -> Vec<i32> {
        let mut result = Vec::new();
        Self::inorder(&root, &mut result);
        result
    }

    fn inorder(node: &Option<Rc<RefCell<TreeNode>>>, result: &mut Vec<i32>) {
        if let Some(n) = node {
            let n = n.borrow();
            Self::inorder(&n.left, result);
            result.push(n.val);
            Self::inorder(&n.right, result);
        }
    }
}

// Iterative approach using a stack
impl Solution {
    pub fn inorder_traversal_iterative(root: Option<Rc<RefCell<TreeNode>>>) -> Vec<i32> {
        let mut result = Vec::new();
        let mut stack: Vec<Rc<RefCell<TreeNode>>> = Vec::new();
        let mut current = root;
        while current.is_some() || !stack.is_empty() {
            // Go as left as possible, pushing nodes onto the stack
            while let Some(node) = current {
                current = node.borrow().left.clone();
                stack.push(node);
            }
            // Pop the top node, visit it, then move to its right subtree
            if let Some(node) = stack.pop() {
                result.push(node.borrow().val);
                current = node.borrow().right.clone();
            }
        }
        result
    }
}

// Morris Traversal (O(1) space)
impl Solution {
    pub fn inorder_traversal_morris(root: Option<Rc<RefCell<TreeNode>>>) -> Vec<i32> {
        let mut result = Vec::new();
        let mut current = root;
        while let Some(node) = current.clone() {
            let left = node.borrow().left.clone();
            if left.is_none() {
                result.push(node.borrow().val);
                current = node.borrow().right.clone();
            } else {
                // Find the rightmost node in the left subtree whose right
                // child is either None or the current node itself
                let mut predecessor = left;
                loop {
                    let right = predecessor.as_ref().unwrap().borrow().right.clone();
                    match right {
                        None => {
                            // Create a temporary link back to current, then go left
                            predecessor.unwrap().borrow_mut().right = Some(node.clone());
                            current = node.borrow().left.clone();
                            break;
                        }
                        Some(r) if Rc::ptr_eq(&r, &node) => {
                            // Remove the temporary link, visit current, then go right
                            predecessor.unwrap().borrow_mut().right = None;
                            result.push(node.borrow().val);
                            current = node.borrow().right.clone();
                            break;
                        }
                        Some(r) => predecessor = Some(r),
                    }
                }
            }
        }
        result
    }
}
```

## Link

[LeetCode 0094 Binary Tree Inorder Traversal](https://leetcode.com/problems/binary-tree-inorder-traversal/)
