# 0990 Satisfiability of Equality Equations

## Problem Description

You are given an array of equations represented as strings. Each equation is of the form `"a==b"` or `"a!=b"`. Determine if it's possible to assign values to variables such that all equations hold true.

### Example 1:
```
Input: equations = ["a==b","b==c","a==c"]
Output: true
```

### Example 2:
```
Input: equations = ["a==b","b!=a"]
Output: false
```

### Example 3:
```
Input: equations = ["a==b","b==c","a==c","a!=b"]
Output: false
```

## Approach

This problem can be solved using Union Find to track variable relationships:

1. **Union Find Setup**: Use Union Find to group variables that must be equal.

2. **Processing Equations**:
   - First process all equality equations (`"a==b"`) to build connected components
   - Then process all inequality equations (`"a!=b"`) to check for contradictions

3. **Validation**:
   - For each inequality `"a!=b"`, check if `a` and `b` are in the same component
   - If they are, the equations are contradictory (return false)
   - If all inequalities are valid, return true

## Solution Code

```go
func equationsPossible(equations []string) bool {
    parent := make(map[byte]byte)
    
    // Initialize Union Find
    for i := byte('a'); i <= byte('z'); i++ {
        parent[i] = i
    }
    
    var find func(x byte) byte
    find = func(x byte) byte {
        if parent[x] != x {
            parent[x] = find(parent[x])
        }
        return parent[x]
    }
    
    union := func(x, y byte) {
        rootX, rootY := find(x), find(y)
        if rootX != rootY {
            parent[rootX] = rootY
        }
    }
    
    // First pass: process all equalities
    for _, eq := range equations {
        if eq[1] == '=' {
            x, y := eq[0], eq[3]
            union(x, y)
        }
    }
    
    // Second pass: check all inequalities
    for _, eq := range equations {
        if eq[1] == '!' {
            x, y := eq[0], eq[3]
            if find(x) == find(y) {
                return false
            }
        }
    }
    
    return true
}
```

## Complexity Analysis

- **Time**: O(nα(n)) where n is the number of equations and α is the inverse Ackermann function
  - Processing each equation: O(n)
  - Union Find operations: O(nα(n)) but practically O(n)
- **Space**: O(1) for the Union Find data structure (fixed size for 26 lowercase letters)

## Link

[LeetCode 0990 Satisfiability of Equality Equations](https://leetcode.com/problems/satisfiability-of-equality-equations/)