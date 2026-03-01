# 0173 Binary Search Tree Iterator

## Problem Description

Implement the `BSTIterator` class that represents an iterator over the in-order traversal of a binary search tree (BST):

- `BSTIterator(TreeNode root)` Initializes an object of the `BSTIterator` class. The `root` of the binary search tree is given as part of the constructor. The pointer should be initialized to a non-existent number smaller than any element in the BST.
- `int next()` Moves the pointer to the right, then returns the number at the pointer.
- `boolean hasNext()` Returns `true` if there exists a number in the traversal to the right of the pointer, otherwise returns `false`.

### Example 1:
```
Input
["BSTIterator", "next", "next", "hasNext", "next", "hasNext", "next", "hasNext", "next", "hasNext"]
[[[7, 3, 15, null, null, 9, 20]], [], [], [], [], [], [], [], [], []]
Output
[null, 3, 7, true, 9, true, 15, true, 20, false]

Explanation
BSTIterator bSTIterator = new BSTIterator([7, 3, 15, null, null, 9, 20]);
bSTIterator.next();    // return 3
bSTIterator.next();    // return 7
bSTIterator.hasNext(); // return True
bSTIterator.next();    // return 9
bSTIterator.hasNext(); // return True
bSTIterator.next();    // return 15
bSTIterator.hasNext(); // return True
bSTIterator.next();    // return 20
bSTIterator.hasNext(); // return False
```

## The Twist

Implementing an iterator for BST that efficiently traverses the tree in-order without precomputing the entire traversal. The challenge is to use O(h) memory where h is the height of the tree.

## Algorithm

### Controlled In-order Traversal with Stack:
1. Use a stack to store the path from root to the leftmost node
2. For initialization:
   - Push all left nodes from root to stack
3. For next():
   - Pop the top node from stack (this is the next in-order node)
   - If the popped node has a right child:
     - Push all left nodes from the right child to stack
   - Return the value of the popped node
4. For hasNext():
   - Check if stack is not empty

The key insight is that we can perform a controlled in-order traversal using a stack, only storing the path to the current node rather than the entire traversal.

## Complexity

- **Time**: 
  - Constructor: O(h) where h is the height of the tree
  - next: O(1) amortized (each node is visited once)
  - hasNext: O(1)
- **Space**: O(h) where h is the height of the tree

## Solution Code

```go
package main

type TreeNode struct {
    Val   int
    Left  *TreeNode
    Right *TreeNode
}

type BSTIterator struct {
    stack []*TreeNode
}

func Constructor(root *TreeNode) BSTIterator {
    iterator := BSTIterator{
        stack: make([]*TreeNode, 0),
    }
    iterator.pushLeftNodes(root)
    return iterator
}

func (this *BSTIterator) Next() int {
    // Pop the top node
    node := this.stack[len(this.stack)-1]
    this.stack = this.stack[:len(this.stack)-1]
    
    // If node has right child, push all left nodes from right child
    if node.Right != nil {
        this.pushLeftNodes(node.Right)
    }
    
    return node.Val
}

func (this *BSTIterator) HasNext() bool {
    return len(this.stack) > 0
}

func (this *BSTIterator) pushLeftNodes(node *TreeNode) {
    for node != nil {
        this.stack = append(this.stack, node)
        node = node.Left
    }
}
```

## Link

[LeetCode 0173 Binary Search Tree Iterator](https://leetcode.com/problems/binary-search-tree-iterator/)