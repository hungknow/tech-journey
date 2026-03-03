# 1265 Print Immutable Linked List in Reverse

## Problem Description

You are given an immutable linked list, print out all values of each node in reverse with the help of the following interface: ImmutableListNode. You must solve this problem without modifying the linked list. You only have access to getNext() and printValue().

### Example 1:
```
Input: head = [1,2,3,4]
Output: [4,3,2,1]
(printed in reverse order)
```

### Example 2:
```
Input: head = [0,-4,-1,3,-5]
Output: [-5,3,-1,-4,0]
```

## The Twist

Without modifying the list, you can use recursion (stack) to print after recursing to the end—so print in reverse. To achieve O(sqrt(n)) space, use a "block" approach: first pass to find length, then process in blocks and use a stack of size sqrt(n).

## Algorithm

### Recursion (O(n) space):
1. If head == nil, return. Recurse on head.getNext(), then print head.

### Block approach (O(sqrt(n)) space):
1. Count length n. Block size b = ceil(sqrt(n)). Traverse and collect every b-th node (block heads). Then for each block from last to first, use a small stack to print that block in reverse.

## Complexity

- **Time**: O(n) — traverse and print each node.
- **Space**: O(sqrt(n)) — with block approach; O(n) with recursion.

## Solution Code

```go
// ImmutableListNode is the interface (LeetCode defines it).
// type ImmutableListNode interface {
//     getNext() ImmutableListNode
//     printValue()
// }

func printLinkedListInReverse(head ImmutableListNode) {
	if head == nil {
		return
	}
	printLinkedListInReverse(head.getNext())
	head.printValue()
}
```

## Link

[LeetCode 1265 Print Immutable Linked List in Reverse](https://leetcode.com/problems/print-immutable-linked-list-in-reverse/)
