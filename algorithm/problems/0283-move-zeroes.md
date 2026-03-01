# 0283 Move Zeroes

## Problem Description

Given an integer array `nums`, move all `0`'s to the end of it while maintaining the relative order of the non-zero elements.

**Note** that you must do this in-place without making a copy of the array.

### Example 1:
```
Input: nums = [0,1,0,3,12]
Output: [1,3,12,0,0]
```

### Example 2:
```
Input: nums = [0]
Output: [0]
```

## Two Pointers Approach

This problem can be efficiently solved using the two-pointer technique. We use one pointer to track the position where the next non-zero element should be placed, and another pointer to traverse the array.

### Algorithm Steps:

1. Initialize a pointer `lastNonZeroFoundAt = 0` to track the position for the next non-zero element
2. Iterate through the array with pointer `current`:
   - If `nums[current]` is non-zero:
     - Swap `nums[lastNonZeroFoundAt]` and `nums[current]`
     - Increment `lastNonZeroFoundAt`
3. After the loop, all non-zero elements are at the beginning, and zeros are at the end

## Complexity

- **Time**: O(n) - we traverse the array once
- **Space**: O(1) - constant space for the two pointers

## Solution Code

```go
package main

func moveZeroes(nums []int) {
    lastNonZeroFoundAt := 0
    
    // Move all non-zero elements to the front
    for current := 0; current < len(nums); current++ {
        if nums[current] != 0 {
            nums[lastNonZeroFoundAt], nums[current] = nums[current], nums[lastNonZeroFoundAt]
            lastNonZeroFoundAt++
        }
    }
}
```

## Alternative Approach (Two Pass)

An alternative approach is to first move all non-zero elements to the front, then fill the rest with zeros. This avoids unnecessary swaps when there are consecutive non-zero elements.

## Alternative Solution Code

```go
package main

func moveZeroes(nums []int) {
    // First pass: move all non-zero elements to the front
    lastNonZeroFoundAt := 0
    for current := 0; current < len(nums); current++ {
        if nums[current] != 0 {
            nums[lastNonZeroFoundAt] = nums[current]
            lastNonZeroFoundAt++
        }
    }
    
    // Second pass: fill the rest with zeros
    for i := lastNonZeroFoundAt; i < len(nums); i++ {
        nums[i] = 0
    }
}
```

## Link

[LeetCode 0283 Move Zeroes](https://leetcode.com/problems/move-zeroes/)