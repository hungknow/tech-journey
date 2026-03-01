# 1334 Find the City With the Smallest Number of Neighbors at a Threshold Distance

## Problem Description

You are given `n` cities, an array `edges` where `edges[i] = [ui, vi, weighti]` represents an edge between city `ui` and city `vi` with distance `weighti`, and a `distanceThreshold`.

The distance between two cities is the sum of the weights of the edges on the shortest path between them.

A city `x` is reachable from city `y` if the distance between them is ≤ `distanceThreshold`.

Return the city with the smallest number of neighbors that are reachable from it. If there are multiple such cities, return the city with the greatest number.

### Example 1:
```
Input: n = 4, edges = [[0,1,3],[1,2,1],[1,3,4],[2,3,1]], distanceThreshold = 4
Output: 3
```

### Example 2:
```
Input: n = 5, edges = [[0,1,2],[0,2,4],[1,2,1],[1,3,2],[2,3,3],[2,4,5],[3,4,1]], distanceThreshold = 17
Output: 4
```

## Approach

This problem can be solved using Floyd-Warshall algorithm:

1. **Distance Matrix**:
   - Initialize distance matrix with infinity
   - Set distance[i][i] = 0 for all i
   - Fill in direct edge distances

2. **Floyd-Warshall Algorithm**:
   - Compute all-pairs shortest paths
   - For each intermediate node k, update distances between all pairs

3. **Neighbor Counting**:
   - For each city, count reachable neighbors
   - Find city with minimum reachable neighbors
   - Return the city with greatest number in case of ties

## Solution Code

```go
func findTheCity(n int, edges [][]int, distanceThreshold int) int {
    // Initialize distance matrix
    dist := make([][]int, n)
    for i := 0; i < n; i++ {
        dist[i] = make([]int, n)
        for j := 0; j < n; j++ {
            if i == j {
                dist[i][j] = 0
            } else {
                dist[i][j] = math.MaxInt32
            }
        }
    }
    
    // Fill in direct edges
    for _, edge := range edges {
        u, v, w := edge[0], edge[1], edge[2]
        dist[u][v] = w
        dist[v][u] = w
    }
    
    // Floyd-Warshall algorithm
    for k := 0; k < n; k++ {
        for i := 0; i < n; i++ {
            for j := 0; j < n; j++ {
                if dist[i][k] + dist[k][j] < dist[i][j] {
                    dist[i][j] = dist[i][k] + dist[k][j]
                }
            }
        }
    }
    
    // Count reachable neighbors for each city
    minNeighbors := math.MaxInt32
    result := 0
    
    for i := 0; i < n; i++ {
        reachableNeighbors := 0
        for j := 0; j < n; j++ {
            if i != j && dist[i][j] <= distanceThreshold {
                reachableNeighbors++
            }
        }
        
        if reachableNeighbors < minNeighbors {
            minNeighbors = reachableNeighbors
            result = i
        } else if reachableNeighbors == minNeighbors && i > result {
            result = i
        }
    }
    
    return result
}
```

## Complexity Analysis

- **Time**: O(n^3) where n is the number of cities
  - Floyd-Warshall algorithm takes O(n^3) time
- **Space**: O(n^2) for the distance matrix

## Link

[LeetCode 1334 Find the City With the Smallest Number of Neighbors at a Threshold Distance](https://leetcode.com/problems/find-the-city-with-the-smallest-number-of-neighbors-at-a-threshold-distance/)