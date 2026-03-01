# 0787 Cheapest Flights Within K Stops

## Problem Description

You are given `n` nodes labeled from `0` to `n-1` and a 2D array `flights` where `flights[i] = [fromi, toi, pricei]` represents a flight from `fromi` to `toi` with price `pricei`.

You are also given integers `src`, `dst`, and `k` representing the maximum number of stops allowed.

Find the cheapest price from `src` to `dst` with at most `k` stops. If there's no such route, return `-1`.

### Example 1:
```
Input: n = 3, flights = [[0,1,100],[1,2,100],[0,2,500]], src = 0, dst = 2, k = 1
Output: 200
```

### Example 2:
```
Input: n = 4, flights = [[0,1,100],[1,2,100],[1,2,500],[2,0,200]], src = 0, dst = 2, k = 1
Output: 500
```

## Approach

This problem can be solved using modified Dijkstra's algorithm with stop count tracking:

1. **Graph Construction**: Build a weighted graph from the flights.

2. **Modified Dijkstra's Algorithm**:
   - Use a priority queue to expand nodes with smallest distance
   - Track the number of stops used
   - When reaching the destination, check if stops <= k

3. **Early Termination**: If destination is unreachable, return -1.

## Solution Code

```go
func findCheapestPrice(n int, flights [][]int, src int, dst int, k int) int {
    // Build graph
    graph := make([][]Edge, n)
    for _, flight := range flights {
        from, to, price := flight[0], flight[1], flight[2]
        graph[from] = append(graph[from], Edge{to, price})
    }
    
    // Dijkstra's algorithm with stop count
    distances := make([]int, n)
    stops := make([]int, n)
    for i := 0; i < n; i++ {
        distances[i] = math.MaxInt32
    }
    
    pq := &MinHeap{}
    heap.Push(&Item{node: src, distance: 0, stops: 0})
    
    for pq.Len() > 0 {
        item := heap.Pop()
        node := item.node
        dist := item.distance
        currentStops := item.stops
        
        if dist < distances[node] {
            distances[node] = dist
            heap.Push(&Item{node: node, distance: dist, stops: currentStops + 1})
        }
    }
    
    if distances[dst] == math.MaxInt32 {
        return -1
    }
    
    return distances[dst]
}

type Edge struct {
    to     int
    price int
}

type Item struct {
    node     int
    distance int
    stops    int
}

type MinHeap []Item

func (h MinHeap) Len() int           { return len(*h) }
func (h MinHeap) Less(i, j int) bool { return (*h)[i].distance < (*h)[j].distance }
func (h MinHeap) Push(x interface{})       { heap.Push(x) }
func (h MinHeap) Pop() interface{}       { return heap.Remove(0) }
```

## Complexity Analysis

- **Time**: O((V + E) log V) where V is the number of nodes and E is the number of flights
  - Building graph: O(E)
  - Modified Dijkstra's algorithm: O((V + E) log V)
- **Space**: O(V + E) for the graph and priority queue

## Link

[LeetCode 0787 Cheapest Flights Within K Stops](https://leetcode.com/problems/cheapest-flights-within-k-stops/)