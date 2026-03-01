# 0976 Largest Perimeter Triangle

## Problem Description

Given an integer array `nums`, return the largest perimeter of a triangle with a non-zero area, formed from three of these lengths. If it is impossible to form any triangle, return `0`.

### Example 1:
```
Input: nums = [2,1,2]
Output: 5
```

### Example 2:
```
Input: nums = [1,2,1]
Output: 0
```

## Solution Approach

For three lengths to form a triangle, the sum of any two sides must be greater than the third side. To find the largest perimeter, we should look for the largest valid sides.

## Algorithm

1. Sort the array in descending order.
2. Iterate through the sorted array:
   - For each triplet of consecutive elements (a, b, c) where a ≥ b ≥ c:
     - If b + c > a, then these three sides can form a triangle.
     - Since we're iterating from largest to smallest, this will be the largest perimeter.
     - Return a + b + c.
3. If no valid triangle is found, return 0.

## Why This Works

After sorting in descending order, if three consecutive elements (a, b, c) don't satisfy b + c > a, then no larger elements can form a valid triangle with c. This is because any larger element would make the inequality even harder to satisfy.

## Complexity

- **Time**: O(n log n) - dominated by the sorting step
- **Space**: O(1) - we can sort in-place (or O(n) if using extra space for sorting)

## Link

[LeetCode 0976 Largest Perimeter Triangle](https://leetcode.com/problems/largest-perimeter-triangle/)