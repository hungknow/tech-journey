# 0886 Possible Bipartition

## Problem Description

We want to split a group of `n` people (labeled from `1` to `n`) into two groups. Each person may dislike some other people, and they should not be put into the same group.

Given `n` and a list of pairs `dislikes` where `dislikes[i] = [ai, bi]` indicates that person `ai` dislikes person `bi`.

Return `true` if it is possible to split everyone into two groups in this way.

### Example 1:
```
Input: n = 4, dislikes = [[1,2],[1,3],[2,4]]
Output: true
```

### Example 2:
```
Input: n = 3, dislikes = [[1,2],[1,3],[2,3]]
Output: false
```

## Approach

This problem can be solved using BFS to check if the graph is bipartite:

1. **Graph Construction**:
   - Build an adjacency list from the dislikes pairs
   - This creates an undirected graph where edges represent dislike relationships

2. **BFS Bipartite Check**:
   - Use BFS to color the graph with two colors
   - Start BFS from each uncolored node
   - For each node, color its neighbors with the opposite color
   - If we find a neighbor with the same color, the graph is not bipartite

3. **Validation**: If we can successfully color the entire graph, return true

## Solution Code

```go
func possibleBipartition(n int, dislikes [][]int) bool {
    // Build adjacency list
    graph := make([][]int, n+1)
    for _, dislike := range dislikes {
        a, b := dislike[0], dislike[1]
        graph[a] = append(graph[a], b)
        graph[b] = append(graph[b], a)
    }
    
    // Color array: 0 = uncolored, 1 = color 1, -1 = color 2
    colors := make([]int, n+1)
    
    // BFS to check bipartite
    for i := 1; i <= n; i++ {
        if colors[i] == 0 {
            queue := []int{i}
            colors[i] = 1
            
            for len(queue) > 0 {
                current := queue[0]
                queue = queue[1:]
                
                for _, neighbor := range graph[current] {
                    if colors[neighbor] == 0 {
                        colors[neighbor] = -colors[current]
                        queue = append(queue, neighbor)
                    } else if colors[neighbor] == colors[current] {
                        return false
                    }
                }
            }
        }
    }
    
    return true
}
```

## Complexity Analysis

- **Time**: O(V + E) where V is the number of people (n) and E is the number of dislike pairs
  - Building the graph: O(E)
  - BFS traversal: O(V + E)
- **Space**: O(V + E) for the graph and color array

## Link

[LeetCode 0886 Possible Bipartition](https://leetcode.com/problems/possible-bipartition/)