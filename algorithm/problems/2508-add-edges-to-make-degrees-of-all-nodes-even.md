# 2508 Add Edges to Make Degrees of All Nodes Even

## Problem Description

You are given an undirected graph with `n` nodes labeled from 0 to n-1 and `edges` where `edges[i] = [ui, vi]` represents an edge between `ui` and `vi`.

You can add edges between any pair of nodes. Each added edge increases the degree of both nodes by 1.

Return the minimum number of edges needed to add so that every node has an even degree. If it's impossible, return -1.

### Example 1:
```
Input: n = 3, edges = [[0,1],[1,2]]
Output: 1
```

### Example 2:
```
Input: n = 4, edges = [[0,1],[2,3]]
Output: 2
```

## Approach

This problem can be solved by analyzing node degrees:

1. **Degree Analysis**:
   - Calculate the degree of each node
   - Count nodes with odd degrees
   - Check if solution is possible

2. **Parity Check**:
   - If number of odd-degree nodes is odd, return -1
   - Otherwise, minimum edges needed is odd_count / 2

3. **Edge Addition Strategy**:
   - Pair up odd-degree nodes
   - Each edge connects two odd-degree nodes
   - This makes both degrees even

4. **Mathematical Proof**:
   - Sum of all degrees must be even (handshaking lemma)
   - Number of odd-degree nodes must be even
   - Each added edge fixes two odd degrees

## Solution Code

```go
func isPossible(n int, edges [][]int) int {
    // Calculate degrees
    degrees := make([]int, n)
    for _, edge := range edges {
        u, v := edge[0], edge[1]
        degrees[u]++
        degrees[v]++
    }
    
    // Count odd degree nodes
    oddCount := 0
    for i := 0; i < n; i++ {
        if degrees[i]%2 == 1 {
            oddCount++
        }
    }
    
    // Check if possible
    if oddCount%2 == 1 {
        return -1
    }
    
    // Minimum edges needed is oddCount / 2
    return oddCount / 2
}
```

## Complexity Analysis

- **Time**: O(V + E) where V is the number of nodes and E is the number of edges
  - Calculating degrees: O(E)
  - Counting odd degrees: O(V)
- **Space**: O(V) for the degrees array

## Link

[LeetCode 2508 Add Edges to Make Degrees of All Nodes Even](https://leetcode.com/problems/add-edges-to-make-degrees-of-all-nodes-even/)