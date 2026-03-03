# 0206 Reverse Linked List

## Problem Description

Given the head of a singly linked list, reverse the list, and return the reversed list.

### Example 1:
```
Input: head = [1,2,3,4,5]
Output: [5,4,3,2,1]
```

### Example 2:
```
Input: head = [1,2]
Output: [2,1]
```

### Example 3:
```
Input: head = []
Output: []
```

## The Twist

Classic in-place reversal: maintain prev, curr, and next; at each step set curr.Next = prev, then advance. No extra stack or new list needed.

## Algorithm

1. Initialize prev = nil, curr = head.
2. While curr != nil: save next = curr.Next, set curr.Next = prev, set prev = curr, curr = next.
3. Return prev (new head).

## Complexity

- **Time**: O(n) — single pass.
- **Space**: O(1) — in-place.

## Solution Code

```go
/**
 * Definition for singly-linked list.
 * type ListNode struct {
 *     Val int
 *     Next *ListNode
 * }
 */
func reverseList(head *ListNode) *ListNode {
	var prev *ListNode
	for head != nil {
		next := head.Next
		head.Next = prev
		prev = head
		head = next
	}
	return prev
}
```

## Link

[LeetCode 206 Reverse Linked List](https://leetcode.com/problems/reverse-linked-list/)
