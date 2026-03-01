# 2187 Minimum Time to Complete Trips

## Problem Description

You are given an array `time` where `time[i]` is the time taken by the `ith` bus to complete one trip.

You are also given an integer `totalTrips`, which is the total number of trips all buses need to complete in total.

Each bus can complete multiple trips one after another. Return the minimum time required for all buses to complete at least `totalTrips` trips.

### Example 1:
```
Input: time = [1,2,3], totalTrips = 5
Output: 3
Explanation:
- At time t=1: Bus 0 completes 1 trip
- At time t=2: Bus 0 completes 2 trips, Bus 1 completes 1 trip
- At time t=3: Bus 0 completes 3 trips, Bus 1 completes 1 trip, Bus 2 completes 1 trip
Total trips at t=3: 3 + 1 + 1 = 5
```

### Example 2:
```
Input: time = [2], totalTrips = 1
Output: 2
Explanation: The single bus needs 2 units of time to complete 1 trip.
```

## The Twist

Finding the **minimum time** to complete all trips. This involves using binary search to efficiently determine the earliest time when the required number of trips can be completed.

## Algorithm

### Binary Search Approach:
1. Use binary search on time (from 1 to a reasonable upper bound)
2. For each candidate time `t`:
   - Calculate how many trips each bus can complete: `t / time[i]`
   - Sum these values to get the total number of trips
3. If the total trips ≥ `totalTrips`, try a smaller time; otherwise, try a larger time
4. Return the minimum valid time

The key insight is that if we can complete `totalTrips` trips in time `t`, we can also complete them in any time greater than `t`, enabling binary search.

## Complexity

- **Time**: O(n log(maxTime)) - binary search with trip counting
- **Space**: O(1) - constant space

## Solution Code

```go
package main

import "fmt"

func minimumTime(time []int, totalTrips int) int64 {
	// Binary search for the minimum time
	left := int64(1)
	right := int64(0)
	
	// Find a reasonable upper bound
	minTime := time[0]
	for _, t := range time {
		if t < minTime {
			minTime = t
		}
	}
	right = int64(minTime) * int64(totalTrips)
	
	var result int64
	
	for left <= right {
		mid := left + (right-left)/2
		
		// Calculate how many trips can be completed in mid time
		trips := int64(0)
		for _, t := range time {
			trips += mid / int64(t)
		}
		
		if trips >= int64(totalTrips) {
			result = mid
			right = mid - 1 // Try smaller time
		} else {
			left = mid + 1 // Try larger time
		}
	}
	
	return result
}
```

## Link

[LeetCode 2187 Minimum Time to Complete Trips](https://leetcode.com/problems/minimum-time-to-complete-trips/)