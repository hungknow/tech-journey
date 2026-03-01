# 1928 Minimum Cost to Reach Destination in Time

## Problem Description

You are given a directed weighted graph with `n` nodes labeled from `0` to `n-1`. You are also given `edges` where `edges[i] = [ui, vi, timei]` represents a directed edge from `ui` to `vi` that takes `timei` time to travel.

You are given `timeLimit` representing the maximum time allowed for travel.

Return the minimum time needed to travel from node `0` to node `n-1` within `timeLimit`. If it's impossible, return `-1`.

### Example 1:
```
Input: n = 4, edges = [[0,1,1],[0,2,100],[1,3,600]], timeLimit = 1
Output: 100
```

### Example 2:
```
Input: n = 4, edges = [[0,1,1,1],[1,2,100]], timeLimit = 2
Output: 200
```

## Approach

This problem can be solved using Dijkstra's algorithm with early termination:

1. **Graph Construction**: Build a weighted graph from the edges.

2. **Dijkstra's Algorithm**:
   - Use a priority queue to always expand the node with the smallest distance
   - Track visited nodes and their distances
   - Early terminate when reaching the target or time limit is exceeded

3. **Early Termination**: If target is unreachable, return -1

## Solution Code

```go
func minimumCost(n int, edges [][]int, timeLimit int) int {
    // Build graph
    graph := make([][]Edge, n)
    for _, edge := range edges {
        from, to, time := edge[0], edge[1], edge[2]
        graph[from] = append(graph[from], Edge{to, weight: time})
    }
    
    // Dijkstra's algorithm
    distances := make([]int, n)
    for i := 0; i < n; i++ {
        distances[i] = math.MaxInt32
    }
    
    pq := &MinHeap{}
    heap.Push(&Item{node: 0, distance: 0})
    
    for pq.Len() > 0 {
        item := heap.Pop()
        node := item.node
        dist := item.distance
        
        if dist > distances[node] {
            distances[node] = dist
            heap.Push(&Item{node: node, distance: dist})
        }
        
        // Check time limit
        if dist > timeLimit {
            return -1
        }
    }
    
    if distances[n-1] == math.MaxInt32 {
        return distances[n-1]
    }
    
    return distances[n-1]
}

type Edge struct {
    to     int
    weight int
}

type Item struct {
    node     int
    distance int
}

type MinHeap []Item

func (h MinHeap) Len() int           { return len(*h) }
func (h MinHeap) Less(i, j int) bool { return (*h)[i].distance < (*h)[j].distance }
func (h MinHeap) Push(x interface{})       { heap.Push(x) }
func (h MinHeap) Pop() interface{}       { return heap.Remove(0) }
```

## Complexity Analysis

- **Time**: O((V + E) log V) where V is the number of nodes and E is the number of edges
  - Building graph: O(E)
  - Dijkstra's algorithm: O((V + E) log V)
- **Space**: O(V + E) for the graph and priority queue

## Link

[LeetCode 1928 Minimum Cost to Reach Destination in Time](https://leetcode.com/problems/minimum-cost-to-reach-destination-in-time/)