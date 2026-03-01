# 0774 Minimize Max Distance to Gas Station

## Problem Description

You are given an integer array `stations` representing the positions of gas stations on a number line, where `stations[i]` is the position of the ith gas station. You are also given an integer `k`.

You have to add `k` new gas stations on the number line. You can add them anywhere on the line (including between existing gas stations).

Return the smallest possible value of the maximum distance between adjacent gas stations after adding the new stations.

The answer is within 10^-6 of the actual answer.

### Example 1:
```
Input: stations = [1,2,3,4,5,6,7,8,9,10], k = 9
Output: 0.50000
```

### Example 2:
```
Input: stations = [1,2,3,4,5], k = 3
Output: 0.66667
```

## The Twist

Finding the **minimum possible maximum distance** after adding `k` stations. This is another binary search on answer problem where we check feasibility for a given maximum distance.

## Algorithm

### Binary Search on Answer:
1. The answer is between 0 and the maximum distance between existing stations
2. Binary search on this range:
   - For each `mid`, calculate how many stations needed to ensure no gap > `mid`
   - For each gap between stations, needed stations = ceil(gap/mid) - 1
   - If total needed ≤ k, we can try smaller distance (`high = mid`)
   - Otherwise, need larger distance (`low = mid`)
3. When loop ends, `low` is the minimum possible maximum distance

## Complexity

- **Time**: O(n log(max_distance)) where n is the number of stations
- **Space**: O(1) - constant extra space

## Solution Code

```go
package main

import (
	"math"
)

func minmaxGasDist(stations []int, k int) float64 {
	if len(stations) < 2 {
		return 0.0
	}
	
	// Find the maximum distance between consecutive stations
	maxDist := 0.0
	for i := 1; i < len(stations); i++ {
		dist := float64(stations[i] - stations[i-1])
		maxDist = math.Max(maxDist, dist)
	}
	
	// Binary search for the minimum possible maximum distance
	left, right := 0.0, maxDist
	
	for right-left > 1e-6 { // Precision requirement
		mid := left + (right-left)/2.0
		
		if canPlaceStations(stations, k, mid) {
			right = mid
		} else {
			left = mid
		}
	}
	
	return right
}

func canPlaceStations(stations []int, k int, maxDist float64) bool {
	needed := 0
	
	for i := 1; i < len(stations); i++ {
		gap := float64(stations[i] - stations[i-1])
		
		// Number of stations needed for this gap
		// ceil(gap/maxDist) - 1
		stationsNeeded := int(math.Ceil(gap/maxDist)) - 1
		needed += stationsNeeded
		
		if needed > k {
			return false
		}
	}
	
	return true
}
```

## Link

[LeetCode 0774 Minimize Max Distance to Gas Station](https://leetcode.com/problems/minimize-max-distance-to-gas-station/)
