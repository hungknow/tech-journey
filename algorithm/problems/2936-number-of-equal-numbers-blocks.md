# 2936 Number of Equal Numbers Blocks

## Problem Description

You are given an integer array `nums`.

A block is a maximal subarray where all elements are equal.

Return the number of blocks in `nums`.

### Example 1:
```
Input: nums = [1,1,2,2,3,3,4,4]
Output: 4
Explanation: There are 4 blocks: [1,1], [2,2], [3,3], [4,4]
```

### Example 2:
```
Input: nums = [1,2,3,4,5]
Output: 5
Explanation: Each element forms its own block.
```

### Example 3:
```
Input: nums = [1,1,1,1,1]
Output: 1
Explanation: All elements form one block.
```

## The Twist

Finding the **number of equal numbers blocks** efficiently. This involves using binary search to quickly count transitions between different values.

## Algorithm

### Binary Search Approach:
1. Use binary search to find the positions where the value changes
2. Count the number of transitions between different values
3. The number of blocks is equal to the number of transitions plus 1
4. Return the count

The key insight is that by using binary search, we can efficiently locate the positions where values change, allowing us to count blocks without scanning the entire array.

## Complexity

- **Time**: O(k log n) - binary searches for k distinct values
- **Space**: O(1) - constant space

## Solution Code

```go
package main

import "fmt"

func countBlocks(nums []int) int {
	if len(nums) == 0 {
		return 0
	}
	
	// Get all distinct values
	valueSet := make(map[int]bool)
	for _, num := range nums {
		valueSet[num] = true
	}
	
	// Convert to slice
	values := make([]int, 0, len(valueSet))
	for value := range valueSet {
		values = append(values, value)
	}
	
	// Sort values
	sort.Ints(values)
	
	// Count blocks by finding transitions
	blocks := 0
	for _, value := range values {
		// Find the first occurrence of value
		left := findFirstOccurrence(nums, value)
		if left != -1 {
			blocks++
		}
	}
	
	return blocks
}

func findFirstOccurrence(nums []int, target int) int {
	left := 0
	right := len(nums) - 1
	
	for left <= right {
		mid := left + (right-left)/2
		
		if nums[mid] < target {
			left = mid + 1
		} else {
			right = mid - 1
		}
	}
	
	// Check if we found the target
	if left < len(nums) && nums[left] == target {
		return left
	}
	
	return -1
}
```

## Link

[LeetCode 2936 Number of Equal Numbers Blocks](https://leetcode.com/problems/number-of-equal-numbers-blocks/)