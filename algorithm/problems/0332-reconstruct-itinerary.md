# 0332 Reconstruct Itinerary

## Problem Description

You are given a list of airline tickets where `tickets[i] = [from, to]` represents a flight from `from` to `to`.

All tickets must be used exactly once, and the itinerary must start from `"JFK"` and end at `"JFK"`.

Return the itinerary with the smallest lexical order when read from left to right.

### Example 1:
```
Input: tickets = [["MUC","LHR"],["JFK","MUC"],["SFO","SJC"],["LHR","JFK"]]
Output: ["JFK","MUC","LHR","SFO","SJC"]
```

### Example 2:
```
Input: tickets = [["JFK","KUL"],["NRT","JFK"],["KUL","IST"]]
Output: ["JFK","NRT","IST","KUL"]
```

## Approach

This problem can be solved using Hierholzer's algorithm for finding Eulerian paths:

1. **Graph Construction**: Build an adjacency list from the tickets.

2. **Eulerian Path Detection**: Check if the graph has an Eulerian path:
   - All nodes with non-zero degree must have even degree (except possibly start/end nodes)
   - The graph must be connected

3. **Hierholzer's Algorithm**:
   - Use DFS to find the Eulerian path
   - Add nodes to the path as they are visited
   - Reverse the path at the end to get the correct order

## Solution Code

```go
func findItinerary(tickets [][]string) []string {
    // Build graph
    graph := make(map[string][]string)
    inDegree := make(map[string]int)
    outDegree := make(map[string]int)
    
    for _, ticket := range tickets {
        from, to := ticket[0], ticket[1]
        graph[from] = append(graph[from], to)
        inDegree[from]++
        outDegree[from]++
    }
    
    // Check if Eulerian path exists
    start := "JFK"
    end := "JFK"
    
    // Find nodes with odd degree
    oddDegreeNodes := make(map[string]bool)
    for node := range graph {
        if (len(graph[node])+len(outDegree[node]))%2 != 0 {
            oddDegreeNodes[node] = true
        }
    }
    
    // Count nodes with odd degree
    oddCount := 0
    for _, isOdd := range oddDegreeNodes {
        if isOdd {
            oddCount++
        }
    }
    
    // Check conditions for Eulerian path
    if oddCount > 2 || (oddCount == 2 && (start != end || oddDegreeNodes[start] || oddDegreeNodes[end])) {
        return []string{}
    }
    
    // Hierholzer's algorithm
    path := []string{}
    var dfs func(node string)
    
    dfs = func(node string) {
        path = append(path, node)
        
        for len(graph[node]) > 0 {
            next := graph[node][len(graph[node])-1]
            graph[node] = graph[node][:len(graph[node])-1]
            dfs(next)
        }
    }
    
    dfs(start)
    
    // Reverse the path
    for i, j := 0, len(path)-1; i < j; i, j = j-1, i++ {
        path[i], path[j] = path[j], path[i]
    }
    
    return path
}
```

## Complexity Analysis

- **Time**: O(V + E) where V is the number of airports and E is the number of tickets
  - Building graph: O(E)
  - DFS traversal: O(V + E)
- **Space**: O(V + E) for the graph and recursion stack

## Link

[LeetCode 0332 Reconstruct Itinerary](https://leetcode.com/problems/reconstruct-itinerary/)