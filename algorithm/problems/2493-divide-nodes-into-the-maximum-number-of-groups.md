# 2493 Divide Nodes Into the Maximum Number of Groups

## Problem Description

You are given an undirected graph with `n` nodes and `edges` list. You need to divide the nodes into groups such that:

1. Each node belongs to exactly one group
2. No two nodes in the same group are directly connected by an edge
3. The number of groups is maximized

Return the maximum number of groups possible.

### Example 1:
```
Input: n = 4, edges = [[1,2],[1,3],[2,3],[3,4]]
Output: 3
```

### Example 2:
```
Input: n = 6, edges = [[1,2],[1,3],[2,3],[4,5],[5,6],[4,6]]
Output: 4
```

## Approach

This problem can be solved using BFS to check bipartiteness:

1. **Key Insight**:
   - The problem is equivalent to finding if the graph is bipartite
   - If bipartite, we can divide into 2 groups
   - If not bipartite, we need to find the maximum grouping

2. **BFS Bipartite Check**:
   - For each connected component, use BFS to check if it's bipartite
   - Use two colors to color the graph
   - If conflict found, the component is not bipartite

3. **Group Calculation**:
   - For bipartite components, count nodes in each color
   - For non-bipartite components, the entire component must be in one group
   - Sum the maximum possible groups across all components

## Solution Code

```go
func magnificentSets(n int, edges [][]int) int {
    // Build adjacency list
    graph := make([][]int, n+1)
    for _, edge := range edges {
        u, v := edge[0], edge[1]
        graph[u] = append(graph[u], v)
        graph[v] = append(graph[v], u)
    }
    
    visited := make([]bool, n+1)
    result := 0
    
    for i := 1; i <= n; i++ {
        if !visited[i] {
            componentSize, isBipartite := bfs(graph, i, visited)
            if isBipartite {
                result += componentSize
            } else {
                result += 1 // Non-bipartite component can only be in one group
            }
        }
    }
    
    return result
}

func bfs(graph [][]int, start int, visited []bool) (int, bool) {
    n := len(graph) - 1
    colors := make([]int, n+1) // 0 = uncolored, 1 = color 1, -1 = color 2
    
    queue := []int{start}
    visited[start] = true
    colors[start] = 1
    componentSize := 0
    colorCount := [2]int{0, 0} // count of each color
    
    for len(queue) > 0 {
        current := queue[0]
        queue = queue[1:]
        componentSize++
        
        if colors[current] == 1 {
            colorCount[0]++
        } else {
            colorCount[1]++
        }
        
        for _, neighbor := range graph[current] {
            if !visited[neighbor] {
                visited[neighbor] = true
                colors[neighbor] = -colors[current]
                queue = append(queue, neighbor)
            } else if colors[neighbor] == colors[current] {
                return 0, false // Not bipartite
            }
        }
    }
    
    // Return the larger color count for maximum grouping
    if colorCount[0] > colorCount[1] {
        return colorCount[0], true
    }
    return colorCount[1], true
}
```

## Complexity Analysis

- **Time**: O(V + E) where V is the number of nodes (n) and E is the number of edges
  - Building the graph: O(E)
  - BFS traversal for all components: O(V + E)
- **Space**: O(V + E) for the graph, visited array, and colors

## Link

[LeetCode 2493 Divide Nodes Into the Maximum Number of Groups](https://leetcode.com/problems/divide-nodes-into-the-maximum-number-of-groups/)