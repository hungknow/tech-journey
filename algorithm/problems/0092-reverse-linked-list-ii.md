# 0092 Reverse Linked List II

## Problem Description

Given the head of a singly linked list and two integers left and right where left <= right, reverse the nodes of the list from position left to position right, and return the reversed list. Positions are 1-based.

### Example 1:
```
Input: head = [1,2,3,4,5], left = 2, right = 4
Output: [1,4,3,2,5]
```

### Example 2:
```
Input: head = [5], left = 1, right = 1
Output: [5]
```

## The Twist

Find the node before position left and the node at position right. Reverse the segment between them in-place, then reconnect the previous part to the new head of the segment and the new tail to the rest of the list.

## Algorithm

1. Use a dummy node. Advance (left-1) steps to get the node before the segment (prev). The segment starts at prev.Next.
2. Reverse (right - left + 1) nodes: classic reverse, keeping track of the new head and tail of the segment.
3. Connect prev.Next (old head, now tail of reversed segment) to the node after the segment; connect prev to the new head of the segment. Return dummy.Next.

## Complexity

- **Time**: O(n) — single pass to find position, then reverse segment.
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
func reverseBetween(head *ListNode, left int, right int) *ListNode {
	dummy := &ListNode{Next: head}
	prev := dummy
	for i := 0; i < left-1; i++ {
		prev = prev.Next
	}
	curr := prev.Next
	var revPrev *ListNode
	for i := 0; i < right-left+1; i++ {
		next := curr.Next
		curr.Next = revPrev
		revPrev = curr
		curr = next
	}
	prev.Next.Next = curr
	prev.Next = revPrev
	return dummy.Next
}
```

## Link

[LeetCode 92 Reverse Linked List II](https://leetcode.com/problems/reverse-linked-list-ii/)
