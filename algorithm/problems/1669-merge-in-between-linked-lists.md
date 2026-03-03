# 1669 Merge In Between Linked Lists

## Problem Description

You are given two linked lists: list1 and list2 of sizes n and m respectively. Remove list1's nodes from the ath node to the bth node (1-based), and put list2 in their place.

### Example 1:
```
Input: list1 = [10,1,13,6,9,5], a = 3, b = 4, list2 = [1000000,1000001,1000002]
Output: [10,1,1000000,1000001,1000002,5]
Explanation: We remove the nodes 3 and 4 and put list2 in their place.
```

### Example 2:
```
Input: list1 = [0,1,2,3,4,5], a = 1, b = 3, list2 = [1000000,1000001,1000002]
Output: [1000000,1000001,1000002,4,5]
```

## The Twist

Find the (a-1)-th node (node before the removed segment) and the (b+1)-th node (node after). Link the (a-1)-th node to list2's head and list2's tail to the (b+1)-th node. One pass with a counter or two passes (one to get lengths) is enough.

## Algorithm

1. Traverse list1 to find the node at position a-1 (prev) and the node at position b (so that prev.Next is the start of the removed segment and we need the node after b).
2. Find the last node of list2.
3. Set prev.Next = list2; set list2_tail.Next = node after b. Return list1.

## Complexity

- **Time**: O(m + n) — traverse list1 to find positions, list2 to find tail.
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
func mergeInBetween(list1 *ListNode, a int, b int, list2 *ListNode) *ListNode {
	prev := list1
	for i := 0; i < a-1; i++ {
		prev = prev.Next
	}
	curr := prev
	for i := 0; i < b-a+2; i++ {
		curr = curr.Next
	}
	tail2 := list2
	for tail2.Next != nil {
		tail2 = tail2.Next
	}
	prev.Next = list2
	tail2.Next = curr
	return list1
}
```

## Link

[LeetCode 1669 Merge In Between Linked Lists](https://leetcode.com/problems/merge-in-between-linked-lists/)
