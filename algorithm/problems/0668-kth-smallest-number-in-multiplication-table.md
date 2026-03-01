# 0668 Kth Smallest Number in Multiplication Table

## Problem Description

Given an integer `m` and an integer `n`, return the `kth` smallest number in the `m x n` multiplication table.

### Example 1:
```
Input: m = 3, n = 3, k = 5
Output: 3
Explanation: The 5th smallest number is 3.
```

### Example 2:
```
Input: m = 2, n = 3, k = 6
Output: 6
Explanation: The 6th smallest number is 6.
```

## The Twist

Finding the **kth smallest number** in a multiplication table without generating the entire table. We can use binary search on the value range.

## Algorithm

### Binary Search on Value:
1. The answer is between 1 and m*n
2. Binary search on this range:
   - For each `mid`, count how many numbers in the table are ≤ `mid`
   - For each row i, the count is min(mid//i, n)
   - If count ≥ k, try smaller value (`right = mid`)
   - Otherwise, need larger value (`left = mid + 1`)
3. When loop ends, `left` is the kth smallest number

## Complexity

- **Time**: O(m log(m*n)) - binary search with O(m) counting
- **Space**: O(1) - constant extra space

## Solution Code

```go
package main

func findKthNumber(m, n, k int) int {
	left, right := 1, m*n
	
	for left < right {
		mid := left + (right-left)/2
		
		if countLessEqual(mid, m, n) >= k {
			right = mid
		} else {
			left = mid + 1
		}
	}
	
	return left
}

func countLessEqual(val, m, n int) int {
	count := 0
	for i := 1; i <= m; i++ {
		// In row i, numbers are i, 2i, 3i, ..., ni
		// Count how many are <= val
		rowCount := min(val/i, n)
		count += rowCount
		
		if rowCount == 0 {
			break
		}
	}
	return count
}

func min(a, b int) int {
	if a < b {
		return a
	}
	return b
}
```

## Link

[LeetCode 0668 Kth Smallest Number in Multiplication Table](https://leetcode.com/problems/kth-smallest-number-in-multiplication-table/)
