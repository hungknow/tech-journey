# 0852 Peak Index in a Mountain Array

## Problem Description

Let's call an array `arr` a mountain if the following properties hold:

- `arr.length >= 3`
- There exists some `i` with `0 < i < arr.length - 1` such that:
  - `arr[0] < arr[1] < ... < arr[i - 1] < arr[i]`
  - `arr[i] > arr[i + 1] > ... > arr[arr.length - 1]`

Given a mountain array `arr`, return the index `i` of the peak element in the array.

### Example 1:
```
Input: arr = [0,1,0]
Output: 1
```

### Example 2:
```
Input: arr = [0,2,1,0]
Output: 1
```

### Example 3:
```
Input: arr = [0,10,5,2]
Output: 1
```

## The Twist

Finding the **peak index** in a mountain array. Since the array first increases then decreases, we can use binary search to find the peak.

## Algorithm

### Binary Search for Peak:
1. Use binary search with `left = 0` and `right = len(arr) - 1`
2. While `left < right`:
   - Calculate `mid = left + (right-left) / 2`
   - If `arr[mid] < arr[mid + 1]`, we're on the ascending slope, peak is to the right (`left = mid + 1`)
   - Otherwise, we're on the descending slope or at the peak, peak is at or to the left (`right = mid`)
3. When loop ends, `left` (or `right`) points to the peak index

## Complexity

- **Time**: O(log n) - binary search
- **Space**: O(1) - constant extra space

## Solution Code

```go
package main

func peakIndexInMountainArray(arr []int) int {
	left, right := 0, len(arr)-1
	
	for left < right {
		mid := left + (right-left)/2
		
		if arr[mid] < arr[mid+1] {
			// We're on the ascending slope, peak is to the right
			left = mid + 1
		} else {
			// We're on the descending slope or at the peak
			right = mid
		}
	}
	
	return left
}
```

## Link

[LeetCode 0852 Peak Index in a Mountain Array](https://leetcode.com/problems/peak-index-in-a-mountain-array/)
