# 1579 Remove Max Number of Edges to Keep Graph Fully Traversable

## Problem Description

You are given a graph with `n` nodes labeled from `1` to `n`. The graph is represented by two arrays:
- `edges1` represents edges that can be used by Alice only
- `edges2` represents edges that can be used by both Alice and Bob

The graph is initially fully traversable by both Alice and Bob. Remove the maximum number of edges while keeping the graph fully traversable by both.

Return the maximum number of edges that can be removed.

### Example 1:
```
Input: n = 4, edges1 = [[3,1],[3,2],[1,2]], edges2 = [[3,3]]
Output: 2
Explanation: Remove edges [3,1] and [3,2] from edges1.
```

### Example 2:
```
Input: n = 4, edges1 = [[3,1],[3,2],[1,2]], edges2 = [[3,3],[1,1]]
Output: 0
Explanation: Cannot remove any edges.
```

## Approach

This problem can be solved using Union Find with Kruskal's algorithm:

1. **Edge Classification**: 
   - Type 3 edges: Available to both Alice and Bob (from edges2)
   - Type 2 edges: Available only to Alice (from edges1)
   - Type 1 edges: Available only to Bob (not in this problem)

2. **Kruskal's Algorithm**:
   - Sort edges by type priority (Type 3 > Type 2 > Type 1)
   - Use Union Find to build a minimum spanning tree
   - Count how many edges of each type are used

3. **Result Calculation**:
   - The maximum edges that can be removed = total edges - edges used in MST

## Solution Code

```go
func maxNumEdgesToRemove(n int, edges [][]int) int {
    // Classify edges by type
    type3 := make([][3]int, 0) // Available to both
    type2 := make([][3]int, 0) // Available to Alice only
    
    for _, edge := range edges {
        if edge[0] == 3 {
            type3 = append(type3, [3]int{edge[1], edge[2], 3})
        } else {
            type2 = append(type2, [3]int{edge[1], edge[2], 2})
        }
    }
    
    // Sort edges by type (Type 3 first, then Type 2)
    allEdges := append(type3, type2...)
    
    parent := make([]int, n+1) // 1-indexed
    
    // Initialize Union Find
    for i := 1; i <= n; i++ {
        parent[i] = i
    }
    
    var find func(x int) int
    find = func(x int) int {
        if parent[x] != x {
            parent[x] = find(parent[x])
        }
        return parent[x]
    }
    
    union := func(x, y int) bool {
        rootX, rootY := find(x), find(y)
        if rootX != rootY {
            parent[rootX] = rootY
            return true
        }
        return false
    }
    
    edgesUsed := 0
    
    for _, edge := range allEdges {
        u, v := edge[0], edge[1]
        
        if union(u, v) {
            edgesUsed++
        }
    }
    
    // Check if the graph is fully connected
    root := find(1)
    for i := 2; i <= n; i++ {
        if find(i) != root {
            return -1
        }
    }
    
    return len(edges) - edgesUsed
}
```

## Complexity Analysis

- **Time**: O(m log m + mα(n)) where m is the total number of edges and n is the number of nodes
  - Sorting edges: O(m log m)
  - Union Find operations: O(mα(n)) but practically O(m)
- **Space**: O(n) for the Union Find data structure

## Link

[LeetCode 1579 Remove Max Number of Edges to Keep Graph Fully Traversable](https://leetcode.com/problems/remove-max-number-of-edges-to-keep-graph-fully-traversable/)