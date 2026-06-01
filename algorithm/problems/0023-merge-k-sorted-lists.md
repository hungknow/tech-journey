# 0023 Merge k Sorted Lists

## Problem Description

You are given an array of `k` linked lists `lists`, each linked list is sorted in ascending order. Merge all the linked lists into one sorted linked list and return its head.

### Example 1:
```
Input: lists = [[1,4,5],[1,3,4],[2,6]]
Output: [1,1,2,3,4,4,5,6]
Explanation: The linked lists are [1->4->5], [1->3->4], and [2->6]. Merging them into one sorted list: 1->1->2->3->4->4->5->6.
```

### Example 2:
```
Input: lists = []
Output: []
```

### Example 3:
```
Input: lists = [[]]
Output: []
```

## The Twist

**Why min-heap helps:**

Without a heap, each time we need to pick the smallest node, we must scan all k list heads. Since we do this n times (once per node), total time is O(n·k). This is inefficient when k is large.

**Key insight:** All k lists are already sorted, so the minimum element is always at one of the k current heads. We only care about the minimum, not all elements. A min-heap gives us exactly this — O(log k) to get the minimum, O(log k) to insert a new element.

**Example walk-through:**

Lists: `[1→4→5]`, `[1→3→4]`, `[2→6]`

Initial heap after pushing heads: `[1@L1, 1@L2, 2@L3]` (value@list)

- Step 1: Pop 1@L1 → result: `1`, push 4@L2 → heap: `[1@L2, 2@L3, 4@L1]`
- Step 2: Pop 1@L2 → result: `1→1`, push 3@L2 → heap: `[2@L3, 3@L2, 4@L1]`
- Step 3: Pop 2@L3 → result: `1→1→2`, push 6@L3 → heap: `[3@L2, 4@L1, 6@L3]`
- Step 4: Pop 3@L2 → result: `1→1→2→3`, push 4@L2 → heap: `[4@L1, 4@L2, 6@L3]`
- Step 5: Pop 4@L1 → result: `1→1→2→3→4`, push 5@L1 → heap: `[4@L2, 5@L1, 6@L3]`
- ... continues until heap empty

Each pop/push is O(log k) instead of O(k) scan.

## Algorithm

### Min-heap approach:
1. Push the head of each non-empty list into a min-heap (keyed by node value).
2. Pop the minimum node, append it to the result, and if that list has a next node, push that next node into the heap.
3. Repeat until the heap is empty. Return the head of the merged list.

### Divide and conquer (alternative):
1. Pair up lists and merge each pair (like merge sort).
2. Repeat until one list remains. Time O(n log k), space O(log k) for recursion.

## Complexity

- **Time**: O(n log k) — n total nodes, heap operations O(log k).
- **Space**: O(1) — heap stores k list pointers (or O(log k) for divide-and-conquer recursion).

## Solution Code

```go
/**
 * Definition for singly-linked list.
 * type ListNode struct {
 *     Val int
 *     Next *ListNode
 * }
 */
import "container/heap"

type minHeap []*ListNode

func (h minHeap) Len() int           { return len(h) }
func (h minHeap) Less(i, j int) bool { return h[i].Val < h[j].Val }
func (h minHeap) Swap(i, j int)      { h[i], h[j] = h[j], h[i] }
func (h *minHeap) Push(x any)        { *h = append(*h, x.(*ListNode)) }
func (h *minHeap) Pop() any {
	old := *h
	n := len(old)
	x := old[n-1]
	*h = old[0 : n-1]
	return x
}

func mergeKLists(lists []*ListNode) *ListNode {
	h := &minHeap{}
	heap.Init(h)
	for _, l := range lists {
		if l != nil {
			heap.Push(h, l)
		}
	}
	dummy := &ListNode{}
	tail := dummy
	for h.Len() > 0 {
		node := heap.Pop(h).(*ListNode)
		tail.Next = node
		tail = tail.Next
		if node.Next != nil {
			heap.Push(h, node.Next)
		}
	}
	return dummy.Next
}
```

### Divide and conquer approach:

```go
func mergeKLists(lists []*ListNode) *ListNode {
	if len(lists) == 0 {
		return nil
	}
	for len(lists) > 1 {
		merged := []*ListNode{}
		for i := 0; i < len(lists); i += 2 {
			if i+1 < len(lists) {
				merged = append(merged, mergeTwoLists(lists[i], lists[i+1]))
			} else {
				merged = append(merged, lists[i])
			}
		}
		lists = merged
	}
	return lists[0]
}

func mergeTwoLists(l1, l2 *ListNode) *ListNode {
	dummy := &ListNode{}
	tail := dummy
	for l1 != nil && l2 != nil {
		if l1.Val < l2.Val {
			tail.Next = l1
			l1 = l1.Next
		} else {
			tail.Next = l2
			l2 = l2.Next
		}
		tail = tail.Next
	}
	if l1 != nil {
		tail.Next = l1
	} else {
		tail.Next = l2
	}
	return dummy.Next
}
```

## Link

[LeetCode 23 Merge k Sorted Lists](https://leetcode.com/problems/merge-k-sorted-lists/)
