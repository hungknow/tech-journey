# 0490 The Maze

## Problem Description

You are given a `m x n` maze represented by a 2D grid. The maze contains:
- `0` represents an open space
- `1` represents a wall

The ball starts at `start = [startRow, startCol]` and wants to reach `destination = [destRow, destCol]`.

The ball can roll in four directions (up, down, left, right) until it hits a wall. When it hits a wall, it can choose a new direction.

Return `true` if the ball can stop at the destination, otherwise return `false`.

### Example 1:
```
Input: maze = [[0,0,1,0,0],[0,0,0,0,0],[0,0,0,1,0],[1,1,0,1,1],[0,0,0,0,0]], start = [0,4], destination = [4,4]
Output: true
```

### Example 2:
```
Input: maze = [[0,0,1,0,0],[0,0,0,0,0],[0,0,0,1,0],[1,1,0,1,1],[0,0,0,0,0]], start = [0,4], destination = [3,2]
Output: false
```

## Approach

This problem can be solved using BFS with special movement rules:

1. **BFS with Rolling Motion**:
   - Start BFS from the start position
   - For each position, roll the ball in each direction until hitting a wall
   - The ball stops at the position just before the wall

2. **Movement Simulation**:
   - For each direction, simulate rolling until hitting a wall or boundary
   - Track visited positions to avoid cycles

3. **Early Termination**: When we reach the destination, return true

## Solution Code

```go
func hasPath(maze [][]int, start []int, destination []int) bool {
    if len(maze) == 0 || len(maze[0]) == 0 {
        return false
    }
    
    m, n := len(maze), len(maze[0])
    
    // Directions: up, down, left, right
    dirs := [][2]int{{-1, 0}, {1, 0}, {0, -1}, {0, 1}}
    
    // BFS setup
    queue := [][2]int{{start[0], start[1]}}
    visited := make([][]bool, m)
    for i := 0; i < m; i++ {
        visited[i] = make([]bool, n)
    }
    visited[start[0]][start[1]] = true
    
    for len(queue) > 0 {
        current := queue[0]
        queue = queue[1:]
        
        // Check if we reached the destination
        if current[0] == destination[0] && current[1] == destination[1] {
            return true
        }
        
        // Try all four directions
        for _, dir := range dirs {
            row, col := current[0], current[1]
            
            // Roll the ball until hitting a wall
            for row+dir[0] >= 0 && row+dir[0] < m && col+dir[1] >= 0 && col+dir[1] < n && maze[row+dir[0]][col+dir[1]] == 0 {
                row += dir[0]
                col += dir[1]
            }
            
            // If this position hasn't been visited, add to queue
            if !visited[row][col] {
                visited[row][col] = true
                queue = append(queue, [2]int{row, col})
            }
        }
    }
    
    return false
}
```

## Complexity Analysis

- **Time**: O(m * n * max(m, n)) where m and n are the dimensions of the maze
  - Each cell can be visited at most once
  - For each cell, we might roll up to max(m, n) steps in each direction
- **Space**: O(m * n) for the visited array and queue

## Link

[LeetCode 0490 The Maze](https://leetcode.com/problems/the-maze/)