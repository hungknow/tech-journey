# 2203 Minimum Weighted Subgraph With the Required Paths

## Problem Description

You are given a weighted undirected graph with `n` vertices labeled from 0 to n-1 and `edges` where `edges[i] = [ui, vi, weighti]` represents an edge between `ui` and `vi` with weight `weighti`.

You are also given two special vertices `src1` and `src2`.

Find a vertex `target` such that:
- There exists a path from `src1` to `target`
- There exists a path from `src2` to `target`
- The sum of weights of the paths from `src1` to `target` and `src2` to `target` is minimized

Return the minimum possible sum of weights.

### Example 1:
```
Input: n = 6, edges = [[0,2,1],[0,5,3],[2,4,4],[3,5,2],[1,5,2]], src1 = 0, src2 = 1
Output: 9
```

### Example 2:
```
Input: n = 3, edges = [[0,1,1],[2,1,1]], src1 = 0, src2 = 2
Output: 2
```

## Approach

This problem can be solved using Dijkstra's algorithm from multiple sources:

1. **Multiple Dijkstra Runs**:
   - Run Dijkstra from `src1` to get distances to all vertices
   - Run Dijkstra from `src2` to get distances to all vertices
   - Run Dijkstra from each vertex to find minimum meeting point

2. **Distance Calculation**:
   - For each vertex, calculate sum of distances from `src1` and `src2`
   - Find the vertex with minimum total distance

3. **Optimization**:
   - Use adjacency list for efficient graph representation
   - Priority queue for Dijkstra's algorithm
   - Early termination when reaching all vertices

4. **Result Selection**:
   - Iterate through all vertices
   - Find minimum sum of distances from both sources
   - Handle unreachable vertices

## Solution Code

```go
func minimumWeight(n int, edges [][]int, src1 int, src2 int) int64 {
    // Build adjacency list
    graph := make([][][2]int, n)
    for _, edge := range edges {
        u, v, w := edge[0], edge[1], edge[2]
        graph[u] = append(graph[u], [2]int{v, w})
        graph[v] = append(graph[v], [2]int{u, w})
    }
    
    // Dijkstra's algorithm
    dijkstra := func(start int) []int64 {
        dist := make([]int64, n)
        for i := 0; i < n; i++ {
            dist[i] = 1<<63 - 1
        }
        dist[start] = 0
        
        pq := [][2]int{{0, start}}
        
        for len(pq) > 0 {
            current := pq[0]
            pq = pq[1:]
            
            d, u := current[0], current[1]
            
            if int64(d) > dist[u] {
                continue
            }
            
            for _, edge := range graph[u] {
                v, w := edge[0], edge[1]
                if dist[v] > dist[u] + int64(w) {
                    dist[v] = dist[u] + int64(w)
                    pq = append(pq, [2]int{int(dist[v]), v})
                }
            }
        }
        
        return dist
    }
    
    // Calculate distances from both sources
    dist1 := dijkstra(src1)
    dist2 := dijkstra(src2)
    
    // Find minimum sum
    minSum := int64(1<<63 - 1)
    for i := 0; i < n; i++ {
        if dist1[i] != 1<<63-1 && dist2[i] != 1<<63-1 {
            total := dist1[i] + dist2[i]
            if total < minSum {
                minSum = total
            }
        }
    }
    
    if minSum == 1<<63-1 {
        return -1
    }
    
    return minSum
}
```

## Complexity Analysis

- **Time**: O((V + E) log V) where V is the number of vertices and E is the number of edges
  - Two Dijkstra runs: 2 * O((V + E) log V)
  - Final scan: O(V)
- **Space**: O(V + E) for the adjacency list and distance arrays

## Link

[LeetCode 2203 Minimum Weighted Subgraph With the Required Paths](https://leetcode.com/problems/minimum-weighted-subgraph-with-the-required-paths/)