# 2389 Longest Subsequence With Limited Sum

## Problem Description

You are given an integer array `nums` and an integer `queries`.

Return an array `answer` where `answer[i]` is the length of the longest subsequence of `nums` whose sum is less than or equal to `queries[i]`.

A subsequence is a sequence that can be derived from an array by deleting some or no elements without changing the order of the remaining elements.

### Example 1:
```
Input: nums = [4,5,2,1], queries = [3,10,21]
Output: [2,3,4]
Explanation:
- For query 3: the longest subsequence is [2,1] with sum 3
- For query 10: the longest subsequence is [4,5,1] with sum 10
- For query 21: the longest subsequence is [4,5,2,1] with sum 12
```

### Example 2:
```
Input: nums = [2,3,4,5], queries = [1]
Output: [0]
Explanation: No subsequence has sum less than or equal to 1.
```

## The Twist

Finding the **longest subsequence** with limited sum for multiple queries efficiently. This involves using binary search to quickly answer each query after preprocessing.

## Algorithm

### Binary Search Approach:
1. Sort the array in ascending order to maximize the number of elements for a given sum
2. Create a prefix sum array to quickly calculate the sum of the first `k` elements
3. For each query:
   - Use binary search to find the largest `k` such that the sum of the first `k` elements ≤ query
   - Return `k` as the answer

The key insight is that by sorting the array and using prefix sums, we can efficiently answer each query with binary search.

## Complexity

- **Time**: O(n log n + q log n) - sorting and binary searches for queries
- **Space**: O(n) - space for sorted array and prefix sums

## Solution Code

```go
package main

import (
	"fmt"
	"sort"
)

func answerQueries(nums []int, queries []int) []int {
	// Sort nums to maximize the number of elements for a given sum
	sort.Ints(nums)
	
	// Create prefix sum array
	prefix := make([]int, len(nums)+1)
	for i := 0; i < len(nums); i++ {
		prefix[i+1] = prefix[i] + nums[i]
	}
	
	result := make([]int, len(queries))
	
	for i, query := range queries {
		// Binary search for the largest k such that prefix[k] <= query
		left := 0
		right := len(nums)
		
		for left < right {
			mid := left + (right-left+1)/2
			if prefix[mid] <= query {
				left = mid
			} else {
				right = mid - 1
			}
		}
		
		result[i] = left
	}
	
	return result
}
```

## Link

[LeetCode 2389 Longest Subsequence With Limited Sum](https://leetcode.com/problems/longest-subsequence-with-limited-sum/)