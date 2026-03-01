# 2709 Greatest Common Divisor Traversal

## Problem Description

You are given an integer `n` and an array `nums` containing integers from `2` to `n`.

You start at `1` and can move to `x` if `gcd(current, x) > 1`.

Return `true` if you can reach `n`, otherwise return `false`.

### Example 1:
```
Input: n = 6, nums = [2,3,4,5,6]
Output: true
```

### Example 2:
```
Input: n = 4, nums = [2,3]
Output: false
```

## Approach

This problem can be solved using BFS with GCD checking:

1. **BFS Traversal**:
   - Start BFS from node 1
   - For each current node, find all reachable next nodes
   - A node x is reachable from current if gcd(current, x) > 1

2. **GCD Calculation**:
   - Use Euclidean algorithm to compute GCD
   - Check if GCD > 1 before adding to queue

3. **Early Termination**: When we reach node n, return true

## Solution Code

```go
func canTraverseAllPairs(n int, nums []int) bool {
    // Build adjacency list based on GCD condition
    graph := make([][]int, n+1)
    
    for i := 1; i <= n; i++ {
        for j := 1; j <= n; j++ {
            if i != j && gcd(i, j) > 1 {
                graph[i] = append(graph[i], j)
            }
        }
    }
    
    // BFS from node 1
    queue := []int{1}
    visited := make([]bool, n+1)
    visited[1] = true
    
    for len(queue) > 0 {
        current := queue[0]
        queue = queue[1:]
        
        if current == n {
            return true
        }
        
        for _, neighbor := range graph[current] {
            if !visited[neighbor] {
                visited[neighbor] = true
                queue = append(queue, neighbor)
            }
        }
    }
    
    return false
}

func gcd(a, b int) int {
    for b != 0 {
        a, b = b, a%b
    }
    return a
}
```

## Complexity Analysis

- **Time**: O(n^2 * log(max(nums))) where n is the maximum value
  - Building the graph: O(n^2) with GCD calculation
  - BFS traversal: O(n^2) in the worst case
  - GCD calculation: O(log(max(nums)))
- **Space**: O(n^2) for the graph and visited array

## Link

[LeetCode 2709 Greatest Common Divisor Traversal](https://leetcode.com/problems/greatest-common-divisor-traversal/)