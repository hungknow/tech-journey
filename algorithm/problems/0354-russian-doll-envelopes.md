# 0354 Russian Doll Envelopes

## Problem Description

You are given a 2D array of integers `envelopes` where `envelopes[i] = [w, h]` represents the width and height of an envelope.

One envelope can fit into another if and only if both the width and height of one envelope are greater than the other envelope's width and height.

Return the maximum number of envelopes you can Russian doll (i.e., put one inside the other).

### Example 1:
```
Input: envelopes = [[5,4],[6,4],[6,7],[2,3]]
Output: 3
Explanation: The maximum number of envelopes you can Russian doll is 3 ([2,3] => [5,4] => [6,7]).
```

### Example 2:
```
Input: envelopes = [[1,1],[1,1],[1,1]]
Output: 1
```

## The Twist

Finding the **maximum number of nested envelopes**. This is a 2D version of LIS. We sort by width and then find LIS on heights.

## Algorithm

### Sort + Binary Search LIS:
1. Sort envelopes by width ascending, and by height descending for equal widths
2. Extract just the heights from the sorted envelopes
3. Find the Longest Increasing Subsequence (LIS) on the heights using binary search:
   - Maintain a `tails` array where `tails[i]` is the smallest possible tail for LIS of length `i+1`
   - For each height, find its position in `tails` using binary search
   - If height extends the LIS, append it; otherwise, replace the existing element

The height sorting in descending order for equal widths prevents counting envelopes with the same width.

## Complexity

- **Time**: O(n log n) - sorting + binary search LIS
- **Space**: O(n) - tails array

## Solution Code

```go
package main

import (
	"sort"
)

func maxEnvelopes(envelopes [][]int) int {
	if len(envelopes) == 0 {
		return 0
	}
	
	// Sort by width ascending, and by height descending for equal widths
	sort.Slice(envelopes, func(i, j int) bool {
		if envelopes[i][0] == envelopes[j][0] {
			return envelopes[i][1] > envelopes[j][1]
		}
		return envelopes[i][0] < envelopes[j][0]
	})
	
	// Find LIS on heights
	tails := []int{}
	
	for _, envelope := range envelopes {
		height := envelope[1]
		
		// Find position in tails using binary search
		idx := sort.SearchInts(tails, height)
		
		if idx == len(tails) {
			tails = append(tails, height)
		} else {
			tails[idx] = height
		}
	}
	
	return len(tails)
}
```

## Link

[LeetCode 0354 Russian Doll Envelopes](https://leetcode.com/problems/russian-doll-envelopes/)
