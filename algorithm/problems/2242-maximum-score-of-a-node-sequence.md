# 2242 Maximum Score of a Node Sequence

## Problem Description

You are given a graph with `n` nodes labeled from 0 to n-1 and `edges` where `edges[i] = [ui, vi]` represents an undirected edge between `ui` and `vi`.

You are also given an array `values` where `values[i]` is the value of node `i`.

A node sequence is valid if:
- Each consecutive pair of nodes in the sequence are connected by an edge
- The sequence contains at least 3 nodes
- The first and last nodes have degree 1 (leaf nodes)

The score of a node sequence is the sum of values of all nodes in the sequence.

Return the maximum possible score of any valid node sequence.

### Example 1:
```
Input: values = [1,2,3,4,5], edges = [[0,1],[0,2],[0,3],[2,4]]
Output: 11
```

### Example 2:
```
Input: values = [5,10,15,20,25], edges = [[0,1],[2,3],[4,1]]
Output: 50
```

## Approach

This problem can be solved by analyzing leaf-to-leaf paths:

1. **Graph Analysis**:
   - Identify leaf nodes (degree 1)
   - Build adjacency list for efficient traversal
   - Track node degrees

2. **Path Finding**:
   - For each leaf node, find paths to other leaf nodes
   - Calculate scores for valid paths
   - Ensure paths have at least 3 nodes

3. **DFS Traversal**:
   - Use DFS to explore paths between leaves
   - Track current path and accumulated score
   - Avoid cycles by tracking visited nodes

4. **Score Calculation**:
   - For each valid leaf-to-leaf path, calculate total score
   - Keep track of maximum score found
   - Handle edge cases (no valid paths)

## Solution Code

```go
func maximumScore(values []int, edges [][]int) int {
    n := len(values)
    if n < 3 {
        return 0
    }
    
    // Build adjacency list and calculate degrees
    graph := make([][]int, n)
    degree := make([]int, n)
    
    for _, edge := range edges {
        u, v := edge[0], edge[1]
        graph[u] = append(graph[u], v)
        graph[v] = append(graph[v], u)
        degree[u]++
        degree[v]++
    }
    
    // Find leaf nodes
    leaves := []int{}
    for i := 0; i < n; i++ {
        if degree[i] == 1 {
            leaves = append(leaves, i)
        }
    }
    
    maxScore := 0
    
    // Try all pairs of leaves
    for i := 0; i < len(leaves); i++ {
        for j := i + 1; j < len(leaves); j++ {
            leaf1, leaf2 := leaves[i], leaves[j]
            
            // Find path between leaf1 and leaf2
            path := findPath(leaf1, leaf2, graph, n)
            
            // Check if path has at least 3 nodes and both ends are leaves
            if len(path) >= 3 && degree[path[0]] == 1 && degree[path[len(path)-1]] == 1 {
                // Calculate score
                score := 0
                for _, node := range path {
                    score += values[node]
                }
                maxScore = max(maxScore, score)
            }
        }
    }
    
    return maxScore
}

func findPath(start, end int, graph [][]int, n int) []int {
    // BFS to find path from start to end
    parent := make([]int, n)
    for i := 0; i < n; i++ {
        parent[i] = -1
    }
    
    queue := []int{start}
    parent[start] = start
    
    for len(queue) > 0 {
        current := queue[0]
        queue = queue[1:]
        
        if current == end {
            break
        }
        
        for _, neighbor := range graph[current] {
            if parent[neighbor] == -1 {
                parent[neighbor] = current
                queue = append(queue, neighbor)
            }
        }
    }
    
    // Reconstruct path
    path := []int{}
    current := end
    
    for current != start {
        if parent[current] == -1 {
            return []int{} // No path found
        }
        path = append([]int{current}, path...)
        current = parent[current]
    }
    path = append([]int{start}, path...)
    
    return path
}

func max(a, b int) int {
    if a > b {
        return a
    }
    return b
}
```

## Complexity Analysis

- **Time**: O(L^2 * (V + E)) where L is the number of leaf nodes, V is vertices, E is edges
  - Finding all leaf pairs: O(L^2)
  - BFS for each pair: O(V + E)
- **Space**: O(V + E) for the adjacency list and BFS traversal

## Link

[LeetCode 2242 Maximum Score of a Node Sequence](https://leetcode.com/problems/maximum-score-of-a-node-sequence/)