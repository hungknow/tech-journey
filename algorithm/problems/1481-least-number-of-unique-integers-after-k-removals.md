# 1481 Least Number of Unique Integers after K Removals

## Problem Description

Given an array of integers `arr` and an integer `k`, remove exactly `k` elements from the array. Return the minimum number of distinct integers after removing `k` elements.

### Example 1:
```
Input: arr = [5,5,4], k = 1
Output: 1
Explanation: Remove the single 4, only 5 is left.
```

### Example 2:
```
Input: arr = [4,3,1,1,3,3,2], k = 3
Output: 2
Explanation: Remove 4, 2 and either one of the two 1s or three 3s. 1 and 3 will be left.
```

## Solution Approach

To minimize the number of distinct integers after removing k elements, we should prioritize removing elements that appear less frequently first. This way, we can eliminate entire distinct values with fewer removals.

## Algorithm

1. Count the frequency of each integer using a hash map.
2. Create a list of (frequency, integer) pairs.
3. Sort this list by frequency in ascending order.
4. Initialize `distinctCount` to the number of unique integers.
5. Iterate through the sorted list:
   - If `k >= frequency`, we can remove all occurrences of this integer:
     - Subtract `frequency` from `k`.
     - Decrement `distinctCount`.
   - Otherwise, we can't remove all occurrences of this integer, so break the loop.
6. Return `distinctCount`.

## Why This Works

By removing integers with lower frequencies first, we maximize the number of distinct integers we can eliminate with the given k removals.

## Complexity

- **Time**: O(n log n) - counting frequencies is O(n), sorting is O(n log n)
- **Space**: O(n) - for the frequency map and sorted list

## Link

[LeetCode 1481 Least Number of Unique Integers after K Removals](https://leetcode.com/problems/least-number-of-unique-integers-after-k-removals/)