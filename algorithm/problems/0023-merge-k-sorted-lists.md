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

Comparing heads of k lists each time is O(k). Using a min-heap (priority queue) of size k reduces "get minimum" to O(log k), giving O(n log k) total instead of O(n·k).

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

## Link

[LeetCode 23 Merge k Sorted Lists](https://leetcode.com/problems/merge-k-sorted-lists/)
