# 0210 Course Schedule II

## Problem Description

You are given `numCourses` courses labeled from `0` to `numCourses-1` and an array `prerequisites` where `prerequisites[i] = [ai, bi]` means you must take course `ai` before course `bi`.

Return a possible order to finish all courses. If there are multiple valid orders, return any of them. If it's impossible to finish all courses, return an empty array.

### Example 1:
```
Input: numCourses = 4, prerequisites = [[1,0],[2,0],[3,1],[3,2]]
Output: [0,1,2,3]
```

### Example 2:
```
Input: numCourses = 1, prerequisites = []
Output: [0]
```

## Approach

This problem can be solved using topological sorting:

1. **Graph Representation**: Build a directed graph from prerequisites.

2. **Topological Sort**: Use Kahn's algorithm:
   - Calculate in-degree for each node
   - Process nodes with in-degree 0
   - Add processed nodes to the result

3. **Cycle Detection**: If not all nodes are processed, there's a cycle, return empty array.

## Solution Code

```go
func findOrder(numCourses int, prerequisites [][]int) []int {
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
    result := []int{}
    for len(queue) > 0 {
        course := queue[0]
        queue = queue[1:]
        result = append(result, course)
        
        // Reduce in-degree for all neighbors
        for _, neighbor := range graph[course] {
            inDegree[neighbor]--
            if inDegree[neighbor] == 0 {
                queue = append(queue, neighbor)
            }
        }
    }
    
    // Check if all courses were processed
    if len(result) == numCourses {
        return result
    }
    
    return []int{}
}
```

## Complexity Analysis

- **Time**: O(V + E) where V is the number of courses and E is the number of prerequisites
  - Building graph: O(E)
  - Topological sort: O(V + E)
- **Space**: O(V + E) for the graph, in-degree array, and result

## Link

[LeetCode 0210 Course Schedule II](https://leetcode.com/problems/course-schedule-ii/)