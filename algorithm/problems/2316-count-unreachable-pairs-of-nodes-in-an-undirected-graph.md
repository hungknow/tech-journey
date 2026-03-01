# 2316 Count Unreachable Pairs of Nodes in an Undirected Graph

## Problem Description

You are given an integer `n` and a list of edges representing an undirected graph. The graph has `n` nodes labeled from `0` to `n-1`.

Two nodes are unreachable if there's no path between them.

Return the number of unreachable pairs of nodes.

### Example 1:
```
Input: n = 3, edges = [[0,1],[2,3]]
Output: 2
```

### Example 2:
```
Input: n = 5, edges = [[0,1],[2,3],[4,5]]
Output: 4
```

## Approach

This problem can be solved using BFS to find connected components:

1. **Connected Components**:
   - Use BFS to find all connected components
   - For each unvisited node, perform BFS to find its component
   - Track the size of each component

2. **Unreachable Pairs Calculation**:
   - For each component of size `s`, it can form unreachable pairs with nodes in other components
   - Total unreachable pairs = sum of (size_i * sum of sizes of remaining components)

3. **Efficient Calculation**: Use a running sum to avoid O(n^2) calculation

## Solution Code

```go
func countPairs(n int, connections [][]int) int64 {
    // Build adjacency list
    graph := make([][]int, n)
    for _, edge := range connections {
        u, v := edge[0], edge[1]
        graph[u] = append(graph[u], v)
        graph[v] = append(graph[v], u)
    }
    
    visited := make([]bool, n)
    componentSizes := []int{}
    
    // Find all connected components using BFS
    for i := 0; i < n; i++ {
        if !visited[i] {
            size := bfs(graph, i, visited)
            componentSizes = append(componentSizes, size)
        }
    }
    
    // Calculate unreachable pairs
    var result int64
    remainingNodes := int64(n)
    
    for _, size := range componentSizes {
        componentSize := int64(size)
        result += componentSize * (remainingNodes - componentSize)
        remainingNodes -= componentSize
    }
    
    return result
}

func bfs(graph [][]int, start int, visited []bool) int {
    queue := []int{start}
    visited[start] = true
    size := 0
    
    for len(queue) > 0 {
        current := queue[0]
        queue = queue[1:]
        size++
        
        for _, neighbor := range graph[current] {
            if !visited[neighbor] {
                visited[neighbor] = true
                queue = append(queue, neighbor)
            }
        }
    }
    
    return size
}
```

## Complexity Analysis

- **Time**: O(V + E) where V is the number of nodes (n) and E is the number of edges
  - Building the graph: O(E)
  - BFS to find components: O(V + E)
  - Calculating pairs: O(V)
- **Space**: O(V + E) for the graph, visited array, and queue

## Link

[LeetCode 2316 Count Unreachable Pairs of Nodes in an Undirected Graph](https://leetcode.com/problems/count-unreachable-pairs-of-nodes-in-an-undirected-graph/)