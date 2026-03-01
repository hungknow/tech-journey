# 2392 Build a Matrix With Conditions

## Problem Description

You are given a positive integer `k` and two 2D arrays `rowConditions` and `colConditions`.

The first array `rowConditions` represents conditions that must be satisfied between rows, where `rowConditions[i] = [abovei, belowi]` means row `abovei` must appear above row `belowi` in the final matrix.

The second array `colConditions` represents conditions that must be satisfied between columns, where `colConditions[i] = [lefti, righti]` means column `lefti` must appear to the left of column `righti` in the final matrix.

The matrix should contain numbers from 1 to k, with each number appearing exactly once.

Return the k x k matrix that satisfies all conditions. If no such matrix exists, return an empty array.

### Example 1:
```
Input: k = 3, rowConditions = [[1,2],[3,2]], colConditions = [[2,1],[3,2]]
Output: [[3,0,0],[0,1,0],[0,2,0]]
```

### Example 2:
```
Input: k = 3, rowConditions = [[1,2],[2,3],[3,1]], colConditions = [[1,2],[2,3]]
Output: []
```

## Approach

This problem can be solved using topological sorting:

1. **Topological Sorting**:
   - Use topological sort to determine row order from rowConditions
   - Use topological sort to determine column order from colConditions
   - Check for cycles (no valid matrix if cycles exist)

2. **Graph Construction**:
   - Build directed graph for row conditions
   - Build directed graph for column conditions
   - Track in-degrees for both graphs

3. **Matrix Construction**:
   - Place numbers according to topological order
   - Row number determines row position
   - Column number determines column position

4. **Validation**:
   - Check if topological sort is possible (no cycles)
   - Ensure all numbers from 1 to k are placed
   - Return empty matrix if impossible

## Solution Code

```go
func buildMatrix(k int, rowConditions [][]int, colConditions [][]int) [][]int {
    // Topological sort for rows
    rowOrder := topologicalSort(k, rowConditions)
    if len(rowOrder) == 0 {
        return [][]int{}
    }
    
    // Topological sort for columns
    colOrder := topologicalSort(k, colConditions)
    if len(colOrder) == 0 {
        return [][]int{}
    }
    
    // Create position mappings
    rowPos := make([]int, k+1)
    colPos := make([]int, k+1)
    
    for i, num := range rowOrder {
        rowPos[num] = i
    }
    
    for i, num := range colOrder {
        colPos[num] = i
    }
    
    // Build the matrix
    matrix := make([][]int, k)
    for i := 0; i < k; i++ {
        matrix[i] = make([]int, k)
    }
    
    for num := 1; num <= k; num++ {
        matrix[rowPos[num]][colPos[num]] = num
    }
    
    return matrix
}

func topologicalSort(k int, conditions [][]int) []int {
    // Build graph
    graph := make([][]int, k+1)
    inDegree := make([]int, k+1)
    
    for _, condition := range conditions {
        from, to := condition[0], condition[1]
        graph[from] = append(graph[from], to)
        inDegree[to]++
    }
    
    // Kahn's algorithm
    queue := []int{}
    for i := 1; i <= k; i++ {
        if inDegree[i] == 0 {
            queue = append(queue, i)
        }
    }
    
    result := []int{}
    
    for len(queue) > 0 {
        current := queue[0]
        queue = queue[1:]
        result = append(result, current)
        
        for _, neighbor := range graph[current] {
            inDegree[neighbor]--
            if inDegree[neighbor] == 0 {
                queue = append(queue, neighbor)
            }
        }
    }
    
    // Check if all nodes are processed
    if len(result) != k {
        return []int{}
    }
    
    return result
}
```

## Complexity Analysis

- **Time**: O(k^2 + r + c) where k is the matrix size, r is row conditions, c is column conditions
  - Building graphs: O(r + c)
  - Topological sorts: O(k^2) in worst case
  - Matrix construction: O(k^2)
- **Space**: O(k^2 + r + c) for the graphs and matrix

## Link

[LeetCode 2392 Build a Matrix With Conditions](https://leetcode.com/problems/build-a-matrix-with-conditions/)