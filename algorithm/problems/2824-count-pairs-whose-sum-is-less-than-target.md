# 2824 Count Pairs Whose Sum is Less Than Target

## Problem Description

Given an integer array `nums` and an integer `target`, return the number of pairs `(i, j)` where `0 <= i < j < nums.length` and `nums[i] + nums[j] < target`.

### Example 1:
```
Input: nums = [-1,1,2,3,1], target = 2
Output: 3
Explanation: There are 3 pairs with sum less than 2:
(-1, 1): -1 + 1 = 0 < 2
(-1, 1): -1 + 1 = 0 < 2
(-1, 2): -1 + 2 = 1 < 2
```

### Example 2:
```
Input: nums = [2,2,2,2], target = 4
Output: 0
Explanation: No pair has a sum less than 4.
```

### Example 3:
```
Input: nums = [-1,0,1,2,3], target = 3
Output: 4
Explanation: There are 4 pairs with sum less than 3:
(-1, 0): -1 + 0 = -1 < 3
(-1, 1): -1 + 1 = 0 < 3
(-1, 2): -1 + 2 = 1 < 3
(0, 1): 0 + 1 = 1 < 3
```

## Two Pointers Approach

This problem can be efficiently solved using the two-pointer technique after sorting the array. We use two pointers to find all pairs with sum less than the target.

### Algorithm Steps:

1. Sort the array in non-decreasing order
2. Initialize two pointers: `left = 0` and `right = len(nums) - 1`
3. Initialize a counter for valid pairs
4. While `left < right`:
   - Calculate the sum of elements at the two pointers
   - If the sum is less than target:
     - All elements between `left` and `right-1` will form valid pairs with `nums[left]`
     - Add `right - left` to the counter
     - Increment `left` to try with a larger element
   - Otherwise, decrement `right` to reduce the sum
5. Return the counter

## Complexity

- **Time**: O(n log n) - sorting takes O(n log n) and the two-pointer traversal takes O(n)
- **Space**: O(1) - constant space for pointers and counter

## Solution Code

```go
package main

import "sort"

func countPairs(nums []int, target int) int {
    sort.Ints(nums)
    
    left, right := 0, len(nums)-1
    count := 0
    
    for left < right {
        sum := nums[left] + nums[right]
        
        if sum < target {
            // All elements between left and right-1 will form valid pairs with nums[left]
            count += right - left
            left++
        } else {
            // Sum is too large, need to reduce it
            right--
        }
    }
    
    return count
}
```

## Alternative Approach (Brute Force)

An alternative approach is to check all possible pairs using nested loops, which is less efficient.

## Alternative Solution Code

```go
package main

func countPairs(nums []int, target int) int {
    count := 0
    n := len(nums)
    
    for i := 0; i < n; i++ {
        for j := i + 1; j < n; j++ {
            if nums[i] + nums[j] < target {
                count++
            }
        }
    }
    
    return count
}
```

## Link

[LeetCode 2824 Count Pairs Whose Sum is Less Than Target](https://leetcode.com/problems/count-pairs-whose-sum-is-less-than-target/)