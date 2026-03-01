# 0141 Linked List Cycle

## Problem Description

Given `head`, the head of a linked list, determine if the linked list has a cycle in it.

There is a cycle in a linked list if there is some node in the list that can be reached again by continuously following the `next` pointer. Internally, `pos` is used to denote the index of the node that `tail`'s `next` pointer is connected to. Note that `pos` is not passed as a parameter.

### Example 1:
```
Input: head = [3,2,0,-4]
Output: true
Explanation: There is a cycle in the linked list, where the tail connects to the 1st node (0-indexed).
```

### Example 2:
```
Input: head = [1,2], pos = 0
Output: true
Explanation: There is a cycle in the linked list, where the tail connects to the 0th node.
```

### Example 3:
```
Input: head = [1], pos = -1
Output: false
Explanation: There is no cycle in the linked list.
```

## Two Pointers Approach (Floyd's Tortoise and Hare)

This problem can be solved using Floyd's Tortoise and Hare algorithm. We use two pointers moving at different speeds - one moves twice as fast as the other. If there's a cycle, the fast pointer will eventually meet the slow pointer.

### Algorithm Steps:

1. Initialize two pointers: `slow` and `fast`, both pointing to the head
2. Move `slow` one step at a time and `fast` two steps at a time
3. If `fast` or `fast.Next` becomes null, there's no cycle
4. If `slow` equals `fast`, there's a cycle
5. If a cycle is detected, reset `slow` to the head and move both pointers at the same speed until they meet again
6. The node where they meet is the start of the cycle

## Complexity

- **Time**: O(n) - in the worst case, we traverse the list twice
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

func hasCycle(head *ListNode) bool {
    if head == nil || head.Next == nil {
        return false
    }
    
    slow := head
    fast := head
    
    // Phase 1: Find if there's a cycle
    for fast != nil && fast.Next != nil {
        slow = slow.Next
        fast = fast.Next.Next
        
        if slow == fast {
            return true
        }
    }
    
    // If we reached here, there's no cycle
    return false
}
```

## Alternative Solution Code (with cycle detection and finding the start)

```go
package main

/**
 * Definition for singly-linked list.
 */
type ListNode struct {
    Val  int
    Next *ListNode
}

func hasCycle(head *ListNode) bool {
    if head == nil || head.Next == nil {
        return false
    }
    
    slow := head
    fast := head
    
    // Phase 1: Find meeting point
    hasCycle := false
    for fast != nil && fast.Next != nil {
        slow = slow.Next
        fast = fast.Next.Next
        
        if slow == fast {
            hasCycle = true
            break
        }
    }
    
    if !hasCycle {
        return false
    }
    
    // Phase 2: Find the start of the cycle
    slow = head
    for slow != fast {
        slow = slow.Next
        fast = fast.Next
    }
    
    return true
}
```

## Link

[LeetCode 0141 Linked List Cycle](https://leetcode.com/problems/linked-list-cycle/)