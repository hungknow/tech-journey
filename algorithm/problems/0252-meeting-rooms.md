# 0252 Meeting Rooms

## Problem Description

Given an array of meeting time intervals `intervals` where `intervals[i] = [starti, endi]`, determine if a person could attend all meetings.

### Example 1:
```
Input: intervals = [[0,30],[5,10],[15,20]]
Output: false
```

### Example 2:
```
Input: intervals = [[7,10],[2,4]]
Output: true
```

## Solution Approach

The key insight is that if we can attend all meetings, then no two meetings should overlap. We can check this by sorting the intervals by their start time and then verifying that each meeting ends before the next one starts.

## Algorithm

1. If there are 0 or 1 intervals, return true (no conflicts possible).
2. Sort the intervals based on their start time.
3. Iterate through the sorted intervals:
   - For each interval (except the first), check if its start time is less than the end time of the previous interval.
   - If it is, there's an overlap, so return false.
4. If we complete the iteration without finding any overlaps, return true.

## Complexity

- **Time**: O(n log n) - dominated by the sorting step
- **Space**: O(1) - we can sort in-place (or O(n) if using extra space for sorting)

## Link

[LeetCode 0252 Meeting Rooms](https://leetcode.com/problems/meeting-rooms/)