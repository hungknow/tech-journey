# 1122 Relative Sort Array

## Problem Description

Given two arrays `arr1` and `arr2`, the elements of `arr2` are distinct, and all elements in `arr2` are also in `arr1`.

Sort the elements of `arr1` such that the relative ordering of items in `arr1` are the same as in `arr2`. Elements that don't appear in `arr2` should be placed at the end of `arr1` in ascending order.

### Example 1:
```
Input: arr1 = [2,3,1,3,2,4,6,7,9,2,19], arr2 = [2,1,4,3,9,6]
Output: [2,2,2,1,4,3,3,9,6,7,19]
```

### Example 2:
```
Input: arr1 = [28,6,22,8,44,17], arr2 = [22,28,8,6]
Output: [22,28,8,6,17,44]
```

## Solution Approach

We need to sort arr1 according to the order specified in arr2, with remaining elements sorted in ascending order.

## Algorithm

1. Count the frequency of each element in arr1 using a hash map.
2. Initialize an empty result list.
3. For each element in arr2:
   - Add the element to the result list as many times as it appears in arr1.
   - Remove the element from the frequency map.
4. For the remaining elements in the frequency map:
   - Sort them in ascending order.
   - Add each element to the result list according to its frequency.
5. Return the result list.

## Alternative Algorithm (Custom Sorting)

1. Create a map that stores the order of each element in arr2.
2. Sort arr1 using a custom comparator:
   - If both elements appear in arr2, sort them according to their order in arr2.
   - If only one element appears in arr2, the one that appears in arr2 comes first.
   - If neither appears in arr2, sort them in ascending order.
3. Return the sorted arr1.

## Complexity

- **Time**: O(n log n) - dominated by sorting
- **Space**: O(n) - for the frequency map and result list

## Link

[LeetCode 1122 Relative Sort Array](https://leetcode.com/problems/relative-sort-array/)