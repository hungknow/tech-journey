# 2172 Maximum AND Sum of Array

## Problem Description

You are given an integer array `nums` and an integer `numSlots`.

You have `numSlots` slots numbered from 1 to `numSlots`. Each slot can hold up to 2 numbers.

The AND sum of an arrangement is defined as:
`(nums[0] & slot1) + (nums[1] & slot2) + ... + (nums[n-1] & slotn)`

where `&` is the bitwise AND operation, and `sloti` is the slot number assigned to `nums[i]`.

Return the maximum possible AND sum of the array after assigning each number to a slot.

### Example 1:
```
Input: nums = [1,2,3,4,5,6], numSlots = 3
Output: 9
```

### Example 2:
```
Input: nums = [1,3,10,4,7,1], numSlots = 9
Output: 24
```

## Approach

This problem can be solved using DP with bitmask:

1. **State Representation**:
   - Use bitmask to represent slot occupancy
   - Each slot can hold up to 2 numbers
   - Track which numbers have been assigned

2. **DP Transitions**:
   - For each state, try assigning current number to available slots
   - Calculate AND sum for each assignment
   - Update DP table with maximum values

3. **Bitmask Operations**:
   - Use 2 bits per slot to represent occupancy (0, 1, or 2 numbers)
   - Efficiently check slot availability
   - Generate next states

4. **Optimization**:
   - Process numbers in order
   - Use memoization to avoid recomputation
   - Early termination for impossible states

## Solution Code

```go
func maximumANDSum(nums []int, numSlots int) int {
    n := len(nums)
    if n == 0 {
        return 0
    }
    
    // Each slot can hold up to 2 numbers, so we need 2 bits per slot
    totalBits := numSlots * 2
    memo := make(map[int]int)
    
    var dfs func(index int, state int) int
    dfs = func(index int, state int) int {
        if index == n {
            return 0
        }
        
        if val, exists := memo[state]; exists {
            return val
        }
        
        maxSum := 0
        
        // Try to place nums[index] in each available slot
        for slot := 1; slot <= numSlots; slot++ {
            slotBits := (slot - 1) * 2
            occupancy := (state >> slotBits) & 3
            
            if occupancy < 2 { // Slot has space
                newState := state + (1 << slotBits)
                currentAnd := nums[index] & slot
                total := currentAnd + dfs(index+1, newState)
                maxSum = max(maxSum, total)
            }
        }
        
        memo[state] = maxSum
        return maxSum
    }
    
    return dfs(0, 0)
}

func max(a, b int) int {
    if a > b {
        return a
    }
    return b
}
```

## Complexity Analysis

- **Time**: O(n * 3^s) where n is the number of numbers and s is the number of slots
  - Each slot can have 3 states (0, 1, or 2 numbers)
  - For each number, we try all possible slots
- **Space**: O(3^s) for the memoization table

## Link

[LeetCode 2172 Maximum AND Sum of Array](https://leetcode.com/problems/maximum-and-sum-of-array/)