# 0142 Linked List Cycle II

## Problem Description

Given a linked list, return the node where the cycle begins. If there is no cycle, return `null`.

There is a cycle in a linked list if there is some node in the list that can be reached again by continuously following the `next` pointer. Internally, `pos` is used to denote the index of the node that tail's `next` pointer is connected to. Note that `pos` is not passed as a parameter.

Notice that you should not modify the linked list.

### Example 1:
```
Input: head = [3,2,0,-4], pos = 1
Output: tail connects to node index 1
Explanation: There is a cycle in the linked list, where tail connects to the second node.
```

### Example 2:
```
Input: head = [1,2], pos = 0
Output: tail connects to node index 0
Explanation: There is a cycle in the linked list, where tail connects to the first node.
```

### Example 3:
```
Input: head = [1], pos = -1
Output: no cycle
Explanation: There is no cycle in the linked list.
```

## Approach

The Floyd's Tortoise and Hare algorithm can be used to detect a cycle in a linked list. The algorithm uses two pointers, one moving at twice the speed of the other. If there is a cycle, the two pointers will eventually meet.

To find the start of the cycle, we can use the following approach:
1. Use Floyd's algorithm to detect if there's a cycle and find a meeting point.
2. If there's a cycle, reset one pointer to the head and move both pointers at the same speed until they meet again. The meeting point will be the start of the cycle.

## Solution Code

```go
/**
 * Definition for singly-linked list.
 * type ListNode struct {
 *     Val int
 *     Next *ListNode
 * }
 */
func detectCycle(head *ListNode) *ListNode {
    if head == nil || head.Next == nil {
        return nil
    }
    
    slow, fast := head, head
    
    // First phase: Check if there's a cycle
    for fast != nil && fast.Next != nil {
        slow = slow.Next
        fast = fast.Next.Next
        
        if slow == fast {
            // Second phase: Find the start of the cycle
            slow = head
            for slow != fast {
                slow = slow.Next
                fast = fast.Next
            }
            return slow
        }
    }
    
    return nil
}
```

## Complexity Analysis

- **Time**: O(n) - We traverse the list at most twice
- **Space**: O(1) - We only use two pointers regardless of the input size

## Link

[LeetCode 0142 Linked List Cycle II](https://leetcode.com/problems/linked-list-cycle-ii/)