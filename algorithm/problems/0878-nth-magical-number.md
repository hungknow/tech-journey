# 0878 Nth Magical Number

## Problem Description

We define a magical number `S` that is divisible by `a`, `b`, and `c` simultaneously if and only if it is divisible by at least one of them.

Given the three integers `n`, `a`, and `b`, return the `n`th magical number.

### Example 1:
```
Input: n = 5, a = 2, b = 4
Output: 8
Explanation: The first 5 magical numbers are: 2, 4, 6, 8, 10.
```

## The Twist

Finding the **nth magical number** efficiently. This is a binary search on answer problem where we count how many numbers are ≤ x.

## Algorithm

### Binary Search on Magical Numbers:
1. The answer is between `min(a, b, c)` and `n * max(a, b, c)`
2. Binary search on this range:
   - For each `mid`, count how many numbers ≤ `mid` are magical
   - If count ≥ n, try smaller value (`right = mid`)
   - Otherwise, need larger value (`left = mid + 1`)
3. When loop ends, `left` is the nth magical number

## Complexity

- **Time**: O(log(n * max(a, b, c))) - binary search with O(log n) counting
- **Space**: O(1) - constant extra space

## Solution Code

```go
package main

func nthMagicalNumber(n, a, b, c int) int {
	left, right := min(a, b, c), n*max(a, b, c)
	
	for left < right {
		mid := left + (right-left)/2
		
		if countMagical(mid, a, b, c) >= n {
			right = mid
		} else {
			left = mid + 1
		}
	}
	
	return left
}

func countMagical(x, a, b, c int) int {
	count := 0
	if x%a == 0 {
		count++
	}
	if x%b == 0 {
		count++
	}
	if x%c == 0 {
		count++
	}
	
	return count
}

func min(a, b, c int) int {
	if a <= b && a <= c {
		return a
	} else if b <= a && b <= c {
		return b
	} else {
		return c
	}
}

func max(a, b, c int) int {
	if a >= b && a >= c {
		return a
	} else if b >= a && b >= c {
		return b
	} else {
		return c
	}
}
```

## Link

[LeetCode 0878 Nth Magical Number](https://leetcode.com/problems/nth-magical-number/)
