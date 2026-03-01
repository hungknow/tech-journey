# 2557 Maximum Number of Integers to Choose From a Range II

## Problem Description

You are given an integer array `banned` and two integers `n` and `maxSum`.

You are choosing integers from the range `[1, n]` that are not in `banned`. The chosen integers must have a sum less than or equal to `maxSum`.

Return the maximum number of integers you can choose following these rules.

### Example 1:
```
Input: banned = [1,6,5], n = 5, maxSum = 6
Output: 2
Explanation: You can choose 2 and 3 with sum 5.
```

### Example 2:
```
Input: banned = [1,2,3,4,5,6,7], n = 8, maxSum = 1
Output: 0
Explanation: All numbers from 1 to 7 are banned, and 8 > maxSum.
```

### Example 3:
```
Input: banned = [11], n = 7, maxSum = 50
Output: 7
Explanation: You can choose all numbers from 1 to 7 with sum 28 <= 50.
```

## The Twist

Finding the **maximum number of integers** to choose from a range. This involves using binary search to efficiently determine the optimal selection strategy.

## Algorithm

### Binary Search Approach:
1. Create a set of banned numbers for O(1) lookup
2. Sort the banned numbers and add 0 and n+1 as boundaries
3. Use binary search to determine how many numbers we can choose:
   - For each segment between banned numbers, calculate how many numbers we can take
   - Use prefix sums to efficiently calculate the sum of consecutive numbers
4. Return the total count of chosen numbers

The key insight is that by sorting the banned numbers and using binary search, we can efficiently determine which segments of available numbers to include.

## Complexity

- **Time**: O(m log m + log n) - sorting banned numbers and binary search
- **Space**: O(m) - space for banned set and sorted array

## Solution Code

```go
package main

import (
	"fmt"
	"sort"
)

func maxCount(banned []int, n int, maxSum int) int {
	// Create a set of banned numbers
	bannedSet := make(map[int]bool)
	for _, num := range banned {
		bannedSet[num] = true
	}
	
	// Sort banned numbers and add boundaries
	sort.Ints(banned)
	
	// Add boundaries
	banned = append(banned, 0)
	banned = append(banned, n+1)
	sort.Ints(banned)
	
	result := 0
	currentSum := 0
	
	// Check each segment between banned numbers
	for i := 1; i < len(banned); i++ {
		start := banned[i-1] + 1
		end := banned[i] - 1
		
		if start > end {
			continue
		}
		
		// Calculate how many numbers we can take from this segment
		segmentSum := (start + end) * (end - start + 1) / 2
		
		if currentSum+segmentSum <= maxSum {
			result += end - start + 1
			currentSum += segmentSum
		} else {
			// We can only take some numbers from this segment
			remaining := maxSum - currentSum
			
			// Binary search for the maximum number we can take
			left := start
			right := end
			
			for left <= right {
				mid := left + (right-left)/2
				partialSum := (start + mid) * (mid - start + 1) / 2
				
				if partialSum <= remaining {
					result += mid - start + 1
					left = mid + 1
				} else {
					right = mid - 1
				}
			}
			
			break
		}
	}
	
	return result
}
```

## Link

[LeetCode 2557 Maximum Number of Integers to Choose From a Range II](https://leetcode.com/problems/maximum-number-of-integers-to-choose-from-a-range-ii/)