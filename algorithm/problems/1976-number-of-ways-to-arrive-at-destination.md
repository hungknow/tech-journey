# 1976 Number of Ways to Arrive at Destination

## Problem Description

You are given a directed graph with `n` vertices labeled from 0 to n-1 and `edges` where `edges[i] = [ui, vi, timei]` represents a directed edge from `ui` to `vi` that takes `timei` units of time to traverse.

You want to travel from vertex 0 to vertex n-1 in the shortest time possible.

Return the number of different ways you can travel from vertex 0 to vertex n-1 in the shortest time. Since the answer may be large, return it modulo 10^9 + 7.

### Example 1:
```
Input: n = 7, edges = [[0,6,7],[0,1,2],[1,2,3],[1,3,3],[6,3,3],[3,5,1],[6,5,1],[2,5,1],[0,4,5],[4,6,2]]
Output: 4
```

### Example 2:
```
Input: n = 2, edges = [[1,0,10]]
Output: 1
```

## Approach

This problem can be solved using Dijkstra's algorithm with path counting:

1. **Shortest Path Calculation**:
   - Use Dijkstra's algorithm to find shortest distance from source to all vertices
   - Track the number of ways to reach each vertex with the shortest distance

2. **Path Counting**:
   - When relaxing edges, if we find a shorter distance, update distance and reset count
   - If we find an equal distance, add to the count

3. **Priority Queue**:
   - Use min-heap to always expand the vertex with current shortest distance
   - Track both distance and path count for each vertex

4. **Modulo Operation**:
   - Apply modulo 10^9 + 7 to prevent integer overflow
   - Handle large numbers of paths

## Solution Code

```go
func countPaths(n int, roads [][]int) int {
    MOD := 1000000007
    
    // Build adjacency list
    graph := make([][][2]int, n)
    for _, road := range roads {
        u, v, time := road[0], road[1], road[2]
        graph[u] = append(graph[u], [2]int{v, time})
        graph[v] = append(graph[v], [2]int{u, time})
    }
    
    // Dijkstra with path counting
    dist := make([]int, n)
    ways := make([]int, n)
    for i := 0; i < n; i++ {
        dist[i] = 1<<31 - 1
        ways[i] = 0
    }
    dist[0] = 0
    ways[0] = 1
    
    // Priority queue: {distance, vertex}
    pq := [][2]int{{0, 0}}
    
    for len(pq) > 0 {
        current := pq[0]
        pq = pq[1:]
        
        d, u := current[0], current[1]
        
        if d > dist[u] {
            continue
        }
        
        for _, edge := range graph[u] {
            v, time := edge[0], edge[1]
            
            if dist[v] > d+time {
                dist[v] = d + time
                ways[v] = ways[u]
                pq = append(pq, [2]int{dist[v], v})
            } else if dist[v] == d+time {
                ways[v] = (ways[v] + ways[u]) % MOD
            }
        }
    }
    
    return ways[n-1]
}
```

## Complexity Analysis

- **Time**: O((V + E) log V) where V is the number of vertices and E is the number of edges
  - Dijkstra's algorithm with priority queue
- **Space**: O(V + E) for the adjacency list, distance array, and ways array

## Link

[LeetCode 1976 Number of Ways to Arrive at Destination](https://leetcode.com/problems/number-of-ways-to-arrive-at-destination/)