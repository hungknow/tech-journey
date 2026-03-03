# 1942 The Number of the Smallest Unoccupied Chair

## Problem Description

You are given an array `times` where `times[i] = [arrivali, leavei]` represents the arrival and leave times of the ith guest. The guests are numbered from 0 to n-1.

When a guest arrives, they will sit on the smallest numbered unoccupied chair. When they leave, their chair becomes unoccupied.

You are also given an integer `targetFriend`. Return the chair number the target guest will sit on.

### Example 1:
```
Input: times = [[1,4],[2,3],[4,6],[5,2]], targetFriend = 1
Output: 1
Explanation: 
Guest 0 arrives at time 1 and sits on chair 0.
Guest 1 arrives at time 2 and sits on chair 1.
Guest 2 arrives at time 3 and sits on chair 2.
Guest 3 arrives at time 4 and sits on chair 3.
Guest 4 arrives at time 6 and sits on chair 4.
Guest 1 is the target friend, sitting on chair 1.
```

### Example 2:
```
Input: times = [[3,10],[2,5],[1,2],[3,8]], targetFriend = 2
Output: 3
Explanation: 
Guest 0 arrives at time 1 and sits on chair 0.
Guest 1 arrives at time 2 and sits on chair 1.
Guest 2 arrives at time 5 and sits on chair 2.
Guest 3 arrives at time 3 and sits on chair 3.
Guest 2 is the target friend, sitting on chair 3.
```

## Solution Approach

We need to track which chairs are occupied and when they become available. This can be solved using a min-heap for available chairs and another structure for tracking leave times.

## Algorithm

1. Sort the guests by arrival time.
2. Initialize a min-heap for available chairs and a map to track when each chair becomes available.
3. Process guests in order:
   - Before processing a guest, free up chairs whose guests have left.
   - Assign the smallest available chair to the current guest.
   - Record the leave time for this guest and chair.
4. Return the chair number of the target guest.

## Why This Works

By sorting by arrival time and using a min-heap for available chairs, we efficiently assign the smallest available chair to each guest.

## Complexity

- **Time**: O(n log n) - sorting and heap operations
- **Space**: O(n) - for the heap and tracking structures

## Solution Code

```go
import "container/heap"

type intHeap []int
func (h intHeap) Len() int            { return len(h) }
func (h intHeap) Less(i, j int) bool { return h[i] < h[j] }
func (h intHeap) Swap(i, j int)      { h[i], h[j] = h[j], h[i] }
func (h *intHeap) Push(x interface{}) { *h = append(*h, x.(int)) }
func (h *intHeap) Pop() interface{} {
	old := *h
	n := len(old)
	x := old[n-1]
	*h = old[:n-1]
	return x
}
type leaveEvent struct{ time, chair int }
type leaveHeap []leaveEvent
func (h leaveHeap) Len() int            { return len(h) }
func (h leaveHeap) Less(i, j int) bool  { return h[i].time < h[j].time }
func (h leaveHeap) Swap(i, j int)       { h[i], h[j] = h[j], h[i] }
func (h *leaveHeap) Push(x interface{}) { *h = append(*h, x.(leaveEvent)) }
func (h *leaveHeap) Pop() interface{} {
	old := *h
	n := len(old)
	x := old[n-1]
	*h = old[:n-1]
	return x
}

func smallestChair(times [][]int, targetFriend int) int {
	n := len(times)
	indices := make([]int, n)
	for i := range indices {
		indices[i] = i
	}
	sort.Slice(indices, func(i, j int) bool {
		return times[indices[i]][0] < times[indices[j]][0]
	})
	available := &intHeap{}
	for i := 0; i < n; i++ {
		heap.Push(available, i)
	}
	leaves := &leaveHeap{}
	heap.Init(leaves)
	for _, idx := range indices {
		arrival, leave := times[idx][0], times[idx][1]
		for leaves.Len() > 0 && (*leaves)[0].time <= arrival {
			e := heap.Pop(leaves).(leaveEvent)
			heap.Push(available, e.chair)
		}
		chair := heap.Pop(available).(int)
		if idx == targetFriend {
			return chair
		}
		heap.Push(leaves, leaveEvent{leave, chair})
	}
	return -1
}
```

## Link

[LeetCode 1942 The Number of the Smallest Unoccupied Chair](https://leetcode.com/problems/the-number-of-the-smallest-unoccupied-chair/)