# 1786 Number of Restricted Paths From First to Last

## Problem Description

You are given `n` cities and `edges` where `edges[i] = [ui, vi, weighti]` represents a bidirectional weighted edge between city `ui` and `vi` with weight `weighti`.

A path from city `0` to city `n-1` is restricted if the sum of edge weights is greater than `maxDistance`.

Return the number of restricted paths from city `0` to city `n-1`. If no path exists, return 0.

### Example 1:
```
Input: n = 5, maxDistance = 3, edges = [[0,1,2],[1,2,3],[2,3,1],[4,3,1]]
Output: 3
```

### Example 2:
```
Input: n = 5, maxDistance = 3, edges = [[0,1,2],[1,2,3],[2,3,1],[4,3,1]]
Output: 0
```

## Approach

This problem can be solved using BFS with pruning:

1. **Graph Construction**:
   - Build adjacency list from edges
   - Track edge weights

2. **BFS with Pruning**:
   - Use BFS from city 0 to city n-1
   - Track cumulative distance
   - Prune paths when distance exceeds maxDistance

3. **Path Counting**:
   - Count all paths that reach the destination within the distance limit
   - Use memoization to avoid redundant calculations

## Solution Code

```go
func restrictedPaths(n int, edges [][]int, maxDistance int) int {
    if n == 0 {
        return 0
    }
    
    // Build adjacency list
    graph := make([][][2]int, n)
    for _, edge := range edges {
        u, v, w := edge[0], edge[1], edge[2]
        graph[u] = append(graph[u], [2]int{v, w})
        graph[v] = append(graph[v], [2]int{u, w})
    }
    
    // BFS with memoization
    memo := make(map[[2]int]int)
    
    var dfs func(city int, currentDistance int) int
    dfs = func(city int, currentDistance int) int {
        if city == n-1 {
            return 1
        }
        
        if currentDistance > maxDistance {
            return 0
        }
        
        if memo[[2]int{city, currentDistance}] > 0 {
            return memo[[2]int{city, currentDistance}]
        }
        
        count := 0
        for _, neighbor := range graph[city] {
            nextDistance := currentDistance + neighbor[1]
            count += dfs(neighbor, nextDistance)
        }
        
        memo[[2]int{city, currentDistance}] = count
        return count
    }
    
    return dfs(0, 0)
}
```

## Complexity Analysis

- **Time**: O(V + E) where V is the number of cities (n) and E is the number of edges
  - BFS explores each edge once
  - With memoization, each state is computed once
- **Space**: O(V * D) where D is the maxDistance
  - Memoization table stores results for all (city, distance) combinations

## Link

[LeetCode 1786 Number of Restricted Paths From First to Last](https://leetcode.com/problems/number-of-restricted-paths-from-first-to-last/)