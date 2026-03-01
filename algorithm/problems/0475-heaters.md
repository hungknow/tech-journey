# 0475 Heaters

## Problem Description

You are given two integer arrays `houses` and `heaters` of lengths `n` and `m` respectively, where `houses[i]` is the position of the ith house and `heaters[j]` is the position of the jth heater.

In one step, a heater can heat up a radius of `1` unit. Return the minimum heating radius required to heat all houses.

### Example 1:
```
Input: houses = [1,2,3,4], heaters = [1,4]
Output: 1
Explanation: The heater at position 1 can heat houses [0,2], and the heater at position 4 can heat houses [3,5].
```

### Example 2:
```
Input: houses = [1,5], heaters = [2]
Output: 3
```

## The Twist

Finding the **minimum heating radius** so that every house is within range of at least one heater. For each house, we need to find the nearest heater.

## Algorithm

### Binary Search for Nearest Heater:
1. Sort the heaters array
2. For each house, find the nearest heater using binary search:
   - Find the insertion position of the house in the heaters array
   - The nearest heater is either the heater just before or just after this position
3. Track the maximum distance across all houses
4. The required radius is this maximum distance

## Complexity

- **Time**: O((m + n) log n) - sorting heaters + binary search for each house
- **Space**: O(1) - constant extra space

## Solution Code

```go
package main

import (
	"sort"
)

func findRadius(houses []int, heaters []int) int {
	if len(houses) == 0 || len(heaters) == 0 {
		return 0
	}
	
	// Sort heaters for binary search
	sort.Ints(heaters)
	
	maxRadius := 0
	
	for _, house := range houses {
		// Find the nearest heater
		radius := findNearestHeater(house, heaters)
		maxRadius = max(maxRadius, radius)
	}
	
	return maxRadius
}

func findNearestHeater(house int, heaters []int) int {
	left, right := 0, len(heaters)-1
	minDistance := 1 << 31 - 1
	
	for left <= right {
		mid := left + (right-left)/2
		
		// Calculate distance to current heater
		distance := abs(heaters[mid] - house)
		minDistance = min(minDistance, distance)
		
		if heaters[mid] == house {
			return 0 // Exact match
		} else if heaters[mid] < house {
			left = mid + 1
		} else {
			right = mid - 1
		}
	}
	
	// Check boundaries if we didn't find exact match
	if left < len(heaters) {
		minDistance = min(minDistance, abs(heaters[left]-house))
	}
	if right >= 0 {
		minDistance = min(minDistance, abs(heaters[right]-house))
	}
	
	return minDistance
}

func abs(x int) int {
	if x < 0 {
		return -x
	}
	return x
}

func max(a, b int) int {
	if a > b {
		return a
	}
	return b
}

func min(a, b int) int {
	if a < b {
		return a
	}
	return b
}
```

## Link

[LeetCode 0475 Heaters](https://leetcode.com/problems/heaters/)
