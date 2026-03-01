# 2123 Minimum Operations to Remove Adjacent Ones in Matrix

## Problem Description

You are given a binary matrix `grid` where `grid[i][j]` is either 0 or 1.

In one operation, you can remove a 1 from the matrix if it has no adjacent 1s (horizontally or vertically).

Return the minimum number of operations needed to remove all 1s from the matrix.

### Example 1:
```
Input: grid = [[1,1,0],[0,1,1],[0,0,0]]
Output: 3
```

### Example 2:
```
Input: grid = [[0,0,0],[0,0,0],[0,0,0]]
Output: 0
```

## Approach

This problem can be solved using maximum bipartite matching:

1. **Graph Construction**:
   - Treat the matrix as a bipartite graph
   - Color cells in chessboard pattern (black and white)
   - Create edges between adjacent 1s

2. **Maximum Independent Set**:
   - The problem reduces to finding maximum independent set
   - This equals total 1s minus maximum matching

3. **Bipartite Matching**:
   - Use Hopcroft-Karp algorithm for maximum matching
   - Find maximum number of adjacent pairs

4. **Operations Calculation**:
   - Minimum operations = total 1s - maximum matching
   - Each matched pair can be removed in one operation

## Solution Code

```go
func minimumOperations(grid [][]int) int {
    m, n := len(grid), len(grid[0])
    if m == 0 || n == 0 {
        return 0
    }
    
    // Count total number of 1s
    totalOnes := 0
    for i := 0; i < m; i++ {
        for j := 0; j < n; j++ {
            if grid[i][j] == 1 {
                totalOnes++
            }
        }
    }
    
    // Build bipartite graph
    // Color cells in chessboard pattern
    blackCells := make([][2]int, 0)
    cellToId := make(map[string]int)
    id := 0
    
    for i := 0; i < m; i++ {
        for j := 0; j < n; j++ {
            if grid[i][j] == 1 && (i+j)%2 == 0 {
                blackCells = append(blackCells, [2]int{i, j})
                cellToId[fmt.Sprintf("%d,%d", i, j)] = id
                id++
            }
        }
    }
    
    // Build adjacency list for black cells
    graph := make([][]int, len(blackCells))
    directions := [][2]int{{-1, 0}, {1, 0}, {0, -1}, {0, 1}}
    
    for idx, cell := range blackCells {
        i, j := cell[0], cell[1]
        
        for _, dir := range directions {
            ni, nj := i+dir[0], j+dir[1]
            
            if ni >= 0 && ni < m && nj >= 0 && nj < n && grid[ni][nj] == 1 {
                graph[idx] = append(graph[idx], ni*n+nj)
            }
        }
    }
    
    // Hopcroft-Karp algorithm for maximum matching
    n1, n2 := len(blackCells), m*n
    pairU := make([]int, n1)
    pairV := make([]int, n2)
    dist := make([]int, n1)
    
    for i := 0; i < n1; i++ {
        pairU[i] = -1
    }
    for i := 0; i < n2; i++ {
        pairV[i] = -1
    }
    
    var bfs func() bool
    bfs = func() bool {
        queue := []int{}
        
        for u := 0; u < n1; u++ {
            if pairU[u] == -1 {
                dist[u] = 0
                queue = append(queue, u)
            } else {
                dist[u] = 1<<31 - 1
            }
        }
        
        found := false
        
        for len(queue) > 0 {
            u := queue[0]
            queue = queue[1:]
            
            for _, v := range graph[u] {
                if pairV[v] != -1 && dist[pairV[v]] == 1<<31-1 {
                    dist[pairV[v]] = dist[u] + 1
                    queue = append(queue, pairV[v])
                } else if pairV[v] == -1 {
                    found = true
                }
            }
        }
        
        return found
    }
    
    var dfs func(u int) bool
    dfs = func(u int) bool {
        for _, v := range graph[u] {
            if pairV[v] == -1 || (dist[pairV[v]] == dist[u]+1 && dfs(pairV[v])) {
                pairU[u] = v
                pairV[v] = u
                return true
            }
        }
        dist[u] = 1<<31 - 1
        return false
    }
    
    maxMatching := 0
    for bfs() {
        for u := 0; u < n1; u++ {
            if pairU[u] == -1 && dfs(u) {
                maxMatching++
            }
        }
    }
    
    return totalOnes - maxMatching
}
```

## Complexity Analysis

- **Time**: O(E * sqrt(V)) where V is number of vertices and E is number of edges
  - Hopcroft-Karp algorithm complexity
- **Space**: O(V + E) for the graph and matching arrays

## Link

[LeetCode 2123 Minimum Operations to Remove Adjacent Ones in Matrix](https://leetcode.com/problems/minimum-operations-to-remove-adjacent-ones-in-matrix/)