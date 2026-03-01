# 1586 Binary Search Tree Iterator II

## Problem Description

Implement the `BSTIterator` class that represents an iterator over the in-order traversal of a binary search tree (BST):

- `BSTIterator(TreeNode root)` Initializes an object of the `BSTIterator` class. The `root` of the binary search tree is given as part of the constructor. The pointer should be initialized to a non-existent number smaller than any element in the BST.
- `boolean hasNext()` Returns `true` if there exists a number in the traversal to the right of the pointer, otherwise returns `false`.
- `int next()` Moves the pointer to the right, then returns the number at the pointer.
- `boolean hasPrev()` Returns `true` if there exists a number in the traversal to the left of the pointer, otherwise returns `false`.
- `int prev()` Moves the pointer to the left, then returns the number at the pointer.

### Example 1:
```
Input
["BSTIterator", "next", "next", "prev", "next", "hasNext", "next", "next", "next", "hasNext"]
[[[7, 3, 15, null, null, 9, 20]], [], [], [], [], [], [], [], [], []]
Output
[null, 3, 7, 3, 7, true, 15, 20, -1, false]

Explanation
BSTIterator bSTIterator = new BSTIterator([7, 3, 15, null, null, 9, 20]);
bSTIterator.next();    // return 3
bSTIterator.next();    // return 7
bSTIterator.prev();    // return 3
bSTIterator.next();    // return 7
bSTIterator.hasNext(); // return true
bSTIterator.next();    // return 15
bSTIterator.next();    // return 20
bSTIterator.next();    // return -1
bSTIterator.hasNext(); // return false
```

## The Twist

Implementing a bidirectional BST iterator that supports both forward and backward traversal. The challenge is to efficiently support prev() operations while maintaining O(h) space complexity.

## Algorithm

### Controlled In-order Traversal with Stack + History:
1. Use a stack for forward in-order traversal (like the original BST iterator)
2. Use an array to store the traversal history for backward operations
3. Use a pointer to track current position in the history array
4. For initialization:
   - Initialize stack with leftmost path
   - Initialize empty history array and pointer at -1
5. For next():
   - If pointer is at the end of history array:
     - Get next element using stack (same as original BST iterator)
     - Add to history array and increment pointer
   - Otherwise:
     - Just increment pointer
   - Return history[pointer]
6. For prev():
   - If pointer > 0:
     - Decrement pointer
     - Return history[pointer]
   - Return -1 if no previous element
7. For hasNext():
   - Check if stack is not empty or pointer < len(history)-1
8. For hasPrev():
   - Check if pointer > 0

The key insight is to maintain a history of traversed elements to support backward navigation.

## Complexity

- **Time**: 
  - Constructor: O(h) where h is the height of the tree
  - next: O(1) amortized
  - prev: O(1)
  - hasNext: O(1)
  - hasPrev: O(1)
- **Space**: O(n) in worst case where n is the number of nodes (for history array)

## Solution Code

```go
package main

type TreeNode struct {
    Val   int
    Left  *TreeNode
    Right *TreeNode
}

type BSTIterator struct {
    stack   []*TreeNode
    history []int
    pointer int
}

func Constructor(root *TreeNode) BSTIterator {
    iterator := BSTIterator{
        stack:   make([]*TreeNode, 0),
        history: make([]int, 0),
        pointer: -1,
    }
    iterator.pushLeftNodes(root)
    return iterator
}

func (this *BSTIterator) HasNext() bool {
    return len(this.stack) > 0 || this.pointer < len(this.history)-1
}

func (this *BSTIterator) Next() int {
    if this.pointer < len(this.history)-1 {
        // We have history to move forward to
        this.pointer++
        return this.history[this.pointer]
    }
    
    // Need to get next element from stack
    if len(this.stack) == 0 {
        return -1
    }
    
    // Pop the top node
    node := this.stack[len(this.stack)-1]
    this.stack = this.stack[:len(this.stack)-1]
    
    // If node has right child, push all left nodes from right child
    if node.Right != nil {
        this.pushLeftNodes(node.Right)
    }
    
    // Add to history
    this.history = append(this.history, node.Val)
    this.pointer++
    
    return node.Val
}

func (this *BSTIterator) HasPrev() bool {
    return this.pointer > 0
}

func (this *BSTIterator) Prev() int {
    if this.pointer > 0 {
        this.pointer--
        return this.history[this.pointer]
    }
    return -1
}

func (this *BSTIterator) pushLeftNodes(node *TreeNode) {
    for node != nil {
        this.stack = append(this.stack, node)
        node = node.Left
    }
}
```

## Link

[LeetCode 1586 Binary Search Tree Iterator II](https://leetcode.com/problems/binary-search-tree-iterator-ii/)