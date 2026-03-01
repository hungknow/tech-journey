# 0307 Range Sum Query - Mutable

## Problem Description

Given an integer array `nums`, handle multiple queries of the following types:
1. **Update** the value of an element in `nums`.
2. **Calculate the sum** of the elements of `nums` between indices `left` and `right` inclusive.

Implement the `NumArray` class:
- `NumArray(int[] nums)` Initializes the object with the integer array `nums`.
- `void update(int index, int val)` Updates `nums[index] = nums[index] + val`.
- `int sumRange(int left, int right)` Returns the sum of all the elements `nums[i]` such that `left <= i <= right`.

### Example 1:
```
Input
["NumArray", "sumRange", "update", "sumRange"]
[[[1, 3, 5]], [0, 2], [1, 2], [0, 2]]
Output
[null, 9, null, 8]
```

### Example 2:
```
Input
["NumArray", "sumRange", "sumRange", "update", "sumRange"]
[[[1, 1, 1, 1, 1]], [0, 4], [0, 4], [1, 3], [0, 4]]
Output
[null, 5, null, 10, 4]
```

## The Twist

The array is **mutable** with frequent updates. A naive sumRange would be O(n) per query, which is too slow. We need a data structure that supports both updates and range sum queries efficiently.

## Algorithm

### Binary Indexed Tree (Fenwick Tree):
1. Build BIT from initial array
2. **update**: Add delta to BIT at index, propagate up
3. **sumRange**: Return prefixSum(right) - prefixSum(left - 1)

### Segment Tree:
1. Build segment tree from initial array
2. **update**: Update leaf and propagate changes up
3. **sumRange**: Query segment tree for range sum

## Complexity

- **Constructor**: O(n)
- **update()**: O(log n)
- **sumRange()**: O(log n)
- **Space**: O(n)

## Link

[LeetCode 0307 Range Sum Query - Mutable](https://leetcode.com/problems/range-sum-query-mutable/)
