# 2577 Minimum Time to Visit a Cell in a Grid

## Problem Description

You are given a `m x n` integer matrix `grid` where `grid[i][j]` represents the time to visit cell `(i, j)`.

You start at cell `(0, 0)` and want to reach cell `(m-1, n-1)`. You can move to adjacent cells (up, down, left, right).

Return the minimum time to reach the target cell. If it's impossible, return `-1`.

### Example 1:
```
Input: grid = [[0,1,3,2],[4,0,1,1],[1,1,1,0]]
Output: 4
```

### Example 2:
```
Input: grid = [[0,2,1,2],[1,0,2,1],[2,1,0,2]]
Output: -1
```

## Approach

This problem can be solved using Dijkstra's algorithm on a grid:

1. **Grid Traversal**: Treat each cell as a node in a graph with edges to adjacent cells.

2. **Dijkstra's Algorithm**:
   - Use a priority queue to always expand the cell with the smallest time
   - Track visited cells and their minimum times
   - Early terminate when reaching the target

3. **Early Termination**: If target is unreachable, return -1

## Solution Code

```go
func minimumTime(grid [][]int) int {
    m, n := len(grid), len(grid[0])
    
    // Check if start and end are accessible
    if grid[0][0] != 0 || grid[m-1][n-1] != 0 {
        return -1
    }
    
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
    dist[0][0] = 0
    
    // Priority queue
    pq := &MinHeap{}
    heap.Push(&Item{row: 0, col: 0, time: 0})
    
    for pq.Len() > 0 {
        item := heap.Pop()
        row, col, time := item.row, item.col, item.time
        
        // Early exit if we reached the target
        if row == m-1 && col == n-1 {
            return time
        }
        
        // Skip if we already found a better path
        if time > dist[row][col] {
            continue
        }
        
        // Explore neighbors
        for _, dir := range dirs {
            newRow, newCol := row+dir[0], col+dir[1]
            
            // Check bounds
            if newRow < 0 || newRow >= m || newCol < 0 || newCol >= n {
                continue
            }
            
            // Calculate new time
            newTime := time + grid[newRow][newCol]
            
            // Update if better path found
            if newTime < dist[newRow][newCol] {
                dist[newRow][newCol] = newTime
                heap.Push(&Item{row: newRow, col: newCol, time: newTime})
            }
        }
    }
    
    // If we couldn't reach the target
    if dist[m-1][n-1] == math.MaxInt32 {
        return -1
    }
    
    return dist[m-1][n-1]
}

type Item struct {
    row, col int
    time     int
}

type MinHeap []Item

func (h MinHeap) Len() int           { return len(*h) }
func (h MinHeap) Less(i, j int) bool { return (*h)[i].time < (*h)[j].time }
func (h MinHeap) Push(x interface{})       { heap.Push(x) }
func (h MinHeap) Pop() interface{}       { return heap.Remove(0) }
```

## Complexity Analysis

- **Time**: O(m * n * log(m * n)) where m and n are the dimensions of the grid
  - Each cell is processed once
  - Each operation on the priority queue takes O(log(m * n))
- **Space**: O(m * n) for the distance matrix and priority queue

## Link

[LeetCode 2577 Minimum Time to Visit a Cell in a Grid](https://leetcode.com/problems/minimum-time-to-visit-a-cell-in-a-grid/)