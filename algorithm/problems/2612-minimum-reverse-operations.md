# 2612 Minimum Reverse Operations

## Problem Description

You are given an integer `n` and an array `queries` where `queries[i] = [p_i, x_i]`.

Initially, you have an array `nums` of size `n+1` where `nums[i] = i` for `0 ≤ i ≤ n`.

For each query, you perform the following operation:
- Find all indices `j` such that `j ≥ p_i` and `nums[j]` is odd
- Reverse the order of these elements and set `nums[j] = nums[j] + x_i` for all such `j`

Return the array after performing all queries.

### Example 1:
```
Input: n = 5, queries = [[2,1],[4,2]]
Output: [0,1,4,3,6]
```

### Example 2:
```
Input: n = 3, queries = [[1,2],[2,1]]
Output: [0,3,3]
```

## Approach

This problem can be solved using BFS with a specialized data structure:

1. **Data Structure**:
   - Use a set to track available odd indices
   - For each query, find all indices ≥ p_i with odd values

2. **Operation Simulation**:
   - Extract all valid indices in order
   - Reverse their order
   - Apply the x_i addition

3. **Efficient Implementation**:
   - Use a balanced tree structure to efficiently find and remove indices
   - Process queries in order

## Solution Code

```go
func minReverseOperations(n int, queries [][]int) []int {
    // Initialize the array
    nums := make([]int, n+1)
    for i := 0; i <= n; i++ {
        nums[i] = i
    }
    
    // Use a set-like structure to track odd indices
    oddIndices := make(map[int]bool)
    for i := 1; i <= n; i += 2 {
        oddIndices[i] = true
    }
    
    // Process each query
    for _, query := range queries {
        p, x := query[0], query[1]
        
        // Find all indices >= p with odd values
        indices := []int{}
        for j := p; j <= n; j++ {
            if oddIndices[j] && nums[j]%2 == 1 {
                indices = append(indices, j)
            }
        }
        
        // Reverse the indices and apply operation
        for i, j := 0, len(indices)-1; i < j; i, j = i+1, j-1 {
            idx1, idx2 := indices[i], indices[j]
            nums[idx1], nums[idx2] = nums[idx2]+x, nums[idx1]+x
        }
        
        // If odd number of indices, handle the middle one
        if len(indices)%2 == 1 {
            mid := indices[len(indices)/2]
            nums[mid] += x
        }
        
        // Update odd indices set
        oddIndices = make(map[int]bool)
        for i := 1; i <= n; i += 2 {
            if nums[i]%2 == 1 {
                oddIndices[i] = true
            }
        }
    }
    
    return nums
}
```

## Complexity Analysis

- **Time**: O(Q * n) where Q is the number of queries and n is the array size
  - For each query, we might scan the entire array
  - In the worst case, this is O(Q * n)
- **Space**: O(n) for the array and odd indices tracking

## Link

[LeetCode 2612 Minimum Reverse Operations](https://leetcode.com/problems/minimum-reverse-operations/)