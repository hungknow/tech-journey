# 0793 Preimage Size of Factorial Zeroes Function

## Problem Description

Let `f(x)` be the number of trailing zeros in the decimal representation of `x!`. Given an integer `k`, return the number of non-negative integers `x` such that `f(x) = k`.

### Example 1:
```
Input: k = 0
Output: 5
Explanation: 0!, 1!, 2!, 3!, and 4! all have 0 trailing zeros.
```

### Example 2:
```
Input: k = 5
Output: 0
Explanation: There is no x such that x! has exactly 5 trailing zeros.
```

### Example 3:
```
Input: k = 3
Output: 5
```

## The Twist

Finding the **preimage size** of the factorial zeroes function efficiently. This involves understanding the distribution of trailing zeros in factorials and using binary search to find the range of values.

## Algorithm

### Binary Search Approach:
1. The number of trailing zeros in `x!` is given by `f(x) = x/5 + x/25 + x/125 + ...`
2. For a given `k`, we need to find all `x` such that `f(x) = k`
3. Use binary search to find the smallest `x` such that `f(x) >= k`
4. Use binary search to find the smallest `x` such that `f(x) >= k+1`
5. The answer is the difference between these two values

The key insight is that `f(x)` is a non-decreasing function, and for any `k`, there are either 0 or 5 values of `x` such that `f(x) = k`.

## Complexity

- **Time**: O(log n) - binary search operations
- **Space**: O(1) - constant space

## Solution Code

```go
package main

import "fmt"

func preimageSizeFZF(k int) int {
    // Helper function to count trailing zeros in x!
    countZeros := func(x int) int {
        count := 0
        for x > 0 {
            x /= 5
            count += x
        }
        return count
    }
    
    // Find the smallest x such that countZeros(x) >= k
    left := 0
    right := 5 * (k + 1) // Upper bound
    
    for left < right {
        mid := left + (right-left)/2
        if countZeros(mid) < k {
            left = mid + 1
        } else {
            right = mid
        }
    }
    
    start := left
    
    // Find the smallest x such that countZeros(x) >= k+1
    left = 0
    right = 5 * (k + 2) // Upper bound
    
    for left < right {
        mid := left + (right-left)/2
        if countZeros(mid) < k+1 {
            left = mid + 1
        } else {
            right = mid
        }
    }
    
    end := left
    
    return end - start
}
```

## Link

[LeetCode 0793 Preimage Size of Factorial Zeroes Function](https://leetcode.com/problems/preimage-size-of-factorial-zeroes-function/)