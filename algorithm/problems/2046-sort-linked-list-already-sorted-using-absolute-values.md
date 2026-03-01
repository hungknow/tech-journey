# 2046 Sort Linked List Already Sorted Using Absolute Values

## Problem Description

Given the head of a singly linked list, return the list after sorting it in absolute order.

The linked list is already sorted in non-decreasing order based on absolute values.

### Example 1:
```
Input: head = [0,2,-5,5,10,-10]
Output: [-10,-5,0,2,5,10]
```

### Example 2:
```
Input: head = [0,1,2]
Output: [0,1,2]
```

## Approach

This problem can be solved using a two-pointer approach combined with insertion sort:

1. Since the list is already sorted by absolute values, we need to reorder it based on actual values.
2. We can use a modified insertion sort approach where we extract nodes one by one and insert them in the correct position.
3. Use two pointers: one to traverse the list and another to find the correct insertion position.

## Solution Code

```go
/**
 * Definition for singly-linked list.
 * type ListNode struct {
 *     Val int
 *     Next *ListNode
 * }
 */
func sortLinkedList(head *ListNode) *ListNode {
    if head == nil || head.Next == nil {
        return head
    }
    
    // Create a dummy node to serve as the new head
    dummy := &ListNode{Next: nil}
    curr := head
    
    for curr != nil {
        next := curr.Next
        prev := dummy
        
        // Find the correct position to insert the current node
        for prev.Next != nil && prev.Next.Val < curr.Val {
            prev = prev.Next
        }
        
        // Insert the current node
        curr.Next = prev.Next
        prev.Next = curr
        
        // Move to the next node in the original list
        curr = next
    }
    
    return dummy.Next
}
```

## Complexity Analysis

- **Time**: O(n^2) - For each node, we might traverse the entire sorted portion
- **Space**: O(1) - We only use a few pointers regardless of the input size

## Link

[LeetCode 2046 Sort Linked List Already Sorted Using Absolute Values](https://leetcode.com/problems/sort-linked-list-already-sorted-using-absolute-values/)