# 2097 Valid Arrangement of Pairs

## Problem Description

You are given an integer `n` and a 2D array `pairs` where `pairs[i] = [starti, endi]` represents a pair of numbers from `starti` to `endi`.

Arrange all pairs in a valid order such that for every pair `pairs[i]`, the `starti` appears before `endi` in the arrangement.

If there are multiple valid arrangements, return any of them.

### Example 1:
```
Input: n = 4, pairs = [[5,12],[9,10],[6,8]]
Output: [[1,2],[3,4],[5,12],[9,10],[6,8]]
```

### Example 2:
```
Input: n = 2, pairs = [[1,2]]
Output: [[1,2]]
```

## Approach

This problem can be solved using graph theory and Hierholzer's algorithm:

1. **Graph Construction**: Build a directed graph from the pairs.

2. **Eulerian Path Detection**: Check if the graph has an Eulerian path:
   - All nodes must have even degree (except possibly start/end nodes)
   - The graph must be connected

3. **Hierholzer's Algorithm**:
   - Use DFS to find the Eulerian path
   - Add nodes to the path as they are visited
   - Reverse the path at the end to get the correct order

## Solution Code

```go
func validArrangement(n int, pairs [][]int) [][]int {
    // Build graph
    graph := make(map[int][]int)
    inDegree := make([]int, n+1)
    outDegree := make([]int, n+1)
    
    for _, pair := range pairs {
        start, end := pair[0], pair[1]
        graph[start] = append(graph[start], end)
        inDegree[start]++
        outDegree[start]++
    }
    
    // Check if Eulerian path exists
    start := pairs[0][0]
    end := pairs[0][1]
    
    // Find nodes with odd degree
    oddDegreeNodes := make([]bool, n+1)
    for i := 1; i <= n; i++ {
        if (len(graph[i])+len(outDegree[i]))%2 != 0 {
            oddDegreeNodes[i] = true
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
        return [][]int{}
    }
    
    // Hierholzer's algorithm
    path := []int{}
    var dfs func(node int)
    
    dfs = func(node int) {
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
    
    // Convert path to pairs format
    result := make([][]int, len(path))
    for i := 0; i < len(path)-1; i++ {
        result[i] = []int{path[i], path[i+1]}
    }
    
    return result
}
```

## Complexity Analysis

- **Time**: O(V + E) where V is the number of nodes and E is the number of pairs
  - Building graph: O(E)
  - DFS traversal: O(V + E)
- **Space**: O(V + E) for the graph and recursion stack

## Link

[LeetCode 2097 Valid Arrangement of Pairs](https://leetcode.com/problems/valid-arrangement-of-pairs/)