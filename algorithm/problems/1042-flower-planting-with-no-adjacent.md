# 1042 Flower Planting With No Adjacent

## Problem Description

You have `n` gardens and `n` flowers. The gardens are arranged in a row. Each garden can have one flower.

The flowers are numbered from 1 to n. Adjacent gardens cannot have the same type of flower.

Return the number of different ways to plant the flowers. Since the answer may be large, return it modulo 10^9 + 7.

### Example 1:
```
Input: n = 1, paths = []
Output: 4
```

### Example 2:
```
Input: n = 3, paths = [[1,2],[2,3],[3,1]]
Output: 12
```

## Approach

This problem can be solved using graph coloring:

1. **Graph Construction**:
   - Build adjacency list from paths
   - Each garden is a node, paths represent edges

2. **Graph Coloring**:
   - Use backtracking to color the graph
   - Try all possible colors for each garden
   - Ensure adjacent gardens have different colors

3. **Counting**:
   - Count all valid colorings
   - Use modulo arithmetic to handle large numbers

## Solution Code

```go
func gardenNoAdj(n int, paths [][]int) int {
    if n == 0 {
        return 0
    }
    
    // Build adjacency list
    graph := make([][]int, n+1)
    for _, path := range paths {
        u, v := path[0], path[1]
        graph[u] = append(graph[u], v)
        graph[v] = append(graph[v], u)
    }
    
    // Colors for each garden
    colors := make([]int, n+1)
    result := 0
    
    // Backtracking to count colorings
    var backtrack func(garden int)
    backtrack = func(garden int) {
        if garden > n {
            result++
            return
        }
        
        // Try all possible colors (1 to n)
        for color := 1; color <= n; color++ {
            valid := true
            
            // Check if color conflicts with adjacent gardens
            for _, neighbor := range graph[garden] {
                if colors[neighbor] == color {
                    valid = false
                    break
                }
            }
            
            if valid {
                colors[garden] = color
                backtrack(garden + 1)
                colors[garden] = 0 // Backtrack
            }
        }
    }
    
    backtrack(1)
    
    return result % (1000000007)
}
```

## Complexity Analysis

- **Time**: O(n^n) where n is the number of gardens
  - For each garden, we try n colors
  - In the worst case, this is exponential
- **Space**: O(n) for the colors array and recursion stack

## Link

[LeetCode 1042 Flower Planting With No Adjacent](https://leetcode.com/problems/flower-planting-with-no-adjacent/)