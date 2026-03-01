# 1385 Find the Distance Value Between Two Arrays

## Problem Description

Given two integer arrays `arr1` and `arr2`, and an integer `d`, return the distance value of the array `arr1`.

The distance value is defined as the number of elements `arr1[i]` such that there is not any element `arr2[j]` where `|arr1[i]-arr2[j]| <= d`.

### Example 1:
```
Input: arr1 = [4,5,8], arr2 = [10,9,1,8], d = 2
Output: 2
Explanation: 
- For arr1[0]=4, we have |4-10|=6 > d, |4-9|=5 > d, |4-1|=3 > d, |4-8|=4 > d
- For arr1[1]=5, we have |5-10|=5 > d, |5-9|=4 > d, |5-1|=4 > d, |5-8|=3 > d
- For arr1[2]=8, we have |8-10|=2 <= d, so arr1[2] is not counted
Therefore, the distance value is 2.
```

### Example 2:
```
Input: arr1 = [1,4,2,3], arr2 = [5,1,2,4,3], d = 1
Output: 0
Explanation: All elements of arr1 have at least one element in arr2 within distance d.
```

### Example 3:
```
Input: arr1 = [1,4,2,3], arr2 = [5,6,7,8,9], d = 2
Output: 4
Explanation: No element of arr1 has any element in arr2 within distance d.
```

## The Twist

Finding the **distance value** efficiently. This involves using binary search to quickly check if there's any element in `arr2` that is within distance `d` of each element in `arr1`.

## Algorithm

### Binary Search Approach:
1. Sort `arr2` to enable binary search
2. For each element `x` in `arr1`:
   - Use binary search to find the position where `x` would be inserted in `arr2`
   - Check the nearest elements in `arr2` (at the insertion position and the previous position)
   - If all checked elements are at distance > `d`, increment the distance value
3. Return the total count

The key insight is that by sorting `arr2`, we can use binary search to quickly find the closest elements to any `x` in `arr1`, avoiding a linear scan.

## Complexity

- **Time**: O(m log m + n log m) - sorting arr2 and binary searches for each element in arr1
- **Space**: O(1) - constant space (ignoring space used by sorting)

## Solution Code

```go
package main

import (
	"fmt"
	"sort"
)

func findTheDistanceValue(arr1 []int, arr2 []int, d int) int {
	// Sort arr2 for binary search
	sort.Ints(arr2)
	
	count := 0
	
	for _, x := range arr1 {
		// Binary search for the insertion position of x in arr2
		left, right := 0, len(arr2)
		
		for left < right {
			mid := left + (right-left)/2
			if arr2[mid] < x {
				left = mid + 1
			} else {
				right = mid
			}
		}
		
		// Check if any element in arr2 is within distance d
		isValid := true
		
		// Check element at insertion position (if exists)
		if left < len(arr2) && abs(arr2[left]-x) <= d {
			isValid = false
		}
		
		// Check previous element (if exists)
		if left > 0 && abs(arr2[left-1]-x) <= d {
			isValid = false
		}
		
		if isValid {
			count++
		}
	}
	
	return count
}

func abs(x int) int {
	if x < 0 {
		return -x
	}
	return x
}
```

## Link

[LeetCode 1385 Find the Distance Value Between Two Arrays](https://leetcode.com/problems/find-the-distance-value-between-two-arrays/)