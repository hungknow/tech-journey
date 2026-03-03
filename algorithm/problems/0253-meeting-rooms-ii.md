# 0253 Meeting Rooms II

## Problem Description

Given an array of meeting time intervals `intervals` where `intervals[i] = [starti, endi]`, return the minimum number of conference rooms required.

### Example 1:
```
Input: intervals = [[0,30],[5,10],[15,20]]
Output: 2
```

### Example 2:
```
Input: intervals = [[7,10],[2,4]]
Output: 1
```

## Solution Approach

We need to find the maximum number of overlapping meetings at any point in time. This can be solved using a line sweep algorithm or by using two separate arrays for start and end times.

## Algorithm

1. Extract all start times and end times into separate arrays.
2. Sort both arrays.
3. Use two pointers:
   - `startPtr` for the start times array
   - `endPtr` for the end times array
4. Initialize `rooms` = 0 and `maxRooms` = 0.
5. While `startPtr` < n:
   - If `startTimes[startPtr]` < `endTimes[endPtr]`, we need a new room:
     - Increment `rooms`
     - Move `startPtr` forward
   - Else, a meeting has ended, freeing a room:
     - Decrement `rooms`
     - Move `endPtr` forward
   - Update `maxRooms` with the maximum of `maxRooms` and `rooms`.
6. Return `maxRooms`.

## Complexity

- **Time**: O(n log n) - sorting the start and end time arrays
- **Space**: O(n) - for storing the start and end time arrays

## Solution Code

```go
func minMeetingRooms(intervals [][]int) int {
	if len(intervals) == 0 {
		return 0
	}
	starts := make([]int, len(intervals))
	ends := make([]int, len(intervals))
	for i, in := range intervals {
		starts[i] = in[0]
		ends[i] = in[1]
	}
	sort.Ints(starts)
	sort.Ints(ends)
	rooms, maxRooms := 0, 0
	s, e := 0, 0
	for s < len(starts) {
		if starts[s] < ends[e] {
			rooms++
			s++
			if rooms > maxRooms {
				maxRooms = rooms
			}
		} else {
			rooms--
			e++
		}
	}
	return maxRooms
}
```

## Link

[LeetCode 0253 Meeting Rooms II](https://leetcode.com/problems/meeting-rooms-ii/)