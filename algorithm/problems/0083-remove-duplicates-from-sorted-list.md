# 0083 Remove Duplicates from Sorted List

## Problem Description

Given the `head` of a sorted linked list, delete all duplicates such that each element appears only once. Return the linked list **sorted** as well.

### Example 1:
```
Input: head = [1,1,2]
Output: [1,2]
```

### Example 2:
```
Input: head = [1,1,2,3,3]
Output: [1,2,3]
```

## The Twist

Keep one node per value and skip all subsequent nodes with the same value. Straightforward in-place traversal.

## Algorithm

1. Traverse from head; for each node, while the next node exists and has the same value, set curr.Next = curr.Next.Next.
2. Then advance curr to curr.Next. Repeat until the end.

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
func deleteDuplicates(head *ListNode) *ListNode {
	curr := head
	for curr != nil && curr.Next != nil {
		if curr.Val == curr.Next.Val {
			curr.Next = curr.Next.Next
		} else {
			curr = curr.Next
		}
	}
	return head
}
```

## Link

[LeetCode 83 Remove Duplicates from Sorted List](https://leetcode.com/problems/remove-duplicates-from-sorted-list/)
