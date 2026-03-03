# 1943 Describe the Painting

## Problem Description

There is a long and thin painting that can be represented by a number line. The painting was painted with a number of overlapping segments, where each segment was painted with a unique color.

You are given a 2D integer array `segments` where `segments[i] = [starti, endi, colori]` represents the ith segment:
- `starti` is the starting point of the segment.
- `endi` is the ending point of the segment.
- `colori` is the color of the segment.

All three values are distinct for each segment.

Return a 2D integer array `painting` describing the painting as follows:
- `painting[j] = [leftj, rightj, colorj]` represents a painted segment between `leftj` and `rightj` (inclusive) with color `colorj`.
- The array should be sorted by left endpoint in ascending order.
- No two adjacent segments in the painting should have the same color.
- Merge overlapping or adjacent segments with the same color.

### Example 1:
```
Input: segments = [[1,4,5],[4,7,7],[5,8,9]], k = 2
Output: [[1,4,5],[4,7,9]]
Explanation: 
The first and second segments are merged because they have the same color.
The third segment remains unchanged.
The painting is sorted by left endpoint: [[1,4,5],[4,7,9]].
```

### Example 2:
```
Input: segments = [[1,4,5],[1,4,7],[5,8,9]], k = 3
Output: [[1,4,5],[1,4,7],[5,8,9]]
Explanation: 
All segments have different colors, so no merging occurs.
The painting is sorted by left endpoint: [[1,4,5],[1,4,7],[5,8,9]].
```

## Solution Approach

We need to process the segments, merge overlapping or adjacent segments with the same color, and then sort by left endpoint.

## Algorithm

1. Sort the segments by start point.
2. Initialize an empty result list.
3. Iterate through the sorted segments:
   - If the current segment overlaps or is adjacent to the last segment in the result and has the same color:
     - Merge them into one segment.
   - Otherwise, add the segment to the result.
4. Sort the result by left endpoint.
5. Return the result.

## Why This Works

By sorting and processing segments in order, we can efficiently identify and merge overlapping or adjacent segments with the same color.

## Complexity

- **Time**: O(n log n) - dominated by sorting
- **Space**: O(n) - for the result list

## Solution Code

```go
func splitPainting(segments [][]int) [][]int64 {
	type event struct {
		pos   int
		delta int64
	}
	var events []event
	for _, s := range segments {
		events = append(events, event{s[0], int64(s[2])}, event{s[1], -int64(s[2])})
	}
	sort.Slice(events, func(i, j int) bool { return events[i].pos < events[j].pos })
	var result [][]int64
	var cur int64
	start := -1
	for _, e := range events {
		if start >= 0 && e.pos > start && cur > 0 {
			result = append(result, []int64{int64(start), int64(e.pos), cur})
		}
		cur += e.delta
		start = e.pos
	}
	return result
}
```

## Link

[LeetCode 1943 Describe the Painting](https://leetcode.com/problems/describe-the-painting/)