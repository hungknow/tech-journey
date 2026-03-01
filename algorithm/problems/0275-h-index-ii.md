# 0275 H-Index II

## Problem Description

Given an array of citations `citations` (where `citations[i]` is the number of citations a researcher received for their ith paper) and an array has already been sorted in ascending order, return the researcher's h-index.

According to the definition of h-index: a scientist has an h-index h if there are at least h papers cited at least h times.

### Example 1:
```
Input: citations = [0,1,3,5,6]
Output: 3
Explanation: The researcher has 5 papers in total and each of them had received 0, 1, 3, 5, 6 citations respectively.
Since the researcher has 3 papers with at least 3 citations each and the remaining two with no more than 3 citations each, their h-index is 3.
```

## The Twist

Finding the **h-index** in a sorted citations array. Since the array is sorted, we can use binary search to find the point where citations[i] >= n-i.

## Algorithm

### Binary Search for H-Index:
1. Use binary search with `left = 0` and `right = n-1`
2. While `left <= right`:
   - Calculate `mid = left + (right-left) / 2`
   - If `citations[mid] >= n-mid`, we have at least `n-mid` papers with `n-mid` citations
     - Try to find a smaller h-index (`right = mid - 1`)
   - Otherwise, need larger h-index (`left = mid + 1`)
3. The answer is `n-left` where `left` is the first position satisfying the condition

## Complexity

- **Time**: O(log n) - binary search
- **Space**: O(1) - constant extra space

## Solution Code

```go
package main

func hIndex(citations []int) int {
	n := len(citations)
	left, right := 0, n-1
	
	for left <= right {
		mid := left + (right-left)/2
		
		if citations[mid] >= n-mid {
			right = mid - 1
		} else {
			left = mid + 1
		}
	}
	
	return n - left
}
```

## Link

[LeetCode 0275 H-Index II](https://leetcode.com/problems/h-index-ii/)
