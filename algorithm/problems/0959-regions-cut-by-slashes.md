# 0959 Regions Cut By Slashes

## Problem Description

A 2D grid contains only characters `'/'`, `'\'`, or empty space `' '`. The grid is divided into regions by slashes. Each cell is divided into 4 triangles by the slashes.

Your task is to return the number of regions in the grid.

### Example 1:
```
Input: grid = [" /","/ "]
Output: 2
```

### Example 2:
```
Input: grid = ["//","/ "]
Output: 3
```

### Example 3:
```
Input: grid = ["\\/", "/\\"]
Output: 4
```

## Approach

This problem can be solved using Union Find by treating each cell as 4 smaller triangles:

1. **Cell Division**: Each cell is divided into 4 triangles:
   - Triangle 0: Top-left
   - Triangle 1: Top-right
   - Triangle 2: Bottom-right
   - Triangle 3: Bottom-left

2. **Union Rules**:
   - For empty space `' '`: All 4 triangles in the cell are connected
   - For `'/'`: Triangle 0 is connected to triangle 3, and triangle 1 is connected to triangle 2
   - For `'\'`: Triangle 0 is connected to triangle 1, and triangle 2 is connected to triangle 3
   - Adjacent cells: triangles that share a border are connected

3. **Region Counting**: After all unions are performed, the number of regions is the number of distinct sets.

## Solution Code

```go
func regionsBySlashes(grid []string) int {
    n := len(grid)
    if n == 0 {
        return 0
    }
    
    // Each cell is divided into 4 triangles
    totalTriangles := n * n * 4
    parent := make([]int, totalTriangles)
    
    // Initialize Union Find
    for i := range parent {
        parent[i] = i
    }
    
    var find func(x int) int
    find = func(x int) int {
        if parent[x] != x {
            parent[x] = find(parent[x])
        }
        return parent[x]
    }
    
    union := func(x, y int) {
        rootX, rootY := find(x), find(y)
        if rootX != rootY {
            parent[rootX] = rootY
        }
    }
    
    // Process each cell
    for i := 0; i < n; i++ {
        for j := 0; j < n; j++ {
            base := (i * n + j) * 4
            
            c := grid[i][j]
            
            if c == ' ' {
                // Connect all 4 triangles in empty space
                union(base + 0, base + 1)
                union(base + 1, base + 2)
                union(base + 2, base + 3)
            } else if c == '/' {
                // Connect 0-3 and 1-2
                union(base + 0, base + 3)
                union(base + 1, base + 2)
            } else if c == '\\' {
                // Connect 0-1 and 2-3
                union(base + 0, base + 1)
                union(base + 2, base + 3)
            }
            
            // Connect with adjacent cells
            // Connect with cell above (triangle 0 with triangle 2)
            if i > 0 {
                aboveBase := ((i-1) * n + j) * 4
                union(base + 0, aboveBase + 2)
            }
            
            // Connect with cell below (triangle 2 with triangle 0)
            if i < n-1 {
                belowBase := ((i+1) * n + j) * 4
                union(base + 2, belowBase + 0)
            }
            
            // Connect with cell to the left (triangle 3 with triangle 1)
            if j > 0 {
                leftBase := (i * n + (j-1)) * 4
                union(base + 3, leftBase + 1)
            }
            
            // Connect with cell to the right (triangle 1 with triangle 3)
            if j < n-1 {
                rightBase := (i * n + (j+1)) * 4
                union(base + 1, rightBase + 3)
            }
        }
    }
    
    // Count distinct regions
    regions := 0
    for i := 0; i < totalTriangles; i++ {
        if find(i) == i {
            regions++
        }
    }
    
    return regions
}
```

## Complexity Analysis

- **Time**: O(n²α(n)) where n is the grid size and α is the inverse Ackermann function
  - Processing each cell: O(n²)
  - Union Find operations: O(n²α(n)) but practically O(n²)
- **Space**: O(n²) for the Union Find data structure (4 triangles per cell)

## Link

[LeetCode 0959 Regions Cut By Slashes](https://leetcode.com/problems/regions-cut-by-slashes/)