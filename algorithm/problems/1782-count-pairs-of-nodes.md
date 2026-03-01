# 1782 Count Pairs of Nodes

## Problem Description

You are given an undirected graph with `n` nodes labeled from `0` to `n-1`. The graph is represented by an `edges` array where `edges[i] = [ui, vi]` represents an edge between `ui` and `vi`.

Return the number of pairs of nodes that are directly connected by an edge.

### Example 1:
```
Input: n = 3, edges = [[0,1],[2,1]]
Output: 2
```

### Example 2:
```
Input: n = 1, edges = []
Output: 0
```

## Approach

This problem can be solved using simple counting:

1. **Edge Counting**:
   - Count the number of edges in the graph
   - Each edge represents one pair of connected nodes

2. **Validation**:
   - Ensure we don't count duplicate pairs
   - Use a set to track counted pairs

3. **Implementation**:
   - Iterate through all edges
   - Add each edge to a set
   - Return the size of the set

## Solution Code

```go
func countPairs(n int, edges [][]int) int {
    if n <= 1 {
        return 0
    }
    
    // Use a set to track unique pairs
    pairSet := make(map[[2]int]bool)
    
    for _, edge := range edges {
        u, v := edge[0], edge[1]
        // Ensure the pair is in valid range
        if u >= 0 && u < n && v >= 0 && v < n {
            // Add the pair in sorted order to avoid duplicates
            if u < v {
                pairSet[[2]int{u, v}] = true
            } else {
                pairSet[[2]int{v, u}] = true
            }
        }
    }
    
    return len(pairSet)
}
```

## Complexity Analysis

- **Time**: O(E) where E is the number of edges
  - We iterate through all edges once
  - Set operations are O(1) on average
- **Space**: O(E) for the pair set

## Link

[LeetCode 1782 Count Pairs of Nodes](https://leetcode.com/problems/count-pairs-of-nodes/)