# Step-By-Step Directions From a Binary Tree Node to Another

## Problem Description

You are given the `root` of a binary tree with `n` nodes. Each node is uniquely assigned a value from `1` to `n`. You are also given an integer `startValue` representing the value of the start node `s`, and an integer `destValue` representing the value of the destination node `t`.

Find the shortest path starting from node `s` and ending at node `t`. Generate step-by-step directions of such path as a string consisting of only the uppercase letters `'L'`, `'R'`, and `'U'`. Each letter indicates a specific direction:

- `'L'` means to go from a node to its left child node.
- `'R'` means to go from a node to its right child node.
- `'U'` means to go from a node to its parent node.

Return the step-by-step directions of the shortest path from `s` to `t`.

**Example 1:**
```
Input: root = [5,1,2,3,null,6,4], startValue = 3, destValue = 6
Output: "UURL"
Explanation: The shortest path is: 3 → 1 → 5 → 2 → 6.
```

**Example 2:**
```
Input: root = [2,1,3], startValue = 1, destValue = 3
Output: "L"
Explanation: The shortest path is: 1 → 3.
```

**Constraints:**
- The number of nodes in the tree is `n`.
- 2 <= n <= 10^5
- 1 <= Node.val <= n
- All the values in the tree are unique.
- 1 <= startValue, destValue <= n
- `startValue != destValue`

## The Twist

This is a tree pathfinding problem where we need to find the shortest path between two nodes. The key insight is that the shortest path always goes through the Lowest Common Ancestor (LCA) of the two nodes. We can find the path from start to LCA (going up, using 'U') and from LCA to dest (going down, using 'L'/'R').

## Algorithm

### Approach: Find LCA and Build Paths

1. Find the Lowest Common Ancestor (LCA) of the start and destination nodes
2. Find the path from start to LCA (all 'U' directions)
3. Find the path from LCA to destination (using 'L' and 'R' directions)
4. Concatenate the two paths

```go
func getDirections(root *TreeNode, startValue int, destValue int) string {
    // Find LCA
    lca := findLCA(root, startValue, destValue)
    
    // Find path from LCA to start
    pathToStart := make([]byte, 0)
    findPath(lca, startValue, &pathToStart)
    
    // Find path from LCA to dest
    pathToDest := make([]byte, 0)
    findPath(lca, destValue, &pathToDest)
    
    // Convert path to start to all 'U's
    result := make([]byte, len(pathToStart)+len(pathToDest))
    for i := range pathToStart {
        result[i] = 'U'
    }
    
    // Add path to dest
    for i, dir := range pathToDest {
        result[len(pathToStart)+i] = dir
    }
    
    return string(result)
}

func findLCA(node *TreeNode, p, q int) *TreeNode {
    if node == nil || node.Val == p || node.Val == q {
        return node
    }
    
    left := findLCA(node.Left, p, q)
    right := findLCA(node.Right, p, q)
    
    if left != nil && right != nil {
        return node
    }
    if left != nil {
        return left
    }
    return right
}

func findPath(node *TreeNode, target int, path *[]byte) bool {
    if node == nil {
        return false
    }
    
    if node.Val == target {
        return true
    }
    
    // Try left
    *path = append(*path, 'L')
    if findPath(node.Left, target, path) {
        return true
    }
    *path = (*path)[:len(*path)-1]
    
    // Try right
    *path = append(*path, 'R')
    if findPath(node.Right, target, path) {
        return true
    }
    *path = (*path)[:len(*path)-1]
    
    return false
}
```

## Complexity

- **Time Complexity:** O(n) - We visit each node at most once
- **Space Complexity:** O(h) - For the recursion stack and the path arrays, where h is the height of the tree

## Link

[LeetCode 2096 - Step-By-Step Directions From a Binary Tree Node to Another](https://leetcode.com/problems/step-by-step-directions-from-a-binary-tree-node-to-another/)
