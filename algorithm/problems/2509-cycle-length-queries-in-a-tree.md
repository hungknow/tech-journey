# Cycle Length Queries in a Tree

## Problem Description

You are given an integer `n`. There is a complete binary tree with `2^n - 1` nodes numbered from `1` to `2^n - 1`, where node `i` has two children:
- Left child: `2 * i`
- Right child: `2 * i + 1`

You are also given a 2D integer array `queries` of length `m`, where `queries[j] = [uj, vj]`. For each query, find the length of the cycle formed by the path from node `uj` to the root and the path from node `vj` to the root. The cycle length is the number of edges on this cycle.

Return an array `answer` of length `m` where `answer[j]` is the answer to the `j`th query.

**Example 1:**
```
Input: n = 3, queries = [[5,3],[4,7],[2,3]]
Output: [4,5,3]
Explanation: 
- Query 0: Path from 5 to root: 5 -> 2 -> 1. Path from 3 to root: 3 -> 1. Cycle: 5 -> 2 -> 1 -> 3 -> 2 -> 5. Length = 4.
- Query 1: Path from 4 to root: 4 -> 2 -> 1. Path from 7 to root: 7 -> 3 -> 1. Cycle: 4 -> 2 -> 1 -> 3 -> 7 -> 3 -> 1 -> 2 -> 4. Length = 5.
- Query 2: Path from 2 to root: 2 -> 1. Path from 3 to root: 3 -> 1. Cycle: 2 -> 1 -> 3 -> 1 -> 2. Length = 3.
```

**Example 2:**
```
Input: n = 2, queries = [[1,2]]
Output: [2]
```

**Constraints:**
- 1 <= n <= 30
- 1 <= queries.length <= 10^5
- 1 <= uj, vj <= 2^n - 1

## The Twist

This is a tree problem where we need to find the cycle length between two nodes. The key insight is that the cycle length is the sum of the distances from each node to their Lowest Common Ancestor (LCA), multiplied by 2.

## Algorithm

### Approach: Find LCA and Calculate Distance

1. For each query, find the LCA of u and v
2. Calculate the distance from u to LCA
3. Calculate the distance from v to LCA
4. Return 2 * (distance(u, LCA) + distance(v, LCA))

```go
func cycleLengthQueries(n int, queries [][]int) []int {
    answer := make([]int, len(queries))
    
    for i, q := range queries {
        u, v := q[0], q[1]
        answer[i] = findCycleLength(u, v)
    }
    
    return answer
}

func findCycleLength(u, v int) int {
    length := 0
    
    // Find LCA by climbing up from both nodes
    for u != v {
        if u > v {
            u /= 2
        } else {
            v /= 2
        }
        length++
    }
    
    // Cycle length is 2 * length (go up and down)
    return 2 * length
}
```

## Complexity

- **Time Complexity:** O(q * log(maxVal)) - For each query, we climb up O(log(maxVal)) levels
- **Space Complexity:** O(1) - Constant space

## Link

[LeetCode 2509 - Cycle Length Queries in a Tree](https://leetcode.com/problems/cycle-length-queries-in-a-tree/)
