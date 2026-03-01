# 2093 Minimum Cost to Reach City with Discounts

## Problem Description

You are given `n` cities labeled from 0 to n-1 and `edges` where `edges[i] = [ui, vi, timei]` represents a bidirectional edge between `ui` and `vi` that takes `timei` units of time to traverse.

You can apply at most `discounts` number of discounts, where each discount reduces the travel time of an edge by half.

Return the minimum time needed to travel from city 0 to city n-1 with at most `discounts` discounts.

### Example 1:
```
Input: n = 5, edges = [[0,1,10],[1,2,10],[2,3,10],[3,4,10],[0,4,50]], discounts = 1
Output: 30
```

### Example 2:
```
Input: n = 5, edges = [[0,1,10],[1,2,10],[2,3,10],[3,4,10],[0,4,50]], discounts = 0
Output: 40
```

## Approach

This problem can be solved using Dijkstra's algorithm with state tracking:

1. **State Representation**:
   - Track current city and remaining discounts
   - Use priority queue for shortest path

2. **Modified Dijkstra**:
   - For each state (city, remaining_discounts), explore neighbors
   - Try both with and without discount on each edge
   - Track minimum time for each state

3. **Dynamic Programming**:
   - Use DP array to store minimum time for each state
   - Update when finding better paths

4. **Priority Queue**:
   - Order by current time (shortest first)
   - Include discount count in state

## Solution Code

```go
func minimumCost(n int, edges [][]int, discounts int) int {
    // Build adjacency list
    graph := make([][][2]int, n)
    for _, edge := range edges {
        u, v, time := edge[0], edge[1], edge[2]
        graph[u] = append(graph[u], [2]int{v, time})
        graph[v] = append(graph[v], [2]int{u, time})
    }
    
    // DP table: [city][remaining_discounts] = minimum_time
    dp := make([][]int, n)
    for i := 0; i < n; i++ {
        dp[i] = make([]int, discounts+1)
        for j := 0; j <= discounts; j++ {
            dp[i][j] = 1<<31 - 1
        }
    }
    dp[0][discounts] = 0
    
    // Priority queue: {time, city, remaining_discounts}
    pq := [][3]int{{0, 0, discounts}}
    
    for len(pq) > 0 {
        current := pq[0]
        pq = pq[1:]
        
        time, city, remainingDiscounts := current[0], current[1], current[2]
        
        if city == n-1 {
            return time
        }
        
        if time > dp[city][remainingDiscounts] {
            continue
        }
        
        for _, edge := range graph[city] {
            neighbor, travelTime := edge[0], edge[1]
            
            // Try without discount
            newTime := time + travelTime
            if newTime < dp[neighbor][remainingDiscounts] {
                dp[neighbor][remainingDiscounts] = newTime
                pq = append(pq, [3]int{newTime, neighbor, remainingDiscounts})
            }
            
            // Try with discount if available
            if remainingDiscounts > 0 {
                discountedTime := time + travelTime/2
                if discountedTime < dp[neighbor][remainingDiscounts-1] {
                    dp[neighbor][remainingDiscounts-1] = discountedTime
                    pq = append(pq, [3]int{discountedTime, neighbor, remainingDiscounts-1})
                }
            }
        }
    }
    
    return -1 // No path found
}
```

## Complexity Analysis

- **Time**: O((V * D + E * D) log (V * D)) where V is vertices, E is edges, D is discounts
  - Each state (city, remaining_discounts) is processed once
  - Priority queue operations dominate the complexity
- **Space**: O(V * D) for the DP table and priority queue

## Link

[LeetCode 2093 Minimum Cost to Reach City with Discounts](https://leetcode.com/problems/minimum-cost-to-reach-city-with-discounts/)