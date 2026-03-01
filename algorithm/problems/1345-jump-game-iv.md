# 1345 Jump Game IV

## Problem Description

You are given an integer array `arr`. From index `i`, you can jump to:
- `i + 1` if within bounds
- `i - 1` if within bounds
- Any index `j` where `arr[i] == arr[j]` and `i != j`

Return the minimum number of steps to reach the last index. If it's impossible, return -1.

### Example 1:
```
Input: arr = [100,-23,-23,404,100,23,23,23,3,404]
Output: 3
```

### Example 2:
```
Input: arr = [7]
Output: 0
```

## Approach

This problem can be solved using BFS with optimization:

1. **BFS Traversal**:
   - Start BFS from index 0
   - For each index, generate all possible next indices
   - Track visited indices to avoid cycles

2. **Jump Generation**:
   - Adjacent jumps: i+1 and i-1
   - Same value jumps: all indices with the same value
   - Optimization: clear same value jumps after first use to avoid redundant processing

3. **Early Termination**: When we reach the last index, return the current step count

## Solution Code

```go
func minJumps(arr []int) int {
    n := len(arr)
    if n == 1 {
        return 0
    }
    
    // Build value to indices mapping
    valueToIndices := make(map[int][]int)
    for i, val := range arr {
        valueToIndices[val] = append(valueToIndices[val], i)
    }
    
    // BFS setup
    queue := []int{0}
    visited := make([]bool, n)
    visited[0] = true
    steps := 0
    
    for len(queue) > 0 {
        levelSize := len(queue)
        
        for i := 0; i < levelSize; i++ {
            current := queue[0]
            queue = queue[1:]
            
            // Check if we reached the last index
            if current == n-1 {
                return steps
            }
            
            // Generate adjacent jumps
            if current+1 < n && !visited[current+1] {
                visited[current+1] = true
                queue = append(queue, current+1)
            }
            
            if current-1 >= 0 && !visited[current-1] {
                visited[current-1] = true
                queue = append(queue, current-1)
            }
            
            // Generate same value jumps
            for _, nextIndex := range valueToIndices[arr[current]] {
                if !visited[nextIndex] {
                    visited[nextIndex] = true
                    queue = append(queue, nextIndex)
                }
            }
            
            // Optimization: clear same value jumps after first use
            delete(valueToIndices, arr[current])
        }
        
        steps++
    }
    
    return -1
}
```

## Complexity Analysis

- **Time**: O(n) on average, O(n^2) in the worst case where n is the length of the array
  - Each index is processed at most once
  - The optimization of clearing same value jumps prevents redundant processing
- **Space**: O(n) for the value mapping, visited array, and queue

## Link

[LeetCode 1345 Jump Game IV](https://leetcode.com/problems/jump-game-iv/)