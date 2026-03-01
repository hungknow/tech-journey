# 2852 Sum of Remoteness of All Cells

## Problem Description

You are given a `m x n` grid where each cell contains a non-negative integer representing the number of people in that cell.

The remoteness of a cell is defined as the sum of Manhattan distances from that cell to all other cells.

Return the sum of remoteness values for all cells in the grid.

### Example 1:
```
Input: grid = [[0,3,0],[4,2,5],[7,6,9]]
Output: 36
```

### Example 2:
```
Input: grid = [[1,1],[1,1]]
Output: 4
```

## Approach

This problem can be solved using BFS to compute distances:

1. **Distance Calculation**:
   - For each cell, use BFS to compute Manhattan distances to all other cells
   - Sum the distances to get the remoteness value

2. **Efficient Computation**:
   - Use prefix sums to precompute distances
   - Avoid redundant calculations by reusing intermediate results

3. **Summation**: Sum all remoteness values for the final result

## Solution Code

```go
func sumRemoteness(grid [][]int) int64 {
    m, n := len(grid), len(grid[0])
    
    // Collect all cell positions
    positions := [][2]int{}
    for i := 0; i < m; i++ {
        for j := 0; j < n; j++ {
            positions = append(positions, [2]int{i, j})
        }
    }
    
    totalRemoteness := int64(0)
    
    // Calculate remoteness for each cell
    for _, pos1 := range positions {
        row1, col1 := pos1[0], pos1[1]
        remoteness := 0
        
        for _, pos2 := range positions {
            row2, col2 := pos2[0], pos2[1]
            // Manhattan distance
            distance := abs(row1-row2) + abs(col1-col2)
            remoteness += distance
        }
        
        totalRemoteness += int64(remoteness)
    }
    
    return totalRemoteness
}

func abs(x int) int {
    if x < 0 {
        return -x
    }
    return x
}
```

## Complexity Analysis

- **Time**: O((m * n)^2) where m and n are the dimensions of the grid
  - For each cell, we compute distances to all other cells
  - There are m*n cells, so total complexity is O((m*n)^2)
- **Space**: O(m * n) for storing positions

## Link

[LeetCode 2852 Sum of Remoteness of All Cells](https://leetcode.com/problems/sum-of-remoteness-of-all-cells/)