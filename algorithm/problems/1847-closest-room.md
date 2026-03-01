# 1847 Closest Room

## Problem Description

There is a hotel with `n` rooms. The rooms are represented by a 2D integer array `rooms` where `rooms[i] = [roomIdi, sizei]` denotes that there is a room with `roomIdi` and size `sizei`.

You are also given `queries` where `queries[j] = [preferredj, minSizej]`. The answer to the jth query is the room ID of a room such that:
- The room's size is at least `minSizej`.
- The absolute difference between the room's ID and `preferredj` is minimized.
- If there are multiple rooms with the same minimal absolute difference, return the one with the smallest room ID.
- If there is no such room, return -1.

Return an array `answer` where `answer[j]` is the answer to the jth query.

### Example 1:
```
Input: rooms = [[2,2],[1,2],[3,2]], queries = [[3,1],[1,3],[5,2]]
Output: [3,-1,3]
Explanation: 
The queries are as follows:
Query [3,1]: Room 3 is the closest with size >= 1.
Query [1,3]: There is no room with size >= 3.
Query [5,2]: Room 3 is the closest with size >= 2.
```

### Example 2:
```
Input: rooms = [[1,4],[2,3],[3,5],[4,1],[5,2]], queries = [[2,3],[2,4],[2,2]]
Output: [2,1,3]
```

## Solution Approach

This problem requires finding the closest room ID for each query, considering both size constraints and ID proximity. We can solve this by sorting both rooms and queries and using a TreeSet or similar data structure.

## Algorithm

1. Sort rooms by size in descending order.
2. Sort queries by minSize in descending order, keeping track of original indices.
3. Initialize an empty TreeSet to store room IDs.
4. Process queries one by one:
   - Add all rooms with size >= current query's minSize to the TreeSet.
   - Use the TreeSet to find the room ID closest to the preferred ID:
     - Find the floor (largest ID <= preferred) and ceiling (smallest ID >= preferred).
     - Choose the one with the smaller absolute difference, preferring the smaller ID in case of ties.
5. Store the result for each query at its original index.
6. Return the result array.

## Why This Works

By processing queries in descending order of minSize, we can maintain a TreeSet of all rooms that satisfy the size constraint. The TreeSet allows us to efficiently find the closest room ID to the preferred ID.

## Complexity

- **Time**: O(n log n + q log q + (n + q) log n) where n is the number of rooms and q is the number of queries
- **Space**: O(n) for the TreeSet

## Link

[LeetCode 1847 Closest Room](https://leetcode.com/problems/closest-room/)