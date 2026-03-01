# 2940 Find Building Where Alice and Bob Can Meet

## Problem Description

You are given three integers `n`, `alicePos`, and `bobPos`, representing `n` buildings in a line, where Alice is at building `alicePos` and Bob is at building `bobPos`.

Alice and Bob can move to adjacent buildings in one step. They want to meet at the same building.

Return the minimum number of steps required for Alice and Bob to meet.

### Example 1:
```
Input: n = 6, alicePos = 3, bobPos = 5
Output: 1
Explanation: Alice moves from building 3 to building 4.
Bob moves from building 5 to building 4.
They meet at building 4 in 1 step.
```

### Example 2:
```
Input: n = 5, alicePos = 2, bobPos = 4
Output: 1
Explanation: Alice moves from building 2 to building 3.
Bob moves from building 4 to building 3.
They meet at building 3 in 1 step.
```

### Example 3:
```
Input: n = 100, alicePos = 1, bobPos = 100
Output: 49
Explanation: Alice moves from building 1 to building 50.
Bob moves from building 100 to building 50.
They meet at building 50 in 49 steps.
```

## The Twist

Finding the **minimum steps** for Alice and Bob to meet. This involves using binary search to efficiently determine the optimal meeting building.

## Algorithm

### Binary Search Approach:
1. Use binary search on the possible meeting buildings
2. For each candidate meeting building `x`:
   - Calculate the steps needed for Alice to reach `x`: `|alicePos - x|`
   - Calculate the steps needed for Bob to reach `x`: `|bobPos - x|`
   - The total steps is the maximum of these two values
3. Find the building that minimizes the maximum steps
4. Return the minimum number of steps

The key insight is that the optimal meeting building is between Alice and Bob, and binary search helps find it efficiently.

## Complexity

- **Time**: O(log n) - binary search on buildings
- **Space**: O(1) - constant space

## Solution Code

```go
package main

import "fmt"

func minSteps(n int, alicePos int, bobPos int) int {
	// Binary search for the optimal meeting building
	left := 1
	right := n
	
	result := 0
	
	for left <= right {
		mid := left + (right-left)/2
		
		// Calculate steps needed to meet at building mid
		aliceSteps := abs(alicePos - mid)
		bobSteps := abs(bobPos - mid)
		totalSteps := max(aliceSteps, bobSteps)
		
		// Check if we can do better
		if mid > 1 {
			midLeft := mid - 1
			aliceStepsLeft := abs(alicePos - midLeft)
			bobStepsLeft := abs(bobPos - midLeft)
			totalStepsLeft := max(aliceStepsLeft, bobStepsLeft)
			
			if totalStepsLeft < totalSteps {
				right = mid - 1
				result = totalStepsLeft
				continue
			}
		}
		
		if mid < n {
			midRight := mid + 1
			aliceStepsRight := abs(alicePos - midRight)
			bobStepsRight := abs(bobPos - midRight)
			totalStepsRight := max(aliceStepsRight, bobStepsRight)
			
			if totalStepsRight < totalSteps {
				left = mid + 1
				result = totalStepsRight
				continue
			}
		}
		
		result = totalSteps
		break
	}
	
	return result
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
```

## Link

[LeetCode 2940 Find Building Where Alice and Bob Can Meet](https://leetcode.com/problems/find-building-where-alice-and-bob-can-meet/)