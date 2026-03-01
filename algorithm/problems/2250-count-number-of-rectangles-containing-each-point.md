# 2250 Count Number of Rectangles Containing Each Point

## Problem Description

You are given a 2D integer array `rectangles` where `rectangles[i] = [widthi, heighti]` represents the `ith` rectangle.

You are also given a 2D integer array `points` where `points[j] = [xj, yj]` represents a point.

Return an integer array `count` of length `points.length` where `count[j]` is the number of rectangles that contain the `jth` point.

A rectangle `widthi, heighti` contains the point `xj, yj` if `xj < widthi` and `yj < heighti`.

### Example 1:
```
Input: rectangles = [[1,2],[2,3],[2,5]], points = [[2,1],[1,4]]
Output: [2,1]
Explanation:
- Point [2,1] is contained in rectangles [1,2] and [2,3]
- Point [1,4] is contained in rectangle [2,5]
```

### Example 2:
```
Input: rectangles = [[1,1],[2,2],[3,3]], points = [[1,3],[1,1]]
Output: [0,2]
Explanation:
- Point [1,3] is not contained in any rectangle
- Point [1,1] is contained in rectangles [1,1], [2,2], and [3,3]
```

## The Twist

Counting the **number of rectangles** containing each point efficiently. This involves using binary search to quickly determine which rectangles contain each point.

## Algorithm

### Binary Search Approach:
1. Sort rectangles by width
2. For each point:
   - Use binary search to find all rectangles with width > x
   - For these rectangles, count how many have height > y
   - Use a frequency array or binary indexed tree to efficiently count heights
3. Return the count for each point

The key insight is that by sorting rectangles and using binary search, we can efficiently determine which rectangles contain each point without checking all rectangles.

## Complexity

- **Time**: O((n + m) log n) - sorting and binary searches
- **Space**: O(n) - space for sorted rectangles and frequency data

## Solution Code

```go
package main

import (
	"fmt"
	"sort"
)

func countRectangles(rectangles [][]int, points [][]int) []int {
	// Sort rectangles by width
	sort.Slice(rectangles, func(i, j int) bool {
		return rectangles[i][0] < rectangles[j][0]
	})
	
	// Extract widths and heights
	widths := make([]int, len(rectangles))
	heights := make([]int, len(rectangles))
	for i, rect := range rectangles {
		widths[i] = rect[0]
		heights[i] = rect[1]
	}
	
	// Create a frequency array for heights (up to 100)
	heightFreq := make([][]int, 101)
	for i, h := range heights {
		heightFreq[h] = append(heightFreq[h], widths[i])
	}
	
	// Sort each height's widths for binary search
	for h := 1; h <= 100; h++ {
		sort.Ints(heightFreq[h])
	}
	
	result := make([]int, len(points))
	
	for i, point := range points {
		x, y := point[0], point[1]
		count := 0
		
		// Count rectangles with height > y and width > x
		for h := y + 1; h <= 100; h++ {
			// Binary search for the first width > x
			idx := sort.SearchInts(heightFreq[h], x+1)
			count += len(heightFreq[h]) - idx
		}
		
		result[i] = count
	}
	
	return result
}
```

## Link

[LeetCode 2250 Count Number of Rectangles Containing Each Point](https://leetcode.com/problems/count-number-of-rectangles-containing-each-point/)