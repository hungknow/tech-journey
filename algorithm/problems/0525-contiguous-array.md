# 0525 Contiguous Array

## Problem Description

Given a binary array `nums`, return the maximum length of a contiguous subarray with an equal number of 0 and 1.

### Example 1:
```
Input: nums = [0,1]
Output: 2
Explanation: [0, 1] is the longest contiguous subarray with equal number of 0 and 1.
```

### Example 2:
```
Input: nums = [0,1,0]
Output: 2
```

### Example 3:
```
Input: nums = [0,0,1,0,0,0,1,1]
Output: 6
Explanation: [0, 0, 1, 0, 0, 1, 1] has 3 zeros and 3 ones.
```

## The Twist

We need to find the **longest subarray with equal 0s and 1s**. If we replace 0s with -1, the problem becomes finding the longest subarray with sum 0.

## Algorithm

### Prefix Sum with Hash Map:
1. Replace all 0s with -1
2. Use a hash map to store the first occurrence of each prefix sum
3. Initialize map with {0: -1}
4. Track running sum
5. For each index:
   - Update running sum
   - If sum exists in map, calculate length: current_index - map[sum]
   - Track maximum length
   - If sum not in map, store current index
6. Return maximum length

## Complexity

- **Time**: O(n) - single pass through the array
- **Space**: O(n) - hash map for prefix sums

## Link

[LeetCode 0525 Contiguous Array](https://leetcode.com/problems/contiguous-array/)
