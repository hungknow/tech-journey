# 1284 Minimum Number of Flips to Convert Binary Matrix to Zero Matrix

## Problem Description

You are given a binary matrix `mat`. In one step, you can choose one cell and flip it and all its four neighbors (if they exist).

Return the minimum number of steps required to convert the matrix to a zero matrix. If it's impossible, return -1.

### Example 1:
```
Input: mat = [[0,0],[0,1]]
Output: 3
```

### Example 2:
```
Input: mat = [[0]]
Output: 0
```

## Approach

This problem can be solved using BFS to find the shortest sequence of flips:

1. **State Representation**:
   - Each state is the current matrix configuration
   - Convert matrix to a string for efficient hashing

2. **BFS Traversal**:
   - Start BFS from the initial matrix configuration
   - For each state, generate all possible next states by flipping each cell
   - Track visited states to avoid cycles

3. **Early Termination**: When we reach the zero matrix, return the current number of flips

## Solution Code

```go
func minFlips(mat [][]int) int {
    m, n := len(mat), len(mat[0])
    
    // Convert matrix to string representation
    start := matrixToString(mat)
    target := strings.Repeat("0", m*n)
    
    // Check if already zero matrix
    if start == target {
        return 0
    }
    
    // Directions: up, down, left, right, and current cell
    dirs := [][2]int{{-1, 0}, {1, 0}, {0, -1}, {0, 1}, {0, 0}}
    
    // BFS setup
    queue := []string{start}
    visited := make(map[string]bool)
    visited[start] = true
    flips := 0
    
    for len(queue) > 0 {
        levelSize := len(queue)
        
        for i := 0; i < levelSize; i++ {
            current := queue[0]
            queue = queue[1:]
            
            // Check if we reached target
            if current == target {
                return flips
            }
            
            // Try flipping each cell
            for row := 0; row < m; row++ {
                for col := 0; col < n; col++ {
                    // Create next state by flipping current cell and neighbors
                    next := stringToMatrix(current, m, n)
                    
                    for _, dir := range dirs {
                        newRow, newCol := row+dir[0], col+dir[1]
                        
                        if newRow >= 0 && newRow < m && newCol >= 0 && newCol < n {
                            next[newRow][newCol] ^= 1 // Flip bit
                        }
                    }
                    
                    nextStr := matrixToString(next)
                    
                    if !visited[nextStr] {
                        visited[nextStr] = true
                        queue = append(queue, nextStr)
                    }
                }
            }
        }
        
        flips++
    }
    
    return -1
}

func matrixToString(mat [][]int) string {
    var sb strings.Builder
    for i := 0; i < len(mat); i++ {
        for j := 0; j < len(mat[0]); j++ {
            sb.WriteByte(byte(mat[i][j] + '0'))
        }
    }
    return sb.String()
}

func stringToMatrix(s string, m, n int) [][]int {
    mat := make([][]int, m)
    for i := 0; i < m; i++ {
        mat[i] = make([]int, n)
        for j := 0; j < n; j++ {
            mat[i][j] = int(s[i*n+j] - '0')
        }
    }
    return mat
}
```

## Complexity Analysis

- **Time**: O(2^(m*n) * m * n) where m and n are the dimensions of the matrix
  - There are 2^(m*n) possible states
  - For each state, we generate m*n next states
- **Space**: O(2^(m*n)) for the visited set and queue

## Link

[LeetCode 1284 Minimum Number of Flips to Convert Binary Matrix to Zero Matrix](https://leetcode.com/problems/minimum-number-of-flips-to-convert-binary-matrix-to-zero-matrix/)