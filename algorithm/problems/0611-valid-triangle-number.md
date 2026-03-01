# 0611 Valid Triangle Number

## Problem Description

Given an integer array `nums`, return the number of triplets chosen from the array that could form triangles if we take three array elements as side lengths of a triangle.

### Example 1:
```
Input: nums = [4,6,3,7]
Output: 3
Explanation: Valid combinations are:
(0,1,2): nums[0] + nums[1] > nums[2], nums[0] + nums[2] > nums[1], nums[1] + nums[2] > nums[0]
(0,1,3): nums[0] + nums[1] > nums[3], nums[0] + nums[3] > nums[1], nums[1] + nums[3] > nums[0]
(0,2,3): nums[0] + nums[2] > nums[3], nums[0] + nums[3] > nums[2], nums[2] + nums[3] > nums[0]
```

### Example 2:
```
Input: nums = [2,2,3,4]
Output: 4
```

## Two Pointers Approach

This problem can be efficiently solved using the two-pointer technique after sorting the array. For each pair of sides, we find the largest third side that can form a valid triangle.

### Algorithm Steps:

1. Sort the array in non-decreasing order
2. Initialize a counter for valid triangles
3. Iterate from the end of the array with index `k` (the largest side):
   - Initialize two pointers: `i = 0` (smallest side) and `j = k-1` (middle side)
   - While `i < j`:
     - If `nums[i] + nums[j] > nums[k]`, then all elements between `i` and `j-1` can form a valid triangle with `j` and `k`
     - Add `j-i` to the counter and decrement `j`
     - Otherwise, increment `i`
4. Return the counter

## Complexity

- **Time**: O(n²) - for each element as the largest side, we use two pointers to find valid pairs
- **Space**: O(1) - constant space for pointers and counter

## Solution Code

```go
package main

import "sort"

func triangleNumber(nums []int) int {
    sort.Ints(nums)
    count := 0
    n := len(nums)
    
    // Iterate from the end (largest side)
    for k := n - 1; k >= 2; k-- {
        i, j := 0, k-1
        
        for i < j {
            // If nums[i] + nums[j] > nums[k], then all elements between i and j-1
            // can form a valid triangle with j and k
            if nums[i] + nums[j] > nums[k] {
                count += j - i
                j--
            } else {
                i++
            }
        }
    }
    
    return count
}
```

## Alternative Approach (Three Nested Loops with Binary Search)

An alternative approach is to fix two sides and use binary search to find the largest third side that can form a valid triangle.

## Alternative Solution Code

```go
package main

import "sort"

func triangleNumber(nums []int) int {
    sort.Ints(nums)
    count := 0
    n := len(nums)
    
    // Fix the first two sides
    for i := 0; i < n-2; i++ {
        for j := i + 1; j < n-1; j++ {
            // Binary search for the largest k such that nums[i] + nums[j] > nums[k]
            left, right := j+1, n-1
            for left <= right {
                mid := left + (right-left)/2
                if nums[i] + nums[j] > nums[mid] {
                    left = mid + 1
                } else {
                    right = mid - 1
                }
            }
            
            // All elements from j+1 to left-1 can form a valid triangle
            count += left - j - 1
        }
    }
    
    return count
}
```

## Link

[LeetCode 0611 Valid Triangle Number](https://leetcode.com/problems/valid-triangle-number/)