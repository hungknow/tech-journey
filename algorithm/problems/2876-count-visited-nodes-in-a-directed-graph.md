# 2876 Count Visited Nodes in a Directed Graph

## Problem Description

You are given a directed graph with `n` nodes labeled from 0 to n-1 and `edges` where `edges[i] = [ui, vi]` represents a directed edge from `ui` to `vi`.

You start at node 0 and follow the edges according to the following rules:
- If you're at node `i` and `edges[i]` exists, move to `edges[i]`
- If `edges[i]` doesn't exist, stop at node `i`

Return an array `answer` where `answer[i]` is the number of unique nodes visited if you start at node `i`.

### Example 1:
```
Input: edges = [[1,2],[0,1],[3,2]]
Output: [1,1,3,2]
```

### Example 2:
```
Input: edges = [[1,2],[0,0],[3,2]]
Output: [1,2,3,2]
```

## Approach

This problem can be solved using cycle detection and memoization:

1. **Cycle Detection**:
   - Use DFS with state tracking to detect cycles
   - Track visitation state: unvisited, visiting, visited
   - When encountering a visiting node, we found a cycle

2. **Path Analysis**:
   - For each starting node, follow the path until termination
   - Count unique nodes visited
   - Handle both cycle and non-cycle paths

3. **Memoization**:
   - Cache results for already processed nodes
   - Avoid recomputing for nodes in cycles
   - Use dynamic programming for efficiency

4. **State Management**:
   - Use array to track visitation state
   - Use array to store computed results
   - Handle recursive path following

## Solution Code

```go
func countVisitedNodes(edges [][]int) []int {
    n := len(edges)
    if n == 0 {
        return []int{}
    }
    
    // Build adjacency list
    graph := make([]int, n)
    for _, edge := range edges {
        u, v := edge[0], edge[1]
        graph[u] = v
    }
    
    // States: 0 = unvisited, 1 = visiting, 2 = visited
    state := make([]int, n)
    result := make([]int, n)
    
    for i := 0; i < n; i++ {
        if state[i] == 0 {
            dfs(i, graph, state, result)
        }
    }
    
    return result
}

func dfs(node int, graph []int, state []int, result []int) int {
    if state[node] == 2 {
        // Already computed
        return result[node]
    }
    
    if state[node] == 1 {
        // Found a cycle - all nodes in cycle are fully visited
        cycleNodes := []int{}
        current := node
        
        for state[current] == 1 {
            cycleNodes = append(cycleNodes, current)
            state[current] = 2
            current = graph[current]
        }
        
        // All nodes in the cycle visit all nodes in the cycle
        cycleSize := len(cycleNodes)
        for _, cycleNode := range cycleNodes {
            result[cycleNode] = cycleSize
        }
        
        return cycleSize
    }
    
    // Mark as visiting
    state[node] = 1
    
    if graph[node] == -1 {
        // No outgoing edge
        state[node] = 2
        result[node] = 1
        return 1
    }
    
    // Recurse
    nextResult := dfs(graph[node], graph, state, result)
    
    // Mark as visited and store result
    state[node] = 2
    result[node] = nextResult + 1
    
    return result[node]
}
```

## Complexity Analysis

- **Time**: O(N) where N is the number of nodes
  - Each node is visited at most once
  - All edges are processed exactly once
- **Space**: O(N) for the state array and result array

## Link

[LeetCode 2876 Count Visited Nodes in a Directed Graph](https://leetcode.com/problems/count-visited-nodes-in-a-directed-graph/)