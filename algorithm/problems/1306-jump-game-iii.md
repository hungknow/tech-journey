# 1306 Jump Game III

## Problem Description

You are given an integer array `arr` and a starting index `start`.

From index `i`, you can jump to:
- `i + arr[i]` if `i + arr[i]` is within bounds
- `i - arr[i]` if `i - arr[i]` is within bounds

Return `true` if you can reach any index with value 0, otherwise return `false`.

### Example 1:
```
Input: arr = [4,2,3,0,3,1,2], start = 5
Output: true
```

### Example 2:
```
Input: arr = [3,0,2,1,2], start = 2
Output: false
```

## Approach

This problem can be solved using BFS to explore reachable indices:

1. **BFS Traversal**:
   - Start BFS from the given start index
   - For each index, generate next indices by jumping forward and backward
   - Track visited indices to avoid cycles

2. **Jump Generation**:
   - Calculate forward jump: current + arr[current]
   - Calculate backward jump: current - arr[current]
   - Only add valid jumps within bounds

3. **Early Termination**: When we reach an index with value 0, return true

## Solution Code

```go
func canReach(arr []int, start int) bool {
    n := len(arr)
    if n == 0 {
        return false
    }
    
    // Check if start is already a zero
    if arr[start] == 0 {
        return true
    }
    
    // BFS setup
    queue := []int{start}
    visited := make([]bool, n)
    visited[start] = true
    
    for len(queue) > 0 {
        current := queue[0]
        queue = queue[1:]
        
        // Check if current is zero
        if arr[current] == 0 {
            return true
        }
        
        // Generate forward jump
        forward := current + arr[current]
        if forward >= 0 && forward < n && !visited[forward] {
            visited[forward] = true
            queue = append(queue, forward)
        }
        
        // Generate backward jump
        backward := current - arr[current]
        if backward >= 0 && backward < n && !visited[backward] {
            visited[backward] = true
            queue = append(queue, backward)
        }
    }
    
    return false
}
```

## Complexity Analysis

- **Time**: O(n) where n is the length of the array
  - Each index is processed at most once
  - For each index, we generate at most 2 next indices
- **Space**: O(n) for the visited array and queue

## Link

[LeetCode 1306 Jump Game III](https://leetcode.com/problems/jump-game-iii/)