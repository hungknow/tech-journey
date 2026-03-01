# 1724 Checking Existence of Edge Length Limited Paths II

## Problem Description

You are given an undirected graph with `n` nodes labeled from `0` to `n-1`. The graph is represented by `edgeList` where `edgeList[i] = [ui, vi, wi]` represents an edge between nodes `ui` and `vi` with weight `wi`.

You are also given `queries` where `queries[i] = [pj, qj, limiti]` asks if there's a path from node `pj` to node `qj` such that every edge in the path has weight at most `limiti`.

Return an array of booleans where the ith element is true if the ith query can be satisfied.

### Example 1:
```
Input: n = 3, edgeList = [[0,1,2],[1,2,4],[1,2,6],[2,0,8],[2,0,12]], queries = [[0,1,4],[1,2,5]]
Output: [true, false]
```

### Example 2:
```
Input: n = 5, edgeList = [[0,1,10],[1,2,5],[2,3,9],[3,4,13]], queries = [[0,4,14],[1,4,13]]
Output: [true, false]
```

## Approach

This problem can be solved using Union Find with offline processing:

1. **Sort Queries by Limit**: Sort queries in ascending order of limit.

2. **Process Queries Offline**:
   - For each query, add all edges with weight <= limit to the Union Find structure
   - Check if the query nodes are connected

3. **Efficient Processing**: 
   - Use a persistent Union Find or process queries in batches to avoid redundant operations
   - Maintain the state of the graph as we increase the limit

## Solution Code

```go
func distanceLimitedPathsExist(n int, edgeList [][]int, queries [][]int) []bool {
    // Sort queries by limit
    indexedQueries := make([]struct {
        p, q, limit, idx int
    }, len(queries))
    
    for i, query := range queries {
        indexedQueries[i] = struct {
            p, q, limit, idx int
        }{query[0], query[1], query[2], i}
    }
    
    sort.Slice(indexedQueries, func(i, j int) bool {
        return indexedQueries[i].limit < indexedQueries[j].limit
    })
    
    // Sort edges by weight
    sort.Slice(edgeList, func(i, j int) bool {
        return edgeList[i][2] < edgeList[j][2]
    })
    
    parent := make([]int, n)
    
    // Initialize Union Find
    for i := range parent {
        parent[i] = i
    }
    
    var find func(x int) int
    find = func(x int) int {
        if parent[x] != x {
            parent[x] = find(parent[x])
        }
        return parent[x]
    }
    
    union := func(x, y int) {
        rootX, rootY := find(x), find(y)
        if rootX != rootY {
            parent[rootX] = rootY
        }
    }
    
    result := make([]bool, len(queries))
    edgeIndex := 0
    
    for _, query := range indexedQueries {
        p, q, limit, idx := query.p, query.q, query.limit
        
        // Add all edges with weight <= limit
        for edgeIndex < len(edgeList) && edgeList[edgeIndex][2] <= limit {
            u, v := edgeList[edgeIndex][0], edgeList[edgeIndex][1]
            union(u, v)
            edgeIndex++
        }
        
        // Check if p and q are connected
        result[idx] = find(p) == find(q)
    }
    
    return result
}
```

## Complexity Analysis

- **Time**: O(m log m + q log q + (m + q)α(n)) where m is the number of edges and q is the number of queries
  - Sorting edges: O(m log m)
  - Sorting queries: O(q log q)
  - Union Find operations: O((m + q)α(n)) but practically O(m + q)
- **Space**: O(n + q) for the Union Find data structure and result array

## Link

[LeetCode 1724 Checking Existence of Edge Length Limited Paths II](https://leetcode.com/problems/checking-existence-of-edge-length-limited-paths-ii/)