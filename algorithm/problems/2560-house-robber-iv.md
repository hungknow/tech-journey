# 2560 House Robber IV

## Problem Description

There are `n` houses in a street arranged in a circle. Each house has some money stashed.

The houses are numbered from `0` to `n-1`. The `ith` house has `nums[i]` money.

You are a professional thief planning to rob houses along the street. However, you cannot rob adjacent houses. Since the houses are arranged in a circle, the first and last houses are also adjacent.

You want to rob exactly `k` houses. Return the minimum amount of money you can steal.

### Example 1:
```
Input: nums = [2,3,5,9], k = 2
Output: 5
Explanation: Rob houses 0 and 2 for a total of 2 + 5 = 7.
But the minimum is to rob houses 1 and 3 for a total of 3 + 9 = 12.
Actually, the minimum is to rob houses 0 and 3 for a total of 2 + 9 = 11.
Wait, let me recalculate...
The minimum is to rob houses 0 and 1 for a total of 2 + 3 = 5.
```

### Example 2:
```
Input: nums = [2,3,5,9], k = 3
Output: 10
Explanation: Rob houses 0, 1, and 3 for a total of 2 + 3 + 9 = 14.
But the minimum is to rob houses 0, 2, and 3 for a total of 2 + 5 + 9 = 16.
Actually, the minimum is to rob houses 1, 2, and 3 for a total of 3 + 5 + 9 = 17.
Wait, let me recalculate...
The minimum is to rob houses 0, 1, and 2 for a total of 2 + 3 + 5 = 10.
```

## The Twist

Finding the **minimum amount** to steal when robbing exactly `k` houses in a circle. This involves using binary search to efficiently determine the optimal houses to rob.

## Algorithm

### Binary Search Approach:
1. Use binary search on the possible minimum amounts
2. For each candidate amount `x`:
   - Check if it's possible to rob exactly `k` houses with total amount ≤ `x`
   - Use dynamic programming to find the minimum number of houses needed for each amount
3. If we can rob `k` houses with amount ≤ `x`, try a smaller amount; otherwise, try a larger amount
4. Return the minimum achievable amount

The key insight is that if we can rob `k` houses with total amount ≤ `x`, we can also rob `k` houses with total amount ≤ any value larger than `x`, enabling binary search.

## Complexity

- **Time**: O(n * k * log(maxAmount)) - binary search with DP
- **Space**: O(n * k) - DP table

## Solution Code

```go
package main

import "fmt"

func minCapability(nums []int, k int) int {
	// Binary search for the minimum amount
	left := 0
	right := 0
	
	// Find the maximum amount as upper bound
	for _, num := range nums {
		if num > right {
			right = num
		}
	}
	
	result := right
	
	for left <= right {
		mid := left + (right-left)/2
		
		// Check if we can rob k houses with capability mid
		if canRob(nums, k, mid) {
			result = mid
			right = mid - 1 // Try smaller amount
		} else {
			left = mid + 1 // Try larger amount
		}
	}
	
	return result
}

func canRob(nums []int, k, maxAmount int) bool {
	n := len(nums)
	
	// dp[i][j] = maximum number of houses we can rob from first i houses with j robberies
	dp := make([][]int, n+1)
	for i := range dp {
		dp[i] = make([]int, k+1)
	}
	
	// Initialize
	for i := 0; i <= n; i++ {
		for j := 0; j <= k; j++ {
			dp[i][j] = -1
		}
	}
	
	dp[0][0] = 0
	
	for i := 1; i <= n; i++ {
		for j := 0; j <= k; j++ {
			// Option 1: Don't rob house i-1
			if dp[i-1][j] != -1 {
				dp[i][j] = dp[i-1][j]
			}
			
			// Option 2: Rob house i-1 if it's within maxAmount
			if j > 0 && nums[i-1] <= maxAmount {
				if i == 1 {
					if dp[i-1][j-1] == -1 {
						dp[i][j] = nums[i-1]
					}
				} else if dp[i-2][j-1] != -1 {
					if dp[i][j] == -1 || dp[i-2][j-1]+nums[i-1] < dp[i][j] {
						dp[i][j] = dp[i-2][j-1] + nums[i-1]
					}
				}
			}
		}
	}
	
	// Check if we can rob exactly k houses
	for i := 1; i <= n; i++ {
		if dp[i][k] != -1 {
			return true
		}
	}
	
	return false
}
```

## Link

[LeetCode 2560 House Robber IV](https://leetcode.com/problems/house-robber-iv/)