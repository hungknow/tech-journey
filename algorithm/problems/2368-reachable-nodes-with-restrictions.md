# 2368 Reachable Nodes With Restrictions

## Problem Description

You are given an undirected graph represented by `n` nodes and `edges` list. There are also `restricted` nodes that cannot be visited.

You start at node `0`. Return the number of nodes you can reach without visiting any restricted nodes.

### Example 1:
```
Input: n = 7, edges = [[0,1],[0,2],[1,3],[1,4],[2,5],[2,6]], restricted = [4,5]
Output: 4
```

### Example 2:
```
Input: n = 7, edges = [[0,1],[0,2],[1,3],[1,4],[2,5],[2,6]], restricted = [4,5,6]
Output: 3
```

## Approach

This problem can be solved using BFS with restrictions:

1. **Graph Construction**:
   - Build an adjacency list from the edges
   - Create a set of restricted nodes for O(1) lookup

2. **BFS with Restrictions**:
   - Start BFS from node 0
   - Only visit nodes that are not restricted
   - Track visited nodes to avoid cycles

3. **Counting**: Count the number of reachable nodes

## Solution Code

```go
func reachableNodes(n int, edges [][]int, restricted []int) int {
    // Build adjacency list
    graph := make([][]int, n)
    for _, edge := range edges {
        u, v := edge[0], edge[1]
        graph[u] = append(graph[u], v)
        graph[v] = append(graph[v], u)
    }
    
    // Create set of restricted nodes
    restrictedSet := make(map[int]bool)
    for _, node := range restricted {
        restrictedSet[node] = true
    }
    
    // Check if start node is restricted
    if restrictedSet[0] {
        return 0
    }
    
    // BFS setup
    queue := []int{0}
    visited := make([]bool, n)
    visited[0] = true
    count := 0
    
    for len(queue) > 0 {
        current := queue[0]
        queue = queue[1:]
        count++
        
        // Explore neighbors
        for _, neighbor := range graph[current] {
            if !visited[neighbor] && !restrictedSet[neighbor] {
                visited[neighbor] = true
                queue = append(queue, neighbor)
            }
        }
    }
    
    return count
}
```

## Complexity Analysis

- **Time**: O(V + E) where V is the number of nodes (n) and E is the number of edges
  - Building the graph: O(E)
  - BFS traversal: O(V + E)
- **Space**: O(V + E) for the graph, restricted set, and visited array

## Link

[LeetCode 2368 Reachable Nodes With Restrictions](https://leetcode.com/problems/reachable-nodes-with-restrictions/)