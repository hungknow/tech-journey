# Root Equals Sum of Children

## Problem Description

You are given the `root` of a binary tree that consists of exactly 3 nodes: the root, its left child, and its right child.

Return `true` if the value of the root is equal to the sum of the values of its two children, or `false` otherwise.

**Example 1:**
```
Input: root = [10,4,6]
Output: true
Explanation: The values of the root, its left child, and its right child are 10, 4, and 6, respectively.
10 is equal to 4 + 6, so we return true.
```

**Example 2:**
```
Input: root = [5,3,1]
Output: false
Explanation: The values of the root, its left child, and its right child are 5, 3, and 1, respectively.
5 is not equal to 3 + 1, so we return false.
```

**Constraints:**
- The tree consists only of the root, its left child, and its right child.
- -100 <= Node.val <= 100

## The Twist

This is a simple tree problem where we just need to check if the root's value equals the sum of its children's values. The key insight is that the tree is guaranteed to have exactly 3 nodes.

## Algorithm

### Approach: Direct Comparison

1. Check if the root's left and right children exist
2. Return true if root.Val == root.Left.Val + root.Right.Val, false otherwise

```go
func checkTree(root *TreeNode) bool {
    return root.Val == root.Left.Val + root.Right.Val
}
```

## Complexity

- **Time Complexity:** O(1) - Constant time operation
- **Space Complexity:** O(1) - No additional space needed

## Link

[LeetCode 2236 - Root Equals Sum of Children](https://leetcode.com/problems/root-equals-sum-of-children/)
