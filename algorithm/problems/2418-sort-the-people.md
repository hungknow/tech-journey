# 2418 Sort the People

## Problem Description

You are given an array of strings `names`, where each string represents a person's name. You are also given an array of integers `heights` where `heights[i]` is the height of the ith person.

Return `names` sorted in descending order according to people's heights.

### Example 1:
```
Input: names = ["Alice","Bob","Bob"], heights = [155,165,170]
Output: ["Bob","Alice"]
Explanation: 
Bob is taller than Alice, so Bob comes first.
```

### Example 2:
```
Input: names = ["Alice","Bob","Bob"], heights = [165,155,170]
Output: ["Alice","Bob"]
Explanation: 
Alice and Bob have the same height, so they maintain their original order.
```

## Solution Approach

We need to sort people by their heights in descending order. This can be solved by pairing each name with its height and sorting.

## Algorithm

1. Create pairs of (height, name) for each person.
2. Sort the pairs by height in descending order.
3. If heights are equal, sort by name in ascending order.
4. Extract the names from the sorted pairs.
5. Return the sorted list of names.

## Why This Works

By pairing heights with names and sorting, we achieve the desired ordering based on height (descending) and name (ascending for ties).

## Complexity

- **Time**: O(n log n) - dominated by sorting
- **Space**: O(n) - for storing the pairs

## Link

[LeetCode 2418 Sort the People](https://leetcode.com/problems/sort-the-people/)