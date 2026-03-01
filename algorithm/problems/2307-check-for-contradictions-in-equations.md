# 2307 Check for Contradictions in Equations

## Problem Description

You are given an array `equations` where `equations[i] = [Ai, Bi, valuei]` represents the equation `Ai / Bi = valuei`.

The equations are guaranteed to be consistent (no contradictions).

You are also given `queries` where `queries[i] = [Aj, Bj, valuej]` asks if the equation `Aj / Bj = valuej` is consistent with the given equations.

Return an array of booleans where the ith element is true if the ith query is consistent with the equations, otherwise false.

### Example 1:
```
Input: equations = [["a","b",2.0], ["b","c",3.0]], queries = [["a","c",6.0]]
Output: [true]
```

### Example 2:
```
Input: equations = [["a","b",2.0], ["b","c",3.0]], queries = [["a","c",5.0]]
Output: [false]
```

## Approach

This problem can be solved using Union Find with weighted edges:

1. **Union Find with Weights**: Use Union Find to track variable relationships and the ratio between them.

2. **Build Equation Graph**:
   - For each equation `A / B = value`, union A and B
   - Store the weight ratio between A and B

3. **Query Processing**:
   - For each query, check if the two variables are in the same component
   - If they are, check if the ratio matches the query value

## Solution Code

```go
func checkContradictions(equations [][]string, queries [][]string) []bool {
    parent := make(map[string]string)
    weight := make(map[string]float64)
    
    // Initialize Union Find
    for _, eq := range equations {
        a, b, val := eq[0], eq[1], eq[2]
        parent[a] = a
        parent[b] = b
        weight[a] = 1.0
        weight[b] = 1.0
    }
    
    var find func(x string) string
    find = func(x string) string {
        if parent[x] != x {
            origParent := parent[x]
            parent[x] = find(parent[x])
            weight[x] *= weight[origParent]
        }
        return parent[x]
    }
    
    union := func(a, b string, val float64) {
        rootA, rootB := find(a), find(b)
        if rootA != rootB {
            parent[rootA] = rootB
            weight[rootA] = val / weight[b]
        }
    }
    
    // Build the equation graph
    for _, eq := range equations {
        a, b, val := eq[0], eq[1], eq[2]
        union(a, b, val)
    }
    
    // Process queries
    result := make([]bool, len(queries))
    for i, query := range queries {
        a, b, val := query[0], query[1], query[2]
        
        if _, exists := parent[a]; !exists {
            result[i] = false
            continue
        }
        
        if _, exists := parent[b]; !exists {
            result[i] = false
            continue
        }
        
        rootA, rootB := find(a), find(b)
        
        if rootA != rootB {
            result[i] = false
        } else {
            ratio := weight[a] / weight[b]
            result[i] = math.Abs(ratio-val) < 1e-9 // Account for floating point precision
        }
    }
    
    return result
}
```

## Complexity Analysis

- **Time**: O((e + q)α(n)) where e is the number of equations, q is the number of queries, and n is the number of variables
  - Building equation graph: O(eα(n)) but practically O(e)
  - Processing queries: O(qα(n)) but practically O(q)
- **Space**: O(n) for the Union Find data structure

## Link

[LeetCode 2307 Check for Contradictions in Equations](https://leetcode.com/problems/check-for-contradictions-in-equations/)