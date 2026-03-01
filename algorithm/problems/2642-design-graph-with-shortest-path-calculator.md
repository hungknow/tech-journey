# 2642 Design Graph With Shortest Path Calculator

## Problem Description

Design a graph that can calculate the shortest path between any two nodes in the graph.

Implement the `Graph` class:

- `Graph(int n, int[][] edges)` Initializes the graph with `n` nodes and `edges`.
- `void addEdge(int from, int to)` Adds an edge from node `from` to node `to`.
- `int shortestPath(int node1, int node2)` Returns the length of the shortest path between node1 and node2. If no path exists, return -1.

### Example 1:
```
Input
["Graph","addEdge","addEdge","addEdge","addEdge","shortestPath","shortestPath"]
[[4,0,1],[[1,2],[1,3],[1,3]]
Output
[null,null,null,null,2]

Explanation
Graph g = new Graph(4, [[0,1],[1,2],[1,3]]);
g.addEdge(0, 1);
g.addEdge(1, 2);
g.addEdge(1, 3);
g.shortestPath(1, 3); // return 2, shortest path from 1 to 3 is 2
```

## The Twist

Implementing a graph data structure that efficiently calculates shortest paths using Dijkstra's algorithm.

## Algorithm

### Dijkstra's Algorithm:
1. Use an adjacency list to represent the graph
2. For Graph(n, edges):
   - Initialize adjacency list
3. For addEdge(from, to):
     - Add edge to adjacency list
4. For shortestPath(node1, node2):
     - Use Dijkstra's algorithm to find shortest path
     - Return the distance or -1 if no path exists

The key insight is using Dijkstra's algorithm with a priority queue to find the shortest path efficiently.

## Complexity

- **Time**: 
  - Graph constructor: O(n + m) where n is nodes and m is edges
  - addEdge: O(1)
  - shortestPath: O((n + m) log n) where n is nodes and m is edges
- **Space**: O(n + m) where n is nodes and m is edges

## Solution Code

```go
package main

import (
	"container/heap"
	"math"
)

type Edge struct {
	from int
	to   int
	weight int
}

type Graph struct {
	n      int
	edges  map[int][]*Edge
	adj     map[int][]int
}

type Node struct {
	id       int
	distance int
	visited  bool
}

type PriorityQueue []*Node

func (g *Graph) AddEdge(from int, to int) {
	edge := Edge{from: from, to: to, weight: 1}
	g.edges[from] = append(g.edges[from], edge)
	g.edges[to] = append(g.edges[to], edge)
}

func (g *Graph) ShortestPath(node1 int, node2 int) int {
	if node1 == node2 {
		return 0
	}
	
	// Dijkstra's algorithm
	n := len(g.edges)
	distances := make([]int, n)
	visited := make([]bool, n)
	pq := &PriorityQueue{}
	heap.Init(q)
	
	// Initialize distances
	for i := 0; i < n; i++ {
		distances[i] = math.MaxInt32
		visited[i] = false
	}
	
	// Initialize priority queue with source node
	heap.Push(q, &Node{id: node1, distance: 0})
	
	for q.Len() > 0 {
		node := heap.Pop(q).(Node)
		visited[node.id] = true
		
		// Update distances for neighbors
		for _, edge := range g.edges[node.id] {
			neighbor := edge.to
			if !visited[neighbor] {
				newDist := distances[node.id] + edge.weight
				if newDist < distances[neighbor] {
					distances[neighbor] = newDist
				}
			}
		}
		
		// Add unvisited neighbors to queue
		for _, edge := range g.edges[node.id] {
			if !visited[edge.to] {
				heap.Push(&Node{id: edge.to, distance: distances[edge.to] + edge.weight})
			}
		}
	}
	
	return distances[node2]
}

/**
 * Your Graph object will be instantiated and called as such:
 * obj := Constructor(n, edges);
 * param_1 := obj.AddEdge(from,to);
 * param_2 := obj.ShortestPath(node1,node2);
 */
```

## Link

[LeetCode 2642 Design Graph With Shortest Path Calculator](https://leetcode.com/problems/design-graph-with-shortest-path-calculator/)