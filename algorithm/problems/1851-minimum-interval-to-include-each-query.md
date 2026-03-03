# 1851 Minimum Interval to Include Each Query

## Problem Description

You are given a 2D integer array `intervals` where `intervals[i] = [lefti, righti]` represents the ith interval starting at `lefti` and ending at `righti` (inclusive).

You are also given an integer array `queries` where `queries[j]` is the start point of the jth query.

For each query, find the smallest interval that contains the query point. If there are multiple such intervals, return the one with the smallest left endpoint. If there is still a tie, return the one with the smallest right endpoint.

Return an array `answer` where `answer[j]` is the size of the smallest interval for the jth query.

### Example 1:
```
Input: intervals = [[1,4],[2,3],[3,4]], queries = [2,3,4]
Output: [2,3,4]
Explanation: 
For query 2: The smallest interval containing 2 is [2,3] with size 2.
For query 3: The smallest interval containing 3 is [2,3] with size 2.
For query 4: The smallest interval containing 4 is [3,4] with size 2.
```

### Example 2:
```
Input: intervals = [[1,4],[2,3],[3,4]], queries = [1,2,3]
Output: [2,3,1]
Explanation: 
For query 1: No interval contains 1, so the answer is 0.
For query 2: The smallest interval containing 2 is [2,3] with size 2.
For query 3: The smallest interval containing 3 is [2,3] with size 2.
```

## Solution Approach

We need to find, for each query, the smallest interval that contains the query point. This can be solved efficiently by sorting intervals and using binary search.

## Algorithm

1. Sort intervals by left endpoint.
2. For each query:
   - Use binary search to find the first interval where left <= query <= right.
   - If multiple intervals have the same left endpoint, choose the one with the smallest right endpoint.
   - The size is right - left + 1.
3. Return the sizes for all queries.

## Why This Works

By sorting intervals and using binary search, we efficiently find the smallest interval containing each query point.

## Complexity

- **Time**: O(n log n + q log n) for sorting and binary search
- **Space**: O(n) - for the sorted intervals

## Solution Code

```go
import "container/heap"

type interval struct{ left, right, size int }
type minHeap []interval
func (h minHeap) Len() int            { return len(h) }
func (h minHeap) Less(i, j int) bool { return h[i].size < h[j].size || (h[i].size == h[j].size && h[i].left < h[j].left) }
func (h minHeap) Swap(i, j int)      { h[i], h[j] = h[j], h[i] }
func (h *minHeap) Push(x interface{}) { *h = append(*h, x.(interval)) }
func (h *minHeap) Pop() interface{} {
	old := *h
	n := len(old)
	x := old[n-1]
	*h = old[:n-1]
	return x
}

func minInterval(intervals [][]int, queries []int) []int {
	sort.Slice(intervals, func(i, j int) bool { return intervals[i][0] < intervals[j][0] })
	type query struct{ q, i int }
	qs := make([]query, len(queries))
	for i, q := range queries {
		qs[i] = query{q, i}
	}
	sort.Slice(qs, func(i, j int) bool { return qs[i].q < qs[j].q })
	h := &minHeap{}
	heap.Init(h)
	result := make([]int, len(queries))
	j := 0
	for _, q := range qs {
		for j < len(intervals) && intervals[j][0] <= q.q {
			size := intervals[j][1] - intervals[j][0] + 1
			heap.Push(h, interval{intervals[j][0], intervals[j][1], size})
			j++
		}
		for h.Len() > 0 && (*h)[0].right < q.q {
			heap.Pop(h)
		}
		if h.Len() > 0 {
			result[q.i] = (*h)[0].size
		} else {
			result[q.i] = 0
		}
	}
	return result
}
```

## Link

[LeetCode 1851 Minimum Interval to Include Each Query](https://leetcode.com/problems/minimum-interval-to-include-each-query/)