# 0218 The Skyline Problem

## Problem Description

A city's skyline is the outer contour of the silhouette formed by all the buildings in that city when viewed from a distance. Given the locations and heights of all the buildings in a city, return the skyline formed by these buildings collectively.

The geometric information of each building is represented by a triplet `[left, right, height]`:
- `left` is the x coordinate of the left edge of the building
- `right` is the x coordinate of the right edge of the building
- `height` is the height of the building

Buildings may overlap. The skyline is essentially the outline formed by the union of all the buildings when viewed from a distance.

### Example 1:
```
Input: buildings = [[2,9,10],[3,7,15],[5,12,12],[15,20,10],[19,24,8]]
Output: [[2,10],[3,15],[7,12],[12,0],[15,10],[20,8],[24,0]]
```

## Solution Approach

This is a classic line sweep algorithm problem. We'll process all the critical points (building edges) in order, maintaining the current maximum height at each point.

## Algorithm

1. Create a list of all critical points:
   - For each building [left, right, height], add (left, -height) and (right, height) to the list.
   - Using negative height for left edges ensures they're processed before right edges at the same x-coordinate.
2. Sort the critical points by x-coordinate, and by height (negative heights first for same x).
3. Use a max-heap to keep track of current building heights:
   - Initialize with height 0.
4. Process each critical point:
   - If it's a left edge (negative height), add the absolute height to the heap.
   - If it's a right edge (positive height), remove that height from the heap.
   - After processing, if the current max height changes, add the current point and new height to the result.
5. Return the result list.

## Complexity

- **Time**: O(n log n) - sorting the critical points and heap operations
- **Space**: O(n) - for storing critical points and the heap

## Solution Code

```go
import "container/heap"

type maxHeap []int
func (h maxHeap) Len() int            { return len(h) }
func (h maxHeap) Less(i, j int) bool  { return h[i] > h[j] }
func (h maxHeap) Swap(i, j int)       { h[i], h[j] = h[j], h[i] }
func (h *maxHeap) Push(x interface{}) { *h = append(*h, x.(int)) }
func (h *maxHeap) Pop() interface{} {
	old := *h
	n := len(old)
	x := old[n-1]
	*h = old[:n-1]
	return x
}

func getSkyline(buildings [][]int) [][]int {
	var points [][]int
	for _, b := range buildings {
		points = append(points, []int{b[0], -b[2]}, []int{b[1], b[2]})
	}
	sort.Slice(points, func(i, j int) bool {
		if points[i][0] != points[j][0] {
			return points[i][0] < points[j][0]
		}
		return points[i][1] < points[j][1]
	})
	h := &maxHeap{}
	heap.Init(h)
	heap.Push(h, 0)
	removed := make(map[int]int)
	prev := 0
	var result [][]int
	for _, p := range points {
		x, height := p[0], p[1]
		if height < 0 {
			heap.Push(h, -height)
		} else {
			removed[height]++
		}
		for h.Len() > 0 {
			top := (*h)[0]
			if removed[top] > 0 {
				removed[top]--
				heap.Pop(h)
			} else {
				break
			}
		}
		cur := (*h)[0]
		if cur != prev {
			result = append(result, []int{x, cur})
			prev = cur
		}
	}
	return result
}
```

## Link

[LeetCode 0218 The Skyline Problem](https://leetcode.com/problems/the-skyline-problem/)