# Change the Root of a Binary Tree

## Problem Description

Given the `root` of a binary tree and a `leaf` node, reroot the tree so that the `leaf` is the new root.

You can reroot the tree by following the steps below:
1. Identify the path from the root to the leaf.
2. For each node in the path (except the leaf), remove the edge from the parent to the child.
3. For each node in the path (except the root), add an edge from the child to the parent.

Return the new root of the rerooted tree.

**Example 1:**
```
Input: root = [3,5,1,6,2,0,8,null,null,7,4], leaf = 7
Output: [7,2,null,5,1,null,null,6,3,null,null,0,8,null,null,4]
```

**Example 2:**
```
Input: root = [3,5,1,6,2,0,8,null,null,7,4], leaf = 0
Output: [0,1,null,8,null,3,5,null,null,6,2,null,null,7,4]
```

**Constraints:**
- The number of nodes in the tree is in the range [2, 100].
- 1 <= Node.val <= 100
- The values of the nodes in the tree are unique.
- `leaf` is a leaf node in the tree.

## The Twist

This is a tree manipulation problem where we need to change the root of a binary tree. The key insight is to find the path from the root to the leaf, then reverse the parent-child relationships along this path.

## Algorithm

### Approach: Find Path and Reverse Edges

1. Find the path from the root to the leaf using DFS
2. For each node in the path (except the leaf), remove the edge from the parent to the child
3. For each node in the path (except the root), add an edge from the child to the parent
4. Return the leaf as the new root

```go
func reroot(root *TreeNode, leaf *TreeNode) *TreeNode {
    // Find the path from root to leaf
    path := findPath(root, leaf, []*TreeNode{})
    
    // Reverse the edges along the path
    for i := 0; i < len(path)-1; i++ {
        parent := path[i]
        child := path[i+1]
        
        // Remove child from parent's children
        if parent.Left == child {
            parent.Left = nil
        } else {
            parent.Right = nil
        }
        
        // Add parent as child of child
        if child.Left == nil {
            child.Left = parent
        } else {
            child.Right = parent
        }
    }
    
    return leaf
}

func findPath(node, target *TreeNode, path []*TreeNode) []*TreeNode {
    if node == nil {
        return nil
    }
    
    path = append(path, node)
    
    if node == target {
        return path
    }
    
    if result := findPath(node.Left, target, path); result != nil {
        return result
    }
    
    if result := findPath(node.Right, target, path); result != nil {
        return result
    }
    
    return nil
}
```

## Complexity

- **Time Complexity:** O(h) - Where h is the height of the tree (we traverse the path once)
- **Space Complexity:** O(h) - For the path array and the recursion stack

## Link

[LeetCode 1666 - Change the Root of a Binary Tree](https://leetcode.com/problems/change-the-root-of-a-binary-tree/)
