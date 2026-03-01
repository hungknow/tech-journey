# 2092 Find All People With Secret

## Problem Description

You are given `n` people labeled from `0` to `n-1` and an array `meetings` where `meetings[i] = [xi, yi]` means person `xi` and person `yi` met at a meeting.

A person has a secret if they have met someone who already has the secret.

Initially, person `firstPerson` knows the secret.

Return all people who know the secret after all meetings. The result can be in any order.

### Example 1:
```
Input: n = 6, meetings = [[1,2,5],[2,3,8],[1,5,10]], firstPerson = 1
Output: [0,1,2,3,5]
```

### Example 2:
```
Input: n = 4, meetings = [[3,1,3],[1,2,2],[0,3,1]], firstPerson = 3
Output: [0,1,3]
```

## Approach

This problem can be solved using Union Find with timestamp tracking:

1. **Sort Meetings by Time**: Sort meetings in chronological order.

2. **Union Find with Time Tracking**:
   - Use Union Find to track who knows the secret
   - For each person, track when they learned the secret

3. **Process Meetings**:
   - For each meeting, if one person knows the secret, the other learns it
   - Use Union Find to connect people who know the secret
   - Keep track of the earliest time each person learned the secret

## Solution Code

```go
func findAllPeople(n int, meetings [][]int, firstPerson int) []int {
    // Sort meetings by time
    sort.Slice(meetings, func(i, j int) bool {
        return meetings[i][2] < meetings[j][2]
    })
    
    parent := make([]int, n)
    secretTime := make([]int, n)
    
    // Initialize Union Find
    for i := range parent {
        parent[i] = i
        secretTime[i] = -1
    }
    
    secretTime[firstPerson] = 0
    
    var find func(x int) int
    find = func(x int) int {
        if parent[x] != x {
            origParent := parent[x]
            parent[x] = find(parent[x])
            secretTime[x] = max(secretTime[x], secretTime[origParent])
        }
        return parent[x]
    }
    
    union := func(x, y int, time int) {
        rootX, rootY := find(x), find(y)
        if rootX != rootY {
            parent[rootX] = rootY
        }
        
        // Update secret time for the root
        if secretTime[rootX] == -1 || time < secretTime[rootX] {
            secretTime[rootX] = time
        }
        if secretTime[rootY] == -1 || time < secretTime[rootY] {
            secretTime[rootY] = time
        }
    }
    
    // Process meetings
    for _, meeting := range meetings {
        x, y, time := meeting[0], meeting[1], meeting[2]
        
        rootX, rootY := find(x), find(y)
        
        if secretTime[rootX] != -1 && secretTime[rootY] == -1 {
            // Both don't know the secret, nothing happens
            continue
        } else if secretTime[rootX] != -1 {
            // X knows the secret, Y learns it
            union(x, y, time)
        } else if secretTime[rootY] != -1 {
            // Y knows the secret, X learns it
            union(y, x, time)
        }
    }
    
    // Collect all people who know the secret
    result := make([]int, 0)
    for i := 0; i < n; i++ {
        if find(i) == find(firstPerson) {
            result = append(result, i)
        }
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

- **Time**: O(m log m + mα(n)) where m is the number of meetings and n is the number of people
  - Sorting meetings: O(m log m)
  - Union Find operations: O(mα(n)) but practically O(m)
- **Space**: O(n) for the Union Find data structure and secret time array

## Link

[LeetCode 2092 Find All People With Secret](https://leetcode.com/problems/find-all-people-with-secret/)