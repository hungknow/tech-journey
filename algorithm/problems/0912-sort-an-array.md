# 0912 Sort an Array

## Problem Description

Given an integer array `nums`, sort the array in ascending order.

### Example 1:
```
Input: nums = [5,2,3,1]
Output: [1,2,3,5]
```

### Example 2:
```
Input: nums = [5,1,1,2,0,0]
Output: [0,0,1,1,2,5]
```

## Solution Approach

This is a classic sorting problem. We can implement various sorting algorithms such as Merge Sort, Quick Sort, or Heap Sort. Here, I'll describe the Merge Sort approach.

## Algorithm (Merge Sort)

1. Base case: if the array has 0 or 1 element, it's already sorted.
2. Divide the array into two halves.
3. Recursively sort both halves.
4. Merge the two sorted halves:
   - Create a temporary array to store the merged result.
   - Use two pointers to compare elements from both halves.
   - Place the smaller element into the temporary array.
   - Continue until one half is exhausted, then copy the remaining elements from the other half.
5. Copy the merged result back to the original array.

## Alternative Algorithms

1. **Quick Sort**: Choose a pivot, partition the array around the pivot, and recursively sort the partitions.
2. **Heap Sort**: Build a max-heap from the array, then repeatedly extract the maximum element.
3. **Counting Sort**: For arrays with a limited range of values, count the frequency of each value and reconstruct the sorted array.

## Complexity

- **Time**: O(n log n) for Merge Sort, Quick Sort (average), and Heap Sort
- **Space**: O(n) for Merge Sort (due to the temporary array), O(log n) for Quick Sort (due to recursion), O(1) for Heap Sort

## Link

[LeetCode 0912 Sort an Array](https://leetcode.com/problems/sort-an-array/)