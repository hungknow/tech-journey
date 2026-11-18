# 0314 Binary Tree Vertical Order Traversal

## Problem Description

Given the `root` of a binary tree, return the vertical order traversal of its nodes' values (i.e., from top to bottom, column by column).

If two nodes are in the same row and column, the order should be from left to right.

### Example 1:
```
Input: root = [3,9,20,null,null,15,7]
Output: [[9],[3,15],[20],[7]]
```

### Example 2:
```
Input: root = [3,9,8,4,0,1,7]
Output: [[4],[9],[3,0,1],[8],[7]]
```

## The Twist

Map stores `column_index -> [list_of_nodes]`. As you BFS down the tree, left children get `col-1` and right children get `col+1`.

## Hash Table Usage

- **Key**: `column_index` (the horizontal position in the tree)
- **Value**: `[list_of_nodes]` (all nodes at this column)

Algorithm:
1. Use BFS to traverse the tree level by level
2. Assign column index 0 to the root
3. For each node:
   - Add the node's value to its column list
   - Left child gets column - 1
   - Right child gets column + 1
4. Sort the columns and return the values in order

## Complexity

- **Time**: O(n log n) - BFS traversal + sorting columns
- **Space**: O(n) - storing all nodes in the map

> Note: tracking `minCol`/`maxCol` during BFS removes the need to sort the column keys (columns form a contiguous range), making it O(n).

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
func verticalOrder(root *TreeNode) [][]int {
	if root == nil {
		return [][]int{}
	}

	columnTable := make(map[int][]int)
	type item struct {
		node *TreeNode
		col  int
	}
	queue := []item{{root, 0}}
	minCol, maxCol := 0, 0

	for len(queue) > 0 {
		it := queue[0]
		queue = queue[1:]
		node, col := it.node, it.col

		columnTable[col] = append(columnTable[col], node.Val)
		minCol = min(minCol, col)
		maxCol = max(maxCol, col)

		if node.Left != nil {
			queue = append(queue, item{node.Left, col - 1})
		}
		if node.Right != nil {
			queue = append(queue, item{node.Right, col + 1})
		}
	}

	result := make([][]int, 0, maxCol-minCol+1)
	for col := minCol; col <= maxCol; col++ {
		result = append(result, columnTable[col])
	}
	return result
}
```

### Rust

```rust
use std::cell::RefCell;
use std::collections::{HashMap, VecDeque};
use std::rc::Rc;

impl Solution {
    pub fn vertical_order(root: Option<Rc<RefCell<TreeNode>>>) -> Vec<Vec<i32>> {
        let root = match root {
            Some(node) => node,
            None => return Vec::new(),
        };

        let mut column_table: HashMap<i32, Vec<i32>> = HashMap::new();
        let mut queue: VecDeque<(Rc<RefCell<TreeNode>>, i32)> = VecDeque::new();
        queue.push_back((root, 0));
        let (mut min_col, mut max_col) = (0, 0);

        while let Some((node, col)) = queue.pop_front() {
            let val = node.borrow().val;
            column_table.entry(col).or_default().push(val);
            min_col = min_col.min(col);
            max_col = max_col.max(col);

            let (left, right) = {
                let n = node.borrow();
                (n.left.clone(), n.right.clone())
            };
            if let Some(left) = left {
                queue.push_back((left, col - 1));
            }
            if let Some(right) = right {
                queue.push_back((right, col + 1));
            }
        }

        (min_col..=max_col)
            .filter_map(|col| column_table.remove(&col))
            .collect()
    }
}
```

## Link

[LeetCode 0314 Binary Tree Vertical Order Traversal](https://leetcode.com/problems/binary-tree-vertical-order-traversal/)
