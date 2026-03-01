# 2662 Minimum Cost of a Path With Special Roads

## Problem Description

You are given a 2D integer array `specialRoads` where `specialRoads[i] = [x1i, y1i, x2i, y2i, costi]` represents a special bidirectional road that connects point `(x1i, y1i)` to `(x2i, y2i)` with cost `costi`.

You can travel between any two points with cost equal to the Manhattan distance between them.

You start at point `(0, 0)` and want to reach point `(targetX, targetY)`.

Return the minimum cost to travel from start to target.

### Example 1:
```
Input: specialRoads = [[1,1,3,3,2]], targetX = 3, targetY = 3
Output: 4
```

### Example 2:
```
Input: specialRoads = [[1,1,3,3,2]], targetX = 5, targetY = 5
Output: 10
```

## Approach

This problem can be solved using Dijkstra's algorithm with state optimization:

1. **Graph Construction**:
   - Treat each point (including special road endpoints and start/target) as a node
   - Connect all points with Manhattan distance edges
   - Add special road edges with their given costs

2. **Dijkstra's Algorithm**:
   - Use priority queue to find minimum cost path
   - Track minimum cost to reach each point
   - Consider both regular and special roads

3. **State Optimization**:
   - Only consider relevant points (special road endpoints + start + target)
   - This reduces the search space significantly
   - Calculate Manhattan distances on the fly

4. **Path Evaluation**:
   - For each point, try all possible next points
   - Use both Manhattan distance and special road costs
   - Early termination when reaching target

## Solution Code

```go
func minimumCost(targetX int, targetY int, specialRoads [][]int) int {
    // Collect all relevant points
    points := map[[2]int]bool{}
    points[[2]int{0, 0}] = true
    points[[2]int{targetX, targetY}] = true
    
    for _, road := range specialRoads {
        x1, y1, x2, y2 := road[0], road[1], road[2], road[3]
        points[[2]int{x1, y1}] = true
        points[[2]int{x2, y2}] = true
    }
    
    // Convert points to slice
    pointList := make([][2]int, 0, len(points))
    for point := range points {
        pointList = append(pointList, point)
    }
    
    // Build adjacency list
    n := len(pointList)
    graph := make([][][2]int, n)
    
    for i := 0; i < n; i++ {
        for j := 0; j < n; j++ {
            if i != j {
                x1, y1 := pointList[i][0], pointList[i][1]
                x2, y2 := pointList[j][0], pointList[j][1]
                cost := abs(x1-x2) + abs(y1-y2) // Manhattan distance
                graph[i] = append(graph[i], [2]int{j, cost})
            }
        }
    }
    
    // Add special roads
    pointIndex := make(map[[2]int]int)
    for i, point := range pointList {
        pointIndex[point] = i
    }
    
    for _, road := range specialRoads {
        x1, y1, x2, y2, cost := road[0], road[1], road[2], road[3], road[4]
        
        if idx1, exists1 := pointIndex[[2]int{x1, y1}]; exists1 {
            if idx2, exists2 := pointIndex[[2]int{x2, y2}]; exists2 {
                graph[idx1] = append(graph[idx1], [2]int{idx2, cost})
                graph[idx2] = append(graph[idx2], [2]int{idx1, cost})
            }
        }
    }
    
    // Dijkstra's algorithm
    start := pointIndex[[2]int{0, 0}]
    target := pointIndex[[2]int{targetX, targetY}]
    
    dist := make([]int, n)
    for i := 0; i < n; i++ {
        dist[i] = 1<<31 - 1
    }
    dist[start] = 0
    
    pq := [][2]int{{0, start}}
    
    for len(pq) > 0 {
        current := pq[0]
        pq = pq[1:]
        
        cost, idx := current[0], current[1]
        
        if idx == target {
            return cost
        }
        
        if cost > dist[idx] {
            continue
        }
        
        for _, neighbor := range graph[idx] {
            nextIdx, nextCost := neighbor[0], neighbor[1]
            newCost := cost + nextCost
            
            if newCost < dist[nextIdx] {
                dist[nextIdx] = newCost
                pq = append(pq, [2]int{newCost, nextIdx})
            }
        }
    }
    
    return dist[target]
}

func abs(x int) int {
    if x < 0 {
        return -x
    }
    return x
}
```

## Complexity Analysis

- **Time**: O(P^2 + S) where P is the number of relevant points and S is the number of special roads
  - Building graph: O(P^2)
  - Dijkstra's algorithm: O(P^2 log P)
- **Space**: O(P^2) for the adjacency list and distance array

## Link

[LeetCode 2662 Minimum Cost of a Path With Special Roads](https://leetcode.com/problems/minimum-cost-of-a-path-with-special-roads/)