# 1040 Moving Stones Until Consecutive II

## Problem Description

You are given an integer array `stones` sorted in ascending order representing the positions of stones in a river.

A stone can be moved if it is at an endpoint (leftmost or rightmost stone) and there is an empty space adjacent to it. The stone can be moved to any empty space.

Return the minimum number of moves to make all the stones occupy consecutive positions, and the maximum number of moves to make all the stones occupy consecutive positions.

### Example 1:
```
Input: stones = [6,5,4,3,10]
Output: [2, 10]
Explanation: 
Minimum moves: Move stone 10 to 7, then to 6, making the positions [3,4,5,6,7].
Maximum moves: Move stone 10 to 9, then to 8, then to 7, then to 6, making the positions [3,4,5,6,7].
```

### Example 2:
```
Input: stones = [7,4,9]
Output: [1, 2]
Explanation: 
Minimum moves: Move stone 9 to 8, making the positions [4,7,8].
Maximum moves: Move stone 4 to 5, then to 6, making the positions [6,7,8].
```

## Approach

For the maximum number of moves:
- The maximum is simply `stones[n-1] - stones[0] + 1 - n`, which represents the number of empty positions between the first and last stone.

For the minimum number of moves:
- We need to find a window of size `n` (number of stones) that contains the maximum number of stones.
- The minimum moves will be `n - maxStonesInWindow`, where `maxStonesInWindow` is the maximum number of stones that can fit in any window of size `n`.
- Special case: If all stones except one are already in a window of size `n-1`, then we need 2 moves (not 1).

## Solution Code

```go
func numMovesStonesII(stones []int) []int {
    n := len(stones)
    
    // For maximum moves
    maxMoves := stones[n-1] - stones[0] + 1 - n
    
    // For minimum moves
    minMoves := n
    
    // Use sliding window to find the window with most stones
    i := 0
    for j := 0; j < n; j++ {
        // Window size is stones[j] - stones[i] + 1
        for stones[j] - stones[i] + 1 > n {
            i++
        }
        
        // Number of stones in current window
        stonesInWindow := j - i + 1
        
        if stonesInWindow == n-1 && stones[j] - stones[i] + 1 == n-1 {
            // Special case: all stones except one are in a window of size n-1
            minMoves = min(minMoves, 2)
        } else {
            minMoves = min(minMoves, n - stonesInWindow)
        }
    }
    
    return []int{minMoves, maxMoves}
}

func min(a, b int) int {
    if a < b {
        return a
    }
    return b
}
```

## Complexity Analysis

- **Time**: O(n) - We use a sliding window approach to traverse the array once
- **Space**: O(1) - We only use a few variables regardless of the input size

## Link

[LeetCode 1040 Moving Stones Until Consecutive II](https://leetcode.com/problems/moving-stones-until-consecutive-ii/)