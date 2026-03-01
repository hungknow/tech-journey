# 1361 Validate Binary Tree Nodes

## Problem Description

You are given `n` nodes labeled from `0` to `n-1` and a list of `edges` where `edges[i] = [ui, vi]` represents a directed edge from `ui` to `vi`.

A binary tree is defined as:
1. There is exactly one root node
2. Each node has either 0, 1, or 2 children
3. Each node is reachable from the root

Return `true` if the given graph is a binary tree, otherwise return `false`.

### Example 1:
```
Input: n = 4, edges = [[1,0],[1,2],[3,1]]
Output: true
```

### Example 2:
```
Input: n = 4, edges = [[1,0],[1,2],[2,3]]
Output: false
```

## Approach

This problem can be solved using graph validation:

1. **Graph Construction**:
   - Build adjacency list from edges
   - Track in-degree and out-degree of each node

2. **Binary Tree Validation**:
   - Check if there's exactly one root (in-degree = 0)
   - Check if all other nodes have in-degree = 1
   - Check if no node has more than 2 children
   - Check if the graph is connected and acyclic

3. **Traversal Check**:
   - Perform DFS/BFS from the root
   - Ensure all nodes are reachable exactly once

## Solution Code

```go
func validateBinaryTreeNodes(n int, edges [][]int) bool {
    if n == 0 {
        return false
    }
    
    // Build adjacency list and track in-degrees
    graph := make([][]int, n)
    inDegree := make([]int, n)
    
    for _, edge := range edges {
        u, v := edge[0], edge[1]
        graph[u] = append(graph[u], v)
        inDegree[v]++
    }
    
    // Find the root (node with in-degree 0)
    root := -1
    for i := 0; i < n; i++ {
        if inDegree[i] == 0 {
            if root != -1 {
                return false // Multiple roots
            }
            root = i
        } else if inDegree[i] != 1 {
            return false // Invalid in-degree
        }
    }
    
    if root == -1 {
        return false // No root found
    }
    
    // Check if no node has more than 2 children
    for i := 0; i < n; i++ {
        if len(graph[i]) > 2 {
            return false
        }
    }
    
    // Check if all nodes are reachable from root and no cycles
    visited := make([]bool, n)
    queue := []int{root}
    visited[root] = true
    visitedCount := 0
    
    for len(queue) > 0 {
        current := queue[0]
        queue = queue[1:]
        visitedCount++
        
        for _, neighbor := range graph[current] {
            if visited[neighbor] {
                return false // Cycle detected
            }
            visited[neighbor] = true
            queue = append(queue, neighbor)
        }
    }
    
    return visitedCount == n
}
```

## Complexity Analysis

- **Time**: O(V + E) where V is the number of nodes (n) and E is the number of edges
  - Building the graph: O(E)
  - BFS traversal: O(V + E)
- **Space**: O(V + E) for the graph and visited array

## Link

[LeetCode 1361 Validate Binary Tree Nodes](https://leetcode.com/problems/validate-binary-tree-nodes/)