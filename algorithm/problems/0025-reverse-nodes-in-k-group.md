# 0025 Reverse Nodes in k-Group

## Problem Description

Given the head of a linked list, reverse the nodes of the list k at a time, and return the modified list. k is a positive integer and is less than or equal to the length of the linked list. If the number of nodes is not a multiple of k then left-out nodes, in the end, should remain as it is.

### Example 1:
```
Input: head = [1,2,3,4,5], k = 2
Output: [2,1,4,3,5]
```

### Example 2:
```
Input: head = [1,2,3,4,5], k = 3
Output: [3,2,1,4,5]
```

## The Twist

Reverse each group of k nodes using the standard in-place reverse (prev, curr, next). After reversing a group, reconnect the previous group's tail to the new head of the reversed group and the new tail to the next group. Use a dummy node to simplify.

## Algorithm

1. Write a helper that reverses a segment of length k and returns (newHead, newTail, nextNode). If fewer than k nodes remain, return without reversing.
2. Use dummy; repeatedly take the next k nodes, reverse them, attach to result, then set curr to the new tail and continue from nextNode until fewer than k nodes remain.
3. Return dummy.Next.

## Complexity

- **Time**: O(n) — each node is visited a constant number of times.
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
func reverseKGroup(head *ListNode, k int) *ListNode {
	dummy := &ListNode{Next: head}
	prev := dummy
	for {
		end := prev
		for i := 0; i < k && end != nil; i++ {
			end = end.Next
		}
		if end == nil {
			break
		}
		nextGroup := end.Next
		// reverse [prev.Next, end]
		curr := prev.Next
		var revPrev *ListNode
		tail := curr
		for curr != nextGroup {
			next := curr.Next
			curr.Next = revPrev
			revPrev = curr
			curr = next
		}
		prev.Next = revPrev
		tail.Next = nextGroup
		prev = tail
	}
	return dummy.Next
}
```

## Link

[LeetCode 25 Reverse Nodes in k-Group](https://leetcode.com/problems/reverse-nodes-in-k-group/)
