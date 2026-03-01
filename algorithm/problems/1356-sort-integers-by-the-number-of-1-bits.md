# 1356 Sort Integers by The Number of 1 Bits

## Problem Description

Given an integer array `arr`, sort the array in ascending order by the number of 1's in their binary representation. If two numbers have the same number of 1's, they should be sorted in ascending order.

Return the sorted array.

### Example 1:
```
Input: arr = [0,1,2,3,4,5,6,7,8]
Output: [0,1,2,4,8,3,5,6,7]
Explanation: [0] is the only number with 0 bits.
[1,2,4,8] have 1 bit.
[3,5,6] have 2 bits.
[7] has 3 bits.
The sorted array by bits is [0,1,2,4,8,3,5,6,7].
```

### Example 2:
```
Input: arr = [1024,512,256,128,64,32,16,8,4,2,1]
Output: [1,2,4,8,16,32,64,128,256,512,1024]
```

## Solution Approach

We need to sort the array based on two criteria:
1. Primary: Number of 1's in the binary representation (ascending)
2. Secondary: The actual value (ascending)

## Algorithm

1. Define a function to count the number of 1's in the binary representation of a number:
   - Use built-in bit count function if available.
   - Or use Brian Kernighan's algorithm: repeatedly clear the least significant 1 bit.
2. Sort the array using a custom comparator:
   - First compare by the number of 1's.
   - If equal, compare by the actual value.
3. Return the sorted array.

## Alternative Algorithm (Counting Sort)

Since the maximum number of 1's is limited (at most 32 for a 32-bit integer):
1. Create buckets for each possible count of 1's (0 to 32).
2. For each number in the array, count its 1's and place it in the corresponding bucket.
3. Sort each bucket individually.
4. Concatenate all buckets in order.
5. Return the result.

## Complexity

- **Time**: O(n log n) for sorting approach, O(n log m) for bucket sort where m is the maximum value
- **Space**: O(1) for sorting approach, O(n) for bucket sort

## Link

[LeetCode 1356 Sort Integers by The Number of 1 Bits](https://leetcode.com/problems/sort-integers-by-the-number-of-1-bits/)