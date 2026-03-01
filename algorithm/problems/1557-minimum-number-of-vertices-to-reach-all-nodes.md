# 1557 Minimum Number of Vertices to Reach All Nodes

## Problem Description

You are given a directed acyclic graph (DAG) with `n` nodes labeled from `0` to `n-1`. The graph is represented by an array `edges` where `edges[i] = [ui, vi]` represents a directed edge from `ui` to `vi`.

Return the minimum number of vertices from which you can reach all nodes in the graph.

### Example 1:
```
Input: n = 6, edges = [[0,1],[0,2],[2,5],[3,4],[4,2]]
Output: [0,3]
```

### Example 2:
```
Input: n = 5, edges = [[0,1],[2,3],[1,4]]
Output: [0,1,2,3,4]
```

## Approach

This problem can be solved using graph analysis:

1. **Graph Construction**:
   - Build adjacency list from edges
   - Track in-degree and out-degree of each node

2. **Source Identification**:
   - Find all nodes with in-degree = 0 (potential sources)
   - These are candidates for the minimum vertex set

3. **Reachability Check**:
   - For each source candidate, perform BFS/DFS
   - Check if all nodes are reachable
   - Find the minimum set that covers all nodes

## Solution Code

```go
func findSmallestSetOfVertices(n int, edges [][]int) []int {
    // Build adjacency list and track in-degrees
    graph := make([][]int, n)
    inDegree := make([]int, n)
    
    for _, edge := range edges {
        u, v := edge[0], edge[1]
        graph[u] = append(graph[u], v)
        inDegree[v]++
    }
    
    // Find all nodes with in-degree = 0
    sources := []int{}
    for i := 0; i < n; i++ {
        if inDegree[i] == 0 {
            sources = append(sources, i)
        }
    }
    
    // Check each source for reachability
    minSize := math.MaxInt32
    result := []int{}
    
    for _, source := range sources {
        visited := make([]bool, n)
        queue := []int{source}
        visited[source] = true
        count := 0
        
        for len(queue) > 0 {
            current := queue[0]
            queue = queue[1:]
            count++
            
            for _, neighbor := range graph[current] {
                if !visited[neighbor] {
                    visited[neighbor] = true
                    queue = append(queue, neighbor)
                }
            }
        }
        
        if count == n {
            if len(sources) == 1 {
                return sources
            }
            if count < minSize {
                minSize = count
                result = []int{source}
            } else if count == minSize {
                result = append(result, source)
            }
        }
    }
    
    return result
}
```

## Complexity Analysis

- **Time**: O(V * (V + E)) where V is the number of nodes (n) and E is the number of edges
  - Building graph: O(E)
  - For each source, BFS: O(V + E)
  - In worst case, we check all sources: O(V * (V + E))
- **Space**: O(V + E) for the graph and visited array

## Link

[LeetCode 1557 Minimum Number of Vertices to Reach All Nodes](https://leetcode.com/problems/minimum-number-of-vertices-to-reach-all-nodes/)