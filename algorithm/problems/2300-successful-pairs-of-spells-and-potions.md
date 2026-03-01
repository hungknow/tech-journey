# 2300 Successful Pairs of Spells and Potions

## Problem Description

You are given two positive integer arrays `spells` and `potions`, of length `n` and `m` respectively, where `spells[i]` represents the strength of the `ith` spell and `potions[j]` represents the strength of the `jth` potion.

You are also given an integer `success`. A spell and potion pair is considered successful if the product of their strengths is at least `success`.

Return an integer array `pairs` of length `n` where `pairs[i]` is the number of successful pairs you can create with the `ith` spell.

### Example 1:
```
Input: spells = [5,1,3], potions = [1,2,3,4,5], success = 7
Output: [4,0,3]
Explanation:
- For spell 5: successful pairs are (5,2), (5,3), (5,4), (5,5)
- For spell 1: no successful pairs
- For spell 3: successful pairs are (3,3), (3,4), (3,5)
```

### Example 2:
```
Input: spells = [3,1,2], potions = [8,5,8], success = 16
Output: [2,0,2]
Explanation:
- For spell 3: successful pairs are (3,8), (3,8)
- For spell 1: no successful pairs
- For spell 2: successful pairs are (2,8), (2,8)
```

## The Twist

Finding the **successful pairs** of spells and potions efficiently. This involves using binary search to quickly count how many potions work with each spell.

## Algorithm

### Binary Search Approach:
1. Sort the potions array in ascending order
2. For each spell:
   - Calculate the minimum potion strength needed: `minStrength = ceil(success / spell)`
   - Use binary search to find the first potion with strength ≥ `minStrength`
   - Count all potions from this position to the end
3. Return the count for each spell

The key insight is that by sorting the potions, we can use binary search to efficiently count how many potions work with each spell, avoiding a linear scan.

## Complexity

- **Time**: O(m log m + n log m) - sorting potions and binary searches
- **Space**: O(1) - constant space (ignoring space used by sorting)

## Solution Code

```go
package main

import (
	"fmt"
	"sort"
)

func successfulPairs(spells []int, potions []int, success int64) []int {
	// Sort potions for binary search
	sort.Ints(potions)
	
	result := make([]int, len(spells))
	
	for i, spell := range spells {
		// Calculate the minimum potion strength needed
		minStrength := (int(success) + spell - 1) / spell // Ceiling division
		
		// Binary search for the first potion with strength >= minStrength
		left := 0
		right := len(potions)
		
		for left < right {
			mid := left + (right-left)/2
			if potions[mid] < minStrength {
				left = mid + 1
			} else {
				right = mid
			}
		}
		
		// Count all potions from this position to the end
		result[i] = len(potions) - left
	}
	
	return result
}
```

## Link

[LeetCode 2300 Successful Pairs of Spells and Potions](https://leetcode.com/problems/successful-pairs-of-spells-and-potions/)