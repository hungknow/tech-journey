# 2594 Minimum Time to Repair Cars

## Problem Description

You are given an integer array `ranks` representing the ranks of mechanics, and an integer `cars`.

The `ith` mechanic can repair `cars[i]` cars in `ranks[i] * cars[i]^2` minutes.

You need to repair all `cars` cars. Return the minimum time required to repair all cars.

### Example 1:
```
Input: ranks = [4,2,3,1], cars = 10
Output: 16
Explanation:
- Mechanic 0 can repair 2 cars in 4 * 2^2 = 16 minutes
- Mechanic 1 can repair 3 cars in 2 * 3^2 = 18 minutes
- Mechanic 2 can repair 2 cars in 3 * 2^2 = 12 minutes
- Mechanic 3 can repair 3 cars in 1 * 3^2 = 9 minutes
Total cars repaired: 2 + 3 + 2 + 3 = 10
```

### Example 2:
```
Input: ranks = [5,1,8], cars = 6
Output: 8
Explanation:
- Mechanic 0 can repair 1 car in 5 * 1^2 = 5 minutes
- Mechanic 1 can repair 2 cars in 1 * 2^2 = 4 minutes
- Mechanic 2 can repair 1 car in 8 * 1^2 = 8 minutes
Total cars repaired: 1 + 2 + 1 = 4, not enough.
Actually, the minimum time is 8 minutes.
```

## The Twist

Finding the **minimum time** to repair all cars. This involves using binary search to efficiently determine the optimal time allocation.

## Algorithm

### Binary Search Approach:
1. Use binary search on time (from 1 to a reasonable upper bound)
2. For each candidate time `t`:
   - Calculate how many cars each mechanic can repair: `floor(sqrt(t/rank[i]))`
   - Sum these values to get the total number of cars repaired
3. If the total cars repaired ≥ `cars`, try a smaller time; otherwise, try a larger time
4. Return the minimum valid time

The key insight is that if we can repair all cars in time `t`, we can also repair them in any time greater than `t`, enabling binary search.

## Complexity

- **Time**: O(n log(maxTime)) - binary search with car counting
- **Space**: O(1) - constant space

## Solution Code

```go
package main

import (
	"fmt"
	"math"
)

func repairCars(ranks []int, cars int) int64 {
	// Binary search for the minimum time
	left := int64(1)
	right := int64(0)
	
	// Find a reasonable upper bound
	minRank := ranks[0]
	for _, rank := range ranks {
		if rank < minRank {
			minRank = rank
		}
	}
	right = int64(minRank) * int64(cars) * int64(cars)
	
	var result int64
	
	for left <= right {
		mid := left + (right-left)/2
		
		// Calculate how many cars can be repaired in mid time
		totalCars := 0
		for _, rank := range ranks {
			// Each mechanic can repair floor(sqrt(mid/rank)) cars
			carsByMechanic := int(math.Sqrt(float64(mid) / float64(rank)))
			totalCars += carsByMechanic
		}
		
		if totalCars >= cars {
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

[LeetCode 2594 Minimum Time to Repair Cars](https://leetcode.com/problems/minimum-time-to-repair-cars/)