# 0297 Serialize and Deserialize Binary Tree

## Problem Description

Serialization is the process of converting a data structure or object into a sequence of bits so that it can be stored in a file or memory buffer, or transmitted across a network connection link to be reconstructed later in the same or another computer environment.

Design an algorithm to serialize and deserialize a binary tree. There is no restriction on how your serialization/deserialization algorithm should work. You just need to ensure that a binary tree can be serialized to a string and this string can be deserialized to the original tree structure.

### Example 1:
```
Input: root = [1,2,3,null,null,4,5]
Output: [1,2,3,null,null,4,5]
```

### Example 2:
```
Input: root = []
Output: []
```

## The Twist

We need to design a **custom serialization format** that can represent the tree structure including null nodes. The format should be reversible (can reconstruct the original tree).

## Algorithm

### Level Order (BFS) Serialization:
1. **Serialize**:
   - Use BFS to traverse the tree level by level
   - Add null markers for missing children
   - Join values with delimiter (e.g., comma)
2. **Deserialize**:
   - Split the string by delimiter
   - Use BFS to reconstruct level by level
   - Create nodes for non-null values, skip nulls

### Preorder DFS Serialization:
1. **Serialize**:
   - Use preorder traversal (root, left, right)
   - Add null markers for null nodes
   - Join values with delimiter
2. **Deserialize**:
   - Use a queue to track tokens
   - Recursively build tree in preorder
   - Return null for null markers

## Complexity

- **Time**: O(n) - each node visited once
- **Space**: O(n) - storing the serialized string and tree

## Solution Code

### Go

```go
package main

import (
	"strconv"
	"strings"
)

/**
 * Definition for a binary tree node.
 * type TreeNode struct {
 *     Val   int
 *     Left  *TreeNode
 *     Right *TreeNode
 * }
 */
type Codec struct{}

func Constructor() Codec {
	return Codec{}
}

// Serializes a tree to a single string.
func (this *Codec) serialize(root *TreeNode) string {
	var sb strings.Builder
	var preorder func(node *TreeNode)
	preorder = func(node *TreeNode) {
		if node == nil {
			sb.WriteString("#,")
			return
		}
		sb.WriteString(strconv.Itoa(node.Val))
		sb.WriteByte(',')
		preorder(node.Left)
		preorder(node.Right)
	}
	preorder(root)
	return sb.String()
}

// Deserializes your encoded data to tree.
func (this *Codec) deserialize(data string) *TreeNode {
	tokens := strings.Split(data, ",")
	var build func() *TreeNode
	build = func() *TreeNode {
		token := tokens[0]
		tokens = tokens[1:]
		if token == "#" {
			return nil
		}
		val, _ := strconv.Atoi(token)
		return &TreeNode{Val: val, Left: build(), Right: build()}
	}
	return build()
}

/**
 * Your Codec object will be instantiated and called as such:
 * ser := Constructor();
 * deser := Constructor();
 * data := ser.serialize(root);
 * ans := deser.deserialize(data);
 */
```

### Rust

```rust
use std::cell::RefCell;
use std::collections::VecDeque;
use std::rc::Rc;

struct Codec;

/**
 * Your Codec object will be instantiated and called as such:
 * let ser = Codec::new();
 * let deser = Codec::new();
 * let data = ser.serialize(root);
 * let ans = deser.deserialize(data);
 */
impl Codec {
    fn new() -> Self {
        Codec
    }

    // Serializes a tree to a single string.
    fn serialize(&self, root: Option<Rc<RefCell<TreeNode>>>) -> String {
        let mut out = String::new();
        Self::preorder(&root, &mut out);
        out
    }

    fn preorder(node: &Option<Rc<RefCell<TreeNode>>>, out: &mut String) {
        match node {
            None => out.push_str("#,"),
            Some(n) => {
                let n = n.borrow();
                out.push_str(&n.val.to_string());
                out.push(',');
                Self::preorder(&n.left, out);
                Self::preorder(&n.right, out);
            }
        }
    }

    // Deserializes your encoded data to tree.
    fn deserialize(&self, data: String) -> Option<Rc<RefCell<TreeNode>>> {
        let mut tokens: VecDeque<&str> = data.split(',').collect();
        Self::build(&mut tokens)
    }

    fn build(tokens: &mut VecDeque<&str>) -> Option<Rc<RefCell<TreeNode>>> {
        match tokens.pop_front() {
            Some("#") | None => None,
            Some(token) => {
                let val: i32 = token.parse().unwrap();
                let node = Rc::new(RefCell::new(TreeNode::new(val)));
                node.borrow_mut().left = Self::build(tokens);
                node.borrow_mut().right = Self::build(tokens);
                Some(node)
            }
        }
    }
}
```

## Link

[LeetCode 0297 Serialize and Deserialize Binary Tree](https://leetcode.com/problems/serialize-and-deserialize-binary-tree/)
