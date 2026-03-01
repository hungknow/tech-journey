# 0374 Guess Number Higher or Lower

## Problem Description

We are playing the Guessing Game. The game will select a number from `1` to `n`. You have to guess which number I picked.

Every time you guess wrong, I will tell you whether the number I picked is higher or lower than your guess.

You call a pre-defined API `int guess(int num)`, which returns three possible results:

- `-1`: Your guess is higher than the number I picked (i.e. `num > pick`).
- `1`: Your guess is lower than the number I picked (i.e. `num < pick`).
- `0`: your guess is equal to the number I picked (i.e. `num == pick`).

Return the number that I picked.

### Example 1:
```
Input: n = 10, pick = 6
Output: 6
```

### Example 2:
```
Input: n = 1, pick = 1
Output: 1
```

## The Twist

Finding the target number using **binary search** with the `guess()` API providing feedback.

## Algorithm

### Binary Search with Guess API:
1. Use binary search with `left = 1` and `right = n`
2. While `left <= right`:
   - Calculate `mid = left + (right-left) / 2`
   - Call `guess(mid)`:
     - If returns 0, we found the number
     - If returns -1, our guess is too high (`right = mid - 1`)
     - If returns 1, our guess is too low (`left = mid + 1`)
3. Return the found number

## Complexity

- **Time**: O(log n) - binary search
- **Space**: O(1) - constant extra space

## Solution Code

```go
package main

/** 
 * Forward declaration of guess API.
 * @param  num   your guess
 * @return 	     -1 if num is higher than the picked number
 *			      1 if num is lower than the picked number
 *               otherwise return 0
 * func guess(num int) int;
 */

func guessNumber(n int) int {
	left, right := 1, n
	
	for left <= right {
		mid := left + (right-left)/2
		result := guess(mid)
		
		if result == 0 {
			return mid
		} else if result == -1 {
			right = mid - 1
		} else {
			left = mid + 1
		}
	}
	
	return -1 // Should not reach here
}

// Mock implementation for testing
func guess(num int) int {
	// This would be provided by the platform
	// For testing purposes, let's say the answer is 6
	pick := 6
	if num == pick {
		return 0
	} else if num > pick {
		return -1
	} else {
		return 1
	}
}
```

## Link

[LeetCode 0374 Guess Number Higher or Lower](https://leetcode.com/problems/guess-number-higher-or-lower/)
