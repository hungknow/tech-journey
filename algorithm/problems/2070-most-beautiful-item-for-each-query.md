# 2070 Most Beautiful Item for Each Query

## Problem Description

You are given a 2D integer array `items` where `items[i] = [pricei, beautyi]` represents the price and beauty of the ith item.

You are also given an integer array `queries` where `queries[j]` is the price that a customer is willing to pay.

For each query, find the most beautiful item with price less than or equal to `queries[j]`. If there are multiple items with the same maximum beauty, return the one with the smallest price.

### Example 1:
```
Input: items = [[1,2],[3,4],[2,5]], queries = [3,2,4]
Output: [2,4]
Explanation: 
For query 3: Items with price <= 3 are [1,2] and [2,3].
The most beautiful is [3,4] with beauty 4.
For query 2: Items with price <= 2 are [1,2] and [2,5].
The most beautiful is [2,5] with beauty 5.
For query 4: No item has price <= 4, so no item is selected.
```

### Example 2:
```
Input: items = [[1,2],[3,4],[2,5]], queries = [2,2,4]
Output: [2,4]
Explanation: 
For query 2: Items with price <= 2 are [1,2] and [2,5].
The most beautiful is [2,5] with beauty 5.
For query 2: Same as above.
For query 4: Same as above.
```

## Solution Approach

We need to find, for each query, the most beautiful item with price <= query. This can be solved efficiently by preprocessing the items.

## Algorithm

1. Sort the items by price in descending order.
2. For each query:
   - Find the first item with price <= query.
   - If multiple items have the same price and beauty, return the one with the smallest price.
3. Return the results.

## Why This Works

By sorting by price in descending order, we can efficiently find the most beautiful item for each query.

## Complexity

- **Time**: O(n log n + q log n) for sorting and binary search
- **Space**: O(n) - for the sorted array

## Link

[LeetCode 2070 Most Beautiful Item for Each Query](https://leetcode.com/problems/most-beautiful-item-for-each-query/)