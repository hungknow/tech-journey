# 1129 Shortest Path with Alternating Colors

## Problem Description

You are given a directed graph with `n` nodes labeled from `0` to `n-1`. The graph is represented by `redEdges` and `blueEdges` where `redEdges[i] = [ui, vi]` represents a red edge from `ui` to `vi`, and similarly for blue edges.

Return an array `answer` where `answer[i]` is the length of the shortest path from node `0` to node `i` such that the edges along the path alternate between red and blue colors. If no such path exists, `answer[i] = -1`.

### Example 1:
```
Input: n = 3, redEdges = [[0,1],[1,2]], blueEdges = []
Output: [0,1,-1]
```

### Example 2:
```
Input: n = 3, redEdges = [[0,1]], blueEdges = [[2,1]]
Output: [0,1,-1]
```

## Approach

This problem can be solved using BFS with state tracking:

1. **State Representation**:
   - Each state is (node, last_edge_color)
   - last_edge_color: 0 = no color (start), 1 = red, 2 = blue

2. **BFS Traversal**:
   - Start BFS from node 0 with both possible starting colors
   - For each state, only traverse edges of the opposite color
   - Track visited states to avoid cycles

3. **Distance Calculation**:
   - Track the distance to reach each state
   - The answer for each node is the minimum distance across all states

## Solution Code

```go
func shortestAlternatingPaths(n int, redEdges [][]int, blueEdges [][]int) []int {
    // Build adjacency lists for red and blue edges
    redGraph := make([][]int, n)
    blueGraph := make([][]int, n)
    
    for _, edge := range redEdges {
        from, to := edge[0], edge[1]
        redGraph[from] = append(redGraph[from], to)
    }
    
    for _, edge := range blueEdges {
        from, to := edge[0], edge[1]
        blueGraph[from] = append(blueGraph[from], to)
    }
    
    // Answer array initialized to -1
    answer := make([]int, n)
    for i := 0; i < n; i++ {
        answer[i] = -1
    }
    answer[0] = 0
    
    // BFS setup: state is (node, last_edge_color)
    // last_edge_color: 0 = start, 1 = red, 2 = blue
    queue := [][2]int{{0, 0}}
    visited := make([][]bool, n)
    for i := 0; i < n; i++ {
        visited[i] = make([]bool, 3)
    }
    visited[0][0] = true
    
    distance := 0
    
    for len(queue) > 0 {
        levelSize := len(queue)
        
        for i := 0; i < levelSize; i++ {
            current := queue[0]
            queue = queue[1:]
            
            node, lastColor := current[0], current[1]
            
            // Update answer for this node
            if answer[node] == -1 || distance < answer[node] {
                answer[node] = distance
            }
            
            // If last edge was red or start, we can take blue edges
            if lastColor != 2 {
                for _, neighbor := range blueGraph[node] {
                    if !visited[neighbor][2] {
                        visited[neighbor][2] = true
                        queue = append(queue, [2]int{neighbor, 2})
                    }
                }
            }
            
            // If last edge was blue or start, we can take red edges
            if lastColor != 1 {
                for _, neighbor := range redGraph[node] {
                    if !visited[neighbor][1] {
                        visited[neighbor][1] = true
                        queue = append(queue, [2]int{neighbor, 1})
                    }
                }
            }
        }
        
        distance++
    }
    
    return answer
}
```

## Complexity Analysis

- **Time**: O(V + E) where V is the number of nodes (n) and E is the total number of edges
  - Each state (node, color) is processed at most once
  - There are O(V * 3) possible states
- **Space**: O(V * 3) for the visited array and queue

## Link

[LeetCode 1129 Shortest Path with Alternating Colors](https://leetcode.com/problems/shortest-path-with-alternating-colors/)