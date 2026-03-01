# 2511 Maximum Enemy Forts That Can Be Captured

## Problem Description

You are given a 0-indexed integer array `forts` representing the positions of enemy forts.

Each `forts[i]` can be:
- -1: An empty fort
- 0: Your fort
- 1: Enemy fort

You can capture an enemy fort if it is adjacent to one of your forts and there are no other forts between them.

Return the maximum number of enemy forts you can capture.

### Example 1:
```
Input: forts = [0,1,0,-1,0,1,0,0]
Output: 2
Explanation: You can capture the forts at positions 1 and 5.
```

### Example 2:
```
Input: forts = [0,-1,0,-1,0,1,0,0]
Output: 0
Explanation: No enemy fort can be captured.
```

## Approach

This problem can be solved using a two-pointer approach:

1. Iterate through each position in the array.
2. For each position with a fort (value 0 or 1), look to the left and right for the nearest enemy fort.
3. For each direction, count the number of empty forts between the current fort and the enemy fort.
4. The maximum number of enemy forts that can be captured is the maximum count found.

## Solution Code

```go
func captureForts(forts []int) int {
    n := len(forts)
    maxCaptures := 0
    
    for i := 0; i < n; i++ {
        if forts[i] == 0 || forts[i] == -1 {
            continue
        }
        
        // Look to the left
        left := i - 1
        captures := 0
        for left >= 0 && forts[left] != 1 {
            if forts[left] == -1 {
                captures++
            }
            left--
        }
        
        // Look to the right
        right := i + 1
        for right < n && forts[right] != 1 {
            if forts[right] == -1 {
                captures++
            }
            right++
        }
        
        if captures > maxCaptures {
            maxCaptures = captures
        }
    }
    
    return maxCaptures
}
```

## Complexity Analysis

- **Time**: O(n^2) - For each position, we might scan the entire array
- **Space**: O(1) - We only use a few pointers regardless of the input size

## Link

[LeetCode 2511 Maximum Enemy Forts That Can Be Captured](https://leetcode.com/problems/maximum-enemy-forts-that-can-be-captured/)