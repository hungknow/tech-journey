# 1482 Minimum Number of Days to Make m Bouquets

## Problem Description

You are given an integer array `bloomDay`, an integer `m` and an integer `k`.

You want to make `m` bouquets. To make a bouquet, you need to use `k` adjacent flowers from the garden.

The garden consists of `n` flowers, the `ith` flower will bloom in the `bloomDay[i]` and can be used in exactly one bouquet.

Return the minimum number of days you need to wait to be able to make `m` bouquets from the garden. If it is impossible to make m bouquets return -1.

### Example 1:
```
Input: bloomDay = [1,10,3,10,2], m = 3, k = 1
Output: 3
Explanation: Let's see what happened after the first three days.
- After day 1, we can use [1] to make a bouquet.
- After day 2, we can use [2] to make a bouquet.
- After day 3, we can use [3] to make a bouquet.
So we can make 3 bouquets in 3 days.
```

### Example 2:
```
Input: bloomDay = [1,10,3,10,2], m = 3, k = 2
Output: -1
Explanation: We need 3 bouquets each having 2 flowers, so we need 6 flowers in total.
We only have 5 flowers so it's impossible.
```

## The Twist

Finding the **minimum days** to make `m` bouquets. This is a binary search on answer problem where we check if we can make the required bouquets by a certain day.

## Algorithm

### Binary Search on Days:
1. The answer is between `min(bloomDay)` and `max(bloomDay)`
2. Binary search on this range:
   - For each `mid`, check if we can make `m` bouquets by day `mid`
   - If yes, try fewer days (`right = mid`)
   - Otherwise, need more days (`left = mid + 1`)
3. When loop ends, `left` is the minimum feasible days

To check feasibility, count how many bouquets we can make by finding consecutive bloomed flowers.

## Complexity

- **Time**: O(n log(max(bloomDay) - min(bloomDay)))
- **Space**: O(1) - constant extra space

## Solution Code

```go
package main

func minDays(bloomDay []int, m, k int) int {
	if len(bloomDay) < m*k {
		return -1
	}
	
	left, right := 0, 0
	for _, day := range bloomDay {
		left = min(left, day)
		right = max(right, day)
	}
	
	// Binary search for the minimum feasible days
	for left < right {
		mid := left + (right-left)/2
		
		if canMakeBouquets(bloomDay, m, k, mid) {
			right = mid
		} else {
			left = mid + 1
		}
	}
	
	return left
}

func canMakeBouquets(bloomDay []int, m, k, days int) bool {
	bouquets := 0
	flowers := 0
	
	for _, day := range bloomDay {
		if day <= days {
			flowers++
			if flowers == k {
				bouquets++
				flowers = 0
				if bouquets >= m {
					return true
				}
			}
		} else {
			flowers = 0
		}
	}
	
	return bouquets >= m
}

func min(a, b int) int {
	if a < b {
		return a
	}
	return b
}

func max(a, b int) int {
	if a > b {
		return a
	}
	return b
}
```

## Link

[LeetCode 1482 Minimum Number of Days to Make m Bouquets](https://leetcode.com/problems/minimum-number-of-days-to-make-m-bouquets/)
