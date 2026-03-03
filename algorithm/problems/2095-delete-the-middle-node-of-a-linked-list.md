# 2095 Delete the Middle Node of a Linked List

## Problem Description

You are given the head of a linked list. Delete the middle node, and return the head of the modified linked list. The middle node of a linked list of size n is the ⌊n / 2⌋th node from the start using 0-based indexing. If there is only one node, return an empty list.

### Example 1:
```
Input: head = [1,3,4,7,1,2,6]
Output: [1,3,4,1,2,6]
Explanation: The middle node (7) is removed.
```

### Example 2:
```
Input: head = [1,2,3,4]
Output: [1,2,4]
Explanation: The middle node (3) is removed.
```

### Example 3:
```
Input: head = [2,1]
Output: [2]
Explanation: The middle node (1) is removed.
```

## The Twist

Use slow and fast pointers: when fast (or fast.Next) reaches the end, slow is one step before the middle. Delete the node after slow. Handle n <= 1 with a dummy node or special case.

## Algorithm

1. If head == nil or head.Next == nil, return nil (or head for single node per problem: single node → return nil).
2. Use dummy node; slow, fast := dummy, dummy; advance fast by 2 and slow by 1 until fast reaches end.
3. slow.Next = slow.Next.Next; return dummy.Next.

## Complexity

- **Time**: O(n) — one pass with two pointers.
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
func deleteMiddle(head *ListNode) *ListNode {
	if head == nil || head.Next == nil {
		return nil
	}
	dummy := &ListNode{Next: head}
	slow, fast := dummy, dummy
	for fast.Next != nil && fast.Next.Next != nil {
		slow = slow.Next
		fast = fast.Next.Next
	}
	slow.Next = slow.Next.Next
	return dummy.Next
}
```

## Link

[LeetCode 2095 Delete the Middle Node of a Linked List](https://leetcode.com/problems/delete-the-middle-node-of-a-linked-list/)
