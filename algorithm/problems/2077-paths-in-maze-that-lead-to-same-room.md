# 2077 Paths in Maze That Lead to Same Room

## Problem Description

You are given a maze represented as a 2D grid where each cell contains a room number.

A path is valid if:
- It starts and ends in the same room
- It visits at least one other room
- It doesn't visit any room more than once

Return the number of valid paths in the maze.

### Example 1:
```
Input: maze = [[1,1,2],[3,2,2],[1,3,2]]
Output: 5
```

### Example 2:
```
Input: maze = [[1,1,1],[1,2,2],[1,3,3]]
Output: 3
```

## Approach

This problem can be solved using graph traversal and cycle detection:

1. **Graph Construction**:
   - Build adjacency list based on room connections
   - Track room positions and connections

2. **Cycle Detection**:
   - Use DFS to find cycles in the graph
   - Count cycles of length >= 2

3. **Path Counting**:
   - For each room, explore all possible paths
   - Count paths that return to the starting room

4. **Visited Tracking**:
   - Use visited array to avoid revisiting rooms
   - Ensure paths are simple (no repeated rooms)

## Solution Code

```go
func numberOfPaths(maze [][]int) int {
    m, n := len(maze), len(maze[0])
    if m == 0 || n == 0 {
        return 0
    }
    
    // Build adjacency list for each room number
    roomPositions := make(map[int][][2]int)
    for i := 0; i < m; i++ {
        for j := 0; j < n; j++ {
            room := maze[i][j]
            roomPositions[room] = append(roomPositions[room], [2]int{i, j})
        }
    }
    
    // Build graph based on adjacent cells with different room numbers
    graph := make(map[int][]int)
    directions := [][2]int{{-1, 0}, {1, 0}, {0, -1}, {0, 1}}
    
    for i := 0; i < m; i++ {
        for j := 0; j < n; j++ {
            currentRoom := maze[i][j]
            
            for _, dir := range directions {
                ni, nj := i+dir[0], j+dir[1]
                
                if ni >= 0 && ni < m && nj >= 0 && nj < n {
                    neighborRoom := maze[ni][nj]
                    if neighborRoom != currentRoom {
                        graph[currentRoom] = append(graph[currentRoom], neighborRoom)
                    }
                }
            }
        }
    }
    
    // Count cycles using DFS
    visited := make(map[int]bool)
    pathCount := 0
    
    var dfs func(room int, start int, pathLength int)
    dfs = func(room int, start int, pathLength int) {
        if room == start && pathLength > 0 {
            pathCount++
            return
        }
        
        if visited[room] {
            return
        }
        
        visited[room] = true
        
        for _, neighbor := range graph[room] {
            if neighbor == start && pathLength == 0 {
                continue // Skip immediate return
            }
            dfs(neighbor, start, pathLength+1)
        }
        
        visited[room] = false
    }
    
    // Start DFS from each room
    for room := range graph {
        dfs(room, room, 0)
    }
    
    return pathCount
}
```

## Complexity Analysis

- **Time**: O(V * E) where V is the number of rooms and E is the number of connections
  - Building graph: O(m * n)
  - DFS traversal: O(V * E) in worst case
- **Space**: O(V + E) for the graph and visited tracking

## Link

[LeetCode 2077 Paths in Maze That Lead to Same Room](https://leetcode.com/problems/paths-in-maze-that-lead-to-same-room/)