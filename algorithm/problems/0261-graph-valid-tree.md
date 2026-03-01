# 0261 Graph Valid Tree

## Problem Description

You are given an undirected graph represented by `n` nodes labeled from `0` to `n-1` and an `edges` list where `edges[i] = [ui, vi]` represents an edge between `ui` and `vi`.

A graph is a valid tree if:
1. It is a connected graph
2. It has no cycles

Return `true` if the graph is a valid tree, otherwise return `false`.

### Example 1:
```
Input: n = 5, edges = [[0,1],[0,2],[0,3],[1,4]]
Output: true
```

### Example 2:
```
Input: n = 5, edges = [[0,1],[1,2],[2,3],[1,3],[1,4]]
Output: false
```

## Approach

This problem can be solved using BFS to check for cycles and connectivity:

1. **Graph Construction**: Build an adjacency list from the edges.

2. **BFS Traversal**:
   - Start BFS from node 0
   - Track visited nodes
   - Check for cycles by ensuring we don't revisit visited nodes (except the parent)

3. **Validation**:
   - If we find a cycle, return false
   - After BFS, check if all nodes are visited (connected)

## Solution Code

```go
func validTree(n int, edges [][]int) bool {
    // A tree must have exactly n-1 edges
    if len(edges) != n-1 {
        return false
    }
    
    // Build adjacency list
    graph := make([][]int, n)
    for _, edge := range edges {
        u, v := edge[0], edge[1]
        graph[u] = append(graph[u], v)
        graph[v] = append(graph[v], u)
    }
    
    // BFS to check connectivity and detect cycles
    visited := make([]bool, n)
    queue := []int{0}
    visited[0] = true
    
    for len(queue) > 0 {
        node := queue[0]
        queue = queue[1:]
        
        for _, neighbor := range graph[node] {
            if !visited[neighbor] {
                visited[neighbor] = true
                queue = append(queue, neighbor)
            }
        }
    }
    
    // Check if all nodes are visited
    for _, v := range visited {
        if !v {
            return false
        }
    }
    
    return true
}
```

## Complexity Analysis

- **Time**: O(V + E) where V is the number of nodes and E is the number of edges
  - Building graph: O(E)
  - BFS traversal: O(V + E)
- **Space**: O(V + E) for the graph and visited array

## Link

[LeetCode 0261 Graph Valid Tree](https://leetcode.com/problems/graph-valid-tree/)