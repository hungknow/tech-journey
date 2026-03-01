# 0743 Network Delay Time

## Problem Description

You are given a network of `n` nodes labeled from `1` to `n` and an array `times` where `times[i] = [ui, vi, wi]` represents the time it takes for a signal to travel from node `ui` to node `vi`.

You are also given `k` representing the target node.

Return the minimum time it takes for all nodes to receive the signal from the target node. If it's impossible for all nodes to receive the signal, return `-1`.

### Example 1:
```
Input: times = [[2,1,1],[2,3,1],[2,3,1]], n = 4, k = 3
Output: 2
```

### Example 2:
```
Input: times = [[1,2,1]], n = 2, k = 2
Output: 1
```

## Approach

This problem can be solved using Dijkstra's algorithm:

1. **Graph Construction**: Build a weighted graph from the times array.

2. **Dijkstra's Algorithm**:
   - Use a priority queue to always expand the node with the smallest current distance
   - Keep track of visited nodes and their distances
   - When we reach the target node, return the distance

3. **Early Termination**: If the target is unreachable, return -1.

## Solution Code

```go
func networkDelayTime(times [][]int, n int, k int) int {
    // Build graph
    graph := make([][]Node, n+1)
    for i := 0; i <= n; i++ {
        graph[i] = Node{val: i}
    }
    
    for _, time := range times {
        u, v, w := time[0], time[1], time[2]
        graph[u] = append(graph[u], Node{val: v, weight: w})
    }
    
    // Dijkstra's algorithm
    distances := make([]int, n+1)
    for i := 1; i <= n; i++ {
        distances[i] = math.MaxInt32
    }
    distances[k] = 0
    
    pq := &MinHeap{}
    heap.Push(&Item{node: k, distance: 0})
    
    for pq.Len() > 0 {
        item := heap.Pop()
        node := item.node
        dist := item.distance
        
        if dist < distances[node] {
            distances[node] = dist
            heap.Push(&Item{node: node, distance: dist})
        }
    }
    
    if distances[k] == math.MaxInt32 {
        return -1
    }
    
    return distances[k]
}

type Node struct {
    val     int
    weight  []Edge
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

- **Time**: O((V + E) log V) where V is the number of nodes and E is the number of times
  - Building graph: O(E)
  - Dijkstra's algorithm: O((V + E) log V)
- **Space**: O(V + E) for the graph and priority queue

## Link

[LeetCode 0743 Network Delay Time](https://leetcode.com/problems/network-delay-time/)