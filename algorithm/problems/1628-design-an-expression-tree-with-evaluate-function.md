# 1628 Design an Expression Tree With Evaluate Function

## Problem Description

Given the postfix tokens of an arithmetic expression, build the expression tree and return its root.

The expression tree should support the following operations:
- `evaluate()`: Returns the result of evaluating the expression tree.
- `merge()`: Merges two expression trees into one.

The postfix notation is a notation for writing arithmetic expressions in which the operands follow the operators. For example, the infix expression `(2 + 3) * 4` would be written in postfix notation as `2 3 + 4 *`.

The expression tree should be built according to the following rules:
1. If the token is an operand, create a leaf node with the token value.
2. If the token is an operator, create an internal node with the token as the operator and the left and right children as the results of recursively building the subtrees.

### Example 1:
```
Input: s = ["2","1","+","3","*"]
Output: [*,+,2,1,3]
Explanation: The expression tree is:
        *
       / \
      +   3
     / \
    2   1
```

## The Twist

Implementing an expression tree that can be built from postfix notation and supports evaluation and merging operations.

## Algorithm

### Stack-based Tree Construction Approach:
1. Use a stack to build the tree from postfix notation
2. For each token in the postfix expression:
   - If it's an operand, create a leaf node and push it to the stack
   - If it's an operator, pop two nodes from the stack, create an internal node with the operator, and push it back
3. The final node on the stack is the root of the expression tree
4. For evaluate():
   - If it's a leaf node, return its value
   - Otherwise, recursively evaluate left and right children, then apply the operator
5. For merge():
   - Create a new internal node with '+' operator
   - Set left child to the current tree
   - Set right child to the tree to merge

The key insight is using a stack to build the tree from postfix notation and implementing recursive evaluation.

## Complexity

- **Time**: 
  - Tree construction: O(n) where n is the number of tokens
  - evaluate: O(n) where n is the number of nodes
  - merge: O(1)
- **Space**: O(n) where n is the number of nodes

## Solution Code

```go
package main

import "strconv"

type Node interface {
	Evaluate() int
	Merge(Node) Node
}

type LeafNode struct {
	val int
}

func (ln *LeafNode) Evaluate() int {
	return ln.val
}

func (ln *LeafNode) Merge(other Node) Node {
	return &InternalNode{
		op:    "+",
		left:  ln,
		right: other,
	}
}

type InternalNode struct {
	op    string
	left  Node
	right Node
}

func (in *InternalNode) Evaluate() int {
	leftVal := in.left.Evaluate()
	rightVal := in.right.Evaluate()
	
	switch in.op {
	case "+":
		return leftVal + rightVal
	case "-":
		return leftVal - rightVal
	case "*":
		return leftVal * rightVal
	case "/":
		return leftVal / rightVal
	}
	
	return 0
}

func (in *InternalNode) Merge(other Node) Node {
	return &InternalNode{
		op:    "+",
		left:  in,
		right: other,
	}
}

type TreeBuilder struct {
}

func Constructor() TreeBuilder {
	return TreeBuilder{}
}

func (this *TreeBuilder) BuildTree(postfix []string) Node {
	stack := make([]Node, 0)
	
	for _, token := range postfix {
		if this.isOperator(token) {
			// Pop two nodes from stack
			right := stack[len(stack)-1]
			left := stack[len(stack)-2]
			stack = stack[:len(stack)-2]
			
			// Create internal node and push back
			node := &InternalNode{
				op:    token,
				left:  left,
				right: right,
			}
			stack = append(stack, node)
		} else {
			// Create leaf node and push to stack
			val, _ := strconv.Atoi(token)
			node := &LeafNode{val: val}
			stack = append(stack, node)
		}
	}
	
	// The last node is the root
	return stack[len(stack)-1]
}

func (this *TreeBuilder) isOperator(token string) bool {
	return token == "+" || token == "-" || token == "*" || token == "/"
}

/**
 * Your TreeBuilder object will be instantiated and called as such:
 * obj := Constructor();
 * param_1 := obj.BuildTree(postfix);
 */
```

## Link

[LeetCode 1628 Design an Expression Tree With Evaluate Function](https://leetcode.com/problems/design-an-expression-tree-with-evaluate-function/)