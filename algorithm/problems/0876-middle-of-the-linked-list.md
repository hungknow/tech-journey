# 0876 Middle of the Linked List

## Problem Description

Given the head of a singly linked list, return the middle node of the linked list.

If the number of nodes in the linked list is even, there will be two middle nodes, so return the second middle node.

### Example 1:
```
Input: head = [1,2,3,4,5]
Output: [3,4,5]
Explanation: The middle node of the list is node 3.
```

### Example 2:
```
Input: head = [1,2,3,4,5,6]
Output: [4,5,6]
Explanation: Since the list has two middle nodes with values 3 and 4, we return the second one.
```

## Approach

This problem can be efficiently solved using the Floyd's Tortoise and Hare algorithm, which uses two pointers moving at different speeds:

1. Initialize two pointers, `slow` and `fast`, both pointing to the head of the list.
2. Move the `slow` pointer one step at a time and the `fast` pointer two steps at a time.
3. When the `fast` pointer reaches the end of the list, the `slow` pointer will be at the middle node.

This approach works because when the `fast` pointer has traversed twice as many nodes as the `slow` pointer, the `slow` pointer will be at the middle of the list.

## Solution Code

```go
/**
 * Definition for singly-linked list.
 * type ListNode struct {
 *     Val int
 *     Next *ListNode
 * }
 */
func middleNode(head *ListNode) *ListNode {
    slow, fast := head, head
    
    // Move fast pointer twice as fast as slow pointer
    for fast != nil && fast.Next != nil {
        slow = slow.Next
        fast = fast.Next.Next
    }
    
    return slow
}
```

## Complexity Analysis

- **Time**: O(n) - We traverse the list once with the fast pointer
- **Space**: O(1) - We only use two pointers regardless of the input size

## Link

[LeetCode 0876 Middle of the Linked List](https://leetcode.com/problems/middle-of-the-linked-list/)