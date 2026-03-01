# 0430 Flatten a Multilevel Doubly Linked List

## Problem Description

You are given a doubly linked list, which contains nodes that have a `next` pointer, a `previous` pointer, and an additional `child` pointer. This child pointer may or may not point to a separate doubly linked list, also containing these special nodes.

Flatten the list so that all the nodes appear in a single-level, doubly linked list. You are given the `head` of the first level of the list.

### Example 1:
```
Input: head = [1,2,3,4,5,6,null,null,null,7,8,9,10,null,null,11,12]
Output: [1,2,3,7,8,11,12,9,10,4,5,6]
```

### Example 2:
```
Input: head = [1,2,null,3]
Output: [1,3,2]
```

### Example 3:
```
Input: head = []
Output: []
```

## The Twist

We need to **flatten a nested structure** into a single level. The child lists should be inserted between the current node and its next node.

## Algorithm

### Iterative Approach:
1. Use a dummy node to simplify edge cases
2. Traverse the list level by level
3. For each node with children:
   - Save the next pointer
   - Insert the child list between current node and next
   - Move to the end of the flattened child list
   - Continue from the saved next pointer
4. Return dummy.next

### Recursive Approach:
1. Recursively flatten the child list
2. Connect the end of the flattened child to the next node
3. Move to the next node and repeat

## Complexity

- **Time**: O(n) - each node visited once
- **Space**: O(1) - constant extra space

## Link

[LeetCode 0430 Flatten a Multilevel Doubly Linked List](https://leetcode.com/problems/flatten-a-multilevel-doubly-linked-list/)
