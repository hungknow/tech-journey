# 2948 Make Lexicographically Smallest Array by Swapping Elements

## Problem Description

You are given a positive integer array `nums`. In one operation, you can swap any two elements and increment them by 1.

Perform exactly `k` operations to make the array lexicographically smallest.

### Example 1:
```
Input: nums = [3,2,1], k = 1
Output: [1,2,3]
Explanation: 
Swap 2 and 3: [2,3,1]
The array becomes [3,2,1].
```

### Example 2:
```
Input: nums = [1,5,3,4], k = 2
Output: [1,3,4,5]
Explanation: 
Swap 1 and 5: [5,1,3,4].
The array becomes [3,1,4,5].
```

## Solution Approach

We need to find the lexicographically smallest array after exactly k swaps. This can be solved using a greedy approach.

## Algorithm

1. Create a list of pairs (value, index) for each element.
2. Sort the pairs by value.
3. For `i` from 0 to n-1:
   - Find the smallest element that can be swapped to position `i`.
   - Swap it with the element at position `i`.
   - Update the pairs list.
4. Repeat k times.
5. Return the sorted array.

## Why This Works

By always swapping the smallest element to the front, we ensure the array becomes lexicographically smallest after k swaps.

## Complexity

- **Time**: O(n × k) - finding and swapping k times
- **Space**: O(n) - for the pairs

## Link

[LeetCode 2948 Make Lexicographically Smallest Array by Swapping Elements](https://leetcode.com/problems/make-lexicographically-smallest-array-by-swapping-elements/)