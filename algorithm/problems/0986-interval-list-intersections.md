# 0986 Interval List Intersections

## Problem Description

You are given two lists of closed intervals, firstList and secondList, where firstList[i] = [starti, endi] and secondList[j] = [startj, endj]. Each list of intervals is pairwise disjoint and in sorted order. Return the intersection of these two interval lists. The intersection of two closed intervals is the set of real numbers that are in both (or empty).

### Example 1:
```
Input: firstList = [[0,2],[5,10],[13,23],[24,25]], secondList = [[1,5],[8,12],[15,24],[25,26]]
Output: [[1,2],[5,5],[8,10],[15,23],[24,24],[25,25]]
```

### Example 2:
```
Input: firstList = [[1,3],[5,9]], secondList = []
Output: []
```

## The Twist

Two pointers: for each pair of intervals, the intersection is [max(start1, start2), min(end1, end2)] if start <= end. Then advance the pointer that ends earlier (smaller end value) to get the next candidate pair.

## Algorithm

1. Two pointers i, j on firstList and secondList. While i < len(first) and j < len(second): compute lo = max(first[i][0], second[j][0]), hi = min(first[i][1], second[j][1]). If lo <= hi, append [lo, hi]. If first[i][1] < second[j][1], i++; else j++.
2. Return the list of intersections.

## Complexity

- **Time**: O(m + n) — each interval considered at most once.
- **Space**: O(1) — excluding output.

## Solution Code

```go
func intervalIntersection(firstList [][]int, secondList [][]int) [][]int {
	var out [][]int
	i, j := 0, 0
	for i < len(firstList) && j < len(secondList) {
		lo := firstList[i][0]
		if secondList[j][0] > lo {
			lo = secondList[j][0]
		}
		hi := firstList[i][1]
		if secondList[j][1] < hi {
			hi = secondList[j][1]
		}
		if lo <= hi {
			out = append(out, []int{lo, hi})
		}
		if firstList[i][1] < secondList[j][1] {
			i++
		} else {
			j++
		}
	}
	return out
}
```

## Link

[LeetCode 986 Interval List Intersections](https://leetcode.com/problems/interval-list-intersections/)
