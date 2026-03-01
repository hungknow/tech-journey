# 2360 Longest Cycle in a Graph

## Problem Description

You are given a directed graph with `n` nodes labeled from 0 to n-1 and `edges` where `edges[i]` represents a directed edge from node `i` to `edges[i]`.

A cycle is a path that starts and ends at the same node with at least one edge.

Return the length of the longest cycle in the graph. If there is no cycle, return -1.

### Example 1:
```
Input: edges = [3,3,4,2,3]
Output: 3
```

### Example 2:
```
Input: edges = [2,-1,3,1]
Output: -1
```

## Approach

This problem can be solved by detecting cycles and calculating their lengths:

1. **Cycle Detection**:
   - Use DFS with state tracking to detect cycles
   - Track visitation state: unvisited, visiting, visited
   - When encountering a visiting node, we found a cycle

2. **Cycle Length Calculation**:
   - When a cycle is detected, calculate its length
   - Use timestamps to determine cycle length
   - Keep track of maximum cycle length found

3. **DFS Traversal**:
   - Visit each node exactly once
   - Track entry time for each node
   - Handle both cycle and non-cycle paths

4. **State Management**:
   - Use array to track visitation state
   - Use array to track entry times
   - Update maximum cycle length during traversal

## Solution Code

```go
func longestCycle(edges []int) int {
    n := len(edges)
    if n == 0 {
        return -1
    }
    
    // States: 0 = unvisited, 1 = visiting, 2 = visited
    state := make([]int, n)
    entryTime := make([]int, n)
    maxCycle := -1
    timestamp := 0
    
    for i := 0; i < n; i++ {
        if state[i] == 0 {
            current := i
            path := []int{}
            
            // Traverse until we hit a visited node or cycle
            for current != -1 && state[current] == 0 {
                state[current] = 1
                entryTime[current] = timestamp
                path = append(path, current)
                timestamp++
                current = edges[current]
            }
            
            // If we found a cycle
            if current != -1 && state[current] == 1 {
                cycleLength := timestamp - entryTime[current]
                maxCycle = max(maxCycle, cycleLength)
            }
            
            // Mark all nodes in path as visited
            for _, node := range path {
                state[node] = 2
            }
        }
    }
    
    return maxCycle
}

func max(a, b int) int {
    if a > b {
        return a
    }
    return b
}
```

## Complexity Analysis

- **Time**: O(N) where N is the number of nodes
  - Each node is visited at most once
  - All edges are processed exactly once
- **Space**: O(N) for the state array, entry time array, and path tracking

## Link

[LeetCode 2360 Longest Cycle in a Graph](https://leetcode.com/problems/longest-cycle-in-a-graph/)