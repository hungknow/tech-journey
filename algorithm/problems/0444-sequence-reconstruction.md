# 0444 Sequence Reconstruction

## Problem Description

You are given an integer array `nums` of length `n` where `1 <= n <= 10^4`. The array is a sequence of integers from `1` to `n` without duplicates.

You are also given a 2D array `sequences` where each `sequences[i]` is a subsequence of `nums`.

Return `true` if `nums` is the unique shortest possible supersequence that reconstructs all sequences in `sequences`, otherwise return `false`.

### Example 1:
```
Input: nums = [1,2,3], sequences = [[1,2],[1,3]]
Output: false
```

### Example 2:
```
Input: nums = [1,2,3], sequences = [[1,2],[1,3],[2,3]]
Output: true
```

## Approach

This problem can be solved using topological sorting and graph theory:

1. **Graph Construction**: Build a directed graph from sequences where each sequence represents edges.

2. **Topological Sort**: Use Kahn's algorithm to find a topological order.

3. **Uniqueness Check**: 
   - If there's more than one node with in-degree 0 at any point, there are multiple possible topological orders
   - If there's exactly one node with in-degree 0 at each step, the topological order is unique

4. **Validation**: Check if the resulting topological order matches the original `nums` array.

## Solution Code

```go
func sequenceReconstruction(nums []int, sequences [][]int) bool {
    n := len(nums)
    
    // Build graph and in-degree array
    graph := make([][]int, n+1)
    inDegree := make([]int, n+1)
    
    for _, seq := range sequences {
        for i := 0; i < len(seq)-1; i++ {
            from, to := seq[i], seq[i+1]
            graph[from] = append(graph[from], to)
            inDegree[to]++
        }
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
        if len(queue) > 1 {
            return false // Multiple nodes with in-degree 0 means multiple possible orders
        }
        
        node := queue[0]
        queue = queue[1:]
        order = append(order, node)
        
        // Reduce in-degree for all neighbors
        for _, neighbor := range graph[node] {
            inDegree[neighbor]--
            if inDegree[neighbor] == 0 {
                queue = append(queue, neighbor)
            }
        }
    }
    
    // Check if the order matches nums
    if len(order) != n {
        return false
    }
    
    for i, num := range order {
        if nums[i] != num {
            return false
        }
    }
    
    return true
}
```

## Complexity Analysis

- **Time**: O(n + m + k) where n is the length of nums, m is the total length of all sequences, and k is the average sequence length
  - Building graph: O(m)
  - Topological sort: O(n + m)
  - Validation: O(n)
- **Space**: O(n + m) for the graph, in-degree array, and order

## Link

[LeetCode 0444 Sequence Reconstruction](https://leetcode.com/problems/sequence-reconstruction/)