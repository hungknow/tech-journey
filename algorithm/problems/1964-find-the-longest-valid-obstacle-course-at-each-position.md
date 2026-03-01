# 1964 Find the Longest Valid Obstacle Course at Each Position

## Problem Description

You are given an integer array `obstacles` of length `n`, where `obstacles[i]` describes the height of the `ith` obstacle.

For each position `i`, find the length of the longest obstacle course that includes the `ith` obstacle as the last obstacle.

An obstacle course is defined as a list of obstacles where:
- The heights are non-decreasing
- The difference between consecutive heights is at most 1

### Example 1:
```
Input: obstacles = [1,2,3,2]
Output: [1,2,3,3]
```

### Example 2:
```
Input: obstacles = [2,2,3,4,4,5]
Output: [1,2,3,4,5,6]
```

## The Twist

Finding the **longest valid obstacle course** ending at each position. This is a variant of LIS with specific constraints.

## Algorithm

### Modified LIS with Constraints:
1. Use binary search to maintain a `tails` array
2. For each obstacle height:
   - Find the smallest index `i` where `tails[i] > obstacle` or `tails[i] > obstacle + 1`
   - The constraint is: `tails[i]` must be ≤ `obstacle + 1`
   - Update `tails[i] = min(tails[i], obstacle)`
3. The length at each position is the index found + 1

## Complexity

- **Time**: O(n log n) - binary search for each element
- **Space**: O(n) - tails array

## Solution Code

```go
package main

import (
	"sort"
)

func longestObstacleCourseAtEachPosition(obstacles []int) []int {
	n := len(obstacles)
	result := make([]int, n)
	tails := []int{}
	
	for i, height := range obstacles {
		// Find the position to insert/replace
		idx := sort.SearchInts(tails, height+1)
		
		if idx == len(tails) {
			tails = append(tails, height)
		} else {
			tails[idx] = height
		}
		
		result[i] = idx + 1
	}
	
	return result
}
```

## Link

[LeetCode 1964 Find the Longest Valid Obstacle Course at Each Position](https://leetcode.com/problems/find-the-longest-valid-obstacle-course-at-each-position/)
