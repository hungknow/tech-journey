# 1036 Escape a Large Maze

## Problem Description

There is a 1 million by 1 million grid with an additional obstacle around the border. The grid is indexed from `(0, 0)` to `(10^6 - 1, 10^6 - 1)`.

You are given an array `blocked` where `blocked[i] = [xi, yi]` represents a blocked cell. It is guaranteed that the blocked cells are distinct and none of them are at the starting point `(source[0], source[1])` or the target point `(target[0], target[1])`.

Return `true` if you can walk from the source to the target, otherwise return `false`.

### Example 1:
```
Input: blocked = [[0,1],[1,0]], source = [0,0], target = [0,2]
Output: false
```

### Example 2:
```
Input: blocked = [], source = [0,0], target = [999999,999999]
Output: true
```

## Approach

This problem can be solved using BFS with early termination based on area constraints:

1. **Key Insight**:
   - If there are no blocked cells, the answer is always true
   - With blocked cells, we can only be trapped if the blocked cells form a closed area
   - The maximum area that can be enclosed by `len(blocked)` cells is `len(blocked) * (len(blocked) - 1) / 2`

2. **BFS with Area Limit**:
   - Perform BFS from both source and target simultaneously
   - If either BFS explores more than the maximum enclosed area, escape is possible
   - If both BFS are limited to small areas, they're trapped

3. **Early Termination**: Stop BFS when we either reach the other point or exceed the area limit

## Solution Code

```go
func isEscapePossible(blocked [][]int, source []int, target []int) bool {
    if len(blocked) == 0 {
        return true
    }
    
    // Convert blocked to set for O(1) lookup
    blockedSet := make(map[[2]int]bool)
    for _, cell := range blocked {
        blockedSet[[2]int{cell[0], cell[1]}] = true
    }
    
    // Maximum area that can be enclosed by n blocked cells
    maxArea := len(blocked) * (len(blocked) - 1) / 2
    
    // Check if source can reach target or escape the enclosed area
    sourceCanEscape := bfs(blockedSet, source, target, maxArea)
    if sourceCanEscape == 1 {
        return true
    }
    
    // Check if target can reach source or escape the enclosed area
    targetCanEscape := bfs(blockedSet, target, source, maxArea)
    if targetCanEscape == 1 {
        return true
    }
    
    // If both are trapped, check if they're in the same area
    return sourceCanEscape == 2 && targetCanEscape == 2
}

func bfs(blockedSet map[[2]int]bool, source []int, target []int, maxArea int) int {
    // Directions: up, down, left, right
    dirs := [][2]int{{-1, 0}, {1, 0}, {0, -1}, {0, 1}}
    
    queue := [][2]int{{source[0], source[1]}}
    visited := make(map[[2]int]bool)
    visited[[2]int{source[0], source[1]}] = true
    explored := 0
    
    for len(queue) > 0 && explored <= maxArea {
        levelSize := len(queue)
        
        for i := 0; i < levelSize; i++ {
            current := queue[0]
            queue = queue[1:]
            explored++
            
            // Check if we reached the target
            if current[0] == target[0] && current[1] == target[1] {
                return 1 // Can reach target
            }
            
            for _, dir := range dirs {
                newRow, newCol := current[0]+dir[0], current[1]+dir[1]
                
                // Check bounds and if cell is not blocked and not visited
                if newRow >= 0 && newRow < 1000000 && newCol >= 0 && newCol < 1000000 &&
                   !blockedSet[[2]int{newRow, newCol}] && !visited[[2]int{newRow, newCol}] {
                    visited[[2]int{newRow, newCol}] = true
                    queue = append(queue, [2]int{newRow, newCol})
                }
            }
        }
    }
    
    if explored > maxArea {
        return 1 // Escaped the enclosed area
    }
    return 2 // Trapped in enclosed area
}
```

## Complexity Analysis

- **Time**: O(min(maxArea, n^2)) where maxArea is the maximum enclosed area and n is the grid size
  - In practice, this is O(maxArea) since we stop early
  - maxArea = len(blocked) * (len(blocked) - 1) / 2
- **Space**: O(maxArea) for the visited set and queue

## Link

[LeetCode 1036 Escape a Large Maze](https://leetcode.com/problems/escape-a-large-maze/)