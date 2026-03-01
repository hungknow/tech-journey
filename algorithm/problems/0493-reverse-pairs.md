# 0493 Reverse Pairs

## Problem Description

Given an integer array `nums`, return the number of reverse pairs in the array.

A reverse pair is a pair `(i, j)` where `0 <= i < j < nums.length` and `nums[i] > 2 * nums[j]`.

### Example 1:
```
Input: nums = [1,3,2,3,1]
Output: 2
```

### Example 2:
```
Input: nums = [2,4,3,5,1]
Output: 3
```

## Solution Approach

This problem can be solved efficiently using a modified merge sort algorithm. The key insight is that during the merge process, when the left and right halves are sorted, we can efficiently count the number of reverse pairs.

## Algorithm

1. Use a modified merge sort approach:
   - Divide the array into halves recursively.
   - Before merging, count the reverse pairs where elements from the left half are greater than twice elements from the right half.
   - Then merge the two sorted halves.
2. For counting reverse pairs:
   - For each element in the left half, find the first element in the right half that is greater than half of the left element.
   - The number of valid elements in the right half is the difference between this position and the start of the right half.
3. Accumulate the count of reverse pairs from all recursive calls.
4. Return the total count.

## Why This Works

By sorting the halves before counting, we can efficiently find the number of valid pairs for each element in the left half using binary search or a two-pointer technique. This avoids the O(n²) brute force approach.

## Complexity

- **Time**: O(n log n) - same as merge sort
- **Space**: O(n) - for the temporary array used in merge sort

## Link

[LeetCode 0493 Reverse Pairs](https://leetcode.com/problems/reverse-pairs/)