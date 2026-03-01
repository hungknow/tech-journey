# Find Root of N-Ary Tree

## Problem Description

You are given all the nodes of an N-ary tree as an array of `Node` objects in the order of a level order traversal of the tree.

Each node has a unique value.

No two nodes have the same value.

Return the root of the tree.

**Example 1:**
```
Input: tree = [1,null,3,2,4,null,5,6]
Output: [1,null,3,2,4,null,5,6]
```

**Example 2:**
```
Input: tree = [1,null,2,3,4,5,null,null,6,7,null,8,null,9,10,null,null,11,null,12,null,13,null,null,14]
Output: [1,null,2,3,4,5,null,null,6,7,null,8,null,9,10,null,null,11,null,12,null,13,null,null,14]
```

**Constraints:**
- The total number of nodes is between [1, 10^4].
- Each node has a unique value.

## The Twist

The key insight is that the root is the only node that is not a child of any other node. We can use this property to find the root efficiently using bit manipulation or a hash set.

## Algorithm

### Approach 1: Bit Manipulation (XOR)

1. Initialize a variable `root` to 0
2. For each node in the tree:
   - XOR the node's value with `root`
3. For each node in the tree:
   - For each child of the node, XOR the child's value with `root`
4. The remaining value in `root` is the value of the root node
5. Find and return the node with this value

```go
func findRoot(tree []*Node) *Node {
    root := 0
    
    // XOR all node values
    for _, node := range tree {
        root ^= node.Val
    }
    
    // XOR all child values
    for _, node := range tree {
        for _, child := range node.Children {
            root ^= child.Val
        }
    }
    
    // Find the node with the remaining value
    for _, node := range tree {
        if node.Val == root {
            return node
        }
    }
    
    return nil
}
```

### Approach 2: Hash Set

1. Create a set of all node values
2. For each node in the tree:
   - For each child of the node, remove the child's value from the set
3. The remaining value in the set is the value of the root node
4. Find and return the node with this value

```go
func findRoot(tree []*Node) *Node {
    values := make(map[int]bool)
    
    // Add all node values to the set
    for _, node := range tree {
        values[node.Val] = true
    }
    
    // Remove all child values from the set
    for _, node := range tree {
        for _, child := range node.Children {
            delete(values, child.Val)
        }
    }
    
    // Find the node with the remaining value
    for val := range values {
        for _, node := range tree {
            if node.Val == val {
                return node
            }
        }
    }
    
    return nil
}
```

## Complexity

- **Time Complexity:** O(n) - We visit each node and each child exactly once
- **Space Complexity:** O(n) for hash set approach, O(1) for bit manipulation approach

## Link

[LeetCode 1506 - Find Root of N-Ary Tree](https://leetcode.com/problems/find-root-of-n-ary-tree/)
