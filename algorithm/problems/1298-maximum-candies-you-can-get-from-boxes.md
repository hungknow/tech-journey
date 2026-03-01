# 1298 Maximum Candies You Can Get from Boxes

## Problem Description

You have `n` boxes of candies, each containing some candies. You are given:
- `status[i]`: 0 if box i is closed, 1 if open
- `candies[i]`: number of candies in box i
- `keys[i]`: list of boxes you can open with keys from box i
- `containedBoxes[i]`: list of boxes contained in box i

You start with some boxes and can:
1. Take candies from any open box
2. Take all keys from any box you open
3. Open any box for which you have a key

Return the maximum number of candies you can get.

### Example 1:
```
Input: status = [1,0,1,0], candies = [7,5,4,100], keys = [[],[0],[1,2],[]], containedBoxes = [[1,2],[3],[],[]], initialBoxes = [0]
Output: 16
```

### Example 2:
```
Input: status = [1,0,0,0,0,0], candies = [1,1,1,1,1,1], keys = [[1,2,3,4,5],[],[],[],[],[]], containedBoxes = [[1,2,3,4,5],[],[],[],[],[]], initialBoxes = [0]
Output: 6
```

## Approach

This problem can be solved using BFS to explore boxes:

1. **BFS Exploration**:
   - Start with initial boxes
   - Process boxes to collect candies, keys, and contained boxes
   - Keep track of available keys and boxes

2. **State Management**:
   - Track which boxes we have
   - Track which keys we have
   - Track which boxes we've processed

3. **Iterative Processing**:
   - Continue processing as long as we can open new boxes
   - Use BFS to ensure we process all reachable boxes

## Solution Code

```go
func maxCandies(status []int, candies []int, keys [][]int, containedBoxes [][]int, initialBoxes []int) int {
    n := len(status)
    
    // Track available boxes and keys
    haveBoxes := make([]bool, n)
    haveKeys := make([]bool, n)
    visited := make([]bool, n)
    
    // Initialize with initial boxes
    queue := []int{}
    for _, box := range initialBoxes {
        haveBoxes[box] = true
        queue = append(queue, box)
    }
    
    totalCandies := 0
    changed := true
    
    // Keep processing while we can make progress
    for changed {
        changed = false
        queueSize := len(queue)
        
        for i := 0; i < queueSize; i++ {
            box := queue[0]
            queue = queue[1:]
            
            // Skip if already visited
            if visited[box] {
                continue
            }
            
            // Check if we can open this box
            canOpen := status[box] == 1 || haveKeys[box]
            
            if canOpen {
                visited[box] = true
                changed = true
                
                // Collect candies
                totalCandies += candies[box]
                
                // Collect keys
                for _, key := range keys[box] {
                    haveKeys[key] = true
                    if haveBoxes[key] && !visited[key] {
                        queue = append(queue, key)
                    }
                }
                
                // Collect contained boxes
                for _, containedBox := range containedBoxes[box] {
                    haveBoxes[containedBox] = true
                    if !visited[containedBox] {
                        queue = append(queue, containedBox)
                    }
                }
            }
        }
    }
    
    return totalCandies
}
```

## Complexity Analysis

- **Time**: O(n^2) in the worst case where n is the number of boxes
  - Each box can be processed multiple times as we acquire new keys
  - In the worst case, we might process each box O(n) times
- **Space**: O(n) for tracking boxes, keys, and visited states

## Link

[LeetCode 1298 Maximum Candies You Can Get from Boxes](https://leetcode.com/problems/maximum-candies-you-can-get-from-boxes/)