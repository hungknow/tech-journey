# 0752 Open the Lock

## Problem Description

You have a lock with 4 circular wheels, each wheel has 10 slots (0-9). The wheels can rotate freely and wrap around.

Each move consists of turning one wheel one slot. The lock initially starts at "0000".

The lock has a list of deadends, meaning if the lock ever displays one of these codes, the wheels will stop turning and you can't open the lock.

You are also given a target representing the code that will open the lock.

Return the minimum total number of turns required to open the lock, or -1 if it's impossible.

### Example 1:
```
Input: deadends = ["0201","0101","0102","1212","2002"], target = "0202"
Output: 6
```

### Example 2:
```
Input: deadends = ["8888"], target = "0009"
Output: 1
```

## Approach

This problem can be solved using BFS to find the shortest path in the state space:

1. **State Space**:
   - Each state is a 4-digit combination
   - From each state, we can move to 8 adjacent states (turn each wheel forward or backward)

2. **BFS Traversal**:
   - Start BFS from "0000"
   - Avoid deadends and visited states
   - For each state, generate all possible next states

3. **Early Termination**: When we reach the target, return the current distance

## Solution Code

```go
func openLock(deadends []string, target string) int {
    // Convert deadends to a set for O(1) lookup
    deadSet := make(map[string]bool)
    for _, deadend := range deadends {
        deadSet[deadend] = true
    }
    
    // Check if start is a deadend
    if deadSet["0000"] {
        return -1
    }
    
    // Check if we're already at the target
    if target == "0000" {
        return 0
    }
    
    // BFS setup
    queue := []string{"0000"}
    visited := make(map[string]bool)
    visited["0000"] = true
    moves := 0
    
    for len(queue) > 0 {
        levelSize := len(queue)
        
        for i := 0; i < levelSize; i++ {
            current := queue[0]
            queue = queue[1:]
            
            // Check if we reached the target
            if current == target {
                return moves
            }
            
            // Generate all possible next states
            for j := 0; j < 4; j++ {
                // Turn wheel forward
                forward := current[:j] + string((current[j]-'0'+1)%10 + '0') + current[j+1:]
                
                if !deadSet[forward] && !visited[forward] {
                    visited[forward] = true
                    queue = append(queue, forward)
                }
                
                // Turn wheel backward
                backward := current[:j] + string((current[j]-'0'-1+10)%10 + '0') + current[j+1:]
                
                if !deadSet[backward] && !visited[backward] {
                    visited[backward] = true
                    queue = append(queue, backward)
                }
            }
        }
        
        moves++
    }
    
    return -1
}
```

## Complexity Analysis

- **Time**: O(N * 4) where N is the total number of possible states (10^4 = 10000)
  - Each state is processed at most once
  - For each state, we generate 8 possible next states
- **Space**: O(N) for the visited set and queue

## Link

[LeetCode 0752 Open the Lock](https://leetcode.com/problems/open-the-lock/)