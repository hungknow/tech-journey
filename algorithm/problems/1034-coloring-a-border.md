# 1034 Coloring a Border

## Problem Description

You are given a 2D grid of size `m x n` representing a map of territories. Each cell in the grid has a color value.

You are also given a starting cell `(row, col)` and a new color `color`.

Color the border of the connected component that includes the starting cell with the new color. A border is defined as a cell that is either:
- On the boundary of the grid
- Adjacent to a cell with a different color

Return the updated grid after coloring the border.

### Example 1:
```
Input: grid = [[1,1],[1,2]], row = 0, col = 0, color = 3
Output: [[3,3],[3,2]]
```

### Example 2:
```
Input: grid = [[1,2,2],[2,3,2]]
row = 0, col = 1, color = 3
Output: [[1,3,3],[2,3,3]]
```

## Approach

This problem can be solved using BFS to find the connected component and identify border cells:

1. **BFS Traversal**:
   - Start BFS from the given cell
   - Find all cells in the connected component with the same original color
   - Track visited cells to avoid cycles

2. **Border Identification**:
   - For each cell in the component, check if it's a border cell
   - A cell is a border if:
     - It's on the grid boundary
     - It has at least one adjacent cell with a different color

3. **Coloring**: Color all identified border cells with the new color

## Solution Code

```go
func colorBorder(grid [][]int, row int, col int, color int) [][]int {
    if len(grid) == 0 || len(grid[0]) == 0 {
        return grid
    }
    
    m, n := len(grid), len(grid[0])
    originalColor := grid[row][col]
    
    // Directions: up, down, left, right
    dirs := [][2]int{{-1, 0}, {1, 0}, {0, -1}, {0, 1}}
    
    // BFS to find the connected component
    queue := [][2]int{{row, col}}
    visited := make(map[[2]int]bool)
    visited[[2]int{row, col}] = true
    
    // Store all cells in the component
    component := [][2]int{{row, col}}
    
    for len(queue) > 0 {
        current := queue[0]
        queue = queue[1:]
        
        for _, dir := range dirs {
            newRow, newCol := current[0]+dir[0], current[1]+dir[1]
            
            if newRow >= 0 && newRow < m && newCol >= 0 && newCol < n &&
               grid[newRow][newCol] == originalColor && !visited[[2]int{newRow, newCol}] {
                visited[[2]int{newRow, newCol}] = true
                queue = append(queue, [2]int{newRow, newCol})
                component = append(component, [2]int{newRow, newCol})
            }
        }
    }
    
    // Identify and color border cells
    borderCells := make(map[[2]int]bool)
    
    for _, cell := range component {
        r, c := cell[0], cell[1]
        isBorder := false
        
        // Check if cell is on grid boundary
        if r == 0 || r == m-1 || c == 0 || c == n-1 {
            isBorder = true
        }
        
        // Check adjacent cells
        for _, dir := range dirs {
            newRow, newCol := r+dir[0], c+dir[1]
            
            if newRow >= 0 && newRow < m && newCol >= 0 && newCol < n &&
               grid[newRow][newCol] != originalColor {
                isBorder = true
                break
            }
        }
        
        if isBorder {
            borderCells[[2]int{r, c}] = true
        }
    }
    
    // Color the border cells
    for cell := range borderCells {
        r, c := cell[0], cell[1]
        grid[r][c] = color
    }
    
    return grid
}
```

## Complexity Analysis

- **Time**: O(m * n) where m and n are the dimensions of the grid
  - BFS traversal: O(m * n) in the worst case
  - Border identification: O(m * n)
- **Space**: O(m * n) for the visited set and component storage

## Link

[LeetCode 1034 Coloring a Border](https://leetcode.com/problems/coloring-a-border/)