# 1851 Minimum Interval to Include Each Query

## Problem Description

You are given a 2D integer array `intervals` where `intervals[i] = [lefti, righti]` represents the ith interval starting at `lefti` and ending at `righti` (inclusive).

You are also given an integer array `queries` where `queries[j]` is the start point of the jth query.

For each query, find the smallest interval that contains the query point. If there are multiple such intervals, return the one with the smallest left endpoint. If there is still a tie, return the one with the smallest right endpoint.

Return an array `answer` where `answer[j]` is the size of the smallest interval for the jth query.

### Example 1:
```
Input: intervals = [[1,4],[2,3],[3,4]], queries = [2,3,4]
Output: [2,3,4]
Explanation: 
For query 2: The smallest interval containing 2 is [2,3] with size 2.
For query 3: The smallest interval containing 3 is [2,3] with size 2.
For query 4: The smallest interval containing 4 is [3,4] with size 2.
```

### Example 2:
```
Input: intervals = [[1,4],[2,3],[3,4]], queries = [1,2,3]
Output: [2,3,1]
Explanation: 
For query 1: No interval contains 1, so the answer is 0.
For query 2: The smallest interval containing 2 is [2,3] with size 2.
For query 3: The smallest interval containing 3 is [2,3] with size 2.
```

## Solution Approach

We need to find, for each query, the smallest interval that contains the query point. This can be solved efficiently by sorting intervals and using binary search.

## Algorithm

1. Sort intervals by left endpoint.
2. For each query:
   - Use binary search to find the first interval where left <= query <= right.
   - If multiple intervals have the same left endpoint, choose the one with the smallest right endpoint.
   - The size is right - left + 1.
3. Return the sizes for all queries.

## Why This Works

By sorting intervals and using binary search, we efficiently find the smallest interval containing each query point.

## Complexity

- **Time**: O(n log n + q log n) for sorting and binary search
- **Space**: O(n) - for the sorted intervals

## Link

[LeetCode 1851 Minimum Interval to Include Each Query](https://leetcode.com/problems/minimum-interval-to-include-each-query/)