# 1584 Min Cost to Connect All Points

## Problem Description

You are given an array `points` where `points[i] = [xi, yi]` represents the coordinates of the ith point on a 2D plane.

The cost of connecting two points is the Manhattan distance between them: `|xi - xj| + |yi - yj|`.

Return the minimum cost to make all points connected. All points are connected if there is exactly one simple path between any two points.

### Example 1:
```
Input: points = [[0,0],[2,2],[3,10],[5,2],[7,0]]
Output: 20
```

### Example 2:
```
Input: points = [[3,12],[-2,5],[-4,1]]
Output: 18
```

## Approach

This problem can be solved using Kruskal's algorithm with Union Find:

1. **Generate All Edges**: Calculate the Manhattan distance between all pairs of points and create edges.

2. **Sort Edges**: Sort all edges by their cost in ascending order.

3. **Kruskal's Algorithm**:
   - Use Union Find to build a minimum spanning tree
   - Add edges to the MST until all points are connected
   - Keep track of the total cost

4. **Early Termination**: Stop when we have connected all points (need n-1 edges for n points).

## Solution Code

```go
func minCostConnectPoints(points [][]int) int {
    n := len(points)
    if n == 1 {
        return 0
    }
    
    // Generate all edges
    edges := make([][3]int, 0)
    for i := 0; i < n; i++ {
        for j := i + 1; j < n; j++ {
            cost := abs(points[i][0]-points[j][0]) + abs(points[i][1]-points[j][1])
            edges = append(edges, [3]int{cost, i, j})
        }
    }
    
    // Sort edges by cost
    sort.Slice(edges, func(i, j int) bool {
        return edges[i][0] < edges[j][0]
    })
    
    parent := make([]int, n)
    
    // Initialize Union Find
    for i := range parent {
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
    
    for _, edge := range edges {
        cost, u, v := edge[0], edge[1], edge[2]
        
        if union(u, v) {
            totalCost += cost
            edgesUsed++
            
            if edgesUsed == n-1 {
                return totalCost
            }
        }
    }
    
    return totalCost
}

func abs(x int) int {
    if x < 0 {
        return -x
    }
    return x
}
```

## Complexity Analysis

- **Time**: O(n² log n) where n is the number of points
  - Generating all edges: O(n²)
  - Sorting edges: O(n² log n²) = O(n² log n)
  - Union Find operations: O(n²α(n)) but practically O(n²)
- **Space**: O(n²) for storing all edges and O(n) for Union Find

## Link

[LeetCode 1584 Min Cost to Connect All Points](https://leetcode.com/problems/min-cost-to-connect-all-points/)