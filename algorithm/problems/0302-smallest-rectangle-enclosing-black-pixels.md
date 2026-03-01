# 0302 Smallest Rectangle Enclosing Black Pixels

## Problem Description

You are given an image represented by a binary matrix `0` and `1`. A black pixel is represented by `'1'` and a white pixel is represented by `'0'`.

The black pixels are connected (i.e., there is only one black region). Pixels are connected horizontally and vertically.

Given a location `(x, y)` of one of the black pixels, return the area of the smallest (axis-aligned) rectangle that encloses all black pixels.

### Example 1:
```
Input: image = [
  ["0","0","1","0"],
  ["0","1","1","0"],
  ["0","1","0","0"]
], x = 0, y = 2
Output: 6
```

## The Twist

Finding the **smallest rectangle** enclosing all black pixels efficiently. Since all black pixels are connected, we can use binary search to find the boundaries.

## Algorithm

### Binary Search on Boundaries:
1. Use binary search to find the left boundary:
   - Search columns from 0 to y
   - For each column, check if there are any black pixels
2. Use binary search to find the right boundary:
   - Search columns from y to n-1
3. Use binary search to find the top boundary:
   - Search rows from 0 to x
4. Use binary search to find the bottom boundary:
   - Search rows from x to m-1
5. The area is (right - left) * (bottom - top)

## Complexity

- **Time**: O(n log n) - binary search on each boundary
- **Space**: O(1) - constant extra space

## Solution Code

```go
package main

func minArea(image [][]byte, x, y int) int {
	if len(image) == 0 || len(image[0]) == 0 {
		return 0
	}
	
	m, n := len(image), len(image[0])
	
	// Find boundaries using binary search
	left := findBoundary(image, 0, y, true, true)
	right := findBoundary(image, y, n-1, true, false)
	top := findBoundary(image, 0, x, false, true)
	bottom := findBoundary(image, x, m-1, false, false)
	
	return (right - left) * (bottom - top)
}

func findBoundary(image [][]byte, start, end int, isColumn, isStart bool) int {
	low, high := start, end
	
	for low < high {
		mid := low + (high-low)/2
		
		if !isStart {
			mid++ // For end boundaries
		}
		
		hasBlack := false
		if isColumn {
			// Check if this column has any black pixels
			for i := 0; i < len(image); i++ {
				if image[i][mid] == '1' {
					hasBlack = true
					break
				}
			}
		} else {
			// Check if this row has any black pixels
			for j := 0; j < len(image[0]); j++ {
				if image[mid][j] == '1' {
					hasBlack = true
					break
				}
			}
		}
		
		if isStart {
			if hasBlack {
				high = mid
			} else {
				low = mid + 1
			}
		} else {
			if hasBlack {
				low = mid
			} else {
				high = mid - 1
			}
		}
	}
	
	return low
}
```

## Link

[LeetCode 0302 Smallest Rectangle Enclosing Black Pixels](https://leetcode.com/problems/smallest-rectangle-enclosing-black-pixels/)
