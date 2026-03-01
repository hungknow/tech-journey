# 2105 Watering Plants II

## Problem Description

Alice and Bob want to water `n` plants in their garden. The plants are arranged in a row and are labeled from `0` to `n-1` from left to right.

Alice and Bob take turns watering the plants. Alice water the plants first, and Bob water the plants last.

Each time, Alice or Bob chooses a plant to water and waters it. If a plant is already watered, it will be watered again.

You are given a 0-indexed integer array `watering` of length `n`, where `watering[i]` is the amount of water the i-th plant needs.

Return the total amount of water used by Alice and Bob to water all the plants.

### Example 1:
```
Input: watering = [1,2,3,4]
Output: 10
Explanation: Alice waters plant 0 (1), plant 1 (2), plant 2 (3), plant 3 (4).
Bob doesn't need to water any plants.
Total water used: 1 + 2 + 3 + 4 = 10.
```

### Example 2:
```
Input: watering = [1,2,3,4,5]
Output: 15
Explanation: Alice waters plant 0 (1), plant 1 (2), plant 2 (3), plant 3 (4).
Bob waters plant 4 (5).
Total water used: 1 + 2 + 3 + 4 + 5 = 15.
```

## Approach

This problem can be solved using a two-pointer approach:

1. Alice starts from the left (index 0) and Bob starts from the right (index n-1).
2. They water plants towards each other until they meet or cross.
3. The total water used is simply the sum of all watering amounts.

## Solution Code

```go
func minimumRefill(watering []int) int {
    n := len(watering)
    left, right := 0, n-1
    total := 0
    
    while left <= right {
        if left == right {
            // Both Alice and Bob are at the same plant
            total += watering[left]
            break
        } else {
            // Alice waters the left plant
            total += watering[left]
            left++
            
            // Bob waters the right plant
            total += watering[right]
            right--
        }
    }
    
    return total
}
```

## Complexity Analysis

- **Time**: O(n) - We traverse the array once with two pointers
- **Space**: O(1) - We only use a few pointers regardless of the input size

## Link

[LeetCode 2105 Watering Plants II](https://leetcode.com/problems/watering-plants-ii/)