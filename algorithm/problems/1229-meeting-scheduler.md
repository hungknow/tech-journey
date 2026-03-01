# 1229 Meeting Scheduler

## Problem Description

Given the availability time slots arrays `slots1` and `slots2` of two people and a meeting duration `duration`, return the earliest time slot that works for both of them and is of duration `duration`.

If there is no common time slot that satisfies the requirements, return an empty array.

The format of a time slot is an array of two elements `[start, end]` representing an inclusive time interval from `start` to `end`.

It is guaranteed that no two availability slots of the same person intersect with each other.

### Example 1:
```
Input: slots1 = [[10,50],[60,120],[140,210]], slots2 = [[0,15],[60,70]], duration = 8
Output: [60,68]
```

### Example 2:
```
Input: slots1 = [[10,50],[60,120],[140,210]], slots2 = [[0,15],[60,70]], duration = 12
Output: []
```

## Solution Approach

We need to find the intersection of two sets of time slots that has at least the specified duration. This can be solved efficiently by sorting both sets of slots and using a two-pointer approach.

## Algorithm

1. Sort both `slots1` and `slots2` by start time.
2. Initialize two pointers, `i` and `j`, both starting at 0.
3. While both pointers are within bounds:
   - Find the intersection of the current slots:
     - `start = max(slots1[i][0], slots2[j][0])`
     - `end = min(slots1[i][1], slots2[j][1])`
   - If `end - start >= duration`, return `[start, start + duration]`.
   - Otherwise, move the pointer of the slot that ends earlier:
     - If `slots1[i][1] < slots2[j][1]`, increment `i`.
     - Else, increment `j`.
4. If no suitable slot is found, return an empty array.

## Why This Works

By sorting the slots and using a two-pointer approach, we efficiently check for intersections in O(n + m) time where n and m are the lengths of the two slot arrays.

## Complexity

- **Time**: O(n log n + m log m) for sorting, O(n + m) for the two-pointer traversal
- **Space**: O(1) - we can sort in-place (or O(n + m) if using extra space for sorting)

## Link

[LeetCode 1229 Meeting Scheduler](https://leetcode.com/problems/meeting-scheduler/)