# 0057 Insert Interval

## Problem Description

You are given an array of non-overlapping intervals `intervals` where `intervals[i] = [starti, endi]` represent the start and the end of the ith interval and `intervals` is sorted in ascending order by `starti`. You are also given an interval `newInterval = [start, end]` that represents the start and end of another interval.

Insert `newInterval` into `intervals` such that `intervals` is still sorted in ascending order by `starti` and `intervals` still does not have any overlapping intervals (merge overlapping intervals if necessary).

Return `intervals` after the insertion.

### Example 1:
```
Input: intervals = [[1,3],[6,9]], newInterval = [2,5]
Output: [[1,5],[6,9]]
```

### Example 2:
```
Input: intervals = [[1,2],[3,5],[6,7],[8,10],[12,16]], newInterval = [4,8]
Output: [[1,2],[3,10],[12,16]]
Explanation: Because the new interval [4,8] overlaps with [3,5],[6,7],[8,10].
```

## Solution Approach

The key insight is to process the intervals in three phases:
1. Add all intervals that end before the new interval starts
2. Merge all overlapping intervals with the new interval
3. Add the remaining intervals

## Algorithm

1. Initialize an empty result list.
2. Iterate through the intervals:
   - If the current interval ends before the new interval starts, add it to the result.
   - If the current interval starts after the new interval ends, add the new interval to the result (if not already added) and then add all remaining intervals.
   - Otherwise, the intervals overlap, so merge them by updating the new interval's start to be the minimum of both starts and the end to be the maximum of both ends.
3. If the new interval hasn't been added yet, add it to the result.
4. Return the result list.

## Complexity

- **Time**: O(n) - single pass through the intervals
- **Space**: O(n) - for the result list

## Link

[LeetCode 0057 Insert Interval](https://leetcode.com/problems/insert-interval/)