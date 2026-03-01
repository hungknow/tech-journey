# 0875 Koko Eating Bananas

## Problem Description

Koko loves to eat bananas. There are `n` piles of bananas, the `ith` pile has `piles[i]` bananas. The guards have gone and will come back in `h` hours.

Koko can decide her bananas-per-hour eating speed of `k`. Each hour, she chooses some pile of bananas and eats `k` bananas from that pile. If the pile has less than `k` bananas, she eats all of them instead and will not eat any more bananas during this hour.

Koko likes to eat slowly but still wants to finish eating all the bananas before the guards return.

Return the minimum integer `k` such that she can eat all the bananas within `h` hours.

### Example 1:
```
Input: piles = [3,6,7,11], h = 8
Output: 4
```

### Example 2:
```
Input: piles = [30,11,23,4,20], h = 5
Output: 30
```

### Example 3:
```
Input: piles = [30,11,23,4,20], h = 6
Output: 23
```

## The Twist

Finding the **minimum eating speed** to finish all bananas within `h` hours. This is a binary search on answer problem where we check if a given speed is feasible.

## Algorithm

### Binary Search on Eating Speed:
1. The answer is between 1 (minimum speed) and max(piles) (maximum needed speed)
2. Binary search on this range:
   - For each `mid`, calculate hours needed to eat all bananas at speed `mid`
   - For each pile, hours needed = ceil(pile/mid)
   - If total hours ≤ h, try slower speed (`high = mid`)
   - Otherwise, need faster speed (`low = mid + 1`)
3. When loop ends, `low` is the minimum feasible speed

## Complexity

- **Time**: O(n log(max(piles))) where n is the number of piles
- **Space**: O(1) - constant extra space

## Solution Code

```go
package main

import (
	"math"
)

func minEatingSpeed(piles []int, h int) int {
	if len(piles) == 0 {
		return 0
	}
	
	// Find the minimum and maximum possible speeds
	left, right := 1, 0
	for _, pile := range piles {
		right = max(right, pile)
	}
	
	// Binary search for the minimum feasible speed
	for left < right {
		mid := left + (right-left)/2
		
		if canEatAll(piles, h, mid) {
			right = mid
		} else {
			left = mid + 1
		}
	}
	
	return left
}

func canEatAll(piles []int, h, speed int) bool {
	hours := 0
	
	for _, pile := range piles {
		// Hours needed for this pile: ceil(pile/speed)
		hours += int(math.Ceil(float64(pile) / float64(speed)))
		
		if hours > h {
			return false
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

[LeetCode 0875 Koko Eating Bananas](https://leetcode.com/problems/koko-eating-bananas/)
