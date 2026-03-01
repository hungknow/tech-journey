# 0274 H-Index

## Problem Description

Given an array of integers `citations` where `citations[i]` is the number of citations a researcher received for their ith paper, return the researcher's h-index.

The h-index is defined as the maximum value of `h` such that the given researcher has published at least `h` papers that have each been cited at least `h` times.

### Example 1:
```
Input: citations = [3,0,6,1,5]
Output: 3
Explanation: The researcher has 5 papers in total and each of them had received 3, 0, 6, 1, 5 citations respectively.
Since the researcher has 3 papers with at least 3 citations each and the remaining two with no more than 3 citations each, their h-index is 3.
```

### Example 2:
```
Input: citations = [1,3,1]
Output: 1
```

## Solution Approach

The h-index can be found by sorting the citations in descending order and finding the position where the citation count is less than or equal to its position index (1-based).

## Algorithm

1. Sort the citations array in descending order.
2. Initialize `hIndex` = 0.
3. Iterate through the sorted citations:
   - For each citation at index `i` (0-based), if `citation > i`, then we have at least `i+1` papers with at least `i+1` citations.
   - Update `hIndex` to be `i+1`.
   - Otherwise, break the loop.
4. Return `hIndex`.

## Alternative Approach (Counting Sort)

Since the h-index can't exceed the number of papers, we can use counting sort for O(n) time:

1. Create a count array of size `n+1` where `n` is the number of papers.
2. For each citation, if it's greater than or equal to `n`, increment `count[n]`.
3. Otherwise, increment `count[citation]`.
4. Iterate from the end of the count array, accumulating the count:
   - If the accumulated count is greater than or equal to the current index, return that index.

## Complexity

- **Time**: O(n log n) for the sorting approach, O(n) for the counting sort approach
- **Space**: O(1) for the sorting approach, O(n) for the counting sort approach

## Link

[LeetCode 0274 H-Index](https://leetcode.com/problems/h-index/)