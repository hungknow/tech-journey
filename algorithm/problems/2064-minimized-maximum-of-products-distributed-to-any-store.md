# 2064 Minimized Maximum of Products Distributed to Any Store

## Problem Description

You are given `n` stores and `m` products, where the `ith` product has `quantities[i]` units.

You need to distribute all products to the stores such that:
1. Each product can be distributed to any number of stores
2. Each store can receive any number of products
3. Each product unit must be distributed to exactly one store

Return the minimum possible maximum number of products distributed to any store.

### Example 1:
```
Input: n = 6, quantities = [11,6]
Output: 3
Explanation: 
- Distribute product 0 (11 units) to stores [3,3,3,2]
- Distribute product 1 (6 units) to stores [3,3]
Maximum products in any store: 3
```

### Example 2:
```
Input: n = 7, quantities = [15,10,10]
Output: 5
Explanation: 
- Distribute product 0 (15 units) to stores [5,5,5]
- Distribute product 1 (10 units) to stores [5,5]
- Distribute product 2 (10 units) to stores [5,5]
Maximum products in any store: 5
```

## The Twist

Finding the **minimized maximum** of products distributed to any store. This involves using binary search to efficiently determine the optimal distribution strategy.

## Algorithm

### Binary Search Approach:
1. Use binary search on the maximum number of products per store (from 1 to max(quantities))
2. For each candidate maximum `x`:
   - Calculate the minimum number of stores needed to distribute all products with each store having at most `x` products
   - For each product `q`, it needs `ceil(q/x)` stores
   - Sum these values to get the total stores needed
3. If the total stores needed ≤ `n`, try a smaller maximum; otherwise, try a larger maximum
4. Return the minimum valid maximum

The key insight is that if we can distribute all products with each store having at most `x` products, we can also distribute them with each store having at most any value larger than `x`, enabling binary search.

## Complexity

- **Time**: O(m log(max(quantities))) - binary search with distribution check
- **Space**: O(1) - constant space

## Solution Code

```go
package main

import (
	"fmt"
	"math"
)

func minimizedMaximum(n int, quantities []int) int {
	// Binary search for the minimum possible maximum
	left := 1
	right := 0
	
	// Find the maximum quantity as upper bound
	for _, q := range quantities {
		if q > right {
			right = q
		}
	}
	
	result := 0
	
	for left <= right {
		mid := left + (right-left)/2
		
		// Calculate the minimum number of stores needed with maximum mid
		storesNeeded := 0
		for _, q := range quantities {
			storesNeeded += int(math.Ceil(float64(q) / float64(mid)))
		}
		
		if storesNeeded <= n {
			result = mid
			right = mid - 1 // Try smaller maximum
		} else {
			left = mid + 1 // Try larger maximum
		}
	}
	
	return result
}
```

## Link

[LeetCode 2064 Minimized Maximum of Products Distributed to Any Store](https://leetcode.com/problems/minimized-maximum-of-products-distributed-to-any-store/)