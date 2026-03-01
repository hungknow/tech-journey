# 2836 Maximize Value of Function in a Ball Passing Game

## Problem Description

You are given an integer array `nums` of length `n` representing players in a ball passing game.

The value of the function is defined as:
- If player `i` receives the ball, they add `nums[i]` to the total value
- The ball is passed in a circular manner: player 0 → 1 → 2 → ... → n-1 → 0 → ...

You can start the ball passing at any player and make exactly `k` passes.

Return the maximum possible value of the function after exactly `k` passes.

### Example 1:
```
Input: nums = [1,2,3,4,5], k = 2
Output: 9
```

### Example 2:
```
Input: nums = [5,10,15,20], k = 1
Output: 20
```

## Approach

This problem can be solved using prefix sums and sliding window:

1. **Pattern Analysis**:
   - After k passes, the ball will be at position (start + k) % n
   - The value depends on which players receive the ball
   - This forms a sliding window pattern

2. **Prefix Sum Optimization**:
   - Calculate prefix sums for efficient range sum queries
   - Use sliding window to find maximum sum
   - Handle circular nature with duplication

3. **Sliding Window**:
   - For each starting position, calculate the sum of k+1 players
   - Use prefix sums for O(1) range sum calculation
   - Consider all possible starting positions

4. **Circular Handling**:
   - Duplicate the array to handle circular nature
   - Use modulo arithmetic for circular indexing
   - Ensure we don't double-count players

## Solution Code

```go
func getMaxFunctionValue(nums []int, k int) int64 {
    n := len(nums)
    if n == 0 {
        return 0
    }
    
    // Duplicate array to handle circular nature
    extended := make([]int, 2*n)
    for i := 0; i < 2*n; i++ {
        extended[i] = nums[i%n]
    }
    
    // Calculate prefix sums
    prefix := make([]int64, 2*n+1)
    for i := 0; i < 2*n; i++ {
        prefix[i+1] = prefix[i] + int64(extended[i])
    }
    
    // Calculate maximum value
    maxValue := int64(0)
    windowSize := k + 1
    
    for start := 0; start < n; start++ {
        end := start + windowSize - 1
        if end < 2*n {
            currentSum := prefix[end+1] - prefix[start]
            if currentSum > maxValue {
                maxValue = currentSum
            }
        }
    }
    
    return maxValue
}
```

## Complexity Analysis

- **Time**: O(N) where N is the length of the array
  - Building extended array: O(N)
  - Calculating prefix sums: O(N)
  - Sliding window search: O(N)
- **Space**: O(N) for the extended array and prefix sums

## Link

[LeetCode 2836 Maximize Value of Function in a Ball Passing Game](https://leetcode.com/problems/maximize-value-of-function-in-a-ball-passing-game/)