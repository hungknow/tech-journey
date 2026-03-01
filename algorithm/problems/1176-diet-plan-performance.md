# 1176 Diet Plan Performance

## Problem Description

A dieter consumes `calories[i]` calories on the i-th day. 

Given an integer `k`, for every consecutive sequence of `k` days (calories[i], calories[i+1], ..., calories[i+k-1]), we count the total calories consumed in that sequence. If the total calories is less than `lower`, we lose one point; if it is higher than `upper`, we gain one point; otherwise, no points are gained or lost.

Return the total points after considering all consecutive sequences of `k` days.

### Example 1:
```
Input: calories = [1,2,3,4,5], k = 1, lower = 3, upper = 3
Output: 0
Explanation: Since k = 1, we consider each element of the array as a sequence of length 1.
Only calories[2] = 3 is within the range [lower, upper], so no points are gained or lost.
```

### Example 2:
```
Input: calories = [3,2], k = 2, lower = 0, upper = 1
Output: 1
Explanation: Since k = 2, we consider the sequence [3,2].
The total calories is 5 > upper, so we gain one point.
```

### Example 3:
```
Input: calories = [6,5,0,0], k = 2, lower = 1, upper = 5
Output: 0
Explanation: 
- [6,5]: total = 11 > upper, gain 1 point
- [5,0]: total = 5 within range, no points
- [0,0]: total = 0 < lower, lose 1 point
Total points: 1 - 1 = 0
```

## Approach

This problem can be efficiently solved using a sliding window approach:

1. Calculate the sum of the first window of size `k`.
2. Slide the window one element at a time, updating the sum by subtracting the element leaving the window and adding the new element entering the window.
3. For each window, compare the sum with `lower` and `upper` to determine if points should be gained or lost.

## Solution Code

```go
func dietPlanPerformance(calories []int, k int, lower int, upper int) int {
    n := len(calories)
    if n < k {
        return 0
    }
    
    points := 0
    
    // Calculate the sum of the first window
    windowSum := 0
    for i := 0; i < k; i++ {
        windowSum += calories[i]
    }
    
    // Check the first window
    if windowSum < lower {
        points--
    } else if windowSum > upper {
        points++
    }
    
    // Slide the window
    for i := k; i < n; i++ {
        // Update the window sum
        windowSum += calories[i] - calories[i-k]
        
        // Check the current window
        if windowSum < lower {
            points--
        } else if windowSum > upper {
            points++
        }
    }
    
    return points
}
```

## Complexity Analysis

- **Time**: O(n) - We traverse the array once with the sliding window
- **Space**: O(1) - We only use a few variables regardless of the input size

## Link

[LeetCode 1176 Diet Plan Performance](https://leetcode.com/problems/diet-plan-performance/)