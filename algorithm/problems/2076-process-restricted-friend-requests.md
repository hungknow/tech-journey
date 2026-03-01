# 2076 Process Restricted Friend Requests

## Problem Description

You are given `n` people labeled from `0` to `n-1` and an array `restrictions` where `restrictions[i] = [xi, yi]` means person `xi` and person `yi` cannot be friends.

You are also given `requests` where `requests[i] = [uj, vj]` represents a friend request from person `uj` to person `vj`.

Return `true` if all friend requests can be processed successfully while respecting the restrictions, otherwise return `false`.

### Example 1:
```
Input: n = 3, restrictions = [[0,1]], requests = [[0,2],[2,1]]
Output: true
```

### Example 2:
```
Input: n = 3, restrictions = [[0,1]], requests = [[1,2],[0,2]]
Output: false
```

## Approach

This problem can be solved using Union Find with conflict checking:

1. **Union Find Setup**: Use Union Find to track friend connections.

2. **Process Restrictions**: 
   - For each restriction, mark that the two people cannot be friends
   - We can store this information in a map or set

3. **Process Requests**:
   - For each request, check if it violates any restriction
   - If no violation, union the two people
   - If any request violates a restriction, return false

## Solution Code

```go
func friendRequests(n int, restrictions [][]int, requests [][]int) bool {
    parent := make([]int, n)
    
    // Initialize Union Find
    for i := range parent {
        parent[i] = i
    }
    
    var find func(x int) int
    find = func(x int) int {
        if parent[x] != x {
            parent[x] = find(parent[x])
        }
        return parent[x]
    }
    
    union := func(x, y int) bool {
        rootX, rootY := find(x), find(y)
        if rootX != rootY {
            parent[rootX] = rootY
            return true
        }
        return false
    }
    
    // Build a map of restricted pairs
    restricted := make(map[int]map[int]bool)
    for _, r := range restrictions {
        if restricted[r[0]] == nil {
            restricted[r[0]] = make(map[int]bool)
        }
        restricted[r[0]][r[1]] = true
        if restricted[r[1]] == nil {
            restricted[r[1]] = make(map[int]bool)
        }
        restricted[r[1]][r[0]] = true
    }
    
    // Process each request
    for _, req := range requests {
        u, v := req[0], req[1]
        
        // Check if this request violates any restriction
        violatesRestriction := false
        
        // Check if u is restricted from v's perspective
        if restricted[u] != nil && restricted[u][v] {
            violatesRestriction = true
        }
        
        // Check if v is restricted from u's perspective
        if restricted[v] != nil && restricted[v][u] {
            violatesRestriction = true
        }
        
        // Check if u is restricted from any of v's friends
        rootU := find(u)
        for friend := range restricted[rootU] {
            if restricted[rootU][friend] {
                violatesRestriction = true
                break
            }
        }
        
        // Check if v is restricted from any of u's friends
        rootV := find(v)
        for friend := range restricted[rootV] {
            if restricted[rootV][friend] {
                violatesRestriction = true
                break
            }
        }
        
        if violatesRestriction {
            return false
        }
        
        // If no restriction violated, make them friends
        if !union(u, v) {
            return false
        }
    }
    
    return true
}
```

## Complexity Analysis

- **Time**: O(n × r + q × n) where n is the number of people, r is the number of restrictions, and q is the number of requests
  - Building restriction map: O(r)
  - Processing requests: O(q × n) in worst case
- **Space**: O(n + r) for the Union Find data structure and restriction map

## Link

[LeetCode 2076 Process Restricted Friend Requests](https://leetcode.com/problems/process-restricted-friend-requests/)