# 2161 Partition Array According to Given Pivot

## Problem Description

You are given a 0-indexed integer array `nums` and an integer `pivot`. Rearrange the array such that:

1. Every element less than `pivot` appears before every element greater than `pivot`.
2. Every element equal to `pivot` appears in between the elements less than and greater than `pivot`.
3. The relative order of the elements less than `pivot` and the elements greater than `pivot` is maintained.

Return the rearranged array.

### Example 1:
```
Input: nums = [9,12,5,10,14,3,10], pivot = 10
Output: [9,5,3,10,10,12,14]
Explanation: 
Elements less than 10: [9,5,3]
Elements equal to 10: [10,10]
Elements greater than 10: [12,14]
```

### Example 2:
```
Input: nums = [-3,4,3,2], pivot = 2
Output: [-3,2,4,3]
Explanation: 
Elements less than 2: [-3]
Elements equal to 2: [2]
Elements greater than 2: [4,3]
```

## Approach

This problem can be solved using a three-pass approach:

1. First pass: Collect all elements less than `pivot` in their original order.
2. Second pass: Collect all elements equal to `pivot` in their original order.
3. Third pass: Collect all elements greater than `pivot` in their original order.
4. Concatenate these three lists to form the result.

## Solution Code

```go
func pivotArray(nums []int, pivot int) []int {
    var less, equal, greater []int
    
    // First pass: collect elements less than pivot
    for _, num := range nums {
        if num < pivot {
            less = append(less, num)
        }
    }
    
    // Second pass: collect elements equal to pivot
    for _, num := range nums {
        if num == pivot {
            equal = append(equal, num)
        }
    }
    
    // Third pass: collect elements greater than pivot
    for _, num := range nums {
        if num > pivot {
            greater = append(greater, num)
        }
    }
    
    // Concatenate the three lists
    result := append(less, equal...)
    result = append(result, greater...)
    
    return result
}
```

## Complexity Analysis

- **Time**: O(n) - We traverse the array three times
- **Space**: O(n) - We store the three lists, which together contain all elements

## Link

[LeetCode 2161 Partition Array According to Given Pivot](https://leetcode.com/problems/partition-array-according-to-given-pivot/)