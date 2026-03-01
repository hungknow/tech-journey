# 0360 Sort Transformed Array

## Problem Description

Given a sorted integer array `nums` and three integers `a`, `b` and `c`, return a sorted array of the `x^2 + a*x + b` values of every number in `nums`.

### Example 1:
```
Input: nums = [-4,-2,2,4], a = 1, b = 3, c = 5
Output: [3,9,15,33]
```

### Example 2:
```
Input: nums = [-4,-2,2,4], a = -1, b = 3, c = 5
Output: [-23,-5,1,7]
```

## Approach

The key observation here is that the quadratic function `f(x) = ax^2 + bx + c` has different properties based on the value of `a`:

1. If `a > 0`: The parabola opens upward, and the function values will be larger at both ends of the array.
2. If `a < 0`: The parabola opens downward, and the function values will be smaller at both ends of the array.
3. If `a = 0`: The function becomes linear `f(x) = bx + c`.

We can use a two-pointer approach:
- For `a > 0`: Start from both ends of the array and fill the result array from the end.
- For `a <= 0`: Start from both ends of the array and fill the result array from the beginning.

## Solution Code

```go
func sortTransformedArray(nums []int, a int, b int, c int) []int {
    n := len(nums)
    result := make([]int, n)
    left, right := 0, n-1
    idx := n - 1
    
    // Helper function to calculate the transformed value
    transform := func(x int) int {
        return a*x*x + b*x + c
    }
    
    // If a is negative, we want to fill from the beginning
    if a < 0 {
        idx = 0
    }
    
    for left <= right {
        leftVal, rightVal := transform(nums[left]), transform(nums[right])
        
        if a >= 0 {
            // For a >= 0, the larger value goes at the end
            if leftVal > rightVal {
                result[idx] = leftVal
                left++
            } else {
                result[idx] = rightVal
                right--
            }
            idx--
        } else {
            // For a < 0, the smaller value goes at the beginning
            if leftVal < rightVal {
                result[idx] = leftVal
                left++
            } else {
                result[idx] = rightVal
                right--
            }
            idx++
        }
    }
    
    return result
}
```

## Complexity Analysis

- **Time**: O(n) - We traverse the array once with two pointers
- **Space**: O(n) - We create a result array of the same size as the input

## Link

[LeetCode 0360 Sort Transformed Array](https://leetcode.com/problems/sort-transformed-array/)