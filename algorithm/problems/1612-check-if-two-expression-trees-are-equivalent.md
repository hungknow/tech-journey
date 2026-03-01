# 1612 Check If Two Expression Trees are Equivalent

## Problem Description

A binary expression tree is a kind of binary tree used to represent arithmetic expressions. Each node has either:
- Two children (operator nodes): `+`, `-`, `*`, `/`
- No children (leaf nodes): non-negative integers

Given the roots of two binary expression trees, return `true` if the two expression trees are equivalent, otherwise return `false`.

Two expression trees are equivalent if they evaluate to the same value regardless of how the variables are assigned.

### Example 1:
```
Input: root1 = [x], root2 = [x]
Output: true
```

### Example 2:
```
Input: root1 = [-,*,+,3,null,null,4,5], root2 = [-,+,*,4,5,3]
Output: true
```

### Example 3:
```
Input: root1 = [-,*,+,3,null,null,4,5], root2 = [-,*,+,3,4,5]
Output: false
```

## The Twist

Expression trees with **commutative operators** (+ and *) are equivalent regardless of operand order. For non-commutative operators (- and /), order matters.

## Algorithm

### Postorder Evaluation:
1. For each tree, compute the result using postorder traversal:
   - If leaf node: return its value
   - If operator node: recursively evaluate left and right, then apply operator
2. Compare the results from both trees

### Commutative Optimization:
1. For + and * operators, sort the subtree evaluations before comparing
2. For - and / operators, maintain order

## Complexity

- **Time**: O(n) - each tree traversed once
- **Space**: O(h) - recursion stack depth

## Link

[LeetCode 1612 Check If Two Expression Trees are Equivalent](https://leetcode.com/problems/check-if-two-expression-trees-are-equivalent/)
