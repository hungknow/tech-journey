# 1968 Array With Elements Not Equal to Average of Neighbors

## Problem Description

You are given an integer array `nums`. Rearrange the array such that for every `i` (0-indexed), `nums[i]` is not equal to the average of its neighbors.

The average of neighbors for `nums[i]` is `(nums[i-1] + nums[i+1]) / 2` if both neighbors exist, or `nums[i]` if only one neighbor exists.

Return the rearranged array.

### Example 1:
```
Input: nums = [1,2,3,4,5]
Output: [1,2,3,4,5]
Explanation: 
No element needs to be moved as all elements already satisfy the condition.
```

### Example 2:
```
Input: nums = [6,2,0,3,5]
Output: [6,2,0,3,5]
Explanation: 
No element needs to be moved as all elements already satisfy the condition.
```

### Example 3:
```
Input: nums = [1,5,2,6,3]
Output: [1,2,6,3,5]
Explanation: 
Original: [1,5,2,6,3]
Rearranged: [1,2,6,3,5]
Now 2 is not equal to (1+3)/2 = 2, and 6 is not equal to (5+3)/2 = 4.
```

## Solution Approach

This is a variant of the Wiggle Sort II problem. We need to arrange the array so that no element is equal to the average of its neighbors.

## Algorithm

1. Find the median of the array using quickselect (O(n) average time).
2. Create a virtual indexed array to help with placement:
   - For index `i`, the virtual index is `(1 + 2*i) % (n | 1)`.
   - This maps indices in the order: 1, 3, 5, ..., 0, 2, 4, ...
3. Use three-way partitioning (Dutch National Flag) to place elements:
   - Elements greater than the median go to the first part (odd indices).
   - Elements equal to the median go to the middle part.
   - Elements less than the median go to the last part (even indices).
4. Iterate through the virtual indices and place elements accordingly.

## Why This Works

By using the median as a pivot and placing larger elements at odd indices and smaller elements at even indices, we ensure no element is equal to the average of its neighbors.

## Complexity

- **Time**: O(n) on average - quickselect to find median and single pass for partitioning
- **Space**: O(1) - in-place rearrangement with constant extra space

## Link

[LeetCode 1968 Array With Elements Not Equal to Average of Neighbors](https://leetcode.com/problems/array-with-elements-not-equal-to-average-of-neighbors/)