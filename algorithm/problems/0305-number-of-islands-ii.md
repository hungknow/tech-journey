# 0305 Number of Islands II

## Problem Description

You are given an empty 2D binary grid `grid` of size `m x n`. The grid is initially empty (all cells are water).

You are also given an array `positions` where `positions[i] = [ri, ci]` represents the position (ri, ci) where you want to add a land cell.

Return the number of islands after each addition. An island is surrounded by water and is formed by connecting adjacent lands horizontally or vertically.

### Example 1:
```
Input: m = 3, n = 3, positions = [[0,0],[0,1],[1,2],[2,1]]
Output: [1,1,2,3]
```

### Example 2:
```
Input: m = 1, n = 2, positions = [[0,1],[0,0]]
Output: [1,1]
```

## The Twist

Hash map/array is used to store the **parent sets** (`flattened_1D_coordinate -> root_coordinate`) to fuel the Union-Find algorithm as islands are dynamically added.

## Hash Table Usage

- **Key**: `flattened_index` (i * n + j, the 1D representation of 2D coordinates)
- **Value**: `parent_index` (the root of this cell in the Union-Find structure)

Algorithm:
1. Initialize parent and rank arrays for Union-Find
2. For each position:
   - If already land, append current island count and continue
   - Add the new land cell
   - Check all 4 neighbors
   - If neighbor is land, union the current cell with the neighbor
   - Update island count accordingly
3. Append the current island count to the result

## Complexity

- **Time**: O(k * α(mn)) where k is number of positions, α is the inverse Ackermann function (nearly constant)
- **Space**: O(mn) - storing parent and rank arrays

## Link

[LeetCode 0305 Number of Islands II](https://leetcode.com/problems/number-of-islands-ii/)
