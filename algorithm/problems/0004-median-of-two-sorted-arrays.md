# 0004 Median of Two Sorted Arrays

## Problem Description

Given two sorted arrays `nums1` and `nums2` of size `m` and `n` respectively, return the median of the two sorted arrays.

The overall run time complexity should be O(log (m+n)).

### Example 1:
```
Input: nums1 = [1,3], nums2 = [2]
Output: 2.00000
Explanation: merged array = [1,2,3] and median is 2.
```

### Example 2:
```
Input: nums1 = [1,2], nums2 = [3,4]
Output: 2.50000
Explanation: merged array = [1,2,3,4] and median is (2 + 3) / 2 = 2.5.
```

## The Twist

Finding the median of two sorted arrays in **O(log(min(m, n)))** time without actually merging them. This requires a clever partition-based approach.

## Algorithm

### Binary Search on Partition:
1. Ensure `nums1` is the smaller array (swap if necessary)
2. Binary search on the smaller array to find the correct partition point
3. For a partition at position `i` in `nums1`, find `j = (m + n + 1) / 2 - i` in `nums2`
4. The partition is correct when:
   - `nums1[i-1] <= nums2[j]` AND `nums2[j-1] <= nums1[i]`
5. Calculate median based on whether total length is odd or even

## Complexity

- **Time**: O(log(min(m, n))) - binary search on smaller array
- **Space**: O(1) - constant extra space

## Solution Code

```go
package main

func findMedianSortedArrays(nums1 []int, nums2 []int) float64 {
	// Ensure nums1 is the smaller array
	if len(nums1) > len(nums2) {
		nums1, nums2 = nums2, nums1
	}
	
	m, n := len(nums1), len(nums2)
	left, right := 0, m
	
	for left <= right {
		partitionX := (left + right) / 2
		partitionY := (m + n + 1) / 2 - partitionX
		
		var maxLeftX, minRightX, maxLeftY, minRightY int
		
		if partitionX == 0 {
			maxLeftX = -1 << 31
		} else {
			maxLeftX = nums1[partitionX-1]
		}
		
		if partitionX == m {
			minRightX = 1 << 31 - 1
		} else {
			minRightX = nums1[partitionX]
		}
		
		if partitionY == 0 {
			maxLeftY = -1 << 31
		} else {
			maxLeftY = nums2[partitionY-1]
		}
		
		if partitionY == n {
			minRightY = 1 << 31 - 1
		} else {
			minRightY = nums2[partitionY]
		}
		
		if maxLeftX <= minRightY && maxLeftY <= minRightX {
			// Found the correct partition
			if (m + n) % 2 == 0 {
				return float64(max(maxLeftX, maxLeftY) + min(minRightX, minRightY)) / 2.0
			}
			return float64(max(maxLeftX, maxLeftY))
		} else if maxLeftX > minRightY {
			right = partitionX - 1
		} else {
			left = partitionX + 1
		}
	}
	
	return 0.0
}

func max(a, b int) int {
	if a > b {
		return a
	}
	return b
}

func min(a, b int) int {
	if a < b {
		return a
	}
	return b
}
```

## Link

[LeetCode 0004 Median of Two Sorted Arrays](https://leetcode.com/problems/median-of-two-sorted-arrays/)
