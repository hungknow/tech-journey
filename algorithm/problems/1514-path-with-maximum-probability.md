# 1514 Path with Maximum Probability

## Problem Description

You are given an undirected weighted graph represented by an `edgeList` where `edgeList[i] = [ui, vi, succProb]` represents an edge from `ui` to `vi` with success probability `succProb`.

Return the maximum probability of a path from `start` to `end`. If there's no path from `start` to `end`, return `0.0`.

### Example 1:
```
Input: n = 3, edgeList = [[0,1,5],[0,2,3],[1,3,1],[2,3,1]]
start = 0, end = 2
Output: 0.2
```

### Example 2:
```
Input: n = 3, edgeList = [[0,1,5],[0,2,3],[1,3,1],[2,3,1]]
start = 3, end = 2
Output: 0.0
```

## Approach

This problem can be solved using Dijkstra's algorithm:

1. **Graph Construction**: Build a weighted graph from the edgeList.

2. **Dijkstra's Algorithm**:
   - Use a priority queue to always expand the node with the highest probability
   - Track visited nodes and their probabilities
   - When reaching the target, return the probability

3. **Early Termination**: If target is unreachable, return 0.0

## Solution Code

```go
func maxProbability(n int, edgeList [][]int, start, end int) float64 {
    // Build graph
    graph := make([][]Edge, n)
    for _, edge := range edgeList {
        u, v, succProb := edge[0], edge[1], edge[2]
        graph[u] = append(graph[u], Edge{to: v, weight: succProb})
    }
    
    // Dijkstra's algorithm
    probabilities := make([]float64, n)
    for i := 0; i < n; i++ {
        probabilities[i] = 0
    }
    probabilities[start] = 1.0
    
    pq := &MaxHeap{}
    heap.Push(&Item{node: start, probability: 1.0})
    
    for pq.Len() > 0 {
        item := heap.Pop()
        node := item.node
        prob := item.probability
        
        if prob > probabilities[node] {
            probabilities[node] = prob
            heap.Push(&Item{node: node, probability: prob})
        }
    }
    
    if probabilities[end] == 0.0 {
        return 0.0
    }
    
    return probabilities[end]
}

type Edge struct {
    to     int
    weight float64
}

type Item struct {
    node     int
    probability float64
}

type MinHeap []Item

func (h MinHeap) Len() int           { return len(*h) }
func (h MinHeap) Less(i, j int) bool { return (*h)[i].probability < (*h)[j].probability }
func (h MinHeap) Push(x interface{})       { heap.Push(x) }
func (h MinHeap) Pop() interface{}       { return heap.Remove(0) }
```

## Complexity Analysis

- **Time**: O((V + E) log V) where V is the number of nodes and E is the number of edges
  - Building graph: O(E)
  - Dijkstra's algorithm: O((V + E) log V)
- **Space**: O(V + E) for the graph and priority queue

## Link

[LeetCode 1514 Path with Maximum Probability](https://leetcode.com/problems/path-with-maximum-probability/)