# 0019 Remove Nth Node From End of List

## Problem Description

Given the `head` of a linked list, remove the `n`th node from the end of the list and return its head.

### Example 1:
```
Input: head = [1,2,3,4,5], n = 2
Output: [1,2,3,5]
Explanation: You are given the second node from the end, which is node with value 2. After removing it, the linked list becomes [1,2,3,5].
```

### Example 2:
```
Input: head = [1], n = 1
Output: []
Explanation: The only node is removed.
```

### Example 3:
```
Input: head = [1,2], n = 1
Output: [1]
```

## Two Pointers Approach

This problem can be solved efficiently using the two-pointer technique. We use two pointers with a gap of `n` nodes between them. When the faster pointer reaches the end, the slower pointer will be at the node to be removed.

### Algorithm Steps:

1. Create a dummy node that points to the head of the list
2. Initialize two pointers: `fast` and `slow`, both pointing to the dummy node
3. Move `fast` pointer `n` steps ahead
4. Move both pointers until `fast` reaches the last node
5. Remove the node after `slow` by skipping it
6. Return the dummy's next pointer (the new head)

## Complexity

- **Time**: O(L) - where L is the length of the linked list
- **Space**: O(1) - constant space for pointers

## Solution Code

```go
package main

/**
 * Definition for singly-linked list.
 */
type ListNode struct {
    Val  int
    Next *ListNode
}

func removeNthFromEnd(head *ListNode, n int) *ListNode {
    // Create a dummy node to handle edge cases
    dummy := &ListNode{Next: head}
    fast := dummy
    slow := dummy
    
    // Move fast pointer n steps ahead
    for i := 0; i < n; i++ {
        fast = fast.Next
        if fast == nil {
            return nil // n is larger than the list length
        }
    }
    
    // Move both pointers until fast reaches the end
    for fast.Next != nil {
        fast = fast.Next
        slow = slow.Next
    }
    
    // Remove the node after slow
    slow.Next = slow.Next.Next
    
    return dummy.Next
}
```

## Link

[LeetCode 0019 Remove Nth Node From End of List](https://leetcode.com/problems/remove-nth-node-from-end-of-list/)