# 2181 Merge Nodes in Between Zeros

## Problem Description

You are given the head of a linked list, which contains a series of integers separated by 0's. The beginning and end of the linked list will have Node.val == 0. For every two consecutive 0's, merge all the nodes lying in between them into a single node whose value is the sum of all the merged nodes. Return the head of the modified list.

### Example 1:
```
Input: head = [0,3,1,0,4,5,2,0]
Output: [4,11]
Explanation: Between first and second 0: 3+1 = 4. Between second and third 0: 4+5+2 = 11.
```

### Example 2:
```
Input: head = [0,1,0,3,0,2,2,0]
Output: [1,3,4]
```

## The Twist

Traverse and whenever you see a 0, either start summing (after the first 0) or finish the current sum, create a new node, and attach it. Use a dummy to simplify head handling.

## Algorithm

1. Use dummy node; skip the first 0. Traverse with a runner, summing values until the next 0.
2. When you hit a 0, append a new node with the current sum to the result list, reset sum to 0, continue.
3. Return dummy.Next.

## Complexity

- **Time**: O(n) — single pass.
- **Space**: O(1) — in-place (only new nodes for merged values).

## Solution Code

```go
/**
 * Definition for singly-linked list.
 * type ListNode struct {
 *     Val int
 *     Next *ListNode
 * }
 */
func mergeNodes(head *ListNode) *ListNode {
	dummy := &ListNode{}
	tail := dummy
	head = head.Next
	for head != nil {
		sum := 0
		for head != nil && head.Val != 0 {
			sum += head.Val
			head = head.Next
		}
		if sum > 0 {
			tail.Next = &ListNode{Val: sum}
			tail = tail.Next
		}
		if head != nil {
			head = head.Next
		}
	}
	return dummy.Next
}
```

## Link

[LeetCode 2181 Merge Nodes in Between Zeros](https://leetcode.com/problems/merge-nodes-in-between-zeros/)
