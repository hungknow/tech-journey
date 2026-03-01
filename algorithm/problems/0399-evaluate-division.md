# 0399 Evaluate Division

## Problem Description

You are given an array of variable pairs `equations` and an array of real numbers `values`, where `equations[i] = [Ai, Bi]` and `values[i]` represent the equation `Ai / Bi = values[i]`. Each `Ai` or `Bi` is a string that represents a variable name.

You are also given some `queries`, where `queries[j] = [Cj, Dj]` represents the `jth` query where you must find the answer for `Cj / Dj = ?`.

Return the answers to all queries. If a single answer cannot be determined for a query, return `-1.0`.

**Note:** The input is always valid. You may assume that evaluating the queries will not result in division by zero and that there is no contradiction.

### Example 1:
```
Input: equations = [["a","b"],["b","c"]], values = [2.0,3.0], queries = [["a","c"],["b","a"],["a","e"],["a","a"],["x","x"]]
Output: [6.00000,0.50000,-1.00000,1.00000,-1.00000]
Explanation: 
Given: a / b = 2.0, b / c = 3.0
queries are: a / c = ?, b / a = ?, a / e = ?, a / a = ?, x / x = ?
return: [6.0, 0.5, -1.0, 1.0, -1.0 ]
```

### Example 2:
```
Input: equations = [["a","b"],["b","c"],["bc","cd"]], values = [1.5,2.5,5.0], queries = [["a","c"],["c","b"],["bc","cd"],["cd","bc"]]
Output: [3.75000,0.40000,5.00000,0.20000]
```

### Example 3:
```
Input: equations = [["a","b"]], values = [0.5], queries = [["a","b"],["b","a"],["a","c"],["x","y"]]
Output: [0.50000,2.00000,-1.00000,-1.00000]
```

## Approach

This problem can be solved using Union Find (Disjoint Set Union) with weights:

1. **Graph Representation**: Treat each variable as a node and each equation as a weighted edge. The weight of edge from A to B represents the value of A/B.

2. **Union Find with Weights**: 
   - Each node will have a parent and a weight relative to its parent
   - When finding the root of a node, we need to update the weight to be relative to the root
   - When unioning two nodes, we need to update the weights accordingly

3. **Query Processing**:
   - For each query (A, B), check if A and B are in the same component
   - If they are, the result is weight[A] / weight[B]
   - If they're not in the same component, return -1.0

## Solution Code

```go
func calcEquation(equations [][]string, values []float64, queries [][]string) []float64 {
    parent := make(map[string]string)
    weight := make(map[string]float64)
    
    // Initialize
    for _, eq := range equations {
        parent[eq[0]] = eq[0]
        parent[eq[1]] = eq[1]
        weight[eq[0]] = 1.0
        weight[eq[1]] = 1.0
    }
    
    var find func(x string) (string, float64)
    find = func(x string) (string, float64) {
        if parent[x] != x {
            origParent := parent[x]
            root, w := find(parent[x])
            parent[x] = root
            weight[x] *= w
        }
        return parent[x], weight[x]
    }
    
    union := func(x, y string, value float64) {
        rootX, weightX := find(x)
        rootY, weightY := find(y)
        
        if rootX != rootY {
            parent[rootX] = rootY
            weight[rootX] = weightY * value / weightX
        }
    }
    
    // Build the graph
    for i, eq := range equations {
        union(eq[0], eq[1], values[i])
    }
    
    // Process queries
    result := make([]float64, len(queries))
    for i, q := range queries {
        if _, exists := parent[q[0]]; !exists {
            result[i] = -1.0
            continue
        }
        if _, exists := parent[q[1]]; !exists {
            result[i] = -1.0
            continue
        }
        
        rootX, weightX := find(q[0])
        rootY, weightY := find(q[1])
        
        if rootX != rootY {
            result[i] = -1.0
        } else {
            result[i] = weightX / weightY
        }
    }
    
    return result
}
```

## Complexity Analysis

- **Time**: O(N * α(N) + Q * α(N)) where N is the number of equations, Q is the number of queries, and α is the inverse Ackermann function (practically constant)
- **Space**: O(N) for storing the parent and weight maps

## Link

[LeetCode 0399 Evaluate Division](https://leetcode.com/problems/evaluate-division/)