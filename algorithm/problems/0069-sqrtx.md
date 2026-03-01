# 0069 Sqrt(x)

## Problem Description

Given a non-negative integer `x`, return the square root of `x` rounded down to the nearest integer. The returned integer should be non-negative as well.

You must not use any built-in exponent function or operator.

For example, do not use `pow(x, 0.5)` in c++ or `x ** 0.5` in python.

### Example 1:
```
Input: x = 4
Output: 2
Explanation: The square root of 4 is 2, so we return 2.
```

### Example 2:
```
Input: x = 8
Output: 2
Explanation: The square root of 8 is 2.82842..., and since we round it down to the nearest integer, 2 is returned.
```

## The Twist

Finding the **integer square root** without using built-in functions. We need to find the largest integer whose square is ≤ x.

## Algorithm

### Binary Search for Square Root:
1. Use binary search with `left = 0` and `right = x`
2. While `left <= right`:
   - Calculate `mid = left + (right-left) / 2`
   - If `mid * mid == x`, return `mid`
   - If `mid * mid < x`, the answer is at least `mid` (`left = mid + 1`)
   - If `mid * mid > x`, the answer is smaller (`right = mid - 1`)
3. When loop ends, `right` is the largest integer whose square is ≤ x

## Complexity

- **Time**: O(log x) - binary search
- **Space**: O(1) - constant extra space

## Solution Code

```go
package main

func mySqrt(x int) int {
	if x < 2 {
		return x
	}
	
	left, right := 1, x/2
	result := 0
	
	for left <= right {
		mid := left + (right-left)/2
		
		if mid == x/mid {
			return mid
		} else if mid < x/mid {
			result = mid
			left = mid + 1
		} else {
			right = mid - 1
		}
	}
	
	return result
}
```

## Link

[LeetCode 0069 Sqrt(x)](https://leetcode.com/problems/sqrtx/)
