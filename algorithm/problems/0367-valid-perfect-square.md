# 0367 Valid Perfect Square

## Problem Description

Given a positive integer `num`, write a function which returns `true` if `num` is a perfect square else `false`.

Follow up: Do not use any built-in library function such as `sqrt`.

### Example 1:
```
Input: num = 16
Output: true
```

### Example 2:
```
Input: num = 14
Output: false
```

## The Twist

Determining if a number is a **perfect square** without using sqrt. We can use binary search or Newton's method.

## Algorithm

### Binary Search Approach:
1. Use binary search between 1 and num
2. For each `mid`, check if `mid * mid == num`
3. Be careful with integer overflow when calculating `mid * mid`

Alternatively, use the mathematical property that perfect squares are the sum of consecutive odd numbers.

## Complexity

- **Time**: O(log n) - binary search
- **Space**: O(1) - constant extra space

## Solution Code

```go
package main

func isPerfectSquare(num int) bool {
	if num < 2 {
		return true
	}
	
	left, right := 1, num/2
	
	for left <= right {
		mid := left + (right-left)/2
		
		// Check for overflow
		if mid > num/mid {
			right = mid - 1
		} else if mid*mid == num {
			return true
		} else {
			left = mid + 1
		}
	}
	
	return false
}
```

## Link

[LeetCode 0367 Valid Perfect Square](https://leetcode.com/problems/valid-perfect-square/)
