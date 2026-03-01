# 1135 Connecting Cities With Minimum Cost

## Problem Description

There are `n` cities labeled from `1` to `n`. You are given the array `connections` where `connections[i] = [city1i, city2i, costi]` represents the cost to connect `city1i` and `city2i`.

Return the minimum cost to connect all the cities. If it's impossible to connect all cities, return `-1`.

### Example 1:
```
Input: n = 3, connections = [[1,2,5],[1,3,6],[2,3,1]]
Output: 6
Explanation: Connect cities 1 and 2 with cost 5, and cities 2 and 3 with cost 1. Total cost is 6.
```

### Example 2:
```
Input: n = 4, connections = [[1,2,3],[3,4,4]]
Output: -1
Explanation: It's impossible to connect all cities.
```

## Approach

This problem can be solved using Kruskal's algorithm with Union Find:

1. **Sort Edges by Cost**: Sort all connections by their cost in ascending order.

2. **Union Find Setup**: Use Union Find to track connected components.

3. **Kruskal's Algorithm**:
   - Iterate through sorted edges
   - For each edge, if the two cities are not already connected, union them and add the cost
   - Stop when we have connected all cities or when we've processed all edges

4. **Result Check**: If we've connected all cities, return the total cost; otherwise, return -1.

## Solution Code

```go
func minimumCost(n int, connections [][]int) int {
    if n == 1 {
        return 0
    }
    
    // Sort connections by cost
    sort.Slice(connections, func(i, j int) bool {
        return connections[i][2] < connections[j][2]
    })
    
    parent := make([]int, n+1) // 1-indexed
    
    // Initialize Union Find
    for i := 1; i <= n; i++ {
        parent[i] = i
    }
    
    var find func(x int) int
    find = func(x int) int {
        if parent[x] != x {
            parent[x] = find(parent[x])
        }
        return parent[x]
    }
    
    union := func(x, y int) bool {
        rootX, rootY := find(x), find(y)
        if rootX != rootY {
            parent[rootX] = rootY
            return true
        }
        return false
    }
    
    totalCost := 0
    edgesUsed := 0
    
    for _, conn := range connections {
        city1, city2, cost := conn[0], conn[1], conn[2]
        
        if union(city1, city2) {
            totalCost += cost
            edgesUsed++
            
            if edgesUsed == n-1 {
                return totalCost
            }
        }
    }
    
    if edgesUsed == n-1 {
        return totalCost
    }
    
    return -1
}
```

## Complexity Analysis

- **Time**: O(m log m + mα(n)) where m is the number of connections and n is the number of cities
  - Sorting connections: O(m log m)
  - Union Find operations: O(mα(n)) but practically O(m)
- **Space**: O(n) for the Union Find data structure

## Link

[LeetCode 1135 Connecting Cities With Minimum Cost](https://leetcode.com/problems/connecting-cities-with-minimum-cost/)