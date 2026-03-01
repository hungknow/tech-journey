# 1942 The Number of the Smallest Unoccupied Chair

## Problem Description

You are given an array `times` where `times[i] = [arrivali, leavei]` represents the arrival and leave times of the ith guest. The guests are numbered from 0 to n-1.

When a guest arrives, they will sit on the smallest numbered unoccupied chair. When they leave, their chair becomes unoccupied.

You are also given an integer `targetFriend`. Return the chair number the target guest will sit on.

### Example 1:
```
Input: times = [[1,4],[2,3],[4,6],[5,2]], targetFriend = 1
Output: 1
Explanation: 
Guest 0 arrives at time 1 and sits on chair 0.
Guest 1 arrives at time 2 and sits on chair 1.
Guest 2 arrives at time 3 and sits on chair 2.
Guest 3 arrives at time 4 and sits on chair 3.
Guest 4 arrives at time 6 and sits on chair 4.
Guest 1 is the target friend, sitting on chair 1.
```

### Example 2:
```
Input: times = [[3,10],[2,5],[1,2],[3,8]], targetFriend = 2
Output: 3
Explanation: 
Guest 0 arrives at time 1 and sits on chair 0.
Guest 1 arrives at time 2 and sits on chair 1.
Guest 2 arrives at time 5 and sits on chair 2.
Guest 3 arrives at time 3 and sits on chair 3.
Guest 2 is the target friend, sitting on chair 3.
```

## Solution Approach

We need to track which chairs are occupied and when they become available. This can be solved using a min-heap for available chairs and another structure for tracking leave times.

## Algorithm

1. Sort the guests by arrival time.
2. Initialize a min-heap for available chairs and a map to track when each chair becomes available.
3. Process guests in order:
   - Before processing a guest, free up chairs whose guests have left.
   - Assign the smallest available chair to the current guest.
   - Record the leave time for this guest and chair.
4. Return the chair number of the target guest.

## Why This Works

By sorting by arrival time and using a min-heap for available chairs, we efficiently assign the smallest available chair to each guest.

## Complexity

- **Time**: O(n log n) - sorting and heap operations
- **Space**: O(n) - for the heap and tracking structures

## Link

[LeetCode 1942 The Number of the Smallest Unoccupied Chair](https://leetcode.com/problems/the-number-of-the-smallest-unoccupied-chair/)