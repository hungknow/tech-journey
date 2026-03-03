# 0082 Remove Duplicates from Sorted List II

## Problem Description

Given the `head` of a sorted linked list, **delete all nodes that have duplicate numbers**, leaving only distinct numbers from the original list. Return the linked list **sorted** as well.

### Example 1:
```
Input: head = [1,2,3,3,4,4,5]
Output: [1,2,5]
Explanation: Nodes 3 and 4 are duplicated; all such nodes are removed.
```

### Example 2:
```
Input: head = [1,1,1,2,3]
Output: [2,3]
Explanation: All 1s are removed.
```

## The Twist

You must remove every node whose value appears more than once, not just leave one copy. Use a dummy node and only append a node when you know it is not part of a duplicate run.

## Algorithm

1. Use a dummy node before the head; maintain a tail for the "distinct" list.
2. Traverse with a pointer; for each run of equal values, determine if the run length is 1.
3. If the current value appears only once (next is nil or different), append that node to the distinct list and advance tail.
4. Otherwise skip the entire run and continue. Return dummy.Next.

## Complexity

- **Time**: O(n) — single pass.
- **Space**: O(1) — in-place with a few pointers.

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
	dummy := &ListNode{Next: head}
	tail := dummy
	for head != nil {
		if head.Next != nil && head.Next.Val == head.Val {
			val := head.Val
			for head != nil && head.Val == val {
				head = head.Next
			}
			continue
		}
		tail.Next = head
		tail = tail.Next
		head = head.Next
	}
	tail.Next = nil
	return dummy.Next
}
```

## Link

[LeetCode 82 Remove Duplicates from Sorted List II](https://leetcode.com/problems/remove-duplicates-from-sorted-list-ii/)
