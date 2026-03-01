# 0074 Search a 2D Matrix

## Problem Description

You are given an `m x n` integer matrix `matrix` with the following two properties:

- Each row is sorted in non-decreasing order.
- The first integer of each row is greater than the last integer of the previous row.

Given an integer `target`, return `true` if `target` is in `matrix` or `false` otherwise.

You must write a solution in O(log(m * n)) time complexity.

### Example 1:
```
Input: matrix = [[1,3,5,7],[10,11,16,20],[23,30,34,60]], target = 3
Output: true
```

### Example 2:
```
Input: matrix = [[1,3,5,7],[10,11,16,20],[23,30,34,60]], target = 13
Output: false
```

## The Twist

The matrix can be treated as a **flattened sorted array**. We can perform binary search on this virtual 1D array by converting between 1D and 2D indices.

## Algorithm

### Binary Search on Flattened Matrix:
1. Treat the matrix as a flattened array of size `m * n`
2. Use binary search with `left = 0` and `right = m * n - 1`
3. For each `mid`, convert to 2D coordinates:
   - `row = mid / n`
   - `col = mid % n`
4. Compare `matrix[row][col]` with `target`:
   - If equal, return `true`
   - If less, search right half (`left = mid + 1`)
   - If greater, search left half (`right = mid - 1`)
5. If loop ends without finding target, return `false`

## Complexity

- **Time**: O(log(m * n)) - binary search on virtual 1D array
- **Space**: O(1) - constant extra space

## Solution Code

```go
package main

func searchMatrix(matrix [][]int, target int) bool {
	if len(matrix) == 0 || len(matrix[0]) == 0 {
		return false
	}
	
	m, n := len(matrix), len(matrix[0])
	left, right := 0, m*n-1
	
	for left <= right {
		mid := left + (right-left)/2
		row := mid / n
		col := mid % n
		midValue := matrix[row][col]
		
		if midValue == target {
			return true
		} else if midValue < target {
			left = mid + 1
		} else {
			right = mid - 1
		}
	}
	
	return false
}
```

## Link

[LeetCode 0074 Search a 2D Matrix](https://leetcode.com/problems/search-a-2d-matrix/)
