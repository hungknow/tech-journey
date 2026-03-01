# 1901 Find a Peak Element II

## Problem Description

A peak element in a 2D grid is an element that is strictly greater than all of its adjacent neighbors to the left, right, top, and bottom.

Given a `0-indexed m x n matrix mat` where no two adjacent cells are equal, find any peak element in `mat`.

An element `mat[i][j]` is a peak if it is strictly greater than all its neighbors:
- `mat[i-1][j]` if `i > 0`
- `mat[i+1][j]` if `i < m-1`
- `mat[i][j-1]` if `j > 0`
- `mat[i][j+1]` if `j < n-1`

You must write an algorithm that runs in `O(m log(n))` or `O(n log(m))` time.

### Example 1:
```
Input: mat = [[1,4],[3,2]]
Output: [0,1]
Explanation: The peak element is mat[0][1] with value 4.
```

### Example 2:
```
Input: mat = [[10,20,15],[21,30,14],[7,16,32]]
Output: [1,1]
Explanation: The peak element is mat[1][1] with value 30.
```

## The Twist

Finding a **peak element in a 2D grid** efficiently. The key insight is to use binary search on columns (or rows) and find the maximum in each middle column.

## Algorithm

### Binary Search on Columns:
1. Use binary search on column indices: `left = 0`, `right = n-1`
2. While `left < right`:
   - Calculate `mid = left + (right-left) / 2`
   - Find the row `maxRow` with the maximum value in column `mid`
   - Compare `mat[maxRow][mid]` with its horizontal neighbors:
     - If it's greater than both neighbors, we found a peak
     - If left neighbor is greater, the peak is in the left half (`right = mid - 1`)
     - If right neighbor is greater, the peak is in the right half (`left = mid + 1`)
3. When loop ends, find the maximum in the remaining column and return its coordinates

## Complexity

- **Time**: O(min(n, m) * log(max(n, m))) - binary search on smaller dimension
- **Space**: O(1) - constant extra space

## Solution Code

```go
package main

func findPeakGrid(mat [][]int) []int {
	m, n := len(mat), len(mat[0])
	left, right := 0, n-1
	
	for left <= right {
		mid := left + (right-left)/2
		
		// Find the row with maximum value in column mid
		maxRow := 0
		for i := 1; i < m; i++ {
			if mat[i][mid] > mat[maxRow][mid] {
				maxRow = i
			}
		}
		
		// Check if this is a peak
		leftIsSmaller := mid == 0 || mat[maxRow][mid] > mat[maxRow][mid-1]
		rightIsSmaller := mid == n-1 || mat[maxRow][mid] > mat[maxRow][mid+1]
		
		if leftIsSmaller && rightIsSmaller {
			return []int{maxRow, mid}
		} else if mid > 0 && mat[maxRow][mid-1] > mat[maxRow][mid] {
			right = mid - 1
		} else {
			left = mid + 1
		}
	}
	
	// This line should not be reached as per problem constraints
	return []int{-1, -1}
}
```

## Link

[LeetCode 1901 Find a Peak Element II](https://leetcode.com/problems/find-a-peak-element-ii/)
