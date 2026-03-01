# 1761 Minimum Degree of a Connected Trio in a Graph

## Problem Description

You are given an undirected graph with `n` nodes labeled from `0` to `n-1`. The graph is represented by an array `edges` where `edges[i] = [ui, vi]` represents an edge between `ui` and `vi`.

A trio is a set of three nodes where each pair of nodes in the trio is directly connected by an edge.

The minimum degree of a connected trio is the minimum number of edges connected to any node in the trio.

Return the minimum degree among all connected trios. If the graph doesn't contain any trio, return -1.

### Example 1:
```
Input: n = 6, edges = [[0,1],[0,2],[1,2],[0,3],[1,3]]
Output: 3
```

### Example 2:
```
Input: n = 1, edges = []
Output: -1
```

## Approach

This problem can be solved using combinatorics:

1. **Trio Enumeration**:
   - Enumerate all possible combinations of 3 nodes
   - For each trio, check if all three edges exist
   - Track the minimum degree

2. **Degree Calculation**:
   - For each valid trio, calculate the degree of each node
   - The degree is the number of edges connected to the node
   - Track the minimum degree across all trios

3. **Efficient Implementation**:
   - Use combinations to generate trios
   - Use a set to quickly check edge existence
   - Early termination if no trios found

## Solution Code

```go
func minTrioDegree(n int, edges [][]int) int {
    if n < 3 {
        return -1
    }
    
    // Build adjacency set for quick lookup
    edgeSet := make(map[[2]int]bool)
    for _, edge := range edges {
        u, v := edge[0], edge[1]
        edgeSet[[2]int{u, v}] = true
        edgeSet[[2]int{v, u}] = true
    }
    
    minDegree := math.MaxInt32
    
    // Enumerate all possible trios
    for i := 0; i < n; i++ {
        for j := i + 1; j < n; j++ {
            for k := j + 1; k < n; k++ {
                // Check if all three edges exist
                if edgeSet[[2]int{i, j}] && edgeSet[[2]int{j, k}] && edgeSet[[2]int{i, k}] {
                    // Calculate degrees for this trio
                    degree := 0
                    degrees := []int{i, j, k}
                    
                    // Count edges connected to each node in the trio
                    for _, edge := range edges {
                        u, v := edge[0], edge[1]
                        if (u == i || u == j || u == k) && 
                           (v == i || v == j || v == k) {
                            degree++
                        }
                    }
                    
                    // Find minimum degree in this trio
                    trioMinDegree := degree
                    for _, d := range degrees {
                        if d < trioMinDegree {
                            trioMinDegree = d
                        }
                    }
                    
                    if trioMinDegree < minDegree {
                        minDegree = trioMinDegree
                    }
                }
            }
        }
    }
    
    if minDegree == math.MaxInt32 {
        return -1
    }
    
    return minDegree
}
```

## Complexity Analysis

- **Time**: O(n^3) where n is the number of nodes
  - Enumerating all trios: O(n^3)
  - For each trio, checking edges: O(E)
  - Total: O(n^3 * E)
- **Space**: O(n^2) for the edge set and temporary arrays

## Link

[LeetCode 1761 Minimum Degree of a Connected Trio in a Graph](https://leetcode.com/problems/minimum-degree-of-a-connected-trio-in-a-graph/)