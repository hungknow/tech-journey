# 0315 Count of Smaller Numbers After Self

## Problem Description

Given an integer array `nums`, return an integer array `counts` where `counts[i]` is the number of smaller elements to the right of `nums[i]`.

### Example 1:
```
Input: nums = [5,2,6,1]
Output: [2,1,1,0]
Explanation:
- To the right of 5 there are 2 smaller elements (2 and 1).
- To the right of 2 there is just 1 smaller element (1).
- To the right of 6 there is 1 smaller element (1).
- To the right of 1 there is 0 smaller element.
```

### Example 2:
```
Input: nums = [-1]
Output: [0]
```

### Example 3:
```
Input: nums = [-1,-1]
Output: [0,0]
```

## The Twist

For each element, we need to count how many smaller elements appear **after it**. This requires efficient counting as we process elements from right to left.

## Algorithm

### Binary Indexed Tree (Fenwick Tree):
1. Coordinate compression: map all values to indices 1 to n
2. Process from right to left:
   - Query BIT for count of elements smaller than current
   - Add current element to BIT
3. Return results

### Merge Sort (Divide and Conquer):
1. During merge sort, count inversions
2. When merging, if left element > right element, all remaining left elements are greater
3. Track the count of smaller elements for each position

### Binary Search Tree:
1. Process from right to left
2. Maintain a BST with size of each subtree
3. For each element, query count of nodes smaller than it
4. Insert current element into BST

## Complexity

- **Time**: O(n log n) - all approaches
- **Space**: O(n) - storing results and auxiliary structures

## Link

[LeetCode 0315 Count of Smaller Numbers After Self](https://leetcode.com/problems/count-of-smaller-numbers-after-self/)
