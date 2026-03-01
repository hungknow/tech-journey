# 1817 Finding the User Active Minimum

## Problem Description

You are given a `n x n` matrix where `logs[i][j]` represents the time when user `i` performed action `j`.

The user is considered active at time `t` if they have performed an action within the past `timeWindow` minutes.

Return the earliest time when the user is active, or -1 if the user is never active.

### Example 1:
```
Input: logs = [[0,1],[1,2],[2,0],[3,1]], timeWindow = 2
Output: 0
```

### Example 2:
```
Input: logs = [[0,1],[1,2],[2,0],[3,1]], timeWindow = 0
Output: 1
```

## Approach

This problem can be solved using sliding window technique:

1. **Sliding Window**:
   - Use a sliding window to track recent actions
   - For each time, check if user is active

2. **Activity Tracking**:
   - For each user, track their last action time
   - A user is active if current time - lastActionTime ≤ timeWindow

3. **Early Termination**:
   - Find the earliest time when any user is active
   - Return -1 if no user is ever active

## Solution Code

```go
func findingUsersActiveMinutes(logs [][]int, timeWindow int) int {
    if len(logs) == 0 {
        return -1
    }
    
    // Track last action time for each user
    lastActionTime := make([]int, len(logs))
    
    // Check each time from 0 to max time
    for t := 0; t <= timeWindow; t++ {
        anyUserActive := false
        
        for _, log := range logs {
            user, actionTime := log[0], log[1]
            if t-actionTime <= timeWindow {
                anyUserActive = true
            }
        }
        
        if anyUserActive {
            return t
        }
    }
    
    return -1
}
```

## Complexity Analysis

- **Time**: O(T * U * W) where T is the maximum time and U is the number of users
  - For each time, we check all users
- **Space**: O(U) for tracking last action times

## Link

[LeetCode 1817 Finding the User Active Minimum](https://leetcode.com/problems/finding-the-user-active-minimum/)