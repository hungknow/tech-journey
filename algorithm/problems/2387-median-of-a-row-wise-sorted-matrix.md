# 2387 Median of a Row Wise Sorted Matrix

## Problem Description

Given a row-wise sorted matrix `matrix` of odd dimensions `m x n`, return the median element of the matrix.

### Example 1:
```
Input: matrix = [[1,3,5],[2,6,9],[3,6,9]]
Output: 5
```

### Example 2:
```
Input: matrix = [[1,1,2],[2,3,3],[2,4,4]]
Output: 2
```

## The Twist

Finding the **median** of a row-wise sorted matrix. Since the matrix is row-wise sorted, we can use binary search on the value range rather than on indices.

## Algorithm

### Binary Search on Value Range:
1. Find the minimum and maximum values in the matrix (first and last elements)
2. Use binary search on this value range:
   - For each `mid`, count how many elements are ≤ `mid` in the matrix
   - If count ≤ (m*n)/2, the median is in the right half (`low = mid + 1`)
   - Otherwise, the median is in the left half (`high = mid`)
3. When loop ends, `low` is the median

To count elements ≤ `mid`, use binary search on each row since rows are sorted.

## Complexity

- **Time**: O(log(r) * m log n) where r is the value range
- **Space**: O(1) - constant extra space

## Solution Code

```go
package main

func matrixMedian(matrix [][]int) int {
	m, n := len(matrix), len(matrix[0])
	total := m * n
	medianPos := total / 2
	
	// Find the minimum and maximum in the matrix
	low, high := matrix[0][0], matrix[0][n-1]
	for i := 0; i < m; i++ {
		low = min(low, matrix[i][0])
		high = max(high, matrix[i][n-1])
	}
	
	// Binary search on the value range
	for low < high {
		mid := low + (high-low)/2
		
		// Count elements less than or equal to mid
		count := 0
		for i := 0; i < m; i++ {
			// Binary search in each row
			left, right := 0, n-1
			rowCount := 0
			
			for left <= right {
				rowMid := left + (right-left)/2
				if matrix[i][rowMid] <= mid {
					left = rowMid + 1
					rowCount = rowMid + 1
				} else {
					right = rowMid - 1
				}
			}
			
			count += rowCount
		}
		
		if count <= medianPos {
			low = mid + 1
		} else {
			high = mid
		}
	}
	
	return low
}

func min(a, b int) int {
	if a < b {
		return a
	}
	return b
}

func max(a, b int) int {
	if a > b {
		return a
	}
	return b
}
```

## Link

[LeetCode 2387 Median of a Row Wise Sorted Matrix](https://leetcode.com/problems/median-of-a-row-wise-sorted-matrix/)
