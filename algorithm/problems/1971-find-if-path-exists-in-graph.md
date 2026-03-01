# 1971 Find if Path Exists in Graph

## Problem Description

You are given an undirected graph represented by `n` vertices (labeled from 0 to n-1) and `edges` where `edges[i] = [ui, vi]` represents a bidirectional edge between `ui` and `vi`.

Given `source` and `destination` vertices, determine if there exists a path between them.

### Example 1:
```
Input: n = 3, edges = [[0,1],[1,2],[2,0]], source = 0, destination = 2
Output: true
```

### Example 2:
```
Input: n = 6, edges = [[0,1],[0,2],[3,5],[5,4],[4,3]], source = 0, destination = 5
Output: false
```

## Approach

This problem can be solved using graph traversal algorithms:

1. **Graph Construction**:
   - Build adjacency list from edges
   - Use Union Find or BFS/DFS for connectivity

2. **Union Find Approach**:
   - Union all connected vertices
   - Check if source and destination are in the same set
   - Efficient for multiple connectivity queries

3. **BFS/DFS Approach**:
   - Start BFS/DFS from source
   - Track visited vertices
   - Early terminate when reaching destination

4. **Path Finding**:
   - Use BFS for shortest path
   - Use DFS for any path existence
   - Both work for connectivity checking

## Solution Code

```go
func validPath(n int, edges [][]int, source int, destination int) bool {
    if source == destination {
        return true
    }
    
    // Build adjacency list
    graph := make([][]int, n)
    for _, edge := range edges {
        u, v := edge[0], edge[1]
        graph[u] = append(graph[u], v)
        graph[v] = append(graph[v], u)
    }
    
    // BFS approach
    visited := make([]bool, n)
    queue := []int{source}
    visited[source] = true
    
    for len(queue) > 0 {
        current := queue[0]
        queue = queue[1:]
        
        if current == destination {
            return true
        }
        
        for _, neighbor := range graph[current] {
            if !visited[neighbor] {
                visited[neighbor] = true
                queue = append(queue, neighbor)
            }
        }
    }
    
    return false
}
```

## Complexity Analysis

- **Time**: O(V + E) where V is the number of vertices and E is the number of edges
  - Building adjacency list: O(E)
  - BFS traversal: O(V + E)
- **Space**: O(V + E) for the adjacency list and visited array

## Link

[LeetCode 1971 Find if Path Exists in Graph](https://leetcode.com/problems/find-if-path-exists-in-graph/)