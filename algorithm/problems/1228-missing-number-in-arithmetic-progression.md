# 1228 Missing Number In Arithmetic Progression

## Problem Description

In some array `arr`, the values are in arithmetic progression. The values are distinct and sorted in ascending order. One value from the array is missing.

Find the missing value.

### Example 1:
```
Input: arr = [15,13,12]
Output: 14
Explanation: The arithmetic progression is [12,13,14,15]. The missing value is 14.
```

### Example 2:
```
Input: arr = [10,0,5]
Output: 5
Explanation: The arithmetic progression is [0,5,10]. The missing value is 5.
```

## The Twist

Finding the **missing number in an arithmetic progression** efficiently. This involves using binary search to locate the missing element by comparing the expected difference with the actual difference.

## Algorithm

### Binary Search Approach:
1. Calculate the common difference `d` as `(arr[-1] - arr[0]) / n` where `n` is the length of the array
2. Use binary search to find the missing element:
   - If the difference between `arr[mid]` and `arr[mid-1]` is not equal to `d`, the missing element is `arr[mid-1] + d`
   - If the difference between `arr[mid+1]` and `arr[mid]` is not equal to `d`, the missing element is `arr[mid] + d`
   - Otherwise, continue searching in the half where the progression breaks
3. If no break is found, the missing element is at the beginning or end

The key insight is that in a perfect arithmetic progression, the difference between any two consecutive elements is constant. A deviation from this constant indicates where the missing element should be.

## Complexity

- **Time**: O(log n) - binary search operations
- **Space**: O(1) - constant space

## Solution Code

```go
package main

import "fmt"

func missingNumber(arr []int) int {
    n := len(arr)
    
    // Handle edge case of 2 elements
    if n == 2 {
        if arr[1]-arr[0] == 2 {
            return arr[0] + 1
        }
        // If difference is not 2, the missing number is between them
        return (arr[0] + arr[1]) / 2
    }
    
    // Calculate the common difference
    d := (arr[n-1] - arr[0]) / n
    
    // Binary search for the missing element
    left := 0
    right := n - 1
    
    for left < right {
        mid := left + (right-left)/2
        
        // Check if the progression breaks at mid
        if arr[mid] != arr[0] + mid*d {
            right = mid
        } else {
            left = mid + 1
        }
    }
    
    // The missing element is at position left
    return arr[0] + left*d
}
```

## Link

[LeetCode 1228 Missing Number In Arithmetic Progression](https://leetcode.com/problems/missing-number-in-arithmetic-progression/)