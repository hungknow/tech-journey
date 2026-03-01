# 2517 Maximum Tastiness of Candy Basket

## Problem Description

You are given an integer array `price` where `price[i]` is the price of the `ith` candy.

The tastiness of a candy basket is defined as the minimum absolute difference between the prices of any two different candies in the basket.

Return the maximum possible tastiness of a candy basket containing exactly two candies.

### Example 1:
```
Input: price = [13,5,1,8,21,2]
Output: 13
Explanation: Choose candies with prices 1 and 14 (doesn't exist) or 1 and 21.
The tastiness is |1-21| = 20, but the maximum possible is |1-14| = 13.
```

### Example 2:
```
Input: price = [1,3,1]
Output: 2
Explanation: Choose candies with prices 1 and 3.
The tastiness is |1-3| = 2.
```

### Example 3:
```
Input: price = [7,7,7,7]
Output: 0
Explanation: All candies have the same price, so any basket has tastiness 0.
```

## The Twist

Finding the **maximum tastiness** of a candy basket. This involves using binary search to efficiently determine the maximum possible minimum difference.

## Algorithm

### Binary Search Approach:
1. Sort the price array in ascending order
2. Use binary search on the possible tastiness values (from 0 to max(price) - min(price))
3. For each candidate tastiness `x`:
   - Check if there exists a pair of candies with a difference of at least `x`
   - Use a sliding window or two-pointer technique to efficiently check
4. If such a pair exists, try a larger tastiness; otherwise, try a smaller tastiness
5. Return the maximum valid tastiness

The key insight is that if we can find a pair with difference ≥ `x`, we can also find a pair with difference ≥ any value smaller than `x`, enabling binary search.

## Complexity

- **Time**: O(n log n) - sorting and binary search with pair checking
- **Space**: O(1) - constant space (ignoring space used by sorting)

## Solution Code

```go
package main

import (
	"fmt"
	"sort"
)

func maximumTastiness(price []int) int {
	// Sort the price array
	sort.Ints(price)
	
	// Binary search for the maximum tastiness
	left := 0
	right := price[len(price)-1] - price[0]
	
	result := 0
	
	for left <= right {
		mid := left + (right-left)/2
		
		// Check if there exists a pair with difference >= mid
		found := false
		i := 0
		j := 1
		
		for j < len(price) {
			diff := price[j] - price[i]
			if diff >= mid {
				found = true
				break
			}
			
			j++
			if j-i > 1 {
				i++
			}
		}
		
		if found {
			result = mid
			left = mid + 1 // Try larger tastiness
		} else {
			right = mid - 1 // Try smaller tastiness
		}
	}
	
	return result
}
```

## Link

[LeetCode 2517 Maximum Tastiness of Candy Basket](https://leetcode.com/problems/maximum-tastiness-of-candy-basket/)