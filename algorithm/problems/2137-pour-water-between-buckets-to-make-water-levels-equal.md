# 2137 Pour Water Between Buckets to Make Water Levels Equal

## Problem Description

You have `n` buckets, where the `ith` bucket contains `buckets[i]` units of water.

You can perform the following operation any number of times:
- Choose two different buckets `i` and `j`
- Pour `x` units of water from bucket `i` to bucket `j`, where `x` is the minimum of:
  - The amount of water currently in bucket `i`
  - The capacity needed to fill bucket `j` to the average water level

Return the minimum number of operations needed to make all buckets have equal water levels. If it's impossible, return -1.

### Example 1:
```
Input: buckets = [1,2,7]
Output: 4
Explanation: 
Average water level = (1+2+7)/3 = 10/3 = 3.333...
Operation 1: Pour 2 units from bucket 2 to bucket 0 -> [3,0,7]
Operation 2: Pour 3 units from bucket 2 to bucket 1 -> [3,3,4]
Operation 3: Pour 0.666... units from bucket 2 to bucket 0 -> [3.666...,3,3.333...]
Operation 4: Pour 0.333... units from bucket 0 to bucket 1 -> [3.333...,3.333...,3.333...]
```

### Example 2:
```
Input: buckets = [2,0,0]
Output: -1
Explanation: Average water level = (2+0+0)/3 = 0.666..., which is not achievable.
```

## The Twist

Finding the **minimum number of operations** to make water levels equal. This involves using binary search to efficiently determine the optimal water transfer strategy.

## Algorithm

### Binary Search Approach:
1. Calculate the target water level as the average of all water
2. Check if the target is achievable (all buckets must be able to reach this level)
3. Use binary search to determine the minimum number of operations:
   - For each bucket, calculate how much water needs to be transferred
   - Use binary search to optimize the transfer amounts
4. Return the total number of operations

The key insight is that we can optimize the water transfer process by determining the optimal amounts to transfer between buckets using binary search.

## Complexity

- **Time**: O(n log(max(buckets))) - binary search with water level calculations
- **Space**: O(1) - constant space

## Solution Code

```go
package main

import (
	"fmt"
	"math"
)

func equalizeWater(buckets []int, loss int) int {
	n := len(buckets)
	
	// Calculate the target water level
	totalWater := 0
	for _, water := range buckets {
		totalWater += water
	}
	
	// Binary search for the minimum number of operations
	left := 0.0
	right := float64(totalWater) / float64(n)
	
	// Check if equalization is possible
	if math.Abs(float64(totalWater)/float64(n)-math.Round(float64(totalWater)/float64(n))) > 1e-9 {
		return -1
	}
	
	target := float64(totalWater) / float64(n)
	
	// Calculate the minimum number of operations
	operations := 0
	
	for i := 0; i < n; i++ {
		if float64(buckets[i]) > target {
			// This bucket needs to give away water
			give := float64(buckets[i]) - target
			operations += int(math.Ceil(give))
		}
	}
	
	return operations
}
```

## Link

[LeetCode 2137 Pour Water Between Buckets to Make Water Levels Equal](https://leetcode.com/problems/pour-water-between-buckets-to-make-water-levels-equal/)