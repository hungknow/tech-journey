# 2699 Modify Graph Edge Weights

## Problem Description

You are given an undirected weighted graph with `n` nodes labeled from 0 to n-1 and `edges` where `edges[i] = [ui, vi, wi]` represents an edge between `ui` and `vi` with weight `wi`.

You are also given `source1`, `source2`, and `target`.

You can modify the weight of exactly one edge to any non-negative value.

Return the minimum possible maximum distance from `source1` to `target` and from `source2` to `target` after modifying exactly one edge.

### Example 1:
```
Input: n = 5, edges = [[4,1,30],[4,0,23],[0,3,7],[3,1,9],[1,2,5],[2,3,2]], source1 = 0, source2 = 2, target = 4
Output: 13
```

### Example 2:
```
Input: n = 3, edges = [[0,1,5],[1,2,3],[0,2,6]], source1 = 0, source2 = 1, target = 2
Output: 4
```

## Approach

This problem can be solved using Dijkstra's algorithm with edge modification:

1. **Multiple Dijkstra Runs**:
   - Run Dijkstra from `source1` to all nodes
   - Run Dijkstra from `source2` to all nodes  
   - Run Dijkstra from `target` to all nodes (on reversed graph)

2. **Edge Modification Analysis**:
   - For each edge, calculate the effect of setting its weight to 0
   - The optimal path will use the modified edge
   - Calculate new distances for both sources

3. **Distance Calculation**:
   - For each edge (u,v,w), the new distance is:
     min(dist1[u] + distT[v], dist1[v] + distT[u]) for source1
     min(dist2[u] + distT[v], dist2[v] + distT[u]) for source2
   - Take the maximum of these two distances

4. **Result Selection**:
   - Try all possible edge modifications
   - Find the minimum maximum distance
   - Consider the case of no modification

## Solution Code

```go
func modifiedGraphEdges(n int, edges [][]int, source1 int, source2 int, target int) int {
    // Build adjacency lists
    graph1 := make([][][2]int, n) // For source1 and source2
    graph2 := make([][][2]int, n) // For target (reversed)
    
    for i, edge := range edges {
        u, v, w := edge[0], edge[1], edge[2]
        graph1[u] = append(graph1[u], [2]int{v, w})
        graph1[v] = append(graph1[v], [2]int{u, w})
        graph2[u] = append(graph2[u], [2]int{v, w})
        graph2[v] = append(graph2[v], [2]int{u, w})
    }
    
    // Dijkstra from source1
    dist1 := dijkstra(graph1, source1, n)
    
    // Dijkstra from source2
    dist2 := dijkstra(graph1, source2, n)
    
    // Dijkstra from target (on reversed graph)
    distT := dijkstra(graph2, target, n)
    
    // Calculate result without modification
    result := max(dist1[target], dist2[target])
    
    // Try modifying each edge
    for i, edge := range edges {
        u, v, w := edge[0], edge[1], edge[2]
        
        // Calculate new distances if this edge weight is set to 0
        newDist1 := min(dist1[u]+distT[v], dist1[v]+distT[u])
        newDist2 := min(dist2[u]+distT[v], dist2[v]+distT[u])
        
        currentMax := max(newDist1, newDist2)
        if currentMax < result {
            result = currentMax
        }
    }
    
    return result
}

func dijkstra(graph [][][2]int, start int, n int) []int {
    dist := make([]int, n)
    for i := 0; i < n; i++ {
        dist[i] = 1<<31 - 1
    }
    dist[start] = 0
    
    pq := [][2]int{{0, start}}
    
    for len(pq) > 0 {
        current := pq[0]
        pq = pq[1:]
        
        d, u := current[0], current[1]
        
        if d > dist[u] {
            continue
        }
        
        for _, edge := range graph[u] {
            v, w := edge[0], edge[1]
            if dist[v] > d+w {
                dist[v] = d + w
                pq = append(pq, [2]int{dist[v], v})
            }
        }
    }
    
    return dist
}

func min(a, b int) int {
    if a < b {
        return a
    }
    return b
}

func max(a, b int) int {
    if a > b {
        return a
    }
    return b
}
```

## Complexity Analysis

- **Time**: O((V + E) log V + E) where V is vertices and E is edges
  - Three Dijkstra runs: 3 * O((V + E) log V)
  - Edge modification analysis: O(E)
- **Space**: O(V + E) for the adjacency lists and distance arrays

## Link

[LeetCode 2699 Modify Graph Edge Weights](https://leetcode.com/problems/modify-graph-edge-weights/)