# 0207 Course Schedule

## Problem Description

You are given `numCourses` courses labeled from `0` to `numCourses-1` and an array `prerequisites` where `prerequisites[i] = [ai, bi]` means you must take course `ai` before course `bi`.

Return `true` if you can finish all courses, otherwise return `false`.

### Example 1:
```
Input: numCourses = 2, prerequisites = [[1,0]]
Output: false
```

### Example 2:
```
Input: numCourses = 2, prerequisites = []
Output: true
```

## Approach

This problem can be solved using cycle detection in a directed graph:

1. **Graph Representation**: Build a directed graph from prerequisites.

2. **Cycle Detection**: Use DFS or Kahn's algorithm to detect cycles:
   - If there's a cycle, it's impossible to finish all courses
   - If no cycles, all courses can be completed

3. **Topological Sort**: Kahn's algorithm is particularly suitable here:
   - Calculate in-degree for each node
   - Process nodes with in-degree 0
   - If all nodes are processed, no cycle exists

## Solution Code

```go
func canFinish(numCourses int, prerequisites [][]int) bool {
    // Build graph and in-degree array
    graph := make([][]int, numCourses)
    inDegree := make([]int, numCourses)
    
    for _, prereq := range prerequisites {
        course, prereq := prereq[0], prereq[1]
        graph[prereq] = append(graph[prereq], course)
        inDegree[course]++
    }
    
    // Initialize queue with courses having in-degree 0
    queue := []int{}
    for i := 0; i < numCourses; i++ {
        if inDegree[i] == 0 {
            queue = append(queue, i)
        }
    }
    
    // Process courses in topological order
    processed := 0
    for len(queue) > 0 {
        course := queue[0]
        queue = queue[1:]
        processed++
        
        // Reduce in-degree for all neighbors
        for _, neighbor := range graph[course] {
            inDegree[neighbor]--
            if inDegree[neighbor] == 0 {
                queue = append(queue, neighbor)
            }
        }
    }
    
    return processed == numCourses
}
```

## Complexity Analysis

- **Time**: O(V + E) where V is the number of courses and E is the number of prerequisites
  - Building graph: O(E)
  - Topological sort: O(V + E)
- **Space**: O(V + E) for the graph and in-degree array

## Link

[LeetCode 0207 Course Schedule](https://leetcode.com/problems/course-schedule/)