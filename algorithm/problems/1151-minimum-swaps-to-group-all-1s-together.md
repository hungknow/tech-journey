# 1151 Minimum Swaps to Group All 1's Together

## Problem Description

Given a binary array `data`, return the minimum number of swaps required to group all `1`s present in the array together in any location in the array.

### Example 1:
```
Input: data = [1,0,1,0,1]
Output: 1
Explanation: There are 3 ways to group all 1's together:
[1,1,1] and swaps = 1 (using the second and third element).
[0,0,0] and swaps = 0 (using the first and last element).
[1,1,1] and swaps = 1 (using the first and last element).
The minimum is 0.
```

### Example 2:
```
Input: data = [0,0,0,1,0]
Output: 0
```

### Example 3:
```
Input: data = [1,0,1,0,1,0,0,1,1,0,1]
Output: 3
```

## Approach

This problem can be solved using a sliding window approach:

1. First, count the total number of 1's in the array. Let's call this `countOnes`.
2. If `countOnes` is 0 or 1, no swaps are needed, return 0.
3. Use a sliding window of size `countOnes` to find the window with the maximum number of 1's.
4. The minimum number of swaps needed is `countOnes - maxOnesInWindow`, where `maxOnesInWindow` is the maximum number of 1's found in any window of size `countOnes`.

## Solution Code

```go
func minSwaps(data []int) int {
    n := len(data)
    
    // Count total number of 1's
    countOnes := 0
    for _, num := range data {
        countOnes += num
    }
    
    // If there are 0 or 1 ones, no swaps needed
    if countOnes <= 1 {
        return 0
    }
    
    // Initialize sliding window
    maxOnesInWindow := 0
    currentOnes := 0
    
    // Count 1's in the first window
    for i := 0; i < countOnes; i++ {
        currentOnes += data[i]
    }
    maxOnesInWindow = currentOnes
    
    // Slide the window
    for i := countOnes; i < n; i++ {
        // Remove the leftmost element and add the new rightmost element
        currentOnes += data[i] - data[i-countOnes]
        maxOnesInWindow = max(maxOnesInWindow, currentOnes)
    }
    
    // Minimum swaps needed is total ones minus maximum ones in any window
    return countOnes - maxOnesInWindow
}

func max(a, b int) int {
    if a > b {
        return a
    }
    return b
}
```

## Complexity Analysis

- **Time**: O(n) - We traverse the array once to count the 1's and then use a sliding window
- **Space**: O(1) - We only use a few variables regardless of the input size

## Link

[LeetCode 1151 Minimum Swaps to Group All 1's Together](https://leetcode.com/problems/minimum-swaps-to-group-all-1s-together/)