# 2050 Parallel Courses III

## Problem Description

You are given an integer `n` representing the number of courses and a 2D array `relations` where `relations[i] = [prevCourse, nextCourse, time]` means you must take course `prevCourse` before course `nextCourse`, and it takes `time` months to complete the course.

The courses are labeled from `1` to `n`.

Return the minimum number of months needed to complete all courses. If it's impossible to complete all courses, return `-1`.

### Example 1:
```
Input: n = 3, relations = [[1,2,3],[2,3,3],[1,3,2]]
Output: 6
Explanation: 
Course 1: 2 months
Course 2: 3 months
Course 3: 1 month
Total: 6 months
```

### Example 2:
```
Input: n = 3, relations = [[1,2,5],[2,3,3],[1,3,2]]
Output: -1
Explanation: There's a cycle in the graph: 1 -> 2 -> 3 -> 1
```

## Approach

This problem can be solved using topological sorting with dynamic programming:

1. **Graph Construction**: Build a directed graph from relations with time weights.

2. **Topological Sort**: Use Kahn's algorithm to find a topological order.

3. **Dynamic Programming**:
   - For each node, calculate the minimum time needed
   - Use memoization to store results
   - The minimum time for a course is the maximum of all prerequisite times plus its own time

4. **Cycle Detection**: If topological sort fails (not all nodes processed), return -1.

## Solution Code

```go
func minimumTime(n int, relations [][]int) int {
    // Build graph and in-degree array
    graph := make([][]int, n+1)
    inDegree := make([]int, n+1)
    time := make([]int, n+1)
    
    for _, rel := range relations {
        prev, next, t := rel[0], rel[1], rel[2]
        graph[prev] = append(graph[prev], struct{next, t})
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
        for _, edge := range graph[course] {
            next := edge.next
            inDegree[next]--
            if inDegree[next] == 0 {
                queue = append(queue, next)
            }
        }
    }
    
    // Check if there's a cycle
    if len(order) != n {
        return -1
    }
    
    // DP to find minimum time
    dp := make([]int, n+1)
    for i := 1; i <= n; i++ {
        dp[i] = 0 // Initially 0 time for each course
    }
    
    // Process in topological order
    for _, course := range order {
        maxTime := 0
        for _, edge := range graph[course] {
            prereqTime := dp[edge.prev]
            if prereqTime+edge.time > maxTime {
                maxTime = prereqTime + edge.time
            }
        }
        dp[course] = maxTime
    }
    
    // Find the maximum time needed
    result := 0
    for i := 1; i <= n; i++ {
        if dp[i] > result {
            result = dp[i]
        }
    }
    
    return result
}
```

## Complexity Analysis

- **Time**: O(V + E + V) where V is the number of courses and E is the number of relations
  - Building graph: O(E)
  - Topological sort: O(V + E)
  - DP calculation: O(V + E)
- **Space**: O(V + E) for the graph, in-degree array, and DP array

## Link

[LeetCode 2050 Parallel Courses III](https://leetcode.com/problems/parallel-courses-iii/)