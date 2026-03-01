# 1060 Missing Element in Sorted Array

## Problem Description

Given a sorted array `arr` of distinct integers and a target value `k`, return the `k`th missing number starting from the leftmost number of the array.

### Example 1:
```
Input: arr = [4,7,9,10], k = 1
Output: 5
Explanation: The first missing number is 5.
```

### Example 2:
```
Input: arr = [4,7,9,10], k = 3
Output: 8
Explanation: The missing numbers are [5,6,8,9,10,...]. The third missing number is 8.
```

### Example 3:
```
Input: arr = [1,2,3,4], k = 2
Output: 6
Explanation: The missing numbers are [5,6,7,...]. The second missing number is 6.
```

## The Twist

Finding the **kth missing number** in a sorted array. The key insight is to use binary search to find the position where the kth missing number would be located.

## Algorithm

### Binary Search on Missing Count:
1. Define a function `missing(idx)` that returns the number of missing elements before `arr[idx]`:
   - `missing(idx) = arr[idx] - arr[0] - idx`
2. If `k` is greater than the total missing elements up to the last element, the answer is beyond the array
3. Use binary search to find the smallest index where `missing(idx) >= k`
4. The answer is `arr[idx-1] + (k - missing(idx-1))`

## Complexity

- **Time**: O(log n) - binary search
- **Space**: O(1) - constant extra space

## Solution Code

```go
package main

func missingElement(nums []int, k int) int {
	n := len(nums)
	
	// If k is beyond the last element
	missing := nums[n-1] - nums[0] - (n - 1)
	if k > missing {
		return nums[n-1] + (k - missing)
	}
	
	// Binary search to find the position
	left, right := 0, n-1
	
	for left < right {
		mid := left + (right-left)/2
		
		// Calculate missing elements before nums[mid]
		missing := nums[mid] - nums[0] - mid
		
		if missing < k {
			left = mid + 1
		} else {
			right = mid
		}
	}
	
	// The answer is between nums[left-1] and nums[left]
	return nums[left-1] + (k - (nums[left-1] - nums[0] - (left - 1)))
}
```

## Link

[LeetCode 1060 Missing Element in Sorted Array](https://leetcode.com/problems/missing-element-in-sorted-array/)
