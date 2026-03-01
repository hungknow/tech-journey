# 1636 Sort Array by Increasing Frequency

## Problem Description

Given an array of integers `nums`, sort the array in increasing order based on the frequency of each value. If multiple values have the same frequency, sort them in decreasing order.

Return the sorted array.

### Example 1:
```
Input: nums = [1,1,2,2,2,3]
Output: [3,1,1,2,2,2]
Explanation: '3' has a frequency of 1, '1' has a frequency of 2, and '2' has a frequency of 3.
```

### Example 2:
```
Input: nums = [2,3,1,3,2]
Output: [1,3,3,2,2]
Explanation: '2' and '3' both have a frequency of 2, so they are sorted in decreasing order.
```

## Solution Approach

We need to sort the array based on two criteria:
1. Primary: Frequency of each value (ascending)
2. Secondary: Value itself (descending) for equal frequencies

## Algorithm

1. Count the frequency of each number using a hash map.
2. Sort the array using a custom comparator:
   - First compare by frequency (ascending).
   - If frequencies are equal, compare by value (descending).
3. Return the sorted array.

## Alternative Algorithm (Bucket Sort)

1. Count the frequency of each number using a hash map.
2. Find the maximum frequency.
3. Create buckets where each bucket contains numbers with a specific frequency.
4. For each bucket, sort the numbers in descending order.
5. Iterate through the buckets from lowest to highest frequency:
   - For each number in the bucket, add it to the result according to its frequency.
6. Return the result array.

## Why This Works

By sorting according to the specified criteria, we ensure that numbers with lower frequencies appear first, and for equal frequencies, larger numbers appear first.

## Complexity

- **Time**: O(n log n) for sorting approach, O(n + m log m) for bucket sort where m is the number of unique values
- **Space**: O(n) for both approaches

## Link

[LeetCode 1636 Sort Array by Increasing Frequency](https://leetcode.com/problems/sort-array-by-increasing-frequency/)