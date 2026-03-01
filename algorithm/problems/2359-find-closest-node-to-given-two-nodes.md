# 2359 Find Closest Node to Given Two Nodes

## Problem Description

You are given a directed graph with `n` nodes labeled from 0 to n-1 and `edges` where `edges[i]` represents a directed edge from node `i` to `edges[i]`.

You are also given two nodes `node1` and `node2`.

Return the node that is the farthest from both `node1` and `node2`. If there are multiple such nodes, return the node with the smallest index. If no such node exists, return -1.

The distance between two nodes is the number of edges in the shortest path between them.

### Example 1:
```
Input: n = 4, edges = [1,2,-1,0], node1 = 0, node2 = 1
Output: 2
```

### Example 2:
```
Input: n = 3, edges = [1,2,-1], node1 = 0, node2 = 2
Output: -1
```

## Approach

This problem can be solved by finding distances from both nodes:

1. **Distance Calculation**:
   - Use BFS to find distances from `node1` to all reachable nodes
   - Use BFS to find distances from `node2` to all reachable nodes
   - Track which nodes are reachable from both sources

2. **Maximum Distance Finding**:
   - For each node reachable from both sources, find the minimum of the two distances
   - Find the maximum of these minimum distances
   - Return the node with smallest index if multiple nodes have same maximum distance

3. **BFS Implementation**:
   - For each source, perform BFS to calculate distances
   - Use visited array to track reachable nodes
   - Store distances in array for easy access

4. **Result Selection**:
   - Iterate through all nodes to find valid candidates
   - Calculate maximum minimum distance
   - Handle edge cases (no valid nodes)

## Solution Code

```go
func closestMeetingNode(edges []int, node1 int, node2 int) int {
    n := len(edges)
    
    // BFS to find distances from node1
    dist1 := make([]int, n)
    for i := 0; i < n; i++ {
        dist1[i] = -1
    }
    
    bfs(edges, node1, dist1)
    
    // BFS to find distances from node2
    dist2 := make([]int, n)
    for i := 0; i < n; i++ {
        dist2[i] = -1
    }
    
    bfs(edges, node2, dist2)
    
    // Find the answer
    result := -1
    maxMinDist := -1
    
    for i := 0; i < n; i++ {
        if dist1[i] != -1 && dist2[i] != -1 {
            minDist := min(dist1[i], dist2[i])
            if minDist > maxMinDist {
                maxMinDist = minDist
                result = i
            } else if minDist == maxMinDist && i < result {
                result = i
            }
        }
    }
    
    return result
}

func bfs(edges []int, start int, dist []int) {
    n := len(edges)
    visited := make([]bool, n)
    queue := []int{start}
    visited[start] = true
    dist[start] = 0
    
    for len(queue) > 0 {
        current := queue[0]
        queue = queue[1:]
        
        next := edges[current]
        if next != -1 && !visited[next] {
            visited[next] = true
            dist[next] = dist[current] + 1
            queue = append(queue, next)
        }
    }
}

func min(a, b int) int {
    if a < b {
        return a
    }
    return b
}
```

## Complexity Analysis

- **Time**: O(N) where N is the number of nodes
  - Two BFS traversals: O(N) each
  - Final scan: O(N)
- **Space**: O(N) for the distance arrays and visited arrays

## Link

[LeetCode 2359 Find Closest Node to Given Two Nodes](https://leetcode.com/problems/find-closest-node-to-given-two-nodes/)