# Number of Good Paths

## Problem Description

There is a tree (i.e. a connected, undirected graph that has no cycles) rooted at node `0` consisting of `n` nodes numbered from `0` to `n - 1`. The tree is represented by a 0-indexed 2D integer array `edges` of length `n - 1`, where `edges[i] = [ai, bi]` indicates that there is an edge between nodes `ai` and `bi` in the tree.

You are also given a 0-indexed integer array `vals` of length `n`, where `vals[i]` denotes the value of the `i`th node.

A path from node `u` to node `v` is a sequence of edges where each edge connects adjacent nodes in the tree. The length of a path is the number of edges in the path.

A good path is a path where the values of the nodes at the endpoints of the path are equal, and all nodes on the path have values less than or equal to the values at the endpoints.

Return the number of good paths.

**Example 1:**
```
Input: vals = [1,3,2,1,3], edges = [[0,1],[0,2],[2,3],[2,4]]
Output: 6
Explanation: The good paths are:
- 0 -> 1
- 1 -> 0
- 0 -> 2 -> 3
- 3 -> 2 -> 0
- 1 -> 0 -> 2 -> 4
- 4 -> 2 -> 0 -> 1
```

**Example 2:**
```
Input: vals = [1,1,2,2,3], edges = [[0,1],[1,2],[2,3],[2,4]]
Output: 7
Explanation: The good paths are:
- 0 -> 1
- 1 -> 0
- 2 -> 3
- 3 -> 2
- 2 -> 4
- 4 -> 2
- 0 -> 1 -> 2 -> 3
```

**Example 3:**
```
Input: vals = [1,2,3], edges = [[0,1],[1,2]]
Output: 1
Explanation: The only good path is 0 -> 1 -> 2.
```

**Constraints:**
- n == vals.length
- 1 <= n <= 3 * 10^4
- 0 <= edges.length <= n - 1
- edges[i].length == 2
- 0 <= ai, bi < n
- ai != bi
- 0 <= vals[i] <= 10^5

## The Twist

This is a tree problem where we need to count good paths. The key insight is to use Union-Find (Disjoint Set Union) to progressively connect nodes by increasing value, and count paths within each connected component.

## Algorithm

### Approach: Union-Find with Sorting

1. Group nodes by their values
2. Sort nodes by value in increasing order
3. For each value, process all nodes with that value:
   - For each node, union it with its neighbors that have value <= current value
   - Count the number of nodes with the current value in each connected component
   - Add C(count, 2) + count to the result (paths between nodes of same value + single-node paths)
4. Return the total count

```go
func numberOfGoodPaths(vals []int, edges [][]int) int {
    n := len(vals)
    
    // Build adjacency list
    adj := make([][]int, n)
    for _, edge := range edges {
        adj[edge[0]] = append(adj[edge[0]], edge[1])
        adj[edge[1]] = append(adj[edge[1]], edge[0])
    }
    
    // Group nodes by value
    valueToNodes := make(map[int][]int)
    for i, val := range vals {
        valueToNodes[val] = append(valueToNodes[val], i)
    }
    
    // Sort values
    sortedValues := make([]int, 0, len(valueToNodes))
    for val := range valueToNodes {
        sortedValues = append(sortedValues, val)
    }
    sort.Ints(sortedValues)
    
    // Union-Find
    uf := NewUnionFind(n)
    result := 0
    
    // Process values in increasing order
    for _, val := range sortedValues {
        nodes := valueToNodes[val]
        
        // Union nodes with neighbors that have value <= current value
        for _, node := range nodes {
            for _, neighbor := range adj[node] {
                if vals[neighbor] <= val {
                    uf.Union(node, neighbor)
                }
            }
        }
        
        // Count nodes with current value in each component
        componentCount := make(map[int]int)
        for _, node := range nodes {
            root := uf.Find(node)
            componentCount[root]++
        }
        
        // Add good paths for this value
        for _, count := range componentCount {
            result += count * (count + 1) / 2
        }
    }
    
    return result
}

type UnionFind struct {
    parent []int
    rank   []int
}

func NewUnionFind(n int) *UnionFind {
    uf := &UnionFind{
        parent: make([]int, n),
        rank:   make([]int, n),
    }
    for i := range uf.parent {
        uf.parent[i] = i
    }
    return uf
}

func (uf *UnionFind) Find(x int) int {
    if uf.parent[x] != x {
        uf.parent[x] = uf.Find(uf.parent[x])
    }
    return uf.parent[x]
}

func (uf *UnionFind) Union(x, y int) {
    rootX := uf.Find(x)
    rootY := uf.Find(y)
    
    if rootX == rootY {
        return
    }
    
    if uf.rank[rootX] < uf.rank[rootY] {
        uf.parent[rootX] = rootY
    } else if uf.rank[rootX] > uf.rank[rootY] {
        uf.parent[rootY] = rootX
    } else {
        uf.parent[rootY] = rootX
        uf.rank[rootX]++
    }
}
```

## Complexity

- **Time Complexity:** O(n log n) - For sorting and Union-Find operations
- **Space Complexity:** O(n) - For the adjacency list, Union-Find, and auxiliary structures

## Link

[LeetCode 2421 - Number of Good Paths](https://leetcode.com/problems/number-of-good-paths/)
