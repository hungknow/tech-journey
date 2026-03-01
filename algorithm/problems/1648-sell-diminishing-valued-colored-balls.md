# 1648 Sell Diminishing-Valued Colored Balls

## Problem Description

You have an `inventory` of different colored balls, where the value of the `ith` color is `inventory[i]`.

You are also given an integer `orders`, which represents the total number of balls you will sell.

You sell balls in the following way:
- If you have balls of a color, you sell one ball of that color.
- After selling a ball of color `i`, the value of that color decreases by 1.
- You continue this process until you have sold `orders` balls.

Return the maximum total value you can earn after selling `orders` balls. Since the answer may be large, return it modulo `10^9 + 7`.

### Example 1:
```
Input: inventory = [2,5], orders = 4
Output: 14
Explanation: 
- Sell the ball with value 5, inventory becomes [2,4]
- Sell the ball with value 4, inventory becomes [2,3]
- Sell the ball with value 3, inventory becomes [2,2]
- Sell the ball with value 2, inventory becomes [2,1]
Total value: 5 + 4 + 3 + 2 = 14
```

### Example 2:
```
Input: inventory = [3,5], orders = 6
Output: 21
Explanation: 
- Sell the ball with value 5, inventory becomes [3,4]
- Sell the ball with value 4, inventory becomes [3,3]
- Sell the ball with value 3, inventory becomes [3,2]
- Sell the ball with value 3, inventory becomes [2,2]
- Sell the ball with value 2, inventory becomes [2,1]
- Sell the ball with value 2, inventory becomes [2,0]
Total value: 5 + 4 + 3 + 3 + 2 + 2 = 19
```

## The Twist

Finding the **maximum total value** when selling diminishing-valued colored balls. This involves using binary search to determine the threshold value at which we stop selling full rounds of balls.

## Algorithm

### Binary Search Approach:
1. Sort the inventory in descending order
2. Use binary search to find the threshold value `t` such that:
   - We sell all balls with value > `t`
   - We sell some balls with value = `t` to reach exactly `orders` balls
3. Calculate the total value:
   - For balls with value > `t`, use the arithmetic series sum formula
   - For balls with value = `t`, calculate the remaining balls to sell
4. Return the total value modulo `10^9 + 7`

The key insight is that we can determine the threshold value using binary search, avoiding the need to simulate each sale individually.

## Complexity

- **Time**: O(n log n) - sorting and binary search
- **Space**: O(1) - constant space (ignoring space used by sorting)

## Solution Code

```go
package main

import (
	"fmt"
	"sort"
)

const MOD = 1000000007

func maxProfit(inventory []int, orders int) int {
	sort.Sort(sort.Reverse(sort.IntSlice(inventory)))
	
	// Binary search for the threshold value
	left := 0
	right := inventory[0]
	
	for left < right {
		mid := left + (right-left+1)/2
		
		// Calculate how many balls we would sell if threshold is mid
		total := 0
		for _, val := range inventory {
			if val > mid {
				total += val - mid
			}
		}
		
		if total <= orders {
			right = mid
		} else {
			left = mid + 1
		}
	}
	
	threshold := left
	
	// Calculate total value
	result := 0
	remainingOrders := orders
	
	// Sell balls above threshold
	for i, val := range inventory {
		if val > threshold {
			// Calculate how many balls we can sell from this color
			count := val - threshold
			if count > remainingOrders {
				count = remainingOrders
			}
			
			// Sum of arithmetic series: val + (val-1) + ... + (val-count+1)
			result += (val + (val - count + 1)) * count / 2
			remainingOrders -= count
			
			// Handle balls at threshold level
			if i < len(inventory)-1 && inventory[i+1] == threshold {
				continue
			}
		}
	}
	
	// If we still have orders to fulfill, sell from threshold level
	if remainingOrders > 0 {
		result += threshold * remainingOrders
	}
	
	return result % MOD
}
```

## Link

[LeetCode 1648 Sell Diminishing-Valued Colored Balls](https://leetcode.com/problems/sell-diminishing-valued-colored-balls/)