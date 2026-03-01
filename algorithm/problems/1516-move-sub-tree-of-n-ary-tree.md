# Move Sub-Tree of N-Ary Tree

## Problem Description

You are given the `root` of an N-ary tree and two nodes `p` and `q`.

Move the subtree of node `p` to become a direct child of node `q`. If `p` is already a direct child of `q`, don't change anything. If `p` is the ancestor of `q`, don't change anything.

Return the root of the modified tree.

**Example 1:**
```
Input: root = [1,null,2,3,null,4,5,6,null,null,null,7,8], p = 4, q = 1
Output: [1,null,3,2,null,4,5,6,null,null,null,7,8]
```

**Example 2:**
```
Input: root = [1,null,2,3,null,4,5,6,null,null,null,7,8], p = 7, q = 4
Output: [1,null,2,3,null,4,5,null,null,7,6,null,null,8]
```

**Example 3:**
```
Input: root = [1,null,2,3,null,4,5,6,null,null,null,7,8], p = 3, q = 8
Output: [1,null,2,null,4,5,6,null,null,null,7,8,null,3]
```

**Constraints:**
- The number of nodes in the tree is in the range [2, 1000].
- 1 <= Node.val <= 10^4
- The values of the nodes in the tree are unique.
- `p` and `q` are different nodes in the tree.

## The Twist

This is a tree manipulation problem where we need to move a subtree from one location to another. The key insight is to handle the edge cases:
1. If `p` is already a child of `q`, do nothing
2. If `p` is an ancestor of `q`, do nothing (this would create a cycle)
3. Otherwise, remove `p` from its parent's children list and add it to `q`'s children list

## Algorithm

### Approach: DFS with Parent Tracking

1. Build a map of parent nodes for each node in the tree
2. Check if `p` is already a child of `q` - if so, return the root unchanged
3. Check if `p` is an ancestor of `q` - if so, return the root unchanged
4. Find the parent of `p` and remove `p` from its children list
5. Add `p` to `q`'s children list
6. Return the root

```go
func moveSubTree(root *Node, p *Node, q *Node) *Node {
    // Build parent map
    parent := make(map[*Node]*Node)
    buildParentMap(root, nil, parent)
    
    // Check if p is already a child of q
    for _, child := range q.Children {
        if child == p {
            return root
        }
    }
    
    // Check if p is an ancestor of q
    if isAncestor(p, q) {
        return root
    }
    
    // Remove p from its parent's children
    pParent := parent[p]
    for i, child := range pParent.Children {
        if child == p {
            pParent.Children = append(pParent.Children[:i], pParent.Children[i+1:]...)
            break
        }
    }
    
    // Add p to q's children
    q.Children = append(q.Children, p)
    
    return root
}

func buildParentMap(node, parentNode *Node, parent map[*Node]*Node) {
    if node == nil {
        return
    }
    parent[node] = parentNode
    for _, child := range node.Children {
        buildParentMap(child, node, parent)
    }
}

func isAncestor(ancestor, node *Node) bool {
    if ancestor == nil || node == nil {
        return false
    }
    for _, child := range ancestor.Children {
        if child == node || isAncestor(child, node) {
            return true
        }
    }
    return false
}
```

## Complexity

- **Time Complexity:** O(n) - We visit each node at most twice (once to build parent map, once to check ancestry)
- **Space Complexity:** O(n) - For the parent map and the recursion stack

## Link

[LeetCode 1516 - Move Sub-Tree of N-Ary Tree](https://leetcode.com/problems/move-sub-tree-of-n-ary-tree/)
