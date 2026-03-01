# 1101 The Earliest Moment When Everyone Become Friends

## Problem Description

There are `n` people in a social network labeled from `0` to `n - 1`. You are given a list of logs where `logs[i] = [timestampi, xi, yi]` indicates that person `xi` and person `yi` become friends at time `timestampi`.

Friendship is transitive: if A is friends with B, and B is friends with C, then A is friends with C.

Return the earliest time when everyone in the social network becomes friends. If it's impossible for everyone to become friends, return `-1`.

### Example 1:
```
Input: logs = [[20190101,0,1],[20190104,3,4],[20190107,2,3],[20190224,1,5]], n = 6
Output: 20190224
Explanation: The earliest time when everyone becomes friends is 20190224.
```

### Example 2:
```
Input: logs = [[20190101,0,1],[20190104,3,4],[20190107,2,3],[20190224,1,5]], n = 5
Output: 20190107
Explanation: Everyone becomes friends at 20190107.
```

### Example 3:
```
Input: logs = [[0,2,3],[1,0,1]], n = 4
Output: -1
Explanation: Person 3 never becomes friends with anyone else.
```

## Approach

This problem can be solved using Union Find with timestamp sorting:

1. **Sort Logs by Timestamp**: Process logs in chronological order to find the earliest moment.

2. **Union Find Setup**: Use Union Find to track connected components of friends.

3. **Process Logs**:
   - For each log entry, union the two people
   - After each union, check if all people are in one component
   - If yes, return the current timestamp

4. **Early Termination**: Once all people are connected, we can stop processing further logs.

## Solution Code

```go
func earliestAcq(logs [][]int, n int) int {
    if n == 1 {
        return 0
    }
    
    // Sort logs by timestamp
    sort.Slice(logs, func(i, j int) bool {
        return logs[i][0] < logs[j][0]
    })
    
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
    
    union := func(x, y int) {
        rootX, rootY := find(x), find(y)
        if rootX != rootY {
            parent[rootX] = rootY
        }
    }
    
    // Count components
    components := n
    
    for _, log := range logs {
        timestamp, x, y := log[0], log[1], log[2]
        
        rootX, rootY := find(x), find(y)
        if rootX != rootY {
            union(x, y)
            components--
        }
        
        if components == 1 {
            return timestamp
        }
    }
    
    return -1
}
```

## Complexity Analysis

- **Time**: O(L log L + Lα(n)) where L is the number of logs and n is the number of people
  - Sorting logs: O(L log L)
  - Union Find operations: O(Lα(n)) but practically O(L)
- **Space**: O(n) for the Union Find data structure

## Link

[LeetCode 1101 The Earliest Moment When Everyone Become Friends](https://leetcode.com/problems/the-earliest-moment-when-everyone-become-friends/)