# 2737 Find the Closest Marked Node

## Problem Description

You are given an undirected weighted graph with `n` nodes labeled from 0 to n-1 and `edges` where `edges[i] = [ui, vi, wi]` represents an edge between `ui` and `vi` with weight `wi`.

You are also given an array `marked` containing the indices of marked nodes.

For each unmarked node, return the distance to the nearest marked node. If there are multiple nearest marked nodes, return the distance to the one with the smallest index.

Return an array `answer` where `answer[i]` is the distance from node `i` to its nearest marked node.

### Example 1:
```
Input: n = 4, edges = [[0,1,1],[1,2,2],[2,3,3]], marked = [0,3]
Output: [0,1,2,0]
```

### Example 2:
```
Input: n = 3, edges = [[0,1,5],[1,2,1]], marked = [2]
Output: [6,1,0]
```

## Approach

This problem can be solved using multi-source Dijkstra's algorithm:

1. **Multi-source BFS**:
   - Initialize all marked nodes with distance 0
   - Use priority queue with all marked nodes as sources
   - Expand outward to find distances for unmarked nodes

2. **Distance Calculation**:
   - Use Dijkstra's algorithm from multiple sources
   - Track minimum distance for each node
   - Update when shorter paths are found

3. **Priority Queue**:
   - Start with all marked nodes in the queue
   - Process nodes in order of increasing distance
   - Ensure each node gets its minimum distance

4. **Result Construction**:
   - After Dijkstra completes, distances are ready
   - Return the distance array
   - Marked nodes will have distance 0

## Solution Code

```go
func findClosestNode(n int, edges [][]int, marked []int) []int {
    // Build adjacency list
    graph := make([][][2]int, n)
    for _, edge := range edges {
        u, v, w := edge[0], edge[1], edge[2]
        graph[u] = append(graph[u], [2]int{v, w})
        graph[v] = append(graph[v], [2]int{u, w})
    }
    
    // Initialize distances
    dist := make([]int, n)
    for i := 0; i < n; i++ {
        dist[i] = 1<<31 - 1
    }
    
    // Multi-source Dijkstra
    pq := [][2]int{}
    
    // Initialize with all marked nodes
    for _, node := range marked {
        dist[node] = 0
        pq = append(pq, [2]int{0, node})
    }
    
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
```

## Complexity Analysis

- **Time**: O((V + E) log V) where V is vertices and E is edges
  - Multi-source Dijkstra's algorithm
  - Each edge is processed at most once
- **Space**: O(V + E) for the adjacency list and distance array

## Link

[LeetCode 2737 Find the Closest Marked Node](https://leetcode.com/problems/find-the-closest-marked-node/)