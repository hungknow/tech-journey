# 0436 Find Right Interval

## Problem Description

You are given an array of intervals, where intervals[i] = [starti, endi] and each interval is sorted by starti.

For each interval `i`, find the right interval `j` such that `startj >= endi` and `startj` is minimized.

Return an array of right interval indices for each interval `i`. If no right interval exists for interval `i`, set `righti` to -1.

### Example 1:
```
Input: intervals = [[1,2],[2,3],[3,4]]
Output: [1,2,-1]
Explanation: There is no right interval for the last interval.
```

### Example 2:
```
Input: intervals = [[1,4],[2,3],[3,4]]
Output: [-1,0,-1]
```

## The Twist

Finding the **right interval** for each interval efficiently. Since intervals are sorted by start, we can use binary search.

## Algorithm

### Binary Search with Sorted Starts:
1. Create an array of (start, index) pairs and sort by start
2. For each interval:
   - Use binary search to find the smallest start ≥ current interval's end
   - If found, return its index; otherwise return -1

## Complexity

- **Time**: O(n log n) - sorting + binary search for each interval
- **Space**: O(n) - sorted starts array

## Solution Code

```go
package main

import (
	"sort"
)

func findRightInterval(intervals [][]int) []int {
	n := len(intervals)
	if n == 0 {
		return []int{}
	}
	
	// Create array of (start, index) pairs and sort by start
	starts := make([][2]int, n)
	for i, interval := range intervals {
		starts[i] = [2]int{interval[0], i}
	}
	
	sort.Slice(starts, func(i, j int) bool {
		return starts[i][0] < starts[j][0]
	})
	
	result := make([]int, n)
	
	for i, interval := range intervals {
		end := interval[1]
		
		// Binary search for the smallest start >= end
		left, right := 0, n
		for left < right {
			mid := left + (right-left)/2
			if starts[mid][0] < end {
				left = mid + 1
			} else {
				right = mid
			}
		}
		
		if left < n {
			result[i] = starts[left][1]
		} else {
			result[i] = -1
		}
	}
	
	return result
}
```

## Link

[LeetCode 0436 Find Right Interval](https://leetcode.com/problems/find-right-interval/)
