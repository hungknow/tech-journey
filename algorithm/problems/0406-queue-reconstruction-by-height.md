# 0406 Queue Reconstruction by Height

## Problem Description

You are given an array of people, `people[i] = [hi, ki]`, where `hi` is the height of the ith person and `ki` is the number of people in front of the ith person who have a height greater than or equal to `hi`.

Reconstruct the queue.

### Example 1:
```
Input: people = [[7,0],[4,4],[7,1],[5,0],[6,1],[5,2]]
Output: [[5,0],[7,0],[5,2],[6,1],[4,4],[7,1]]
```

### Example 2:
```
Input: people = [[6,0],[5,0],[4,0],[3,2],[2,2],[1,4]]
Output: [[4,0],[5,0],[2,2],[3,2],[1,4],[6,0]]
```

## Solution Approach

The key insight is to sort people by height in descending order, and by k-value in ascending order. Then, we can insert each person at the position specified by their k-value.

## Algorithm

1. Sort the people array:
   - Primary key: height in descending order
   - Secondary key: k-value in ascending order
2. Initialize an empty result list.
3. For each person in the sorted array:
   - Insert the person at index k in the result list.
   - Since we're processing taller people first, when we insert a person, all people already in the list are taller or of equal height.
   - Therefore, inserting at position k ensures there are exactly k people in front who are taller or of equal height.
4. Return the result list.

## Why This Works

By sorting by height in descending order, we ensure that when we place a person at position k, all people already placed are taller or of equal height. This guarantees that the k-value is satisfied.

## Complexity

- **Time**: O(n²) - sorting takes O(n log n), but each insertion can take O(n) in the worst case
- **Space**: O(n) - for the result list

## Link

[LeetCode 0406 Queue Reconstruction by Height](https://leetcode.com/problems/queue-reconstruction-by-height/)