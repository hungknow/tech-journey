# 1409 Queries on a Permutation With Key

## Problem Description

You are given a permutation `nums` of `n` integers from `1` to `n` and an integer `k`. For each query `[i, j]`, return the number of elements in the permutation `nums` that are less than `nums[i]` after the `i`-th element of the permutation.

### Example 1:
```
Input: nums = [7,5,2,6], queries = [[2,2],[4,4],[6,1]]
Output: [2,1,1,0]
Explanation:
- After the 1st query (i=2), nums becomes [7,5,6,2]. Elements less than nums[2]=5 are [2,1]. Count = 2
- After the 2nd query (i=4), nums becomes [7,5,2,6]. Elements less than nums[4]=6 are [2,1]. Count = 2
- After the 3rd query (i=6), nums becomes [7,5,2,6]. Elements less than nums[6]=6 are [2,1]. Count = 0
```

### Example 2:
```
Input: nums = [7,5,5,2,6], queries = [[5,5],[2,2],[7,3],[8,1]]
Output: [2,2,2,1,4,0]
```

## The Twist

The permutation is **modified in place** after each query. We need to efficiently count elements less than `nums[i]` after each permutation step. A naive O(n²) per query would be too slow.

## Algorithm

### Binary Indexed Tree (Fenwick Tree):
1. Use a BIT to maintain frequency counts of values
2. For each query:
   - Get count of elements less than nums[i]
   - Remove nums[i] from the BIT
   - Add nums[i] back to the BIT at its original position
3. Return the count

### Using Sorted List with Pointers:
1. Maintain a sorted list of values with their indices
2. For each query:
   - Use binary search to find the count of elements less than nums[i]
   - Remove nums[i] from the sorted list
   - Add nums[i] back to its original position
3. Return the count

### Using Order Statistics Tree:
1. Use an order statistics tree to maintain counts
2. For each query:
   - Query the tree for count of elements less than nums[i]
   - Remove nums[i] from the tree
   - Add nums[i] back to the tree
3. Return the count

## Complexity

- **Time**: O(n log n) per query with BIT
- **Space**: O(n) - storing the data structure

## Link

[LeetCode 1409 Queries on a Permutation With Key](https://leetcode.com/problems/queries-on-a-permutation-with-key/)
