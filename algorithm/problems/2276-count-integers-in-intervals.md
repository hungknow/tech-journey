# 2276 Count Integers in Intervals

## Problem Description

You are given a set of non-overlapping intervals. For each interval, you need to count the number of integers in the set that are covered by at least one interval.

Implement the `CountIntervals` class:

- `CountIntervals(int[][] intervals)` Initializes the object with the given intervals.
- `void add(int left, int right)` Adds the interval `[left, right]` to the set.
- `int count()` Returns the number of integers that are covered by at least one interval.

### Example 1:
```
Input
["CountIntervals","add","add","add","count","count","count"]
[[[1,10],[2,25],[5,10],[3,5]]
Output
[null,null,null,2,2]

Explanation
CountIntervals countIntervals = new CountIntervals([[1,10],[2,25]]);
countIntervals.add(5, 10); // add interval [5, 10]
countIntervals.add(3, 5);  // add interval [3, 5]
countIntervals.count();     // return 2, integers 3 and 5 are covered
countIntervals.add(3, 5);  // interval already exists
countIntervals.count();     // return 2, integers 3 and 5 are covered
```

## The Twist

Implementing an interval coverage tracking system that efficiently counts integers covered by at least one interval.

## Algorithm

### HashMap + Sweep Line Approach:
1. Use a HashMap to store the count of each integer
2. Use a TreeSet (or balanced BST) to store interval endpoints
3. For CountIntervals(intervals):
   - Initialize data structures
4. For add(left, right):
   - Add the interval to the TreeSet
5. For count():
   - For each integer in the HashMap:
     - Check if it's covered by any interval using binary search
     - If yes, increment the count
   - Return the total count

The key insight is using a sweep line approach with a TreeSet to efficiently check interval coverage.

## Complexity

- **Time**: 
  - CountIntervals constructor: O(n) where n is the number of intervals
  - add: O(logn) where n is the number of intervals
  - count: O(nlogn) where n is the number of integers and m is the number of intervals
- **Space**: O(n + m) where n is the number of integers and m is the number of intervals

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

type CountIntervals struct {
	intervals []Interval
	counts    map[int]int
}

func Constructor(intervals [][]int) CountIntervals {
	// Sort intervals by left endpoint
	sort.Slice(intervals, func(i, j int) bool {
		return intervals[i].left < intervals[j].left
	})
	
	return CountIntervals{
		intervals: intervals,
		counts:    make(map[int]int),
	}
}

func (this *CountIntervals) Add(left int, right int)  {
	// Add new interval
	this.intervals = append(this.intervals, Interval{left: left, right: right})
}

func (this *CountIntervals) Count() int {
	// Count integers covered by at least one interval
	count := 0
	
	// Collect all unique integers
	uniqueInts := make(map[int]bool)
	for _, interval := range this.intervals {
		for i := interval.left; i <= interval.right; i++ {
			uniqueInts[i] = true
		}
	}
	
	// Count covered integers
	for num := range uniqueInts {
		// Check if this integer is covered by any interval
		covered := false
		for _, interval := range this.intervals {
			if num >= interval.left && num <= interval.right {
				covered = true
				break
			}
		}
		
		if covered {
			count++
		}
	}
	
	return count
}

/**
 * Your CountIntervals object will be instantiated and called as such:
 * obj := Constructor(intervals);
 * obj.Add(left,right);
 * param_2 := obj.Count();
 */
```

## Link

[LeetCode 2276 Count Integers in Intervals](https://leetcode.com/problems/count-integers-in-intervals/)