# 1820 Maximum Number of Accepted Invitations

## Problem Description

You are given a bipartite graph represented by an `m x n` grid where `grid[i][j] = 1` indicates that boy `i` can invite girl `j`.

Each boy can invite at most one girl, and each girl can accept at most one invitation.

Return the maximum number of accepted invitations possible.

### Example 1:
```
Input: grid = [[1,1,1],[1,0,1],[0,0,1]]
Output: 3
```

### Example 2:
```
Input: grid = [[1,0,1,0],[1,0,0,0],[0,0,1,0]]
Output: 2
```

## Approach

This problem can be solved using maximum bipartite matching:

1. **Bipartite Graph**:
   - Boys are on one side, girls on the other
   - Edge exists if grid[i][j] = 1

2. **Maximum Matching**:
   - Use Hungarian algorithm or DFS-based augmenting path
   - Find maximum number of disjoint boy-girl pairs

3. **Augmenting Path**:
   - For each boy, try to find a girl
   - If girl is already matched, try to reassign her current boy

4. **Greedy Matching**:
   - Iterate through boys
   - For each boy, find an available girl through DFS

## Solution Code

```go
func maximumInvitations(grid [][]int) int {
    m, n := len(grid)
    if m == 0 || n == 0 {
        return 0
    }
    
    // girlToBoy maps girl to boy
    girlToBoy := make([]int, n)
    for i := 0; i < n; i++ {
        girlToBoy[i] = -1
    }
    
    var dfs func(boy int, visited []bool) bool
    dfs = func(boy int, visited []bool) bool {
        for girl := 0; girl < n; girl++ {
            if grid[boy][girl] == 1 && !visited[girl] {
                visited[girl] = true
                
                // If girl is not matched or we can reassign her current boy
                if girlToBoy[girl] == -1 || dfs(girlToBoy[girl], visited) {
                    girlToBoy[girl] = boy
                    return true
                }
            }
        }
        return false
    }
    
    result := 0
    for boy := 0; boy < m; boy++ {
        visited := make([]bool, n)
        if dfs(boy, visited) {
            result++
        }
    }
    
    return result
}
```

## Complexity Analysis

- **Time**: O(m * n * min(m, n)) where m is number of boys and n is number of girls
  - For each boy, we might explore all girls
  - In worst case, we might reassign multiple times
- **Space**: O(n) for the girlToBoy array and visited array

## Link

[LeetCode 1820 Maximum Number of Accepted Invitations](https://leetcode.com/problems/maximum-number-of-accepted-invitations/)