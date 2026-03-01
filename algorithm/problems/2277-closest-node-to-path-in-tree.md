# Closest Node to Path in Tree

## Problem Description

You are given a tree (i.e. a connected, undirected graph that has no cycles) rooted at node `0` consisting of `n` nodes numbered from `0` to `n - 1`. The tree is represented by a 0-indexed 2D integer array `edges` of length `n - 1`, where `edges[i] = [ai, bi]` indicates that there is an edge between nodes `ai` and `bi` in the tree.

You are also given a 2D integer array `queries` of length `m`, where `queries[j] = [uj, vj]`. For each query `j`, find the node on the path between `uj` and `vj` that is closest to `wj`, or return `-1` if no such node exists.

Return an array `answer` of length `m` where `answer[j]` is the answer to the `j`th query.

**Example 1:**
```
Input: n = 7, edges = [[0,1],[0,2],[0,3],[1,4],[2,5],[2,6]], queries = [[5,3,4],[5,3,6]]
Output: [0,2]
Explanation: 
- Query 0: The path between 5 and 3 is 5 -> 2 -> 0 -> 3. Node 0 is closest to 4.
- Query 1: The path between 5 and 3 is 5 -> 2 -> 0 -> 3. Node 2 is closest to 6.
```

**Example 2:**
```
Input: n = 3, edges = [[0,1],[1,2]], queries = [[0,1,2]]
Output: [1]
Explanation: The path between 0 and 2 is 0 -> 1 -> 2. Node 1 is closest to 2.
```

**Constraints:**
- 1 <= n <= 1000
- edges.length == n - 1
- edges[i].length == 2
- 0 <= ai, bi < n
- 1 <= queries.length <= 1000
- queries[j].length == 3
- 0 <= uj, vj, wj < n

## The Twist

This is a tree problem where we need to find the closest node to a given target on the path between two nodes. The key insight is to use Binary Lifting for efficient LCA queries and BFS to precompute distances.

## Algorithm

### Approach: Binary Lifting + BFS

1. Build the tree adjacency list
2. Precompute binary lifting table and depths using BFS/DFS
3. For each query:
   - Find the LCA of u and v
   - Get all nodes on the path from u to v
   - Find the node on this path closest to w

```go
func closestNode(n int, edges [][]int, queries [][]int) []int {
    // Build adjacency list
    adj := make([][]int, n)
    for _, edge := range edges {
        adj[edge[0]] = append(adj[edge[0]], edge[1])
        adj[edge[1]] = append(adj[edge[1]], edge[0])
    }
    
    // Precompute binary lifting table and depths
    LOG := 12
    up := make([][]int, n)
    depth := make([]int, n)
    for i := range up {
        up[i] = make([]int, LOG)
    }
    
    // BFS to fill depth and up[0]
    queue := []int{0}
    visited := make([]bool, n)
    visited[0] = true
    depth[0] = 0
    
    for len(queue) > 0 {
        node := queue[0]
        queue = queue[1:]
        
        for _, neighbor := range adj[node] {
            if !visited[neighbor] {
                visited[neighbor] = true
                depth[neighbor] = depth[node] + 1
                up[neighbor][0] = node
                queue = append(queue, neighbor)
            }
        }
    }
    
    // Fill binary lifting table
    for j := 1; j < LOG; j++ {
        for i := 0; i < n; i++ {
            up[i][j] = up[up[i][j-1]][j-1]
        }
    }
    
    // LCA function
    lca := func(u, v int) int {
        if depth[u] < depth[v] {
            u, v = v, u
        }
        
        // Bring u to same level as v
        for j := LOG - 1; j >= 0; j-- {
            if depth[u]-depth[v] >= (1 << j) {
                u = up[u][j]
            }
        }
        
        if u == v {
            return u
        }
        
        for j := LOG - 1; j >= 0; j-- {
            if up[u][j] != up[v][j] {
                u = up[u][j]
                v = up[v][j]
            }
        }
        
        return up[u][0]
    }
    
    // Get path from u to v
    getPath := func(u, v int) []int {
        ancestor := lca(u, v)
        path := []int{}
        
        // Path from u to ancestor
        for u != ancestor {
            path = append(path, u)
            u = up[u][0]
        }
        path = append(path, ancestor)
        
        // Path from v to ancestor (excluding ancestor)
        path2 := []int{}
        for v != ancestor {
            path2 = append(path2, v)
            v = up[v][0]
        }
        
        // Reverse path2 and append
        for i, j := 0, len(path2)-1; i < j; i, j = i+1, j-1 {
            path2[i], path2[j] = path2[j], path2[i]
        }
        path = append(path, path2...)
        
        return path
    }
    
    // Precompute distances from all nodes
    dist := make([][]int, n)
    for i := 0; i < n; i++ {
        dist[i] = make([]int, n)
        for j := 0; j < n; j++ {
            dist[i][j] = -1
        }
        dist[i][i] = 0
        queue := []int{i}
        for len(queue) > 0 {
            node := queue[0]
            queue = queue[1:]
            for _, neighbor := range adj[node] {
                if dist[i][neighbor] == -1 {
                    dist[i][neighbor] = dist[i][node] + 1
                    queue = append(queue, neighbor)
                }
            }
        }
    }
    
    // Answer queries
    answer := make([]int, len(queries))
    for i, q := range queries {
        u, v, w := q[0], q[1], q[2]
        path := getPath(u, v)
        
        closest := -1
        minDist := -1
        for _, node := range path {
            d := dist[w][node]
            if closest == -1 || d < minDist {
                closest = node
                minDist = d
            }
        }
        answer[i] = closest
    }
    
    return answer
}
```

## Complexity

- **Time Complexity:** O((n + q) * log n + n^2) - For binary lifting and distance precomputation
- **Space Complexity:** O(n * log n + n^2) - For the binary lifting table and distance matrix

## Link

[LeetCode 2277 - Closest Node to Path in Tree](https://leetcode.com/problems/closest-node-to-path-in-tree/)
