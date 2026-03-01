# 1552 Magnetic Force Between Two Balls

## Problem Description

In the universe Earth C-137, Rick discovered a special form of magnetic force between two balls if they are put in his new invented basket. Rick has `n` empty baskets, the `ith` basket is at `position[i]`, Morty has `m` balls and needs to distribute the balls into the baskets such that the minimum magnetic force between any two balls is maximum.

Rick stated that magnetic force between two different balls at positions `x` and `y` is `|x - y|`.

Given the integer array `position` and the integer `m`, return the required force.

### Example 1:
```
Input: position = [1,2,3,4,7], m = 3
Output: 3
Explanation: Distributing the 3 balls into baskets 1, 4 and 7 will make the magnetic force between ball pairs [3, 3, 6]. The minimum magnetic force is 3.
```

### Example 2:
```
Input: position = [5,4,3,2,1,1000000000], m = 2
Output: 999999999
Explanation: We can use baskets 1 and 1000000000.
```

## The Twist

Finding the **maximum minimum magnetic force**. This is a binary search on answer problem where we check if we can place `m` balls with at least a certain force between them.

## Algorithm

### Binary Search on Force:
1. Sort the positions array
2. The answer is between 1 and `position[n-1] - position[0]`
3. Binary search on this range:
   - For each `mid`, check if we can place `m` balls with at least `mid` force between them
   - If yes, try larger force (`left = mid + 1`)
   - Otherwise, need smaller force (`right = mid - 1`)
4. When loop ends, `left` is the maximum feasible minimum force

To check feasibility, greedily place balls starting from the first position.

## Complexity

- **Time**: O(n log(max_distance))
- **Space**: O(1) - constant extra space

## Solution Code

```go
package main

import (
	"sort"
)

func maxDistance(position []int, m int) int {
	sort.Ints(position)
	
	left, right := 1, position[len(position)-1] - position[0]
	result := 0
	
	// Binary search for the maximum feasible minimum distance
	for left <= right {
		mid := left + (right-left)/2
		
		if canPlaceBalls(position, m, mid) {
			result = mid
			left = mid + 1
		} else {
			right = mid - 1
		}
	}
	
	return result
}

func canPlaceBalls(position []int, m, minDistance int) bool {
	count := 1
	lastPosition := position[0]
	
	for i := 1; i < len(position); i++ {
		if position[i] - lastPosition >= minDistance {
			count++
			lastPosition = position[i]
			
			if count >= m {
				return true
			}
		}
	}
	
	return count >= m
}
```

## Link

[LeetCode 1552 Magnetic Force Between Two Balls](https://leetcode.com/problems/magnetic-force-between-two-balls/)
