# 2924 Find Champion II

## Problem Description

You are given a directed graph with `n` teams labeled from 0 to n-1 and `edges` where `edges[i] = [ui, vi]` represents a directed edge from `ui` to `vi`.

A team is a champion if:
- Every other team can be reached from this team
- No other team can reach this team

Return the champion team if it exists and is unique, otherwise return -1.

### Example 1:
```
Input: n = 3, edges = [[0,1],[1,2]]
Output: 0
```

### Example 2:
```
Input: n = 4, edges = [[0,2],[1,3],[1,2]]
Output: -1
```

## Approach

This problem can be solved using topological sorting and indegree analysis:

1. **Graph Analysis**:
   - Build adjacency list and indegree array
   - Check if graph is a DAG (no cycles)
   - Find nodes with indegree 0 (potential champions)

2. **Topological Sort**:
   - Use Kahn's algorithm to topologically sort the graph
   - If all nodes are processed, graph is a DAG
   - Track the order of nodes

3. **Champion Identification**:
   - In a DAG, there should be exactly one node with indegree 0
   - This node can reach all others (since it's a DAG)
   - Verify uniqueness and reachability

4. **Validation**:
   - Check if topological sort succeeds (no cycles)
   - Ensure exactly one node has indegree 0
   - Return -1 if conditions are not met

## Solution Code

```go
func findChampion(n int, edges [][]int) int {
    if n == 0 {
        return -1
    }
    
    // Build adjacency list and indegree array
    graph := make([][]int, n)
    indegree := make([]int, n)
    
    for _, edge := range edges {
        u, v := edge[0], edge[1]
        graph[u] = append(graph[u], v)
        indegree[v]++
    }
    
    // Find nodes with indegree 0
    zeroIndegreeNodes := []int{}
    for i := 0; i < n; i++ {
        if indegree[i] == 0 {
            zeroIndegreeNodes = append(zeroIndegreeNodes, i)
        }
    }
    
    // If more than one node has indegree 0, no unique champion
    if len(zeroIndegreeNodes) != 1 {
        return -1
    }
    
    potentialChampion := zeroIndegreeNodes[0]
    
    // Check if all nodes are reachable from potential champion
    visited := make([]bool, n)
    queue := []int{potentialChampion}
    visited[potentialChampion] = true
    visitedCount := 1
    
    for len(queue) > 0 {
        current := queue[0]
        queue = queue[1:]
        
        for _, neighbor := range graph[current] {
            if !visited[neighbor] {
                visited[neighbor] = true
                visitedCount++
                queue = append(queue, neighbor)
            }
        }
    }
    
    // If all nodes are reachable, we have a champion
    if visitedCount == n {
        return potentialChampion
    }
    
    return -1
}
```

## Complexity Analysis

- **Time**: O(V + E) where V is the number of teams and E is the number of edges
  - Building graph: O(E)
  - Finding indegree 0 nodes: O(V)
  - BFS for reachability: O(V + E)
- **Space**: O(V + E) for the adjacency list and visited array

## Link

[LeetCode 2924 Find Champion II](https://leetcode.com/problems/find-champion-ii/)