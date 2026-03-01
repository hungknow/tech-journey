# 2204 Distance to a Cycle in Undirected Graph

## Problem Description

You are given an undirected graph with `n` vertices labeled from 0 to n-1 and `edges` where `edges[i] = [ui, vi]` represents an edge between `ui` and `vi`.

The graph is guaranteed to be connected and contains exactly one cycle.

For each node, return the distance to the closest node in the cycle.

### Example 1:
```
Input: n = 7, edges = [[1,2],[2,3],[3,4],[4,5],[5,6],[6,7],[7,1],[2,4]]
Output: [1,0,0,0,0,1,2]
```

### Example 2:
```
Input: n = 4, edges = [[1,2],[2,3],[3,4],[4,1]]
Output: [0,0,0,0]
```

## Approach

This problem can be solved by first finding the cycle, then calculating distances:

1. **Cycle Detection**:
   - Use DFS to detect the cycle in the graph
   - Track parent nodes to identify back edges
   - Collect all nodes in the cycle

2. **Distance Calculation**:
   - Perform BFS from all cycle nodes simultaneously
   - Calculate minimum distance for each non-cycle node
   - Use multi-source BFS for efficiency

3. **Graph Traversal**:
   - Build adjacency list for the graph
   - Use visited array to track cycle nodes
   - Compute distances layer by layer

4. **Result Construction**:
   - Set distance 0 for cycle nodes
   - Calculate distances for other nodes using BFS
   - Return the distance array

## Solution Code

```go
func distanceToCycle(n int, edges [][]int) []int {
    // Build adjacency list
    graph := make([][]int, n)
    for _, edge := range edges {
        u, v := edge[0], edge[1]
        graph[u] = append(graph[u], v)
        graph[v] = append(graph[v], u)
    }
    
    // Find cycle using DFS
    visited := make([]bool, n)
    parent := make([]int, n)
    cycleNodes := make([]bool, n)
    
    var dfs func(u, p int) bool
    dfs = func(u, p int) bool {
        visited[u] = true
        parent[u] = p
        
        for _, v := range graph[u] {
            if !visited[v] {
                if dfs(v, u) {
                    return true
                }
            } else if v != p {
                // Found a back edge, trace the cycle
                cycleStart := v
                current := u
                
                for current != cycleStart {
                    cycleNodes[current] = true
                    current = parent[current]
                }
                cycleNodes[cycleStart] = true
                return true
            }
        }
        return false
    }
    
    // Start DFS from node 0
    dfs(0, -1)
    
    // Multi-source BFS from all cycle nodes
    distance := make([]int, n)
    for i := 0; i < n; i++ {
        distance[i] = -1
    }
    
    queue := []int{}
    
    // Initialize queue with all cycle nodes
    for i := 0; i < n; i++ {
        if cycleNodes[i] {
            distance[i] = 0
            queue = append(queue, i)
        }
    }
    
    // BFS
    for len(queue) > 0 {
        current := queue[0]
        queue = queue[1:]
        
        for _, neighbor := range graph[current] {
            if distance[neighbor] == -1 {
                distance[neighbor] = distance[current] + 1
                queue = append(queue, neighbor)
            }
        }
    }
    
    return distance
}
```

## Complexity Analysis

- **Time**: O(V + E) where V is the number of vertices and E is the number of edges
  - DFS for cycle detection: O(V + E)
  - BFS for distance calculation: O(V + E)
- **Space**: O(V + E) for the adjacency list, visited array, and queue

## Link

[LeetCode 2204 Distance to a Cycle in Undirected Graph](https://leetcode.com/problems/distance-to-a-cycle-in-undirected-graph/)