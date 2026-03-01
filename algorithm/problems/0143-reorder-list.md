# 0143 Reorder List

## Problem Description

You are given the head of a singly linked-list. The list can be represented as:

L0 → L1 → … → Ln - 1 → Ln

Reorder the list to be on the following form:

L0 → Ln → L1 → Ln - 1 → L2 → Ln - 2 → …

You may not modify the values in the list's nodes. Only nodes themselves may be changed.

### Example 1:
```
Input: head = [1,2,3,4]
Output: [1,4,2,3]
```

### Example 2:
```
Input: head = [1,2,3,4,5]
Output: [1,5,2,4,3]
```

## Approach

To reorder the list, we can follow these steps:
1. Find the middle of the linked list using the slow and fast pointer technique.
2. Reverse the second half of the linked list.
3. Merge the first half and the reversed second half alternately.

This approach uses O(1) extra space and runs in O(n) time.

## Solution Code

```go
/**
 * Definition for singly-linked list.
 * type ListNode struct {
 *     Val int
 *     Next *ListNode
 * }
 */
func reorderList(head *ListNode) {
    if head == nil || head.Next == nil {
        return
    }
    
    // Step 1: Find the middle of the list
    slow, fast := head, head
    for fast.Next != nil && fast.Next.Next != nil {
        slow = slow.Next
        fast = fast.Next.Next
    }
    
    // Step 2: Reverse the second half of the list
    prev, curr := (*ListNode)(nil), slow.Next
    slow.Next = nil // Split the list into two halves
    for curr != nil {
        nextTemp := curr.Next
        curr.Next = prev
        prev = curr
        curr = nextTemp
    }
    
    // Step 3: Merge the two halves
    first, second := head, prev
    for second != nil {
        temp1, temp2 := first.Next, second.Next
        first.Next = second
        second.Next = temp1
        first, second = temp1, temp2
    }
}
```

## Complexity Analysis

- **Time**: O(n) - We traverse the list a constant number of times
- **Space**: O(1) - We only use a few pointers regardless of the input size

## Link

[LeetCode 0143 Reorder List](https://leetcode.com/problems/reorder-list/)