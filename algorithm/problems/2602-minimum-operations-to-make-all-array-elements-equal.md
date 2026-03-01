# 2602 Minimum Operations to Make All Array Elements Equal

## Problem Description

You are given an integer array `nums` and an integer `queries`.

For each query `queries[i]`, you want to make all elements in `nums` equal to `queries[i]`.

In one operation, you can increase or decrease any element by 1.

Return an array `answer` where `answer[i]` is the minimum number of operations needed to make all elements in `nums` equal to `queries[i]`.

### Example 1:
```
Input: nums = [3,1,6,8], queries = [1,5]
Output: [12,10]
Explanation:
- For query 1: |3-1| + |1-1| + |6-1| + |8-1| = 2 + 0 + 5 + 7 = 14
- For query 5: |3-5| + |1-5| + |6-5| + |8-5| = 2 + 4 + 1 + 3 = 10
```

### Example 2:
```
Input: nums = [2,9,6,3], queries = [10]
Output: [20]
Explanation: |2-10| + |9-10| + |6-10| + |3-10| = 8 + 1 + 4 + 7 = 20
```

## The Twist

Finding the **minimum operations** to make all array elements equal for multiple queries efficiently. This involves using binary search to quickly answer each query after preprocessing.

## Algorithm

### Binary Search Approach:
1. Sort the array and create a prefix sum array
2. For each query:
   - Use binary search to find the position where the query value would be inserted
   - Calculate the operations needed for elements less than the query
   - Calculate the operations needed for elements greater than the query
   - Sum these values to get the total operations
3. Return the results for all queries

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

func minOperations(nums []int, queries []int) []int64 {
	// Sort nums for binary search
	sort.Ints(nums)
	n := len(nums)
	
	// Create prefix sum array
	prefix := make([]int64, n+1)
	for i := 0; i < n; i++ {
		prefix[i+1] = prefix[i] + int64(nums[i])
	}
	
	result := make([]int64, len(queries))
	
	for i, query := range queries {
		// Binary search for the position where query would be inserted
		pos := sort.SearchInts(nums, query)
		
		// Calculate operations for elements less than query
		leftOps := int64(query)*int64(pos) - prefix[pos]
		
		// Calculate operations for elements greater than query
		rightOps := (prefix[n] - prefix[pos]) - int64(query)*int64(n-pos)
		
		result[i] = leftOps + rightOps
	}
	
	return result
}
```

## Link

[LeetCode 2602 Minimum Operations to Make All Array Elements Equal](https://leetcode.com/problems/minimum-operations-to-make-all-array-elements-equal/)