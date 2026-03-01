# Create Binary Tree From Descriptions

## Problem Description

You are given a 2D integer array `descriptions` where `descriptions[i] = [parenti, childi, isLefti]` indicates that `parenti` is the parent of `childi` in a binary tree of unique values. Additionally:

- If `isLefti == 1`, then `childi` is the left child of `parenti`.
- If `isLefti == 0`, then `childi` is the right child of `parenti`.

Construct the binary tree described by `descriptions` and return its root.

**Example 1:**
```
Input: descriptions = [[20,15,1],[20,17,0],[50,20,1],[50,80,0],[80,19,1]]
Output: [50,20,80,15,17,19]
```

**Example 2:**
```
Input: descriptions = [[1,2,1],[2,3,0],[3,4,1]]
Output: [1,2,null,null,3,4]
```

**Constraints:**
- 1 <= descriptions.length <= 10^4
- descriptions[i].length == 3
- 1 <= parenti, childi <= 10^5
- 0 <= isLefti <= 1
- The binary tree values are unique.

## The Twist

This is a tree construction problem where we need to build a binary tree from edge descriptions. The key insight is that the root is the only node that is not a child of any other node. We can use this property to identify the root.

## Algorithm

### Approach: Build Tree and Find Root

1. Create a map of node values to TreeNode objects
2. Create a set to track all child nodes
3. For each description:
   - Create or get the parent node
   - Create or get the child node
   - Set the child as left or right child of the parent
   - Add the child to the set of children
4. Find the root (the node that is not in the children set)
5. Return the root

```go
func createBinaryTree(descriptions [][]int) *TreeNode {
    nodes := make(map[int]*TreeNode)
    children := make(map[int]bool)
    
    for _, desc := range descriptions {
        parentVal, childVal, isLeft := desc[0], desc[1], desc[2]
        
        // Get or create parent node
        parent, ok := nodes[parentVal]
        if !ok {
            parent = &TreeNode{Val: parentVal}
            nodes[parentVal] = parent
        }
        
        // Get or create child node
        child, ok := nodes[childVal]
        if !ok {
            child = &TreeNode{Val: childVal}
            nodes[childVal] = child
        }
        
        // Set child relationship
        if isLeft == 1 {
            parent.Left = child
        } else {
            parent.Right = child
        }
        
        // Mark child as having a parent
        children[childVal] = true
    }
    
    // Find root (node without a parent)
    for val, node := range nodes {
        if !children[val] {
            return node
        }
    }
    
    return nil
}
```

## Complexity

- **Time Complexity:** O(n) - We process each description once
- **Space Complexity:** O(n) - For the nodes map and children set

## Link

[LeetCode 2196 - Create Binary Tree From Descriptions](https://leetcode.com/problems/create-binary-tree-from-descriptions/)
