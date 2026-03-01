# 2850 Minimum Moves to Spread Stones Over Grid

## Problem Description

You are given a 3 x 3 grid where each cell contains 0 to 8 stones.

In one move, you can move a stone from any cell to any adjacent cell (horizontally or vertically).

Return the minimum number of moves required to make all cells contain exactly one stone.

### Example 1:
```
Input: grid = [[1,1,0],[1,1,1],[1,2,1]]
Output: 3
```

### Example 2:
```
Input: grid = [[1,3,0],[1,0,0],[1,0,1]]
Output: 4
```

## Approach

This problem can be solved using Hungarian algorithm for minimum weight matching:

1. **Problem Analysis**:
   - We need to move stones from cells with excess to cells with deficit
   - Each stone move has a cost (Manhattan distance)
   - This is a minimum cost bipartite matching problem

2. **Bipartite Matching**:
   - Left side: cells with excess stones
   - Right side: cells that need stones
   - Edge weight: Manhattan distance between cells

3. **Hungarian Algorithm**:
   - Find minimum weight perfect matching
   - Each excess cell matched to exactly one deficit cell
   - Minimize total movement cost

4. **Cost Calculation**:
   - For each matching, calculate total Manhattan distance
   - This represents the minimum number of moves
   - Ensure all stones are redistributed

## Solution Code

```go
func minimumMoves(grid [][]int) int {
    // Count stones and find cells with excess/deficit
    totalStones := 0
    excess := []int{}
    deficit := []int{}
    
    for i := 0; i < 3; i++ {
        for j := 0; j < 3; j++ {
            totalStones += grid[i][j]
        }
    }
    
    targetPerCell := totalStones / 9
    
    for i := 0; i < 3; i++ {
        for j := 0; j < 3; j++ {
            diff := grid[i][j] - targetPerCell
            if diff > 0 {
                // Add this cell to excess side multiple times
                for k := 0; k < diff; k++ {
                    excess = append(excess, i*3+j)
                }
            } else if diff < 0 {
                // Add this cell to deficit side multiple times
                for k := 0; k < -diff; k++ {
                    deficit = append(deficit, i*3+j)
                }
            }
        }
    }
    
    // Build cost matrix
    m := len(excess)
    n := len(deficit)
    cost := make([][]int, m)
    for i := 0; i < m; i++ {
        cost[i] = make([]int, n)
        for j := 0; j < n; j++ {
            fromCell := excess[i]
            toCell := deficit[j]
            fromRow, fromCol := fromCell/3, fromCell%3
            toRow, toCol := toCell/3, toCell%3
            cost[i][j] = abs(fromRow-toRow) + abs(fromCol-toCol)
        }
    }
    
    // Hungarian algorithm for minimum weight matching
    return hungarian(cost)
}

func hungarian(cost [][]int) int {
    m := len(cost)
    n := len(cost[0])
    
    // Ensure square matrix by padding
    size := max(m, n)
    matrix := make([][]int, size)
    for i := 0; i < size; i++ {
        matrix[i] = make([]int, size)
        for j := 0; j < size; j++ {
            if i < m && j < n {
                matrix[i][j] = cost[i][j]
            } else {
                matrix[i][j] = 0
            }
        }
    }
    
    // Hungarian algorithm implementation
    u := make([]int, size+1)
    v := make([]int, size+1)
    p := make([]int, size+1)
    way := make([]int, size+1)
    
    for i := 1; i <= size; i++ {
        p[0] = i
        j0 := 0
        minv := make([]int, size+1)
        used := make([]bool, size+1)
        
        for j := 1; j <= size; j++ {
            minv[j] = 1<<31 - 1
            used[j] = false
        }
        
        for {
            used[j0] = true
            i0 := p[j0]
            delta := 1<<31 - 1
            j1 := 0
            
            for j := 1; j <= size; j++ {
                if !used[j] {
                    cur := matrix[i0-1][j-1] - u[i0] - v[j]
                    if cur < minv[j] {
                        minv[j] = cur
                        way[j] = j0
                    }
                    if minv[j] < delta {
                        delta = minv[j]
                        j1 = j
                    }
                }
            }
            
            for j := 0; j <= size; j++ {
                if used[j] {
                    u[p[j]] += delta
                    v[j] -= delta
                }
            }
            
            j0 = j1
            if p[j0] == 0 {
                break
            }
        }
        
        for j := j0; j >= 1; j-- {
            j1 := way[j]
            p[j] = p[j1]
            j = j1
        }
    }
    
    // Calculate total cost
    totalCost := 0
    for j := 1; j <= size; j++ {
        if p[j] != 0 && p[j] <= m {
            totalCost += matrix[p[j]-1][j-1]
        }
    }
    
    return totalCost
}

func max(a, b int) int {
    if a > b {
        return a
    }
    return b
}

func abs(x int) int {
    if x < 0 {
        return -x
    }
    return x
}
```

## Complexity Analysis

- **Time**: O(N^3) where N is the number of cells (9 in this case)
  - Hungarian algorithm complexity
  - For 3x3 grid, this is constant time
- **Space**: O(N^2) for the cost matrix and algorithm arrays

## Link

[LeetCode 2850 Minimum Moves to Spread Stones Over Grid](https://leetcode.com/problems/minimum-moves-to-spread-stones-over-grid/)