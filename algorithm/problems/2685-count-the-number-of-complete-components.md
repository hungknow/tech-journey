# 2685 Count the Number of Complete Components

## Problem Description

You are given an undirected graph with `n` nodes and `edges` list. A component is complete if every pair of nodes in the component is directly connected by an edge.

Return the number of complete components in the graph.

### Example 1:
```
Input: n = 6, edges = [[0,1],[0,2],[1,2],[3,4]]
Output: 3
```

### Example 2:
```
Input: n = 5, edges = [[0,1],[0,2],[1,2],[3,4]]
Output: 2
```

## Approach

This problem can be solved using BFS to find connected components:

1. **Connected Components**:
   - Use BFS to find all connected components
   - For each unvisited node, perform BFS to find its component
   - Track all nodes in each component

2. **Completeness Check**:
   - For each component, check if it's complete
   - A component with k nodes is complete if it has k*(k-1)/2 edges
   - Count the number of complete components

3. **Efficient Checking**: Use adjacency sets for O(1) edge existence checks

## Solution Code

```go
func countCompleteComponents(n int, edges [][]int) int {
    // Build adjacency list and adjacency set
    graph := make([][]int, n)
    adjacencySet := make([]map[int]bool, n)
    for i := 0; i < n; i++ {
        adjacencySet[i] = make(map[int]bool)
    }
    
    for _, edge := range edges {
        u, v := edge[0], edge[1]
        graph[u] = append(graph[u], v)
        graph[v] = append(graph[v], u)
        adjacencySet[u][v] = true
        adjacencySet[v][u] = true
    }
    
    visited := make([]bool, n)
    completeComponents := 0
    
    // Find all connected components using BFS
    for i := 0; i < n; i++ {
        if !visited[i] {
            component := bfs(graph, i, visited)
            
            // Check if component is complete
            if isComplete(component, adjacencySet) {
                completeComponents++
            }
        }
    }
    
    return completeComponents
}

func bfs(graph [][]int, start int, visited []bool) []int {
    queue := []int{start}
    visited[start] = true
    component := []int{}
    
    for len(queue) > 0 {
        current := queue[0]
        queue = queue[1:]
        component = append(component, current)
        
        for _, neighbor := range graph[current] {
            if !visited[neighbor] {
                visited[neighbor] = true
                queue = append(queue, neighbor)
            }
        }
    }
    
    return component
}

func isComplete(component []int, adjacencySet []map[int]bool) bool {
    k := len(component)
    requiredEdges := k * (k - 1) / 2
    
    // Count actual edges in the component
    actualEdges := 0
    for i := 0; i < k; i++ {
        for j := i + 1; j < k; j++ {
            if adjacencySet[component[i]][component[j]] {
                actualEdges++
            }
        }
    }
    
    return actualEdges == requiredEdges
}
```

## Complexity Analysis

- **Time**: O(V + E + V^2) where V is the number of nodes (n) and E is the number of edges
  - Building the graph: O(E)
  - BFS to find components: O(V + E)
  - Checking completeness: O(V^2) in the worst case
- **Space**: O(V + E) for the graph, adjacency sets, and visited array

## Link

[LeetCode 2685 Count the Number of Complete Components](https://leetcode.com/problems/count-the-number-of-complete-components/)