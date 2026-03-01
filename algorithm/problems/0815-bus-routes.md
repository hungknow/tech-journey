# 0815 Bus Routes

## Problem Description

You are given an array `routes` where `routes[i]` is a bus route that the i-th bus runs forever. For example, if `routes[0] = [1, 5, 7]`, then the 0-th bus travels in the sequence 1 → 5 → 7 → 1 → 5 → 7 → 1 → ...

You are also given `source` and `target` bus stops. Return the least number of buses you must take to travel from `source` to `target`. If it is impossible to travel from `source` to `target`, return -1.

### Example 1:
```
Input: routes = [[1,2,7],[3,6,7]], source = 1, target = 6
Output: 2
```

### Example 2:
```
Input: routes = [[7,12],[4,5,15],[6,15],[15,19,12],[9,12,13]], source = 15, target = 12
Output: 1
```

## Approach

This problem can be solved using BFS on a graph where nodes are bus routes:

1. **Graph Construction**:
   - Create a graph where each bus route is a node
   - Two routes are connected if they share at least one common stop
   - Build a stop-to-routes mapping for efficient lookup

2. **BFS Traversal**:
   - Start BFS from all routes that contain the source stop
   - Track visited routes to avoid cycles
   - When we reach any route containing the target stop, return the current level

3. **Early Termination**: When we find a route containing the target, return the number of buses taken

## Solution Code

```go
func numBusesToDestination(routes [][]int, source int, target int) int {
    if source == target {
        return 0
    }
    
    // Build stop to routes mapping
    stopToRoutes := make(map[int][]int)
    for i := 0; i < len(routes); i++ {
        for _, stop := range routes[i] {
            stopToRoutes[stop] = append(stopToRoutes[stop], i)
        }
    }
    
    // Check if source and target are reachable
    if _, exists := stopToRoutes[source]; !exists {
        return -1
    }
    if _, exists := stopToRoutes[target]; !exists {
        return -1
    }
    
    // BFS setup
    queue := []int{}
    visited := make(map[int]bool)
    visitedRoutes := make(map[int]bool)
    
    // Start with all routes containing source
    for _, route := range stopToRoutes[source] {
        queue = append(queue, route)
        visitedRoutes[route] = true
    }
    
    buses := 1
    
    for len(queue) > 0 {
        levelSize := len(queue)
        
        for i := 0; i < levelSize; i++ {
            currentRoute := queue[0]
            queue = queue[1:]
            
            // Check if this route contains target
            for _, stop := range routes[currentRoute] {
                if stop == target {
                    return buses
                }
                
                // Add all routes that share this stop
                for _, nextRoute := range stopToRoutes[stop] {
                    if !visitedRoutes[nextRoute] {
                        visitedRoutes[nextRoute] = true
                        queue = append(queue, nextRoute)
                    }
                }
            }
        }
        
        buses++
    }
    
    return -1
}
```

## Complexity Analysis

- **Time**: O(R * S) where R is the number of routes and S is the average number of stops per route
  - Building the stop-to-routes mapping: O(R * S)
  - BFS traversal: O(R * S) in the worst case
- **Space**: O(R * S) for the stop-to-routes mapping and visited sets

## Link

[LeetCode 0815 Bus Routes](https://leetcode.com/problems/bus-routes/)