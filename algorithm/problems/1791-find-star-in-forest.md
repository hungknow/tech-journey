# 1791 Find Star in Forest

## Problem Description

You are given a forest represented by an array `edges` where `edges[i] = [ui, vi]` represents a bidirectional edge between `ui` and `vi`.

A star is a node that is the center of one or more connected components.

Return the center of the star graph if it exists, otherwise return -1.

### Example 1:
```
Input: edges = [[1,2],[2,3],[4,6],[5,1]]
Output: 3
```

### Example 2:
```
Input: edges = [[1,2],[2,3],[3,4],[4,6],[5,1]]
Output: 1
```

## Approach

This problem can be solved using graph analysis:

1. **Graph Construction**:
   - Build adjacency list from edges
   - Track degrees of all nodes

2. **Star Identification**:
   - A star center is a node with maximum degree
   - If multiple nodes have the same maximum degree, return the smallest numbered one

3. **Degree Calculation**:
   - Count the degree of each node
   - Find the maximum degree
   - Identify all nodes with this maximum degree

4. **Result Selection**:
   - Among nodes with maximum degree, return the smallest numbered node
   - If no edges exist, return -1

## Solution Code

```go
func findCenter(edges [][]int) int {
    if len(edges) == 0 {
        return -1
    }
    
    // Find the maximum node number to determine array size
    maxNode := 0
    for _, edge := range edges {
        for _, node := range edge {
            if node > maxNode {
                maxNode = node
            }
        }
    }
    
    // Build degree count
    degrees := make([]int, maxNode+1)
    
    for _, edge := range edges {
        degrees[edge[0]]++
        degrees[edge[1]]++
    }
    
    // Find maximum degree
    maxDegree := 0
    for _, degree := range degrees {
        if degree > maxDegree {
            maxDegree = degree
        }
    }
    
    // Find all nodes with maximum degree
    candidates := []int{}
    for node, degree := range degrees {
        if degree == maxDegree {
            candidates = append(candidates, node)
        }
    }
    
    if len(candidates) == 0 {
        return -1
    }
    
    // Return the smallest numbered candidate
    minCandidate := candidates[0]
    for _, candidate := range candidates {
        if candidate < minCandidate {
            minCandidate = candidate
        }
    }
    
    return minCandidate
}
```

## Complexity Analysis

- **Time**: O(V + E) where V is the number of nodes and E is the number of edges
  - Finding max node: O(V)
  - Building degree count: O(E)
  - Finding candidates: O(V)
- **Space**: O(V) for the degree array

## Link

[LeetCode 1791 Find Star in Forest](https://leetcode.com/problems/find-star-in-forest/)