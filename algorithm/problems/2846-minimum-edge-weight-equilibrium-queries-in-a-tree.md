# Minimum Edge Weight Equilibrium Queries in a Tree

## Problem Description

There is a tree with `n` nodes numbered from `0` to `n - 1`. The tree is represented by a 2D integer array `edges` of length `n - 1`, where `edges[i] = [ui, vi, wi]` indicates that there is an edge between nodes `ui` and `vi` with weight `wi`.

You are also given a 2D integer array `queries` of length `m`, where `queries[j] = [uj, vj]`. For each query, find the minimum possible value of `maxEdge - minEdge` for any path from `uj` to `vj`, where `maxEdge` is the maximum edge weight on the path and `minEdge` is the minimum edge weight on the path.

Return an array `answer` of length `m` where `answer[j]` is the answer to the `j`th query.

**Example 1:**
```
Input: n = 7, edges = [[0,1,1],[1,2,1],[2,3,1],[3,4,2],[4,5,2],[5,6,2]], queries = [[0,3],[3,6],[2,6],[0,6]]
Output: [0,0,0,1]
```

**Example 2:**
```
Input: n = 8, edges = [[1,2,6],[1,3,4],[2,4,5],[2,5,3],[3,6,2],[3,0,8],[7,8,1]], queries = [[4,6],[0,4],[6,5],[7,4]]
Output: [1,2,2,3]
```

**Constraints:**
- 1 <= n <= 10^4
- 0 <= edges.length <= n - 1
- edges[i].length == 3
- 0 <= ui, vi < n
- ui != vi
- 1 <= wi <= 10^5
- 1 <= queries.length <= 10^4
- queries[j].length == 2
- 0 <= uj, vj < n

## The Twist

This is a tree problem where we need to find the minimum difference between max and min edge weights on any path between two nodes. The key insight is to use Binary Lifting for efficient LCA queries and precompute min/max edge weights for each ancestor.

## Algorithm

### Approach: Binary Lifting with Min/Max Precomputation

1. Build the tree adjacency list
2. Precompute binary lifting table with min/max edge weights using BFS/DFS
3. For each query:
   - Find the LCA of u and v
   - Get the min and max edge weights on the path from u to LCA
   - Get the min and max edge weights on the path from v to LCA
   - Return the difference between the overall max and min

```go
func minOperationsQueries(n int, edges [][]int, queries [][]int) []int {
    // Build adjacency list
    adj := make([][][2]int, n)
    for _, edge := range edges {
        adj[edge[0]] = append(adj[edge[0]], [2]int{edge[1], edge[2]})
        adj[edge[1]] = append(adj[edge[1]], [2]int{edge[0], edge[2]})
    }
    
    // Precompute binary lifting table and min/max weights
    LOG := 14
    up := make([][]int, n)
    minWeight := make([][]int, n)
    maxWeight := make([][]int, n)
    depth := make([]int, n)
    
    for i := range up {
        up[i] = make([]int, LOG)
        minWeight[i] = make([]int, LOG)
        maxWeight[i] = make([]int, LOG)
        for j := range LOG {
            minWeight[i][j] = 1 << 30
            maxWeight[i][j] = 0
        }
    }
    
    // BFS to fill depth, up[0], minWeight[0], maxWeight[0]
    queue := []int{0}
    visited := make([]bool, n)
    visited[0] = true
    depth[0] = 0
    
    for len(queue) > 0 {
        node := queue[0]
        queue = queue[1:]
        
        for _, neighbor := range adj[node] {
            child, weight := neighbor[0], neighbor[1]
            if !visited[child] {
                visited[child] = true
                depth[child] = depth[node] + 1
                up[child][0] = node
                minWeight[child][0] = weight
                maxWeight[child][0] = weight
                queue = append(queue, child)
            }
        }
    }
    
    // Fill binary lifting table
    for j := 1; j < LOG; j++ {
        for i := 0; i < n; i++ {
            up[i][j] = up[up[i][j-1]][j-1]
            minWeight[i][j] = min(minWeight[i][j-1], minWeight[up[i][j-1]][j-1])
            maxWeight[i][j] = max(maxWeight[i][j-1], maxWeight[up[i][j-1]][j-1])
        }
    }
    
    // LCA function with min/max
    lcaWithMinMax := func(u, v int) (int, int, int, int) {
        minW, maxW := 1<<30, 0
        
        if depth[u] < depth[v] {
            u, v = v, u
        }
        
        // Bring u to same level as v
        diff := depth[u] - depth[v]
        for j := 0; j < LOG; j++ {
            if (diff>>j)&1 == 1 {
                minW = min(minW, minWeight[u][j])
                maxW = max(maxW, maxWeight[u][j])
                u = up[u][j]
            }
        }
        
        if u == v {
            return u, minW, maxW, u
        }
        
        for j := LOG - 1; j >= 0; j-- {
            if up[u][j] != up[v][j] {
                minW = min(minW, min(minWeight[u][j], minWeight[v][j]))
                maxW = max(maxW, max(maxWeight[u][j], maxWeight[v][j]))
                u = up[u][j]
                v = up[v][j]
            }
        }
        
        minW = min(minW, min(minWeight[u][0], minWeight[v][0]))
        maxW = max(maxW, max(maxWeight[u][0], maxWeight[v][0]))
        
        return up[u][0], minW, maxW, up[u][0]
    }
    
    // Answer queries
    answer := make([]int, len(queries))
    for i, q := range queries {
        u, v := q[0], q[1]
        _, minW, maxW, _ := lcaWithMinMax(u, v)
        answer[i] = maxW - minW
    }
    
    return answer
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

## Complexity

- **Time Complexity:** O((n + q) * log n) - For binary lifting and queries
- **Space Complexity:** O(n * log n) - For the binary lifting tables

## Link

[LeetCode 2846 - Minimum Edge Weight Equilibrium Queries in a Tree](https://leetcode.com/problems/minimum-edge-weight-equilibrium-queries-in-a-tree/)
