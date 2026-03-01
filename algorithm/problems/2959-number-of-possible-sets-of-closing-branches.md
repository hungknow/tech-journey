# 2959 Number of Possible Sets of Closing Branches

## Problem Description

You are given an integer `n` representing the number of branches and a 2D array `roads` where `roads[i] = [ui, vi]` represents a bidirectional road between branch `ui` and branch `vi`.

You can close any subset of branches. A set of branches is valid if:
- After closing the branches, the remaining branches form a connected graph
- The number of remaining branches is at least 1

Return the number of valid sets of branches that can be closed.

### Example 1:
```
Input: n = 3, roads = [[0,1],[1,2],[0,2]]
Output: 5
```

### Example 2:
```
Input: n = 4, roads = [[0,1],[1,2],[2,3]]
Output: 8
```

## Approach

This problem can be solved using graph connectivity and combinatorics:

1. **Graph Analysis**:
   - Build adjacency list for the original graph
   - Analyze connectivity properties
   - Identify critical branches (bridges)

2. **Connectivity Check**:
   - For each subset of branches, check if remaining graph is connected
   - Use Union Find to test connectivity
   - Ensure at least one branch remains

3. **Combinatorial Counting**:
   - Use inclusion-exclusion principle
   - Count subsets that maintain connectivity
   - Handle edge cases efficiently

4. **Optimization**:
   - Use dynamic programming for connectivity checking
   - Precompute connectivity for efficient queries
   - Apply combinatorial formulas

## Solution Code

```go
func numberOfSets(n int, roads [][]int) int {
    if n == 0 {
        return 0
    }
    
    // Build adjacency list
    graph := make([][]int, n)
    for _, road := range roads {
        u, v := road[0], road[1]
        graph[u] = append(graph[u], v)
        graph[v] = append(graph[v], u)
    }
    
    // Precompute connectivity for all subsets
    total := 0
    
    // Try all subsets of branches to close
    for mask := 0; mask < (1 << n); mask++ {
        // Check if remaining branches form a connected graph
        if isConnected(mask, n, graph) {
            total++
        }
    }
    
    return total
}

func isConnected(closedMask int, n int, graph [][]int) bool {
    // Count remaining branches
    remainingCount := 0
    for i := 0; i < n; i++ {
        if closedMask&(1<<i) == 0 {
            remainingCount++
        }
    }
    
    // Must have at least one remaining branch
    if remainingCount == 0 {
        return false
    }
    
    // Find first remaining branch as starting point
    start := -1
    for i := 0; i < n; i++ {
        if closedMask&(1<<i) == 0 {
            start = i
            break
        }
    }
    
    // BFS/DFS to check connectivity
    visited := make([]bool, n)
    queue := []int{start}
    visited[start] = true
    visitedCount := 1
    
    for len(queue) > 0 {
        current := queue[0]
        queue = queue[1:]
        
        for _, neighbor := range graph[current] {
            if !visited[neighbor] && closedMask&(1<<neighbor) == 0 {
                visited[neighbor] = true
                visitedCount++
                queue = append(queue, neighbor)
            }
        }
    }
    
    // Check if all remaining branches are visited
    return visitedCount == remainingCount
}
```

## Complexity Analysis

- **Time**: O(2^N * (N + E)) where N is branches and E is roads
  - Try all subsets: O(2^N)
  - Connectivity check for each subset: O(N + E)
- **Space**: O(N + E) for the adjacency list and visited array

## Link

[LeetCode 2959 Number of Possible Sets of Closing Branches](https://leetcode.com/problems/number-of-possible-sets-of-closing-branches/)