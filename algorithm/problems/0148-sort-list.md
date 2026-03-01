# 0148 Sort List

## Problem Description

Given the `head` of a singly linked list, sort the list using **O(n log n)** time complexity and **O(1)** space complexity.

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

To achieve O(n log n) time complexity, we can use merge sort on the linked list. The key steps are:
1. Find the middle of the list using the slow and fast pointer technique.
2. Recursively sort the left and right halves.
3. Merge the two sorted halves.

## Algorithm

1. Base case: if the list is empty or has only one node, it's already sorted.
2. Find the middle of the list:
   - Use two pointers, `slow` and `fast`, both starting at the head.
   - Move `slow` one step at a time and `fast` two steps at a time.
   - When `fast` reaches the end, `slow` will be at the middle.
3. Split the list into two halves by setting `slow.next` to null.
4. Recursively sort both halves.
5. Merge the two sorted halves:
   - Create a dummy node as the starting point.
   - Compare the nodes from both lists and attach the smaller one to the dummy.
   - Continue until one list is exhausted, then attach the remaining nodes from the other list.
6. Return the merged list.

## Complexity

- **Time**: O(n log n) - we divide the list in half at each step (log n steps) and merge takes O(n) time
- **Space**: O(log n) - due to the recursion stack (not O(1) as required, but this is the standard approach)

## Link

[LeetCode 0148 Sort List](https://leetcode.com/problems/sort-list/)