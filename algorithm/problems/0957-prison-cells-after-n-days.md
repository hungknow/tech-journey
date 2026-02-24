# 0957 Prison Cells After N Days

## Problem Description

There are 8 prison cells in a row and each cell is either occupied or vacant. Each day, whether the cell is occupied or vacant changes according to the following rules:

- If a cell has two adjacent neighbors that are both occupied or both vacant, then the cell becomes occupied.
- Otherwise, it becomes vacant.

The first and last cells can't have two adjacent neighbors, so they are always vacant.

Given two integer arrays `cells` and `n`, return the state of the prison after `n` days.

### Example 1:
```
Input: cells = [0,1,0,1,1,0,0,1], n = 7
Output: [0,0,1,1,0,0,0,0]
```

### Example 2:
```
Input: cells = [1,0,0,1,0,0,1,0], n = 1000000000
Output: [0,0,1,1,1,1,1,0]
```

## The Twist

N is **too massive to simulate linearly**. The state space is limited (2^6 = 64 possible states since first and last cells are always 0), so states must eventually repeat. We can detect the cycle and use modulo math to skip to the end.

## Hash Table Usage

- **Key**: `prison_state` (the 8-cell state as a string or tuple)
- **Value**: `day_seen` (the first day this state was observed)

Algorithm:
1. Simulate day by day, storing each state in the map
2. When a state repeats, we've found a cycle
3. Calculate the cycle length: `current_day - day_seen[repeated_state]`
4. Use modulo to skip to the final state: `remaining_days = (n - cycle_start) % cycle_length`
5. Simulate the remaining days to get the final state

## Complexity

- **Time**: O(1) - at most 64 unique states before a cycle is found
- **Space**: O(1) - at most 64 states stored in the map

## Link

[LeetCode 0957 Prison Cells After N Days](https://leetcode.com/problems/prison-cells-after-n-days/)
