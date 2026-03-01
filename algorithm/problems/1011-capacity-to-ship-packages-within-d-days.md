# 1011 Capacity To Ship Packages Within D Days

## Problem Description

A conveyor belt has packages that must be shipped from one port to another within `days` days.

The `i`th package on the conveyor belt has a weight of `weights[i]`. Each day, we load the ship with packages on the conveyor belt (in the order given by `weights`). We may not load more weight than the maximum weight capacity of the ship.

Return the least weight capacity of the ship that will result in all the packages on the conveyor belt being shipped within `days` days.

### Example 1:
```
Input: weights = [1,2,3,4,5,6,7,8,9,10], days = 5
Output: 15
Explanation: A ship capacity of 15 is the minimum to ship all the packages in 5 days like this:
1st day: 1, 2, 3, 4, 5
2nd day: 6, 7
3rd day: 8
4th day: 9
5th day: 10
```

### Example 2:
```
Input: weights = [3,2,2,4,1,4], days = 3
Output: 6
Explanation: A ship capacity of 6 is the minimum to ship all the packages in 3 days like this:
1st day: 3, 2
2nd day: 2, 4
3rd day: 1, 4
```

## The Twist

Finding the **minimum ship capacity** to ship all packages within `days`. This is another binary search on answer problem.

## Algorithm

### Binary Search on Ship Capacity:
1. The answer is between `max(weights)` (minimum possible) and `sum(weights)` (maximum possible)
2. Binary search on this range:
   - For each `mid`, check if we can ship all packages within `days` with capacity `mid`
   - If yes, try smaller capacity (`high = mid`)
   - Otherwise, need larger capacity (`low = mid + 1`)
3. When loop ends, `low` is the minimum feasible capacity

To check feasibility, greedily accumulate packages until adding the next would exceed capacity, then start a new day.

## Complexity

- **Time**: O(n log(sum(weights) - max(weights)))
- **Space**: O(1) - constant extra space

## Solution Code

```go
package main

func shipWithinDays(weights []int, days int) int {
	if len(weights) == 0 {
		return 0
	}
	
	// Find the minimum and maximum possible capacities
	left, right := 0, 0
	for _, weight := range weights {
		left = max(left, weight)    // At least the heaviest package
		right += weight              // All packages in one day
	}
	
	// Binary search for the minimum feasible capacity
	for left < right {
		mid := left + (right-left)/2
		
		if canShip(weights, days, mid) {
			right = mid
		} else {
			left = mid + 1
		}
	}
	
	return left
}

func canShip(weights []int, days, capacity int) bool {
	neededDays := 1
	currentLoad := 0
	
	for _, weight := range weights {
		if currentLoad + weight > capacity {
			neededDays++
			currentLoad = weight
			
			if neededDays > days {
				return false
			}
		} else {
			currentLoad += weight
		}
	}
	
	return true
}

func max(a, b int) int {
	if a > b {
		return a
	}
	return b
}
```

## Link

[LeetCode 1011 Capacity To Ship Packages Within D Days](https://leetcode.com/problems/capacity-to-ship-packages-within-d-days/)
