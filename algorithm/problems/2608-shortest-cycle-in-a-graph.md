# 2608 Shortest Cycle in a Graph

## Problem Description

You are given a directed graph with `n` nodes labeled from 0 to n-1 and `edges` where `edges[i] = [ui, vi]` represents a directed edge from `ui` to `vi`.

A cycle is a path that starts and ends at the same node with at least one edge.

Return the length of the shortest cycle in the graph. If there is no cycle, return -1.

### Example 1:
```
Input: n = 7, edges = [[0,1],[1,2],[2,0],[3,4],[4,5],[5,6],[6,3]]
Output: 3
```

### Example 2:
```
Input: n = 4, edges = [[0,1],[1,2],[2,3]]
Output: -1
```

## Approach

This problem can be solved using BFS from each node:

1. **Cycle Detection**:
   - For each node, perform BFS to find shortest cycle starting from that node
   - Track distance and parent for each visited node
   - When encountering a visited node, calculate cycle length

2. **BFS Implementation**:
   - Use queue for BFS traversal
   - Track distance from start node
   - Track parent to reconstruct cycle

3. **Cycle Length Calculation**:
   - When finding an edge to a visited node (not parent), calculate cycle length
   - Cycle length = current_distance + 1 - visited_distance
   - Keep track of minimum cycle length

4. **Optimization**:
   - Early termination if cycle length is 1 (minimum possible)
   - Reset visited array for each BFS start
   - Process each node as potential cycle start

## Solution Code

```go
func findShortestCycle(n int, edges [][]int) int {
    // Build adjacency list
    graph := make([][]int, n)
    for _, edge := range edges {
        u, v := edge[0], edge[1]
        graph[u] = append(graph[u], v)
    }
    
    shortest := -1
    
    for start := 0; start < n; start++ {
        // BFS from start node
        dist := make([]int, n)
        parent := make([]int, n)
        for i := 0; i < n; i++ {
            dist[i] = -1
            parent[i] = -1
        }
        
        queue := []int{start}
        dist[start] = 0
        
        for len(queue) > 0 {
            current := queue[0]
            queue = queue[1:]
            
            for _, neighbor := range graph[current] {
                if dist[neighbor] == -1 {
                    dist[neighbor] = dist[current] + 1
                    parent[neighbor] = current
                    queue = append(queue, neighbor)
                } else if parent[current] != neighbor {
                    // Found a cycle
                    cycleLength := dist[current] + dist[neighbor] + 1
                    if shortest == -1 || cycleLength < shortest {
                        shortest = cycleLength
                    }
                }
            }
        }
    }
    
    return shortest
}
```

## Complexity Analysis

- **Time**: O(N * (N + E)) where N is the number of nodes and E is the number of edges
  - BFS from each node: O(N + E)
  - Total: N times BFS = O(N * (N + E))
- **Space**: O(N + E) for the adjacency list and BFS arrays

## Link

[LeetCode 2608 Shortest Cycle in a Graph](https://leetcode.com/problems/shortest-cycle-in-a-graph/)