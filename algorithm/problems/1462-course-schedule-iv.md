# 1462 Course Schedule IV

## Problem Description

You are given `n` courses, labeled from `0` to `n-1`, and an array `prerequisites` where `prerequisites[i] = [ui, vi]` represents that you must take course `ui` before course `vi`.

You are also given `queries` where `queries[i] = [start, end]` represents a query asking for the number of different ways to take courses from `start` to `end`.

Return an array `answer` where `answer[i]` is the number of different ways to take courses for `queries[i]`.

### Example 1:
```
Input: n = 2, prerequisites = [[1,0]], queries = [[0,1],[1,0]]
Output: [1,1]
```

### Example 2:
```
Input: n = 2, prerequisites = [], queries = [[1,0],[0,1]]
Output: [1,1]
```

## Approach

This problem can be solved using Floyd-Warshall algorithm:

1. **Graph Construction**:
   - Build adjacency matrix from prerequisites
   - Initialize distance matrix with infinity

2. **Floyd-Warshall Algorithm**:
   - Compute all-pairs shortest paths
   - For each intermediate node k, update distances between all pairs

3. **Query Processing**:
   - For each query, check if there's a path from start to end
   - If distance is finite, there's at least one way
   - Return 1 if reachable, 0 otherwise

## Solution Code

```go
func checkIfPrerequisite(numCourses int, prerequisites [][]int, queries [][]int) []bool {
    // Initialize distance matrix
    dist := make([][]int, numCourses)
    for i := 0; i < numCourses; i++ {
        dist[i] = make([]int, numCourses)
        for j := 0; j < numCourses; j++ {
            if i == j {
                dist[i][j] = 0
            } else {
                dist[i][j] = math.MaxInt32
            }
        }
    }
    
    // Fill in direct prerequisites
    for _, prereq := range prerequisites {
        u, v := prereq[0], prereq[1]
        dist[u][v] = 1
    }
    
    // Floyd-Warshall algorithm
    for k := 0; k < numCourses; k++ {
        for i := 0; i < numCourses; i++ {
            for j := 0; j < numCourses; j++ {
                if dist[i][k] + dist[k][j] < dist[i][j] {
                    dist[i][j] = dist[i][k] + dist[k][j]
                }
            }
        }
    }
    
    // Process queries
    answer := make([]bool, len(queries))
    for i, query := range queries {
        start, end := query[0], query[1]
        answer[i] = dist[start][end] < math.MaxInt32
    }
    
    return answer
}
```

## Complexity Analysis

- **Time**: O(n^3 + q) where n is the number of courses and q is the number of queries
  - Floyd-Warshall algorithm: O(n^3)
  - Query processing: O(q)
- **Space**: O(n^2) for the distance matrix

## Link

[LeetCode 1462 Course Schedule IV](https://leetcode.com/problems/course-schedule-iv/)