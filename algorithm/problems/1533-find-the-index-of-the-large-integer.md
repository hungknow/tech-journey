# 1533 Find the Index of the Large Integer

## Problem Description

You are given an API `ArrayReader` which returns the sum of a subarray from index `l` to `r` (both inclusive). The array is **1-indexed** and contains positive integers only.

You need to find the index of the element with the maximum value in the array. If there are multiple maximum values, return the **smallest index**.

### Example 1:
```
Input: reader = [7,8,9,10,11]
Output: 4
Explanation: The maximum element is at index 4.
```

### Example 2:
```
Input: reader = [6,6,6,6,6]
Output: 1
Explanation: All elements are the same, so we return the smallest index 1.
```

## The Twist

Finding the **index of the large integer** efficiently with limited API access. This involves using binary search to locate the maximum element by comparing sums of different subarrays.

## Algorithm

### Binary Search Approach:
1. Use binary search to find the maximum element:
   - At each step, compare the sum of the left half and right half
   - If the left sum is greater, the maximum is in the left half
   - If the right sum is greater, the maximum is in the right half
   - If they're equal, the maximum is at the boundary
2. Continue until we narrow down to a single element
3. Return the index of the maximum element

The key insight is that by comparing sums of subarrays, we can determine which half contains the larger elements, allowing us to use binary search even with limited API access.

## Complexity

- **Time**: O(log n) - binary search operations
- **Space**: O(1) - constant space

## Solution Code

```go
package main

import "fmt"

/**
 * // This is the ArrayReader's API interface.
 * // You should not implement it, or speculate about its implementation
 * type ArrayReader struct {
 * }
 *
 * func (this *ArrayReader) query(subarray []int) int {
 *     ...
 * }
 *
 * func (this *ArrayReader) length() int {
 *     ...
 * }
 */

func getIndex(reader *ArrayReader) int {
    n := reader.length()
    
    // Binary search for the maximum element
    left := 0
    right := n - 1
    
    for left < right {
        mid := left + (right-left)/2
        
        // If even number of elements, compare left and right halves
        if (right-left+1)%2 == 0 {
            leftSum := reader.query([]int{left, mid})
            rightSum := reader.query([]int{mid + 1, right})
            
            if leftSum < rightSum {
                left = mid + 1
            } else {
                right = mid
            }
        } else {
            // If odd number of elements, exclude the middle element
            leftSum := reader.query([]int{left, mid - 1})
            rightSum := reader.query([]int{mid + 1, right})
            
            if leftSum < rightSum {
                left = mid + 1
            } else if leftSum > rightSum {
                right = mid - 1
            } else {
                // If sums are equal, the middle element is the maximum
                return mid + 1 // 1-indexed
            }
        }
    }
    
    return left + 1 // 1-indexed
}

// Mock ArrayReader for testing
type ArrayReader struct {
    arr []int
}

func (ar *ArrayReader) query(subarray []int) int {
    l, r := subarray[0], subarray[1]
    sum := 0
    for i := l; i <= r; i++ {
        sum += ar.arr[i]
    }
    return sum
}

func (ar *ArrayReader) length() int {
    return len(ar.arr)
}
```

## Link

[LeetCode 1533 Find the Index of the Large Integer](https://leetcode.com/problems/find-the-index-of-the-large-integer/)