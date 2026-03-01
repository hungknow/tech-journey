# 0347 Top K Frequent Elements

## Problem Description

Given an integer array `nums` and an integer `k`, return the `k` most frequent elements.

### Example 1:
```
Input: nums = [1,1,1,2,2,3], k = 2
Output: [1,2]
```

### Example 2:
```
Input: nums = [1], k = 1
Output: [1]
```

## Solution Approach

We need to find the k most frequent elements. There are several approaches:
1. Sort by frequency (O(n log n))
2. Use a min-heap of size k (O(n log k))
3. Use bucket sort (O(n))

## Algorithm (Bucket Sort)

1. Count the frequency of each element using a hash map.
2. Create buckets where the index represents the frequency:
   - The maximum possible frequency is n (length of the array).
   - For each element, place it in the bucket corresponding to its frequency.
3. Iterate from the highest frequency bucket downwards:
   - Add elements from each bucket to the result until we have k elements.
4. Return the result.

## Alternative Algorithm (Heap)

1. Count the frequency of each element using a hash map.
2. Use a min-heap to keep track of the k most frequent elements:
   - For each element-frequency pair, add it to the heap.
   - If the heap size exceeds k, remove the element with the lowest frequency.
3. Extract all elements from the heap to form the result.

## Complexity

- **Time**: O(n) for bucket sort, O(n log k) for heap approach
- **Space**: O(n) for both approaches (hash map and buckets/heap)

## Link

[LeetCode 0347 Top K Frequent Elements](https://leetcode.com/problems/top-k-frequent-elements/)