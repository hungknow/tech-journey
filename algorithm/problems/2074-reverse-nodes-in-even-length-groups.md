# 2074 Reverse Nodes in Even Length Groups

## Problem Description

You are given the head of a linked list. The nodes in the linked list are sequentially assigned to non-empty groups whose lengths form the sequence of the natural numbers (1, 2, 3, 4, ...). The length of a group is the number of nodes assigned to it. Reverse the nodes in each group with an even length, and return the head of the modified linked list.

### Example 1:
```
Input: head = [5,2,6,3,9,1,7,3,8,4]
Output: [5,6,2,3,9,1,4,8,3,7]
Explanation: Groups: (5), (2,6), (3,9,1), (7,3,8,4). Reverse even-length groups (2,6) and (7,3,8,4).
```

### Example 2:
```
Input: head = [1,1,0,6]
Output: [1,0,1,6]
```

## The Twist

Traverse the list in chunks of size 1, 2, 3, 4, ... For each chunk, if the actual size is even, reverse that segment in-place before moving on. Track the node before the chunk and the node after to reconnect.

## Algorithm

1. Use dummy; prev = dummy. Group index g = 1 (group size).
2. While there are nodes: collect exactly g nodes (or until end). If the count is even, reverse this segment; attach prev to the new head and the new tail to the rest. Set prev to the tail of this group, advance by g, increment g.
3. Return dummy.Next.

## Complexity

- **Time**: O(n) — each node processed a constant number of times.
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
func reverseEvenLengthGroups(head *ListNode) *ListNode {
	dummy := &ListNode{Next: head}
	prev := dummy
	g := 1
	for prev.Next != nil {
		var tail *ListNode
		curr := prev.Next
		count := 0
		for count < g && curr != nil {
			tail = curr
			curr = curr.Next
			count++
		}
		if count%2 == 0 {
			// reverse [prev.Next, tail]
			start := prev.Next
			var revPrev *ListNode
			node := start
			for node != curr {
				next := node.Next
				node.Next = revPrev
				revPrev = node
				node = next
			}
			prev.Next = revPrev
			start.Next = curr
			prev = start
		} else {
			prev = tail
		}
		g++
	}
	return dummy.Next
}
```

## Link

[LeetCode 2074 Reverse Nodes in Even Length Groups](https://leetcode.com/problems/reverse-nodes-in-even-length-groups/)
