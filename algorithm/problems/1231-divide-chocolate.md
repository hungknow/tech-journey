# 1231 Divide Chocolate

## Problem Description

You have one chocolate bar that consists of some chunks. Each chunk has its own sweetness given by the array `sweetness`.

You want to share the chocolate with `k` friends, so you need to cut the chocolate bar `k` times. Each cut divides a chunk into two smaller chunks.

After cutting `k` times, you will have `k+1` pieces, and you want to distribute these pieces to `k+1` people (yourself and `k` friends). Each person gets exactly one piece.

The sweetness of the piece is the sum of the sweetness of all chunks in that piece. The total sweetness of all pieces remains the same as the original chocolate bar.

The unfairness of the distribution is defined as the maximum sweetness of a piece minus the minimum sweetness of a piece.

Return the minimum unfairness after cutting the chocolate bar `k` times.

### Example 1:
```
Input: sweetness = [1,2,3,4,5,6,7,8,9], k = 5
Output: 1
Explanation: You can divide the chocolate into [1,2,3], [4,5], [6], [7], [8], [9]
The unfairness is max(6,5,6,7,8,9) - min(6,5,6,7,8,9) = 9 - 6 = 3
We can make the unfairness smaller by dividing into [1,2], [3,4], [5,6], [7], [8], [9]
The unfairness is 3 - 2 = 1
```

### Example 2:
```
Input: sweetness = [5,6,7,8,9,1,2,3,4], k = 8
Output: 1
```

## The Twist

Finding the **minimum unfairness** when dividing chocolate. This is a binary search on answer problem where we check if we can achieve a certain maximum sweetness.

## Algorithm

### Binary Search on Maximum Sweetness:
1. The answer is between `min(sweetness)` and `sum(sweetness)`
2. Binary search on this range:
   - For each `mid`, check if we can divide chocolate into `k+1` pieces with each piece having at most `mid` sweetness
   - If yes, try smaller maximum (`high = mid`)
   - Otherwise, need larger maximum (`low = mid + 1`)
3. When loop ends, `low` is the minimum possible maximum sweetness

To check feasibility, greedily accumulate chunks until adding the next would exceed `mid`, then make a cut.

## Complexity

- **Time**: O(n log(sum(sweetness)))
- **Space**: O(1) - constant extra space

## Solution Code

```go
package main

import (
	"math"
)

func divideChocolate(sweetness []int, k int) int {
	if k >= len(sweetness) {
		return 0
	}
	
	// Find the minimum and maximum possible values
	left, right := math.MaxInt32, 0
	for _, s := range sweetness {
		left = min(left, s)
		right += s
	}
	
	// Binary search for the minimum feasible maximum sweetness
	for left < right {
		mid := left + (right-left)/2
		
		if canDivide(sweetness, k, mid) {
			right = mid
		} else {
			left = mid + 1
		}
	}
	
	return left
}

func canDivide(sweetness []int, k, maxSweetness int) bool {
	pieces := 1
	currentSum := 0
	
	for _, s := range sweetness {
		if currentSum + s > maxSweetness {
			pieces++
			currentSum = s
			
			if pieces > k+1 {
				return false
			}
		} else {
			currentSum += s
		}
	}
	
	return true
}

func min(a, b int) int {
	if a < b {
		return a
	}
	return b
}
```

## Link

[LeetCode 1231 Divide Chocolate](https://leetcode.com/problems/divide-chocolate/)
