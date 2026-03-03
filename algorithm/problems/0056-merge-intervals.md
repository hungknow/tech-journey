# 0056 Merge Intervals

## Problem Description

Given an array of `intervals` where `intervals[i] = [starti, endi]`, merge all overlapping intervals, and return an array of the non-overlapping intervals that cover all the intervals in the input.

### Example 1:
```
Input: intervals = [[1,3],[2,6],[8,10],[15,18]]
Output: [[1,6],[8,10],[15,18]]
Explanation: Since intervals [1,3] and [2,6] overlap, merge them into [1,6].
```

### Example 2:
```
Input: intervals = [[1,4],[4,5]]
Output: [[1,5]]
Explanation: Intervals [1,4] and [4,5] are considered overlapping.
```

## Solution Approach

The key insight is to sort the intervals by their start time. Once sorted, we can iterate through the intervals and merge them with the previous interval if they overlap.

## Algorithm

1. Sort the intervals based on their start time.
2. Initialize a result list with the first interval.
3. For each subsequent interval:
   - If the current interval overlaps with the last interval in the result list (i.e., current.start ≤ last.end), merge them by updating the end of the last interval to be the maximum of both ends.
   - Otherwise, add the current interval to the result list.
4. Return the result list.

## Complexity

- **Time**: O(n log n) - dominated by the sorting step
- **Space**: O(n) - for the result list (can be O(1) if we modify in-place)

## Solution Code

```go
func merge(intervals [][]int) [][]int {
	if len(intervals) == 0 {
		return nil
	}
	sort.Slice(intervals, func(i, j int) bool {
		return intervals[i][0] < intervals[j][0]
	})
	result := [][]int{intervals[0]}
	for i := 1; i < len(intervals); i++ {
		last := result[len(result)-1]
		if intervals[i][0] <= last[1] {
			if intervals[i][1] > last[1] {
				result[len(result)-1][1] = intervals[i][1]
			}
		} else {
			result = append(result, intervals[i])
		}
	}
	return result
}
```

## Link

[LeetCode 0056 Merge Intervals](https://leetcode.com/problems/merge-intervals/)