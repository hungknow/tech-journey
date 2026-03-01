# 2528 Maximize the Minimum Powered City

## Problem Description

You are given an integer array `stations` representing the power of `n` power stations, where `stations[i]` is the power of the `ith` power station.

You are also given an integer `r` representing the range of each power station. Each power station can provide power to cities within `r` distance.

You are given an integer `k` representing the additional power you can distribute among the power stations.

Return the maximum possible minimum power among all cities after distributing the additional power optimally.

### Example 1:
```
Input: stations = [1,2,4,5,0], r = 1, k = 2
Output: 5
Explanation: 
- Add 1 power to station 1: [1,3,4,5,0]
- Add 1 power to station 3: [1,3,5,6,0]
City powers: [4,8,9,11,6]
Minimum power is 4, but we can do better.
```

### Example 2:
```
Input: stations = [4,4,4,4], r = 0, k = 3
Output: 7
Explanation: Add all power to any station, making it [7,4,4,4].
Minimum power is 4.
```

## The Twist

Finding the **maximum minimum power** after distributing additional power. This involves using binary search to efficiently determine the optimal distribution strategy.

## Algorithm

### Binary Search Approach:
1. Use binary search on the possible minimum power values
2. For each candidate minimum power `x`:
   - Calculate how much additional power is needed to ensure all cities have at least `x` power
   - Use a sliding window technique to efficiently calculate the power distribution
3. If the total additional power needed ≤ `k`, try a larger minimum power; otherwise, try a smaller one
4. Return the maximum achievable minimum power

The key insight is that if we can achieve a minimum power of `x`, we can also achieve any minimum power less than `x`, enabling binary search.

## Complexity

- **Time**: O(n log(maxPower)) - binary search with power distribution calculation
- **Space**: O(n) - space for power distribution array

## Solution Code

```go
package main

import "fmt"

func maxPower(stations []int, r int, k int64) int64 {
	n := len(stations)
	
	// Binary search for the maximum minimum power
	left := int64(0)
	right := int64(0)
	
	// Calculate upper bound
	for _, station := range stations {
		right += int64(station) + k
	}
	
	var result int64
	
	for left <= right {
		mid := left + (right-left)/2
		
		// Check if we can achieve minimum power mid
		if canAchieveMinPower(stations, r, k, mid) {
			result = mid
			left = mid + 1 // Try higher minimum power
		} else {
			right = mid - 1 // Try lower minimum power
		}
	}
	
	return result
}

func canAchieveMinPower(stations []int, r int, k int64, target int64) bool {
	n := len(stations)
	powerNeeded := make([]int64, n)
	
	// Calculate power needed for each position
	for i := 0; i < n; i++ {
		// Current power at position i
		currentPower := int64(stations[i])
		
		// Additional power from previous operations
		if i > 0 {
			currentPower += powerNeeded[i-1]
		}
		
		// Power needed to reach target
		if currentPower < target {
			need := target - currentPower
			
			// Check if we have enough power left
			if need > k {
				return false
			}
			
			// Distribute power to cover range [i, i+r]
			powerNeeded[i] = need
			k -= need
			
			// Remove power effect after range r
			if i+r < n {
				powerNeeded[i+r] -= need
			}
		}
	}
	
	return true
}
```

## Link

[LeetCode 2528 Maximize the Minimum Powered City](https://leetcode.com/problems/maximize-the-minimum-powered-city/)