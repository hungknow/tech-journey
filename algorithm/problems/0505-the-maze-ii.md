# 0505 The Maze II

## Problem Description

You are given a `m x n` maze represented by a 2D grid. The maze contains:
- `0` represents an open space
- `1` represents a wall

The ball starts at `start = [startRow, startCol]` and wants to reach `destination = [destRow, destCol]`.

The ball can roll in four directions (up, down, left, right) until it hits a wall. When it hits a wall, it can choose a new direction.

Return the minimum number of steps to reach the destination. If it's impossible, return -1.

### Example 1:
```
Input: maze = [[0,0,1,0,0],[0,0,0,0,0],[0,0,0,1,0],[1,1,0,1,1],[0,0,0,0,0]], start = [0,4], destination = [4,4]
Output: 12
```

### Example 2:
```
Input: maze = [[0,0,1,0,0],[0,0,0,0,0],[0,0,0,1,0],[1,1,0,1,1],[0,0,0,0,0]], start = [0,4], destination = [3,2]
Output: -1
```

## Approach

This problem can be solved using BFS to find the shortest path:

1. **BFS with Distance Tracking**:
   - Start BFS from the start position
   - For each position, roll the ball in each direction until hitting a wall
   - Track the distance (number of steps) to reach each position

2. **Movement Simulation**:
   - For each direction, simulate rolling until hitting a wall or boundary
   - Count the number of steps taken during the roll
   - Track visited positions with their minimum distances

3. **Early Termination**: When we reach the destination, return the distance

## Solution Code

```go
func shortestDistance(maze [][]int, start []int, destination []int) int {
    if len(maze) == 0 || len(maze[0]) == 0 {
        return -1
    }
    
    m, n := len(maze), len(maze[0])
    
    // Directions: up, down, left, right
    dirs := [][2]int{{-1, 0}, {1, 0}, {0, -1}, {0, 1}}
    
    // Distance matrix
    dist := make([][]int, m)
    for i := 0; i < m; i++ {
        dist[i] = make([]int, n)
        for j := 0; j < n; j++ {
            dist[i][j] = math.MaxInt32
        }
    }
    
    // BFS setup
    queue := [][2]int{{start[0], start[1]}}
    dist[start[0]][start[1]] = 0
    
    for len(queue) > 0 {
        current := queue[0]
        queue = queue[1:]
        
        // Try all four directions
        for _, dir := range dirs {
            row, col := current[0], current[1]
            steps := 0
            
            // Roll the ball until hitting a wall
            for row+dir[0] >= 0 && row+dir[0] < m && col+dir[1] >= 0 && col+dir[1] < n && maze[row+dir[0]][col+dir[1]] == 0 {
                row += dir[0]
                col += dir[1]
                steps++
            }
            
            // If we found a shorter path to this position
            if dist[current[0]][current[1]] + steps < dist[row][col] {
                dist[row][col] = dist[current[0]][current[1]] + steps
                queue = append(queue, [2]int{row, col})
            }
        }
    }
    
    if dist[destination[0]][destination[1]] == math.MaxInt32 {
        return -1
    }
    
    return dist[destination[0]][destination[1]]
}
```

## Complexity Analysis

- **Time**: O(m * n * max(m, n)) where m and n are the dimensions of the maze
  - Each cell can be visited multiple times
  - For each cell, we might roll up to max(m, n) steps in each direction
- **Space**: O(m * n) for the distance matrix and queue

## Link

[LeetCode 0505 The Maze II](https://leetcode.com/problems/the-maze-ii/)