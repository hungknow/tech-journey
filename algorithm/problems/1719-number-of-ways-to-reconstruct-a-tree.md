# 1719 Number Of Ways To Reconstruct A Tree

## Problem Description

You are given `n` nodes labeled from `0` to `n-1` and a list of `edges` where `edges[i] = [ui, vi]` represents an undirected edge between `ui` and `vi`.

Return the number of different ways to reconstruct a tree with `n` nodes.

### Example 1:
```
Input: n = 3, edges = [[0,1],[0,2],[1,2]]
Output: 1
```

### Example 2:
```
Input: n = 4, edges = [[0,1],[0,2],[2,3]]
Output: 16
```

## Approach

This problem can be solved using combinatorics:

1. **Tree Properties**:
   - A tree with n nodes has exactly n-1 edges
   - The number of labeled trees is n^(n-2) (Cayley's formula)

2. **Edge Counting**:
   - If we have exactly n-1 edges, the answer is n^(n-2)
   - If we have fewer edges, it's impossible to form a tree

3. **Implementation**:
   - Check if we have the right number of edges
   - Use modular arithmetic for large numbers

## Solution Code

```go
func checkWays(n int, edges [][]int) int {
    if n == 0 {
        return 1
    }
    
    // A tree with n nodes must have exactly n-1 edges
    if len(edges) != n-1 {
        return 0
    }
    
    // Number of labeled trees is n^(n-2)
    // Use modular arithmetic to handle large numbers
    MOD := 1000000007
    result := 1
    
    for i := 0; i < n-2; i++ {
        result = (result * n) % MOD
    }
    
    return result
}
```

## Complexity Analysis

- **Time**: O(1) where n is the number of nodes
  - We only need to check the number of edges
  - Power calculation: O(n)
- **Space**: O(1) for constant space

## Link

[LeetCode 1719 Number Of Ways To Reconstruct A Tree](https://leetcode.com/problems/number-of-ways-to-reconstruct-a-tree/)