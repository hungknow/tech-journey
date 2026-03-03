# 1836 Remove Duplicates From an Unsorted Linked List

## Problem Description

Given the head of a linked list, remove all nodes that have duplicate values, leaving only nodes with unique values. Return the linked list sorted as well. (LeetCode Premium)

### Example 1:
```
Input: head = [1,2,3,2,1]
Output: [3]
Explanation: Values 1 and 2 appear more than once; only 3 is unique.
```

### Example 2:
```
Input: head = [1,1,2,2,3]
Output: [3]
```

## The Twist

Because the list is unsorted, use a hash set to count (or record seen) values in one pass, then a second pass to build the result keeping only nodes whose value appears once. Alternatively: one pass to count, then filter.

## Algorithm

1. First pass: traverse and count each value in a map.
2. Second pass: use a dummy node; append only nodes whose value has count 1; skip others. Return dummy.Next.

## Complexity

- **Time**: O(n) — two passes.
- **Space**: O(n) — hash map for counts.

## Solution Code

```go
/**
 * Definition for singly-linked list.
 * type ListNode struct {
 *     Val int
 *     Next *ListNode
 * }
 */
func deleteDuplicatesUnsorted(head *ListNode) *ListNode {
	count := make(map[int]int)
	for p := head; p != nil; p = p.Next {
		count[p.Val]++
	}
	dummy := &ListNode{}
	tail := dummy
	for head != nil {
		if count[head.Val] == 1 {
			tail.Next = head
			tail = tail.Next
		}
		head = head.Next
	}
	tail.Next = nil
	return dummy.Next
}
```

## Link

[LeetCode 1836 Remove Duplicates From an Unsorted Linked List](https://leetcode.com/problems/remove-duplicates-from-an-unsorted-linked-list/)
