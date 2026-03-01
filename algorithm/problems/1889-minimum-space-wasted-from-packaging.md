# 1889 Minimum Space Wasted From Packaging

## Problem Description

You have `n` packages, where the `ith` package has a weight of `packages[i]`.

You have `m` suppliers, where the `jth` supplier can supply packages with weights in the range `[minWeights[j], maxWeights[j]]`.

For each supplier, you can package any subset of the packages as long as the total weight of the subset is within the supplier's range. The space wasted is the difference between the maximum capacity of the supplier and the total weight of the packages you choose to package with that supplier.

Return the minimum total space wasted when packaging all the packages.

### Example 1:
```
Input: packages = [2,3,5], minWeights = [1,2,3], maxWeights = [5,6,7]
Output: 0
Explanation: 
- Use supplier 1 to package package 1 (weight 2)
- Use supplier 2 to package package 2 (weight 3)
- Use supplier 3 to package package 3 (weight 5)
No space is wasted.
```

### Example 2:
```
Input: packages = [2,3,5,9], minWeights = [1,3,5], maxWeights = [4,8,10]
Output: 5
Explanation: 
- Use supplier 1 to package packages 1 and 2 (weights 2 and 3, total 5)
- Use supplier 3 to package packages 3 and 4 (weights 5 and 9, total 14)
Space wasted: (4-5) + (10-14) = 5
```

## The Twist

Finding the **minimum space wasted** from packaging. This involves using binary search to efficiently determine the optimal packaging strategy for each supplier.

## Algorithm

### Binary Search Approach:
1. Sort the packages in ascending order
2. Create a prefix sum array for efficient range sum calculations
3. For each supplier:
   - Use binary search to find the range of packages that can be packaged by this supplier
   - Calculate the minimum space wasted for this supplier using dynamic programming
4. Use dynamic programming to find the minimum total space wasted across all suppliers

The key insight is that by sorting the packages and using binary search, we can efficiently determine which packages can be grouped together for each supplier.

## Complexity

- **Time**: O(n log n + m log n + n*m) - sorting, binary searches, and DP
- **Space**: O(n) - space for prefix sum and DP array

## Solution Code

```go
package main

import (
	"fmt"
	"math"
	"sort"
)

func minWastedSpace(packages []int, boxes [][]int) int {
	const MOD = 1000000007
	
	// Sort packages
	sort.Ints(packages)
	n := len(packages)
	
	// Create prefix sum array
	prefix := make([]int, n+1)
	for i := 0; i < n; i++ {
		prefix[i+1] = prefix[i] + packages[i]
	}
	
	// DP array: dp[i] = minimum space wasted for packages[i:]
	dp := make([]int, n+1)
	for i := n - 1; i >= 0; i-- {
		dp[i] = math.MaxInt32
	}
	
	// Try each box/supplier
	for _, box := range boxes {
		minWeight, maxWeight := box[0], box[1]
		
		// Find the first package that can fit in this box
		start := sort.SearchInts(packages, minWeight)
		
		// Try different packaging strategies starting from each position
		for i := 0; i < n; i++ {
			// Find the furthest package that can fit in this box
			end := sort.SearchInts(packages, maxWeight+1)
			
			// Try packaging packages[i:end] in this box
			if end > i {
				totalWeight := prefix[end] - prefix[i]
				spaceWasted := maxWeight - totalWeight
				
				// Update DP
				if end < n && dp[end] != math.MaxInt32 {
					dp[i] = min(dp[i], spaceWasted+dp[end])
				} else if end == n {
					dp[i] = min(dp[i], spaceWasted)
				}
			}
		}
	}
	
	if dp[0] == math.MaxInt32 {
		return -1
	}
	
	return dp[0] % MOD
}

func min(a, b int) int {
	if a < b {
		return a
	}
	return b
}
```

## Link

[LeetCode 1889 Minimum Space Wasted From Packaging](https://leetcode.com/problems/minimum-space-wasted-from-packaging/)