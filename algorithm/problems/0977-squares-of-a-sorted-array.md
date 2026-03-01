# 0977 Squares of a Sorted Array

## Problem Description

Given an integer array `nums` sorted in non-decreasing order, return an array of the squares of each number sorted in non-decreasing order.

### Example 1:
```
Input: nums = [-4,-1,0,3,10]
Output: [0,1,9,16,100]
Explanation: After squaring, the array becomes [16,1,0,9,100].
After sorting, it becomes [0,1,9,16,100].
```

### Example 2:
```
Input: nums = [-7,-3,2,3,11]
Output: [4,9,9,49,121]
```

## Two Pointers Approach

Since the input array is sorted, the largest square values will come from the elements with the largest absolute values, which are at either end of the array. We can use two pointers to efficiently build the result array from the end.

### Algorithm Steps:

1. Initialize two pointers: `left = 0` and `right = len(nums) - 1`
2. Create a result array of the same length
3. Initialize a position pointer `pos = len(nums) - 1` to fill the result array from the end
4. While `left <= right`:
   - Compare the absolute values of `nums[left]` and `nums[right]`
   - If `|nums[left]| > |nums[right]|`, place `nums[left]^2` at `result[pos]` and increment `left`
   - Otherwise, place `nums[right]^2` at `result[pos]` and decrement `right`
   - Decrement `pos`
5. Return the result array

## Complexity

- **Time**: O(n) - we traverse the array once with two pointers
- **Space**: O(n) - space for the result array (output space doesn't count toward space complexity)

## Solution Code

```go
package main

func sortedSquares(nums []int) []int {
    n := len(nums)
    result := make([]int, n)
    left, right := 0, n-1
    pos := n-1
    
    for left <= right {
        leftSquare := nums[left] * nums[left]
        rightSquare := nums[right] * nums[right]
        
        if leftSquare > rightSquare {
            result[pos] = leftSquare
            left++
        } else {
            result[pos] = rightSquare
            right--
        }
        pos--
    }
    
    return result
}
```

## Alternative Approach (Brute Force)

An alternative approach is to square all elements and then sort the array, which is less efficient.

## Alternative Solution Code

```go
package main

import "sort"

func sortedSquares(nums []int) []int {
    // Square all elements
    for i := range nums {
        nums[i] = nums[i] * nums[i]
    }
    
    // Sort the array
    sort.Ints(nums)
    
    return nums
}
```

## Link

[LeetCode 0977 Squares of a Sorted Array](https://leetcode.com/problems/squares-of-a-sorted-array/)