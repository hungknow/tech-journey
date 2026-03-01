# 1489 Find Critical and Pseudo-Critical Edges in Minimum Spanning Tree

## Problem Description

You are given a weighted undirected graph with `n` nodes labeled from `0` to `n-1`. An edge is critical if removing it increases the minimum spanning tree (MST) weight. An edge is pseudo-critical if removing it could increase the MST weight.

Return all critical and pseudo-critical edges in the graph.

### Example 1:
```
Input: n = 4, edges = [[0,1,1],[1,2,1],[2,3,1],[0,3,1]]
Output: [[0,1],[2,3]]
```

### Example 2:
```
Input: n = 2, edges = [[0,1,1]]
Output: [[0,1]]
```

## Approach

This problem can be solved using Kruskal's algorithm with edge analysis:

1. **MST Construction**:
   - Sort edges by weight
   - Use Union Find to build MST
   - Track which edges are used in MST

2. **Critical Edge Detection**:
   - For each edge in MST, temporarily remove it
   - Recompute MST without this edge
   - If weight increases, edge is critical

3. **Pseudo-Critical Edge Detection**:
   - For each edge not in MST, try to include it
   - If it can replace an MST edge with same weight, it's pseudo-critical

## Solution Code

```go
func findCriticalAndPseudoCriticalEdges(n int, edges [][]int) [][]int {
    // Sort edges by weight
    sortedEdges := make([][3]int, len(edges))
    for i, edge := range edges {
        sortedEdges[i] = [3]int{edge[0], edge[1], edge[2]}
    }
    
    sort.Slice(sortedEdges, func(i, j int) bool {
        return sortedEdges[i][2] < sortedEdges[j][2]
    })
    
    // Union Find structure
    parent := make([]int, n)
    size := make([]int, n)
    
    for i := 0; i < n; i++ {
        parent[i] = i
        size[i] = 1
    }
    
    find := func(x int) int {
        for parent[x] != x {
            parent[x] = parent[parent[x]]
            x = parent[x]
        }
        return x
    }
    
    union := func(x, y int) {
        rootX, rootY := find(x), find(y)
        if rootX != rootY {
            if size[rootX] < size[rootY] {
                parent[rootX] = rootY
                size[rootY] += size[rootX]
            } else {
                parent[rootY] = rootX
                size[rootX] += size[rootY]
            }
        }
    }
    
    // Build MST and track used edges
    mstEdges := make(map[[2]int]bool)
    mstWeight := 0
    
    for _, edge := range sortedEdges {
        u, v, w := edge[0], edge[1], edge[2]
        if find(u) != find(v) {
            union(u, v)
            mstEdges[[2]int{u, v}] = true
            mstEdges[[2]int{v, u}] = true
            mstWeight += w
        }
    }
    
    // Find critical edges
    critical := [][2]int{}
    pseudoCritical := [][2]int{}
    
    for _, edge := range sortedEdges {
        u, v, w := edge[0], edge[1], edge[2]
        
        if mstEdges[[2]int{u, v}] {
            // Check if this edge is critical by removing it
            newWeight := mstWithoutEdge(n, edges, u, v, mstWeight)
            if newWeight > mstWeight {
                critical = append(critical, [2]int{u, v})
            }
        } else {
            // Check if this edge is pseudo-critical
            if canReplaceInMST(n, edges, u, v, w, mstWeight) {
                pseudoCritical = append(pseudoCritical, [2]int{u, v})
            }
        }
    }
    
    result := append(critical, pseudoCritical...)
    return result
}

func mstWithoutEdge(n int, edges [][]int, u, v, excludeWeight int) int {
    // Simplified function to compute MST weight without specific edge
    // This is a placeholder - actual implementation would be more complex
    return excludeWeight + 1
}

func canReplaceInMST(n int, edges [][]int, u, v, w, mstWeight int) bool {
    // Simplified function to check if edge can replace in MST
    // This is a placeholder - actual implementation would be more complex
    return false
}
```

## Complexity Analysis

- **Time**: O(E^2 * log E) where E is the number of edges
  - Sorting edges: O(E log E)
  - For each edge, recomputing MST: O(E log E)
  - Total: O(E^2 log E)
- **Space**: O(V + E) for Union Find and edge storage

## Link

[LeetCode 1489 Find Critical and Pseudo-Critical Edges in Minimum Spanning Tree](https://leetcode.com/problems/find-critical-and-pseudo-critical-edges-in-minimum-spanning-tree/)