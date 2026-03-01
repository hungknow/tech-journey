# 2492 Minimum Score of a Path Between Two Cities

## Problem Description

You are given an integer `n` and a list of roads where `roads[i] = [ai, bi, distancei]` represents a road between cities `ai` and `bi` with distance `distancei`.

The score of a path between two cities is defined as the minimum distance among all roads in the path.

Return the minimum possible score of a path between city `1` and city `n`.

### Example 1:
```
Input: n = 4, roads = [[1,2,9],[2,3,6],[2,4,5],[1,4,7]]
Output: 5
```

### Example 2:
```
Input: n = 5, roads = [[1,2,3],[1,3,4],[2,3,2],[3,4,7],[3,5,8]]
Output: 2
```

## Approach

This problem can be solved using BFS to find the connected component:

1. **Key Insight**:
   - The minimum score path between city 1 and city n will be the minimum edge weight in their connected component
   - We need to find all cities reachable from city 1 and find the minimum edge weight among them

2. **BFS Traversal**:
   - Start BFS from city 1
   - Find all cities in the connected component
   - Track the minimum edge weight encountered

3. **Result**: The minimum edge weight in the connected component is the answer

## Solution Code

```go
func minScore(n int, roads [][]int) int {
    // Build adjacency list
    graph := make([][][2]int, n+1)
    for _, road := range roads {
        u, v, distance := road[0], road[1], road[2]
        graph[u] = append(graph[u], [2]int{v, distance})
        graph[v] = append(graph[v], [2]int{u, distance})
    }
    
    // BFS to find connected component of city 1
    queue := []int{1}
    visited := make([]bool, n+1)
    visited[1] = true
    minScore := math.MaxInt32
    
    for len(queue) > 0 {
        current := queue[0]
        queue = queue[1:]
        
        // Explore all neighbors
        for _, neighbor := range graph[current] {
            nextCity, distance := neighbor[0], neighbor[1]
            
            // Update minimum score
            if distance < minScore {
                minScore = distance
            }
            
            if !visited[nextCity] {
                visited[nextCity] = true
                queue = append(queue, nextCity)
            }
        }
    }
    
    return minScore
}
```

## Complexity Analysis

- **Time**: O(V + E) where V is the number of cities (n) and E is the number of roads
  - Building the graph: O(E)
  - BFS traversal: O(V + E)
- **Space**: O(V + E) for the graph and visited array

## Link

[LeetCode 2492 Minimum Score of a Path Between Two Cities](https://leetcode.com/problems/minimum-score-of-a-path-between-two-cities/)