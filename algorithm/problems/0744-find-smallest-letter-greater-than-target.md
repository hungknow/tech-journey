# 0744 Find Smallest Letter Greater Than Target

## Problem Description

Given a circular character array `letters` of sorted lowercase English letters, and a target letter `target`, find the smallest letter in the array that is greater than `target`.

Letters are wrapped around, so if `target` is greater than the last character, we return the first character.

### Example 1:
```
Input: letters = ["c","f","j"], target = "a"
Output: "c"
```

### Example 2:
```
Input: letters = ["c","f","j"], target = "c"
Output: "f"
```

### Example 3:
```
Input: letters = ["c","f","j"], target = "d"
Output: "f"
```

## The Twist

Finding the **smallest letter greater than target** in a circular sorted array. This is a modified binary search problem.

## Algorithm

### Binary Search with Circular Array:
1. Use binary search with `left = 0` and `right = len(letters) - 1`
2. While `left <= right`:
   - Calculate `mid = left + (right-left) / 2`
   - If `letters[mid]` > target, the answer is at or before `mid` (`right = mid - 1`)
   - Otherwise, the answer is after `mid` (`left = mid + 1`)
3. If `left` goes beyond the array bounds, return `letters[0]` (wrap around)
4. Otherwise, return `letters[left]`

## Complexity

- **Time**: O(log n) - binary search
- **Space**: O(1) - constant extra space

## Solution Code

```go
package main

func nextGreatestLetter(letters []byte, target byte) byte {
	left, right := 0, len(letters)-1
	
	for left <= right {
		mid := left + (right-left)/2
		
		if letters[mid] > target {
			right = mid - 1
		} else {
			left = mid + 1
		}
	}
	
	// Wrap around if left exceeds array bounds
	if left >= len(letters) {
		return letters[0]
	}
	
	return letters[left]
}
```

## Link

[LeetCode 0744 Find Smallest Letter Greater Than Target](https://leetcode.com/problems/find-smallest-letter-greater-than-target/)
