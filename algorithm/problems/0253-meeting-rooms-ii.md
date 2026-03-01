# 0253 Meeting Rooms II

## Problem Description

Given an array of meeting time intervals `intervals` where `intervals[i] = [starti, endi]`, return the minimum number of conference rooms required.

### Example 1:
```
Input: intervals = [[0,30],[5,10],[15,20]]
Output: 2
```

### Example 2:
```
Input: intervals = [[7,10],[2,4]]
Output: 1
```

## Solution Approach

We need to find the maximum number of overlapping meetings at any point in time. This can be solved using a line sweep algorithm or by using two separate arrays for start and end times.

## Algorithm

1. Extract all start times and end times into separate arrays.
2. Sort both arrays.
3. Use two pointers:
   - `startPtr` for the start times array
   - `endPtr` for the end times array
4. Initialize `rooms` = 0 and `maxRooms` = 0.
5. While `startPtr` < n:
   - If `startTimes[startPtr]` < `endTimes[endPtr]`, we need a new room:
     - Increment `rooms`
     - Move `startPtr` forward
   - Else, a meeting has ended, freeing a room:
     - Decrement `rooms`
     - Move `endPtr` forward
   - Update `maxRooms` with the maximum of `maxRooms` and `rooms`.
6. Return `maxRooms`.

## Complexity

- **Time**: O(n log n) - sorting the start and end time arrays
- **Space**: O(n) - for storing the start and end time arrays

## Link

[LeetCode 0253 Meeting Rooms II](https://leetcode.com/problems/meeting-rooms-ii/)