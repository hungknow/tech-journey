# 1870 Minimum Speed to Arrive on Time

## Problem Description

You are given a floating-point number `hour`, representing the amount of time you have to travel to a destination.

You are also given an integer array `dist`, where `dist[i]` is the distance of the `ith` segment of your journey.

You can travel at a constant speed `s` for each segment. However, before traveling to the `i+1`th segment, you must wait until the next integer hour (i.e., wait until `ceil` of the current time).

Return the minimum integer speed `s` such that you can arrive at the destination on time or earlier. If it is impossible to arrive on time, return -1.

### Example 1:
```
Input: dist = [1,3,2], hour = 6
Output: 1
Explanation: At speed 1:
- Time to travel the first segment = 1/1 = 1 hour
- Wait until the next integer hour = 0 hours
- Time to travel the second segment = 3/1 = 3 hours
- Wait until the next integer hour = 0 hours
- Time to travel the third segment = 2/1 = 2 hours
Total time = 1 + 0 + 3 + 0 + 2 = 6 hours, which is exactly the given time.
```

### Example 2:
```
Input: dist = [1,3,2], hour = 2.7
Output: 3
Explanation: At speed 3:
- Time to travel the first segment = 1/3 = 0.333... hours
- Wait until the next integer hour = 0.666... hours
- Time to travel the second segment = 3/3 = 1 hour
- Wait until the next integer hour = 0 hours
- Time to travel the third segment = 2/3 = 0.666... hours
Total time ≈ 0.333 + 0.666 + 1 + 0 + 0.666 = 2.666... hours, which is less than 2.7 hours.
```

## The Twist

Finding the **minimum speed** to arrive on time. This involves using binary search to efficiently find the smallest speed that allows arrival within the time limit.

## Algorithm

### Binary Search Approach:
1. Use binary search on possible speeds (from 1 to a reasonable maximum)
2. For each speed candidate:
   - Calculate the total time needed to travel all segments
   - For all segments except the last one, round up the time to the next integer hour
   - For the last segment, use the exact time
3. If the total time ≤ `hour`, try a smaller speed; otherwise, try a larger speed
4. Return the minimum valid speed

The key insight is that if a speed `s` allows arrival on time, any speed greater than `s` will also allow arrival on time, enabling binary search.

## Complexity

- **Time**: O(n log(maxSpeed)) - binary search with time calculation
- **Space**: O(1) - constant space

## Solution Code

```go
package main

import (
	"fmt"
	"math"
)

func minSpeedOnTime(dist []int, hour float64) int {
	n := len(dist)
	
	// If we need to travel n segments and have less than n-1 hours, it's impossible
	if hour < float64(n-1) {
		return -1
	}
	
	// Binary search for the minimum speed
	left := 1
	right := 10000000 // Upper bound for speed
	
	result := -1
	
	for left <= right {
		mid := left + (right-left)/2
		
		// Calculate total time needed at speed mid
		totalTime := 0.0
		
		// For all segments except the last one, round up to the next integer hour
		for i := 0; i < n-1; i++ {
			segmentTime := float64(dist[i]) / float64(mid)
			totalTime += math.Ceil(segmentTime)
		}
		
		// For the last segment, use the exact time
		totalTime += float64(dist[n-1]) / float64(mid)
		
		if totalTime <= hour {
			result = mid
			right = mid - 1 // Try smaller speed
		} else {
			left = mid + 1 // Try larger speed
		}
	}
	
	return result
}
```

## Link

[LeetCode 1870 Minimum Speed to Arrive on Time](https://leetcode.com/problems/minimum-speed-to-arrive-on-time/)