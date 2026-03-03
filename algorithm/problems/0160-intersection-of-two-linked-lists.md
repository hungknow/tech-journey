# 0160 Intersection of Two Linked Lists

## Problem Description

Given the heads of two singly linked lists headA and headB, return the node at which the two lists intersect. If the two linked lists have no intersection at all, return null. The linked lists must retain their original structure after the function returns.

### Example 1:
```
Input: intersectVal = 8, listA = [4,1,8,4,5], listB = [5,6,1,8,4,5], skipA = 2, skipB = 3
Output: Reference to the node with value 8
Explanation: The lists intersect at node 8.
```

### Example 2:
```
Input: intersectVal = 2, listA = [1,9,1,2,4], listB = [3,2,4], skipA = 3, skipB = 1
Output: Reference to the node with value 2
```

### Example 3:
```
Input: intersectVal = 0, listA = [2,6,4], listB = [1,5]
Output: null
```

## The Twist

If you align the two lists so their tails match (by having two pointers traverse A then B, and B then A), they will meet at the intersection node after exactly (length of A before intersection + length of B before intersection + common length) steps, or both become nil if no intersection.

## Algorithm

1. Use two pointers pA = headA, pB = headB.
2. Advance both: when pA reaches end, set pA = headB; when pB reaches end, set pB = headA.
3. Continue until pA == pB (either both at intersection node or both nil). Return pA.

## Complexity

- **Time**: O(m + n) — each pointer traverses at most two lists.
- **Space**: O(1) — two pointers only.

## Solution Code

```go
/**
 * Definition for singly-linked list.
 * type ListNode struct {
 *     Val int
 *     Next *ListNode
 * }
 */
func getIntersectionNode(headA, headB *ListNode) *ListNode {
	a, b := headA, headB
	for a != b {
		if a != nil {
			a = a.Next
		} else {
			a = headB
		}
		if b != nil {
			b = b.Next
		} else {
			b = headA
		}
	}
	return a
}
```

## Link

[LeetCode 160 Intersection of Two Linked Lists](https://leetcode.com/problems/intersection-of-two-linked-lists/)
