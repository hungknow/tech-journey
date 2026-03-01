# 1054 Distant Barcodes

## Problem Description

The retail store uses barcodes to identify products. Each barcode is a string of digits, 0 to 9.

The barcodes are placed in a row. The distance between two adjacent barcodes is 1. The distance between the ith and jth barcode is the absolute difference of their indices.

A barcode arrangement is distant if the minimum distance between any two identical barcodes is greater than 1.

Given an array of barcodes, return any arrangement of the barcodes that is distant.

### Example 1:
```
Input: barcodes = [1,1,1,2,2,2]
Output: [1,2,1,2,1,2]
```

### Example 2:
```
Input: barcodes = [1,1,1,1,2,2,3,3]
Output: [1,3,1,3,2,1,2,1]
```

## Solution Approach

This is similar to the "Rearrange String k Distance Apart" problem. We need to arrange the barcodes such that no two identical barcodes are adjacent. We can use a max-heap to always pick the most frequent barcode that's not the same as the last placed one.

## Algorithm

1. Count the frequency of each barcode using a hash map.
2. Create a max-heap based on frequency.
3. Initialize the result array.
4. While the heap is not empty:
   - Extract the most frequent barcode from the heap.
   - Place it in the result array.
   - Decrease its frequency.
   - If there's still frequency left, store it temporarily.
   - If we have a previously stored barcode with remaining frequency, push it back to the heap.
   - Set the current barcode as the previously stored one for the next iteration.
5. Return the result array.

## Why This Works

By always picking the most frequent barcode that's different from the last placed one, we maximize the chances of creating a valid arrangement. If we get stuck, it means no valid arrangement exists, but the problem guarantees one exists.

## Complexity

- **Time**: O(n log k) where k is the number of unique barcodes
- **Space**: O(k) for the heap and frequency map

## Link

[LeetCode 1054 Distant Barcodes](https://leetcode.com/problems/distant-barcodes/)