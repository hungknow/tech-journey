# Clone N-ary Tree

## Problem Description

Given a root of an N-ary tree, return a deep copy (clone) of the tree.

Each node in the n-ary tree contains a val (int) and a list (List[Node]) of its children.

```
class Node {
    public int val;
    public List<Node> children;
}
```

Nary-Tree input serialization is represented in their level order traversal, each group of children is separated by the null value (See examples).

**Example 1:**
```
Input: root = [1,null,3,2,4,null,5,6]
Output: [1,null,3,2,4,null,5,6]
```

**Example 2:**
```
Input: root = [1,null,2,3,4,5,null,null,6,7,null,8,null,9,10,null,null,11,null,12,null,13,null,null,14]
Output: [1,null,2,3,4,5,null,null,6,7,null,8,null,9,10,null,null,11,null,12,null,13,null,null,14]
```

**Constraints:**
- The height of the n-ary tree is less than or equal to 1000
- The total number of nodes is between [0, 10^4]

## The Twist

This is a classic tree traversal problem where we need to create a deep copy of an N-ary tree. The key insight is that we need to recursively clone each node and all of its children.

## Algorithm

### Approach 1: DFS (Recursive)

1. If the root is null, return null
2. Create a new node with the same value as the root
3. For each child of the root, recursively clone the child and add it to the new node's children list
4. Return the new node

```go
func cloneTree(root *Node) *Node {
    if root == nil {
        return nil
    }
    
    newNode := &Node{Val: root.Val}
    for _, child := range root.Children {
        newNode.Children = append(newNode.Children, cloneTree(child))
    }
    
    return newNode
}
```

### Approach 2: BFS (Iterative)

1. If the root is null, return null
2. Create a queue and add the root to it
3. Create a map to store the mapping from original nodes to cloned nodes
4. While the queue is not empty:
   - Pop a node from the queue
   - Create a new node with the same value
   - Add the mapping to the map
   - For each child of the node, add the child to the queue
5. For each node in the map, set its children to the cloned children
6. Return the cloned root

```go
func cloneTree(root *Node) *Node {
    if root == nil {
        return nil
    }
    
    queue := []*Node{root}
    cloned := map[*Node]*Node{root: &Node{Val: root.Val}}
    
    for len(queue) > 0 {
        node := queue[0]
        queue = queue[1:]
        
        for _, child := range node.Children {
            cloned[child] = &Node{Val: child.Val}
            queue = append(queue, child)
        }
    }
    
    for node, cloneNode := range cloned {
        for _, child := range node.Children {
            cloneNode.Children = append(cloneNode.Children, cloned[child])
        }
    }
    
    return cloned[root]
}
```

## Complexity

- **Time Complexity:** O(n) - We visit each node exactly once
- **Space Complexity:** O(h) for recursive approach, O(n) for BFS approach where h is the height of the tree and n is the number of nodes

## Link

[LeetCode 1490 - Clone N-ary Tree](https://leetcode.com/problems/clone-n-ary-tree/)
