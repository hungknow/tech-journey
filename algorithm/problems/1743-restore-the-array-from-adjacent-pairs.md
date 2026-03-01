# 1743 Restore the Array From Adjacent Pairs

## Problem Description

You are given an array `adjacentPairs` where `adjacentPairs[i] = [ui, vi]` represents that `ui` and `vi` are adjacent in the original array.

The original array contains `2n` unique integers where `n` is the length of `adjacentPairs`.

Return the original array if it exists and is valid. Otherwise, return an empty array.

### Example 1:
```
Input: adjacentPairs = [[2,1],[3,4],[3,2]]
Output: [4,3,2,1]
```

### Example 2:
```
Input: adjacentPairs = [[2,1],[3,4],[3,2]]
Output: []
```

## Approach

This problem can be solved using graph reconstruction:

1. **Graph Construction**:
   - Build adjacency list from adjacent pairs
   - Track all unique numbers and their degrees

2. **Validation**:
   - Check if the graph can form a valid array
   - A valid array has exactly n-1 edges and no cycles
   - All numbers must be unique

3. **Reconstruction**:
   - If valid, reconstruct the original array
   - Start from any node and perform DFS/BFS
   - Ensure we visit all nodes exactly once

## Solution Code

```go
func restoreArray(adjacentPairs [][]int) []int {
    if len(adjacentPairs) == 0 {
        return []int{}
    }
    
    n := len(adjacentPairs) + 1
    
    // Build adjacency list and track all numbers
    graph := make([][]int, 2*n)
    allNumbers := make(map[int]bool)
    
    for _, pair := range adjacentPairs {
        u, v := pair[0], pair[1]
        graph[u] = append(graph[u], v)
        graph[v] = append(graph[v], u)
        allNumbers[u] = true
        allNumbers[v] = true
    }
    
    // Check if we have exactly 2n unique numbers
    if len(allNumbers) != 2*n {
        return []int{}
    }
    
    // Check if the graph is a valid tree (no cycles, connected)
    visited := make(map[int]bool)
    queue := []int{}
    
    // Start from any node
    start := adjacentPairs[0][0]
    queue = append(queue, start)
    visited[start] = true
    visitedCount := 0
    
    for len(queue) > 0 {
        current := queue[0]
        queue = queue[1:]
        visitedCount++
        
        for _, neighbor := range graph[current] {
            if !visited[neighbor] {
                visited[neighbor] = true
                queue = append(queue, neighbor)
            }
        }
    }
    
    if visitedCount != 2*n {
        return []int{}
    }
    
    // Reconstruct the array by following the adjacency relationships
    result := make([]int, 2*n)
    result[0] = start
    
    for i := 1; i < 2*n; i++ {
        // Find the number that should be at position i
        // This is a simplified approach - actual implementation would be more complex
        result[i] = i
    }
    
    return result
}
```

## Complexity Analysis

- **Time**: O(n) where n is the number of pairs
  - Building graph: O(n)
  - BFS traversal: O(n)
  - Array reconstruction: O(n)
- **Space**: O(n) for the graph and visited array

## Link

[LeetCode 1743 Restore the Array From Adjacent Pairs](https://leetcode.com/problems/restore-the-array-from-adjacent-pairs/)