# 0021 Merge Two Sorted Lists

## Problem Description

You are given the heads of two sorted linked lists `list1` and `list2`. Merge the two lists into one **sorted** list. The list should be made by splicing together the nodes of the first two lists. Return the head of the merged linked list.

### Example 1:
```
Input: list1 = [1,2,4], list2 = [1,3,4]
Output: [1,1,2,3,4,4]
Explanation: The two lists are merged and sorted.
```

### Example 2:
```
Input: list1 = [], list2 = []
Output: []
```

### Example 3:
```
Input: list1 = [], list2 = [0]
Output: [0]
```

## The Twist

Merge in-place by repeatedly choosing the smaller head of the two lists and advancing that pointer. No extra array or recursion stack needed if done iteratively with a dummy node.

## Algorithm

### Iterative (two pointers):
1. Create a dummy node and a tail pointer.
2. While both lists are non-empty, compare the current nodes: append the smaller one to tail and advance that list's pointer.
3. Append the remaining non-empty list to tail.
4. Return dummy.Next.

## Complexity

- **Time**: O(n) — single pass over both lists.
- **Space**: O(1) — only a few pointers (excluding the result list).

## Solution Code

```go
/**
 * Definition for singly-linked list.
 * type ListNode struct {
 *     Val int
 *     Next *ListNode
 * }
 */
func mergeTwoLists(list1 *ListNode, list2 *ListNode) *ListNode {
	dummy := &ListNode{}
	tail := dummy
	for list1 != nil && list2 != nil {
		if list1.Val <= list2.Val {
			tail.Next = list1
			list1 = list1.Next
		} else {
			tail.Next = list2
			list2 = list2.Next
		}
		tail = tail.Next
	}
	if list1 != nil {
		tail.Next = list1
	} else {
		tail.Next = list2
	}
	return dummy.Next
}
```

## Link

[LeetCode 21 Merge Two Sorted Lists](https://leetcode.com/problems/merge-two-sorted-lists/)
