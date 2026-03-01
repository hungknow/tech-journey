# 1136 Parallel Courses

## Problem Description

You are given an integer `n` representing the number of courses and a 2D array `relations` where `relations[i] = [prevCourse, nextCourse]` means you must take course `prevCourse` before course `nextCourse`.

The courses are labeled from `1` to `n`.

Return the minimum number of semesters needed to complete all courses. If it's impossible to complete all courses, return `-1`.

### Example 1:
```
Input: n = 3, relations = [[1,3],[2,3]]
Output: 2
Explanation: 
Semester 1: Take course 1 and 2
Semester 2: Take course 3
```

### Example 2:
```
Input: n = 3, relations = [[1,2],[2,3],[3,1]]
Output: -1
Explanation: There's a cycle in the graph: 1 -> 2 -> 3 -> 1
```

## Approach

This problem can be solved using topological sorting and dynamic programming:

1. **Graph Construction**: Build a directed graph from relations.

2. **Topological Sort**: Use Kahn's algorithm to find a topological order.

3. **Dynamic Programming**:
   - For each node, calculate the minimum semester needed
   - Use memoization to store results
   - The minimum semester for a course is 1 + max(minimum semester of all prerequisites)

4. **Cycle Detection**: If topological sort fails (not all nodes processed), return -1.

## Solution Code

```go
func minimumSemesters(n int, relations [][]int) int {
    // Build graph and in-degree array
    graph := make([][]int, n+1)
    inDegree := make([]int, n+1)
    
    for _, rel := range relations {
        prev, next := rel[0], rel[1]
        graph[prev] = append(graph[prev], next)
        inDegree[next]++
    }
    
    // Initialize queue with nodes having in-degree 0
    queue := []int{}
    for i := 1; i <= n; i++ {
        if inDegree[i] == 0 {
            queue = append(queue, i)
        }
    }
    
    // Process nodes in topological order
    order := []int{}
    for len(queue) > 0 {
        course := queue[0]
        queue = queue[1:]
        order = append(order, course)
        
        // Reduce in-degree for all neighbors
        for _, neighbor := range graph[course] {
            inDegree[neighbor]--
            if inDegree[neighbor] == 0 {
                queue = append(queue, neighbor)
            }
        }
    }
    
    // Check if there's a cycle
    if len(order) != n {
        return -1
    }
    
    // DP to find minimum semesters
    dp := make([]int, n+1)
    for i := 1; i <= n; i++ {
        dp[i] = 1 // At least 1 semester for each course
    }
    
    // Process in topological order
    for _, course := range order {
        maxSemester := 1
        for _, prereq := range graph[course] {
            maxSemester = max(maxSemester, dp[prereq]+1)
        }
        dp[course] = maxSemester
    }
    
    // Find the maximum semester needed
    result := 0
    for i := 1; i <= n; i++ {
        result = max(result, dp[i])
    }
    
    return result
}

func max(a, b int) int {
    if a > b {
        return a
    }
    return b
}
```

## Complexity Analysis

- **Time**: O(V + E + V) where V is the number of courses and E is the number of relations
  - Building graph: O(E)
  - Topological sort: O(V + E)
  - DP calculation: O(V + E)
- **Space**: O(V + E) for the graph, in-degree array, and DP array

## Link

[LeetCode 1136 Parallel Courses](https://leetcode.com/problems/parallel-courses/)