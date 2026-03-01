# 1095 Find in Mountain Array

## Problem Description

(This problem is an interactive problem.)

You may recall that an array `arr` is a mountain array if and only if:

- `arr.length >= 3`
- There exists some `i` with `0 < i < arr.length - 1` such that:
  - `arr[0] < arr[1] < ... < arr[i - 1] < arr[i]`
  - `arr[i] > arr[i + 1] > ... > arr[arr.length - 1]`

Given a mountain array `mountainArr`, return the minimum `index` such that `mountainArr.get(index) == target`. If such an `index` does not exist, return `-1`.

You cannot access the mountain array directly. You may only access the array using a `MountainArray` interface:

- `MountainArray.get(k)` returns the element of the array at index `k` (0-indexed).
- `MountainArray.length()` returns the length of the array.

### Example 1:
```
Input: array = [1,2,3,4,5,3,1], target = 3
Output: 2
Explanation: 3 exists in the array, at index=2 and index=5. Return the minimum index, which is 2.
```

### Example 2:
```
Input: array = [0,1,2,4,2,1], target = 3
Output: -1
Explanation: 3 does not exist in the array, so return -1.
```

## The Twist

Finding a target in a **mountain array** with limited access. We need to first find the peak, then search both sides of the peak.

## Algorithm

### Three-Phase Approach:
1. **Find the Peak**:
   - Use binary search to find the peak index
   - Compare `get(mid)` with `get(mid + 1)` to determine slope

2. **Search Left Side (Ascending)**:
   - Use binary search on the ascending part (0 to peak)
   - Standard binary search for the target

3. **Search Right Side (Descending)**:
   - If not found on left, search the descending part (peak+1 to end)
   - Modified binary search for descending order

## Complexity

- **Time**: O(log n) - three binary searches
- **Space**: O(1) - constant extra space

## Solution Code

```go
package main

/**
 * // This is the MountainArray's API interface.
 * // You should not implement it, or speculate about its implementation
 * type MountainArray struct {
 * }
 *
 * func (this *MountainArray) get(index int) int {}
 * func (this *MountainArray) length() int {}
 */

type MountainArray struct {
	// This would be provided by the platform
	// For testing purposes, let's implement a simple version
	arr []int
}

func (m *MountainArray) get(index int) int {
	return m.arr[index]
}

func (m *MountainArray) length() int {
	return len(m.arr)
}

func findInMountainArray(target int, mountainArr *MountainArray) int {
	n := mountainArr.length()
	
	// Step 1: Find the peak index
	left, right := 0, n-1
	peak := 0
	
	for left < right {
		mid := left + (right-left)/2
		if mountainArr.get(mid) < mountainArr.get(mid+1) {
			left = mid + 1
			peak = mid + 1
		} else {
			right = mid
		}
	}
	
	// Step 2: Search in the ascending part (0 to peak)
	left, right = 0, peak
	for left <= right {
		mid := left + (right-left)/2
		val := mountainArr.get(mid)
		if val == target {
			return mid
		} else if val < target {
			left = mid + 1
		} else {
			right = mid - 1
		}
	}
	
	// Step 3: Search in the descending part (peak+1 to n-1)
	left, right = peak+1, n-1
	for left <= right {
		mid := left + (right-left)/2
		val := mountainArr.get(mid)
		if val == target {
			return mid
		} else if val > target {
			left = mid + 1
		} else {
			right = mid - 1
		}
	}
	
	return -1
}
```

## Link

[LeetCode 1095 Find in Mountain Array](https://leetcode.com/problems/find-in-mountain-array/)
