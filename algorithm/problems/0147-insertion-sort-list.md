# 0147 Insertion Sort List

## Problem Description

Given the `head` of a singly linked list, sort the list using insertion sort, and return the sorted list's head.

### Example 1:
```
Input: head = [4,2,1,3]
Output: [1,2,3,4]
```

### Example 2:
```
Input: head = [-1,5,3,4,0]
Output: [-1,0,3,4,5]
```

## Solution Approach

For insertion sort on a linked list, we maintain a sorted portion and an unsorted portion. We iterate through the unsorted portion and insert each node into its correct position in the sorted portion.

## Algorithm

1. Create a dummy node that will serve as the starting point of the sorted list.
2. Initialize `lastSorted` to point to the head of the original list (this will be the end of our sorted portion).
3. Initialize `curr` to point to `head.next` (this is the first node in the unsorted portion).
4. While `curr` is not null:
   - If `lastSorted.val <= curr.val`, the node is already in the correct position, so move `lastSorted` to `curr` and advance `curr`.
   - Otherwise, we need to insert `curr` into the sorted portion:
     - Start from the dummy node and find the correct position to insert `curr`.
     - Insert `curr` at this position.
     - Update `lastSorted.next` to point to `curr.next`.
     - Advance `curr` to `lastSorted.next`.
5. Return `dummy.next` which is the head of the sorted list.

## Complexity

- **Time**: O(n²) - in the worst case, for each node we might traverse through the entire sorted portion
- **Space**: O(1) - we're rearranging the existing nodes without creating new ones

## Link

[LeetCode 0147 Insertion Sort List](https://leetcode.com/problems/insertion-sort-list/)