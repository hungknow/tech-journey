# 2838 Maximum Coins Heroes Can Collect

## Problem Description

You are given two integer arrays `heroes` and `coins`, where `heroes[i]` is the power of the i-th hero and `coins[j]` is the power of the j-th coin.

A hero can collect a coin if their power is greater than or equal to the coin's power.

Each hero can collect at most one coin.

Return the maximum number of coins that can be collected.

### Example 1:
```
Input: heroes = [2,1,4], coins = [1,2,3]
Output: 2
Explanation: Hero 1 (power 2) can collect coin 1 (power 1) and coin 2 (power 2).
Hero 2 (power 1) can collect coin 1 (power 1) and coin 2 (power 2).
Hero 4 (power 4) cannot collect any coin.
Total coins collected: 2.
```

### Example 2:
```
Input: heroes = [2,1,4], coins = [2,3,4]
Output: 3
Explanation: Hero 1 (power 2) can collect coin 2 (power 2) and coin 3 (power 3).
Hero 2 (power 1) can collect coin 2 (power 2) and coin 3 (power 3).
Hero 4 (power 4) can collect coin 2 (power 2) and coin 3 (power 3).
Total coins collected: 3.
```

## Approach

This problem can be solved using a two-pointer approach:

1. Sort both arrays in ascending order.
2. Use two pointers to traverse both arrays simultaneously.
3. For each hero, find the most powerful coin they can collect.
4. Increment the count for each hero that can collect a coin.
5. Return the total count.

## Solution Code

```go
func maximumCoins(heroes []int, coins []int) int {
    // Sort both arrays in ascending order
    sort.Ints(heroes)
    sort.Ints(coins)
    
    i, j := 0, len(heroes)-1
    count := 0
    
    for i < len(heroes) && j >= 0 {
        heroPower := heroes[i]
        coinPower := coins[j]
        
        // Find the most powerful coin this hero can collect
        for j > 0 && coins[j-1] >= heroPower {
            j--
        }
        
        if heroPower >= coinPower {
            count++
            i++
        } else {
            j--
        }
    }
    
    return count
}
```

## Complexity Analysis

- **Time**: O(n log n + m log m) - Sorting dominates the time complexity
- **Space**: O(1) - We only use a few pointers regardless of the input size

## Link

[LeetCode 2838 Maximum Coins Heroes Can Collect](https://leetcode.com/problems/maximum-coins-heroes-can-collect/)