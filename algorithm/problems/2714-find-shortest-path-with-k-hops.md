# 2714 Find Shortest Path with K Hops

## Problem Description

You are given a directed weighted graph with `n` nodes labeled from 0 to n-1 and `edges` where `edges[i] = [ui, vi, wi]` represents a directed edge from `ui` to `vi` with weight `wi`.

You can make at most `k` "hops" where a hop allows you to skip exactly one edge on your path.

Return the shortest distance from node 0 to node n-1 with at most `k` hops.

### Example 1:
```
Input: n = 4, edges = [[0,1,100],[1,2,100],[2,3,100],[0,2,500]], k = 1
Output: 200
```

### Example 2:
```
Input: n = 3, edges = [[0,1,100],[1,2,100],[0,2,500]], k = 0
Output: 200
```

## Approach

This problem can be solved using modified Dijkstra's algorithm with state tracking:

1. **State Representation**:
   - Track current node and number of hops used
   - Use DP table: dp[node][hops_used] = minimum distance
   - Each state represents a unique configuration

2. **Modified Dijkstra**:
   - Use priority queue with (distance, node, hops_used)
   - For each state, try both regular and hop moves
   - Update DP table when finding shorter paths

3. **Hop Mechanics**:
   - Regular move: go to next node with edge weight
   - Hop move: skip one edge and go to its destination
   - Track remaining hops for each state

4. **Result Extraction**:
   - After processing all states, find minimum distance to target
   - Consider all possible hop counts (0 to k)
   - Return the minimum among all valid states

## Solution Code

```go
func shortestPathWithHops(n int, edges [][]int, k int) int {
    // Build adjacency list
    graph := make([][][2]int, n)
    for _, edge := range edges {
        u, v, w := edge[0], edge[1], edge[2]
        graph[u] = append(graph[u], [2]int{v, w})
    }
    
    // DP table: dp[node][hops_used] = minimum distance
    dp := make([][]int, n)
    for i := 0; i < n; i++ {
        dp[i] = make([]int, k+1)
        for j := 0; j <= k; j++ {
            dp[i][j] = 1<<31 - 1
        }
    }
    dp[0][0] = 0
    
    // Priority queue: {distance, node, hops_used}
    pq := [][3]int{{0, 0, 0}}
    
    for len(pq) > 0 {
        current := pq[0]
        pq = pq[1:]
        
        dist, node, hops := current[0], current[1], current[2]
        
        if node == n-1 {
            return dist
        }
        
        if dist > dp[node][hops] {
            continue
        }
        
        // Try all edges from current node
        for _, edge := range graph[node] {
            next, weight := edge[0], edge[1]
            
            // Regular move (no hop)
            newDist := dist + weight
            if newDist < dp[next][hops] {
                dp[next][hops] = newDist
                pq = append(pq, [3]int{newDist, next, hops})
            }
            
            // Hop move (if we have hops left)
            if hops < k {
                // Skip this edge and go directly to its destination
                hopDist := dist
                if hopDist < dp[next][hops+1] {
                    dp[next][hops+1] = hopDist
                    pq = append(pq, [3]int{hopDist, next, hops + 1})
                }
            }
        }
    }
    
    // Find minimum distance to target with any number of hops
    result := 1<<31 - 1
    for hops := 0; hops <= k; hops++ {
        if dp[n-1][hops] < result {
            result = dp[n-1][hops]
        }
    }
    
    return result
}
```

## Complexity Analysis

- **Time**: O((V * K + E * K) log (V * K)) where V is vertices, E is edges, K is max hops
  - Each state (node, hops) is processed once
  - Priority queue operations dominate the complexity
- **Space**: O(V * K) for the DP table and priority queue

## Link

[LeetCode 2714 Find Shortest Path with K Hops](https://leetcode.com/problems/find-shortest-path-with-k-hops/)