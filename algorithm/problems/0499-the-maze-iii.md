# 0499 The Maze III

## Problem Description

You are given a `m x n` maze represented by a 2D grid. The maze contains:
- `0` represents an open space
- `1` represents a wall

The ball starts at `start = [startRow, startCol]` and wants to reach `destination = [destRow, destCol]`.

The ball can roll in four directions (up, down, left, right) until it hits a wall. When it hits a wall, it can choose a new direction.

Return the lexicographically smallest string of directions that leads the ball to the destination. If it's impossible to reach the destination, return "impossible".

The directions are represented as:
- 'u' for up
- 'd' for down
- 'l' for left
- 'r' for right

### Example 1:
```
Input: maze = [[0,0,0,0,0],[1,1,0,0,1],[0,0,0,0,0],[0,1,0,0,1],[0,1,0,0,0]], start = [4,3], destination = [0,1]
Output: "lul"
```

### Example 2:
```
Input: maze = [[0,0,0,0,0],[1,1,0,0,1],[0,0,0,0,0],[0,1,0,0,1],[0,1,0,0,0]], start = [4,3], destination = [3,2]
Output: "impossible"
```

## Approach

This problem can be solved using BFS with path tracking:

1. **BFS with Path Tracking**:
   - Start BFS from the start position
   - For each position, roll the ball in each direction until hitting a wall
   - Track the path taken to reach each position

2. **Lexicographical Order**:
   - Process directions in lexicographical order: 'd', 'l', 'r', 'u'
   - This ensures the first found path is lexicographically smallest

3. **Early Termination**: When we reach the destination, return the path

## Solution Code

```go
func findShortestWay(maze [][]int, ball []int, hole []int) string {
    if len(maze) == 0 || len(maze[0]) == 0 {
        return "impossible"
    }
    
    m, n := len(maze), len(maze[0])
    
    // Directions in lexicographical order: d, l, r, u
    dirs := [][3]int{
        {1, 0, 'd'}, // down
        {0, -1, 'l'}, // left
        {0, 1, 'r'},  // right
        {-1, 0, 'u'},  // up
    }
    
    // Distance and path tracking
    dist := make([][]int, m)
    path := make([][]string, m)
    for i := 0; i < m; i++ {
        dist[i] = make([]int, n)
        path[i] = make([]string, n)
        for j := 0; j < n; j++ {
            dist[i][j] = math.MaxInt32
            path[i][j] = ""
        }
    }
    
    dist[ball[0]][ball[1]] = 0
    path[ball[0]][ball[1]] = ""
    
    // Priority queue for Dijkstra's algorithm
    pq := &MinHeap{}
    heap.Push(&Item{row: ball[0], col: ball[1], distance: 0, path: ""})
    
    for pq.Len() > 0 {
        item := heap.Pop()
        row, col, distance, currentPath := item.row, item.col, item.distance, item.path
        
        // Check if we reached the hole
        if row == hole[0] && col == hole[1] {
            return currentPath
        }
        
        // Skip if we already found a better path
        if distance > dist[row][col] || (distance == dist[row][col] && currentPath > path[row][col]) {
            continue
        }
        
        // Try all four directions
        for _, dir := range dirs {
            newRow, newCol := row, col
            steps := 0
            newPath := currentPath + string(dir[2])
            
            // Roll the ball until hitting a wall or the hole
            for newRow+dir[0] >= 0 && newRow+dir[0] < m && 
               newCol+dir[1] >= 0 && newCol+dir[1] < n && 
               maze[newRow+dir[0]][newCol+dir[1]] == 0 &&
               !(newRow == hole[0] && newCol == hole[1]) {
                newRow += dir[0]
                newCol += dir[1]
                steps++
            }
            
            newDistance := distance + steps
            
            // Update if better path found
            if newDistance < dist[newRow][newCol] || 
               (newDistance == dist[newRow][newCol] && newPath < path[newRow][newCol]) {
                dist[newRow][newCol] = newDistance
                path[newRow][newCol] = newPath
                heap.Push(&Item{row: newRow, col: newCol, distance: newDistance, path: newPath})
            }
        }
    }
    
    if dist[hole[0]][hole[1]] == math.MaxInt32 {
        return "impossible"
    }
    
    return path[hole[0]][hole[1]]
}

type Item struct {
    row, col int
    distance int
    path     string
}

type MinHeap []Item

func (h MinHeap) Len() int           { return len(*h) }
func (h MinHeap) Less(i, j int) bool { 
    if (*h)[i].distance != (*h)[j].distance {
        return (*h)[i].distance < (*h)[j].distance
    }
    return (*h)[i].path < (*h)[j].path
}
func (h MinHeap) Push(x interface{})       { heap.Push(x) }
func (h MinHeap) Pop() interface{}       { return heap.Remove(0) }
```

## Complexity Analysis

- **Time**: O(m * n * max(m, n) * log(m * n)) where m and n are the dimensions of the maze
  - Each cell can be processed multiple times
  - Each operation on the priority queue takes O(log(m * n))
- **Space**: O(m * n) for the distance matrix, path matrix, and priority queue

## Link

[LeetCode 0499 The Maze III](https://leetcode.com/problems/the-maze-iii/)