# 1891 Cutting Ribbons

## Problem Description

You are given an integer array `ribbons`, where `ribbons[i]` represents the length of the `ith` ribbon, and an integer `k`.

You may cut any ribbon into pieces of any positive integer length, but you cannot join ribbons together.

Return the maximum possible integer length `L` such that you can obtain at least `k` pieces of length `L`.

### Example 1:
```
Input: ribbons = [9,3,8,2], k = 11
Output: 2
Explanation: 
- Cut the ribbon of length 9 into 4 pieces of length 2
- Cut the ribbon of length 3 into 1 piece of length 2
- Cut the ribbon of length 8 into 4 pieces of length 2
- Cut the ribbon of length 2 into 1 piece of length 2
Total pieces: 4 + 1 + 4 + 1 = 10, which is less than 11.
So the maximum possible length is 1.
```

### Example 2:
```
Input: ribbons = [7,5,9], k = 4
Output: 4
Explanation: 
- Cut the ribbon of length 7 into 1 piece of length 4
- Cut the ribbon of length 5 into 1 piece of length 4
- Cut the ribbon of length 9 into 2 pieces of length 4
Total pieces: 1 + 1 + 2 = 4
```

## The Twist

Finding the **maximum ribbon length** that can yield at least `k` pieces. This involves using binary search to efficiently determine the optimal length.

## Algorithm

### Binary Search Approach:
1. Use binary search on possible ribbon lengths (from 1 to the maximum ribbon length)
2. For each length candidate `L`:
   - Calculate how many pieces of length `L` can be obtained from all ribbons
   - Sum up `ribbon[i] / L` for all ribbons
3. If the total number of pieces ≥ `k`, try a larger length; otherwise, try a smaller length
4. Return the maximum valid length

The key insight is that if we can obtain at least `k` pieces of length `L`, we can also obtain at least `k` pieces of any length smaller than `L`, enabling binary search.

## Complexity

- **Time**: O(n log(maxRibbon)) - binary search with piece counting
- **Space**: O(1) - constant space

## Solution Code

```go
package main

import "fmt"

func maxLength(ribbons []int, k int) int {
	// Binary search for the maximum length
	left := 1
	right := 0
	
	// Find the maximum ribbon length as upper bound
	for _, ribbon := range ribbons {
		if ribbon > right {
			right = ribbon
		}
	}
	
	result := 0
	
	for left <= right {
		mid := left + (right-left)/2
		
		// Calculate how many pieces of length mid we can get
		totalPieces := 0
		for _, ribbon := range ribbons {
			totalPieces += ribbon / mid
		}
		
		if totalPieces >= k {
			result = mid
			left = mid + 1 // Try larger length
		} else {
			right = mid - 1 // Try smaller length
		}
	}
	
	return result
}
```

## Link

[LeetCode 1891 Cutting Ribbons](https://leetcode.com/problems/cutting-ribbons/)