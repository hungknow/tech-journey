# 2473 Minimum Cost to Buy Apples

## Problem Description

You are given an integer `n` representing the number of cities labeled from 0 to n-1 and a 2D array `roads` where `roads[i] = [ui, vi, costi]` represents a bidirectional road between city `ui` and city `vi` with travel cost `costi`.

You can buy apples in any city and sell them in any other city. The profit from buying in city `i` and selling in city `j` is `price[j] - price[i] - travel_cost(i, j)`.

You want to maximize your profit by buying and selling apples. Return the minimum cost to travel from city 0 to city n-1.

### Example 1:
```
Input: n = 4, roads = [[0,1,9],[1,2,6],[2,3,8],[0,3,12]]
Output: 12
```

### Example 2:
```
Input: n = 5, roads = [[0,1,5],[1,2,10],[2,3,15],[3,4,20]]
Output: 50
```

## Approach

This problem can be solved using Dijkstra's algorithm:

1. **Graph Construction**:
   - Build adjacency list from roads
   - Each road is bidirectional with given cost
   - Use priority queue for shortest path

2. **Shortest Path Calculation**:
   - Use Dijkstra's algorithm to find minimum cost from city 0 to city n-1
   - Track minimum distance to each city
   - Update distances when shorter paths are found

3. **Priority Queue**:
   - Use min-heap to always expand the city with current minimum cost
   - Store pairs of (current_cost, city)
   - Early termination when reaching destination

4. **Optimization**:
   - Stop when destination is popped from queue
   - Use visited array to avoid reprocessing
   - Handle edge cases (no path exists)

## Solution Code

```go
func minCost(n int, roads [][]int) int {
    // Build adjacency list
    graph := make([][][2]int, n)
    for _, road := range roads {
        u, v, cost := road[0], road[1], road[2]
        graph[u] = append(graph[u], [2]int{v, cost})
        graph[v] = append(graph[v], [2]int{u, cost})
    }
    
    // Dijkstra's algorithm
    dist := make([]int, n)
    for i := 0; i < n; i++ {
        dist[i] = 1<<31 - 1
    }
    dist[0] = 0
    
    // Priority queue: {cost, city}
    pq := [][2]int{{0, 0}}
    
    for len(pq) > 0 {
        current := pq[0]
        pq = pq[1:]
        
        cost, city := current[0], current[1]
        
        if city == n-1 {
            return cost
        }
        
        if cost > dist[city] {
            continue
        }
        
        for _, neighbor := range graph[city] {
            nextCity, travelCost := neighbor[0], neighbor[1]
            newCost := cost + travelCost
            
            if newCost < dist[nextCity] {
                dist[nextCity] = newCost
                pq = append(pq, [2]int{newCost, nextCity})
            }
        }
    }
    
    return -1 // No path found
}
```

## Complexity Analysis

- **Time**: O((V + E) log V) where V is the number of cities and E is the number of roads
  - Dijkstra's algorithm with priority queue
- **Space**: O(V + E) for the adjacency list and distance array

## Link

[LeetCode 2473 Minimum Cost to Buy Apples](https://leetcode.com/problems/minimum-cost-to-buy-apples/)