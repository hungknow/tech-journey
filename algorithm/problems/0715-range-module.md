# 0715 Range Module

## Problem Description

A Range Module is a module that tracks ranges of numbers. Your task is to design and implement the following interfaces in an efficient way.

`addRange(int left, int right)` Adds the half-open interval `[left, right)`, tracking every real number in that interval. Adding an interval that partially overlaps with currently tracked numbers should add any numbers in the interval `[left, right)` that are not already tracked.

`queryRange(int left, int right)` Returns true if and only if every real number in the interval `[left, right)` is currently being tracked.

`removeRange(int left, int right)` Removes every real number in the interval `[left, right)` from currently being tracked.

### Example 1:
```
Input
["RangeModule", "addRange", "removeRange", "queryRange", "queryRange", "queryRange"]
[[], [10, 20], [14, 16], [10, 14], [13, 15], [16, 17]]
Output
[null, null, null, true, false, true]

Explanation
RangeModule rangeModule = new RangeModule();
rangeModule.addRange(10, 20);
rangeModule.removeRange(14, 16);
rangeModule.queryRange(10, 14); // return True (Every number in [10, 14) is being tracked)
rangeModule.queryRange(13, 15); // return False (Numbers like 14, 15 are not being tracked)
rangeModule.queryRange(16, 17); // return True (The number 16 in [16, 17) is still being tracked)
```

## The Twist

Implementing a range module that efficiently tracks, queries, and modifies intervals of numbers with proper merging and splitting operations.

## Algorithm

### TreeMap/Interval Merging Approach:
1. Use a TreeMap (or equivalent) to store non-overlapping intervals
2. For addRange(left, right):
   - Find all intervals that overlap with [left, right)
   - Merge these intervals with the new range
   - Replace the overlapping intervals with the merged interval
3. For queryRange(left, right):
   - Find the interval that should contain left
   - Check if such an interval exists and covers the entire [left, right) range
4. For removeRange(left, right):
   - Find all intervals that overlap with [left, right)
   - For each overlapping interval, split or trim it to remove the overlapping portion
   - Replace the original interval with the modified intervals

The key insight is maintaining a set of non-overlapping intervals and efficiently merging/splitting them during operations.

## Complexity

- **Time**: 
  - addRange: O(n) where n is the number of intervals
  - queryRange: O(logn) average
  - removeRange: O(n) where n is the number of intervals
- **Space**: O(n) where n is the number of intervals

## Solution Code

```go
package main

import (
	"sort"
)

type Interval struct {
	left  int
	right int
}

type RangeModule struct {
	intervals []Interval
}

func Constructor() RangeModule {
	return RangeModule{
		intervals: make([]Interval, 0),
	}
}

func (this *RangeModule) AddRange(left int, right int)  {
	// Find the position to insert the new interval
	newIntervals := make([]Interval, 0)
	i := 0
	n := len(this.intervals)
	
	// Add all intervals that end before the new interval starts
	for i < n && this.intervals[i].right < left {
		newIntervals = append(newIntervals, this.intervals[i])
		i++
	}
	
	// Merge overlapping intervals
	for i < n && this.intervals[i].left <= right {
		left = min(left, this.intervals[i].left)
		right = max(right, this.intervals[i].right)
		i++
	}
	
	// Add the merged interval
	newIntervals = append(newIntervals, Interval{left: left, right: right})
	
	// Add the remaining intervals
	for i < n {
		newIntervals = append(newIntervals, this.intervals[i])
		i++
	}
	
	this.intervals = newIntervals
}

func (this *RangeModule) QueryRange(left int, right int) bool {
	// Binary search for the interval that might contain left
	i := sort.Search(len(this.intervals), func(i int) bool {
		return this.intervals[i].right >= left
	})
	
	if i < len(this.intervals) {
		interval := this.intervals[i]
		return interval.left <= left && interval.right >= right
	}
	
	return false
}

func (this *RangeModule) RemoveRange(left int, right int)  {
	newIntervals := make([]Interval, 0)
	i := 0
	n := len(this.intervals)
	
	// Add all intervals that end before the new interval starts
	for i < n && this.intervals[i].right <= left {
		newIntervals = append(newIntervals, this.intervals[i])
		i++
	}
	
	// Process overlapping intervals
	for i < n && this.intervals[i].left < right {
		interval := this.intervals[i]
		
		// If the interval starts before left, keep the left part
		if interval.left < left {
			newIntervals = append(newIntervals, Interval{left: interval.left, right: left})
		}
		
		// If the interval ends after right, keep the right part
		if interval.right > right {
			newIntervals = append(newIntervals, Interval{left: right, right: interval.right})
		}
		
		i++
	}
	
	// Add the remaining intervals
	for i < n {
		newIntervals = append(newIntervals, this.intervals[i])
		i++
	}
	
	this.intervals = newIntervals
}

func min(a, b int) int {
	if a < b {
		return a
	}
	return b
}

func max(a, b int) int {
	if a > b {
		return a
	}
	return b
}

/**
 * Your RangeModule object will be instantiated and called as such:
 * obj := Constructor();
 * obj.AddRange(left,right);
 * param_2 := obj.QueryRange(left,right);
 * obj.RemoveRange(left,right);
 */
```

## Link

[LeetCode 0715 Range Module](https://leetcode.com/problems/range-module/)