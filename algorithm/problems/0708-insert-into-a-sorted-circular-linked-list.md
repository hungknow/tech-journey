# 0708 Insert into a Sorted Circular Linked List

## Problem Description

Given a circular linked list which is sorted in ascending order, write a function to insert a value insertVal into the list such that it remains a sorted circular list. The given node can be a reference to any single node in the list and may not necessarily be the smallest value in the circular list. If the list is empty, create a new single circular list and return the reference to that single node.

### Example 1:
```
Input: head = [3,4,1], insertVal = 2
Output: [3,4,1,2]
Explanation: Insert 2 between 1 and 3.
```

### Example 2:
```
Input: head = [], insertVal = 1
Output: [1]
```

### Example 3:
```
Input: head = [1], insertVal = 0
Output: [1,0]
```

## The Twist

Handle edge cases: empty list, single node, and the wrap-around (insert between tail and head). Find the correct position by traversing until you find adjacent nodes (prev, next) such that prev.Val <= insertVal <= next.Val, or you've done one full loop (insert at any position, e.g. after max).

## Algorithm

1. If head is nil, create a new node with insertVal, point its Next to itself, return it.
2. Traverse from head; find the insertion point: either prev.Val <= insertVal <= curr.Val (normal), or at the boundary (prev.Val > curr.Val and insertVal >= prev.Val or insertVal <= curr.Val). After one full loop, insert after the last node.
3. Insert the new node and return head.

## Complexity

- **Time**: O(n) — one pass through the list.
- **Space**: O(1) — in-place.

## Solution Code

```go
/**
 * Definition for a Node.
 * type Node struct {
 *     Val int
 *     Next *Node
 * }
 */
func insert(head *Node, insertVal int) *Node {
	newNode := &Node{Val: insertVal}
	if head == nil {
		newNode.Next = newNode
		return newNode
	}
	prev, curr := head, head.Next
	for curr != head {
		if (prev.Val <= insertVal && insertVal <= curr.Val) ||
			(prev.Val > curr.Val && (insertVal >= prev.Val || insertVal <= curr.Val)) {
			prev.Next = newNode
			newNode.Next = curr
			return head
		}
		prev, curr = curr, curr.Next
	}
	prev.Next = newNode
	newNode.Next = curr
	return head
}
```

## Link

[LeetCode 708 Insert into a Sorted Circular Linked List](https://leetcode.com/problems/insert-into-a-sorted-circular-linked-list/)
