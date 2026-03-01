# 1601 Maximum Number of Achievable Transfer Requests

## Problem Description

You are given `n` people labeled from `0` to `n-1` and a list of `requests` where `requests[i] = [from, to]` represents a transfer request.

A transfer request is achievable if it doesn't create a cycle in the transfer graph.

Return the maximum number of achievable transfer requests.

### Example 1:
```
Input: n = 3, requests = [[0,1],[2,0]]
Output: 2
```

### Example 2:
```
Input: n = 3, requests = [[0,1],[1,2],[2,0]]
Output: 3
```

## Approach

This problem can be solved using backtracking with cycle detection:

1. **Graph Representation**:
   - Track current transfer relationships
   - Use an array to represent the transfer graph

2. **Backtracking**:
   - Try each request in order
   - Check if adding the request creates a cycle
   - If no cycle, proceed with the request
   - Track the maximum number of successful requests

3. **Cycle Detection**:
   - Use Union Find or DFS to detect cycles
   - A cycle exists if we can reach back to a visited node

## Solution Code

```go
func maximumRequests(n int, requests [][]int) int {
    // Track current transfer relationships
    transfers := make([]int, n)
    for i := 0; i < n; i++ {
        transfers[i] = i
    }
    
    maxRequests := 0
    var backtrack func(index int)
    
    backtrack = func(index int) {
        if index == len(requests) {
            if index > maxRequests {
                maxRequests = index
            }
            return
        }
        
        // Try to fulfill current request
        from, to := requests[index][0], requests[index][1]
        originalTransfer := transfers[from]
        
        // Temporarily make the transfer
        transfers[from] = to
        
        // Check if this creates a cycle
        if hasCycle(transfers) {
            // Backtrack
            transfers[from] = originalTransfer
            return
        }
        
        // Proceed to next request
        backtrack(index + 1)
        
        // Backtrack
        transfers[from] = originalTransfer
    }
    
    backtrack(0)
    return maxRequests
}

func hasCycle(transfers []int) bool {
    visited := make([]bool, len(transfers))
    
    for i := 0; i < len(transfers); i++ {
        if visited[i] {
            continue
        }
        
        current := i
        for !visited[current] {
            visited[current] = true
            current = transfers[current]
            if current == i {
                return true // Cycle detected
            }
        }
    }
    
    return false
}
```

## Complexity Analysis

- **Time**: O(2^N * N) where N is the number of requests
  - For each request, we try to include or exclude it
  - Cycle detection: O(N) for each request
- **Space**: O(N) for the transfer array and visited array

## Link

[LeetCode 1601 Maximum Number of Achievable Transfer Requests](https://leetcode.com/problems/maximum-number-of-achievable-transfer-requests/)