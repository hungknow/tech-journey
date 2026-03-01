# 1201 Ugly Number III

## Problem Description

An ugly number is a positive integer that is divisible by `a`, `b`, or `c`.

Given four integers `n`, `a`, `b`, and `c`, return the `nth` ugly number.

### Example 1:
```
Input: n = 3, a = 2, b = 3, c = 5
Output: 4
Explanation: The ugly numbers are 2, 3, 4, 5, 6, 8, 9, 10... The 3rd ugly number is 4.
```

### Example 2:
```
Input: n = 4, a = 2, b = 3, c = 4
Output: 6
Explanation: The ugly numbers are 2, 3, 4, 6, 8, 9, 10, 12... The 4th ugly number is 6.
```

### Example 3:
```
Input: n = 5, a = 2, b = 11, c = 13
Output: 10
Explanation: The ugly numbers are 2, 4, 6, 8, 10, 11, 12, 13... The 5th ugly number is 10.
```

## The Twist

Finding the **nth ugly number** efficiently without generating all ugly numbers. This involves using binary search with the inclusion-exclusion principle to count how many ugly numbers are less than or equal to a given value.

## Algorithm

### Binary Search with Inclusion-Exclusion Principle:
1. Use binary search to find the smallest number `x` such that there are at least `n` ugly numbers ≤ `x`
2. To count ugly numbers ≤ `x`, use the inclusion-exclusion principle:
   - Count numbers divisible by `a`, `b`, or `c`
   - Subtract numbers divisible by pairs (lcm)
   - Add back numbers divisible by all three (lcm)
3. The count is: `x/a + x/b + x/c - x/lcm(a,b) - x/lcm(a,c) - x/lcm(b,c) + x/lcm(a,b,c)`
4. Binary search until we find the exact `nth` ugly number

The key insight is that we can count ugly numbers without generating them, allowing for efficient binary search.

## Complexity

- **Time**: O(log(max(a,b,c) * n)) - binary search operations
- **Space**: O(1) - constant space

## Solution Code

```go
package main

import (
	"fmt"
	"math"
)

func nthUglyNumber(n int, a int, b int, c int) int {
	// Helper function to calculate GCD
	gcd := func(x, y int) int {
		for y != 0 {
			x, y = y, x%y
		}
		return x
	}
	
	// Helper function to calculate LCM
	lcm := func(x, y int) int {
		return x * y / gcd(x, y)
	}
	
	// Helper function to count ugly numbers <= x
	countUgly := func(x int) int {
		ab := lcm(a, b)
		ac := lcm(a, c)
		bc := lcm(b, c)
		abc := lcm(ab, c)
		
		return x/a + x/b + x/c - x/ab - x/ac - x/bc + x/abc
	}
	
	// Binary search for the nth ugly number
	left := 1
	right := n * min(a, min(b, c)) // Upper bound
	
	for left < right {
		mid := left + (right-left)/2
		if countUgly(mid) < n {
			left = mid + 1
		} else {
			right = mid
		}
	}
	
	return left
}

func min(x, y int) int {
	if x < y {
		return x
	}
	return y
}
```

## Link

[LeetCode 1201 Ugly Number III](https://leetcode.com/problems/ugly-number-iii/)