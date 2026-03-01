# 0675 Cut Off Trees for Golf Event

## Problem Description

You are given a 2D grid representing a forest. Each cell contains:
- `0` represents an obstacle
- `1` represents a tree with height 1
- `2` represents a tree with height 2
- ...

You need to cut all trees in order of their height, starting from the smallest height to the largest height.

You start at position `(0, 0)` and can move in four directions (up, down, left, right). Each move takes 1 step.

Return the minimum total number of steps to cut all trees. If it's impossible to cut all trees, return -1.

### Example 1:
```
Input: forest = [[1,2,3],[0,0,4],[7,6,5]]
Output: 6
```

### Example 2:
```
Input: forest = [[1,2,3],[0,0,0],[7,6,5]]
Output: -1
```

## Approach

This problem can be solved using BFS to find shortest paths between trees:

1. **Tree Collection**:
   - Collect all trees with their positions and heights
   - Sort trees by height in ascending order

2. **Sequential BFS**:
   - For each consecutive pair of trees, use BFS to find the shortest path
   - Start from current position, find shortest path to next tree
   - Accumulate the total steps

3. **Path Validation**: If any tree is unreachable, return -1

## Solution Code

```go
func cutOffTree(forest [][]int) int {
    if len(forest) == 0 || len(forest[0]) == 0 {
        return -1
    }
    
    m, n := len(forest), len(forest[0])
    
    // Collect all trees with their positions and heights
    trees := [][3]int{}
    for i := 0; i < m; i++ {
        for j := 0; j < n; j++ {
            if forest[i][j] > 1 {
                trees = append(trees, [3]int{forest[i][j], i, j})
            }
        }
    }
    
    // Sort trees by height
    sort.Slice(trees, func(i, j int) bool {
        return trees[i][0] < trees[j][0]
    })
    
    totalSteps := 0
    currentRow, currentCol := 0, 0
    
    // Process trees in order
    for _, tree := range trees {
        targetRow, targetCol := tree[1], tree[2]
        
        // Find shortest path from current position to tree
        steps := bfs(forest, currentRow, currentCol, targetRow, targetCol)
        
        if steps == -1 {
            return -1
        }
        
        totalSteps += steps
        currentRow, currentCol = targetRow, targetCol
    }
    
    return totalSteps
}

func bfs(forest [][]int, startRow, startCol, targetRow, targetCol int) int {
    if startRow == targetRow && startCol == targetCol {
        return 0
    }
    
    m, n := len(forest), len(forest[0])
    
    // Directions: up, down, left, right
    dirs := [][2]int{{-1, 0}, {1, 0}, {0, -1}, {0, 1}}
    
    // BFS setup
    queue := [][2]int{{startRow, startCol}}
    visited := make([][]bool, m)
    for i := 0; i < m; i++ {
        visited[i] = make([]bool, n)
    }
    visited[startRow][startCol] = true
    
    steps := 0
    
    for len(queue) > 0 {
        levelSize := len(queue)
        steps++
        
        for i := 0; i < levelSize; i++ {
            current := queue[0]
            queue = queue[1:]
            
            for _, dir := range dirs {
                newRow, newCol := current[0]+dir[0], current[1]+dir[1]
                
                // Check bounds and if cell is valid
                if newRow >= 0 && newRow < m && newCol >= 0 && newCol < n && 
                   forest[newRow][newCol] != 0 && !visited[newRow][newCol] {
                    
                    if newRow == targetRow && newCol == targetCol {
                        return steps
                    }
                    
                    visited[newRow][newCol] = true
                    queue = append(queue, [2]int{newRow, newCol})
                }
            }
        }
    }
    
    return -1
}
```

## Complexity Analysis

- **Time**: O(t * m * n) where t is the number of trees, m and n are the dimensions of the forest
  - For each tree, we perform BFS which takes O(m * n)
  - Sorting trees takes O(t log t)
- **Space**: O(m * n) for the visited array and queue

## Link

[LeetCode 0675 Cut Off Trees for Golf Event](https://leetcode.com/problems/cut-off-trees-for-golf-event/)