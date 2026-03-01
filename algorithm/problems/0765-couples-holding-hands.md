# 0765 Couples Holding Hands

## Problem Description

N couples sit in 2N seats arranged in a row. The couples are given as an array where each element represents a person.

A couple is sitting together if they occupy adjacent seats. Return the minimum number of swaps required so that every couple sits together.

### Example 1:
```
Input: row = [0,2,1,3]
Output: 1
```

### Example 2:
```
Input: row = [3,2,0,1]
Output: 0
```

## Approach

This problem can be solved using Union Find:

1. **Union Find Structure**:
   - Each seat is a node
   - Union seats that should be together (every 2 consecutive seats)
   - Track the size of each component

2. **Component Analysis**:
   - For each component, count how many people are already in correct positions
   - Calculate swaps needed for each component

3. **Swap Calculation**:
   - For a component of size k, we need k/2 - 1 swaps
   - Sum swaps across all components

## Solution Code

```go
func minSwapsCouples(row []int) int {
    n := len(row)
    if n == 0 {
        return 0
    }
    
    // Union Find structure
    parent := make([]int, n)
    size := make([]int, n)
    
    for i := 0; i < n; i++ {
        parent[i] = i
        size[i] = 1
    }
    
    find := func(x int) int {
        for parent[x] != x {
            parent[x] = parent[parent[x]]
            x = parent[x]
        }
        return x
    }
    
    union := func(x, y int) {
        rootX, rootY := find(x), find(y)
        if rootX != rootY {
            if size[rootX] < size[rootY] {
                parent[rootX] = rootY
                size[rootY] += size[rootX]
            } else {
                parent[rootY] = rootX
                size[rootX] += size[rootY]
            }
        }
    }
    
    // Union seats that should be together (every 2 consecutive seats)
    for i := 0; i < n; i += 2 {
        union(i, i+1)
    }
    
    // Count people in each component
    componentCount := make(map[int]int)
    for i := 0; i < n; i++ {
        root := find(i)
        componentCount[root]++
    }
    
    // Calculate swaps needed
    swaps := 0
    for _, count := range componentCount {
        swaps += count/2 - 1
    }
    
    return swaps
}
```

## Complexity Analysis

- **Time**: O(N * α(N)) where N is the number of people and α is the inverse Ackermann function
  - Union Find operations are nearly constant time
- **Space**: O(N) for the Union Find structure

## Link

[LeetCode 0765 Couples Holding Hands](https://leetcode.com/problems/couples-holding-hands/)