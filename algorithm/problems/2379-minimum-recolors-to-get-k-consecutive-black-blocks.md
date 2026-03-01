# 2379 Minimum Recolors to Get K Consecutive Black Blocks

## Problem Description

You are given a string `blocks` representing the color of a row of blocks. Each block can be either 'W' (white) or 'B' (black).

You want to recolor some blocks to get `k` consecutive black blocks. Return the minimum number of recolors needed.

### Example 1:
```
Input: blocks = "WBBWWBBWBW", k = 7
Output: 3
Explanation: Recolor the 1st, 2nd, and 6th blocks to get "BBBBBBBWBW".
```

### Example 2:
```
Input: blocks = "WBWBBBW", k = 2
Output: 0
Explanation: The substring "BB" already has 2 consecutive black blocks.
```

## Approach

This problem can be solved using a sliding window approach:

1. Use a sliding window of size `k` to find the window with the maximum number of black blocks.
2. For each window, count the number of white blocks, which is the number of recolors needed.
3. The minimum number of recolors is the minimum count of white blocks in any window of size `k`.

## Solution Code

```go
func minimumRecolors(blocks string, k int) int {
    n := len(blocks)
    if k > n {
        return 0
    }
    
    // Initialize the first window
    whiteCount := 0
    for i := 0; i < k; i++ {
        if blocks[i] == 'W' {
            whiteCount++
        }
    }
    
    minRecolors := whiteCount
    
    // Slide the window
    for i := k; i < n; i++ {
        // Remove the leftmost block
        if blocks[i-k] == 'W' {
            whiteCount--
        }
        
        // Add the new block
        if blocks[i] == 'W' {
            whiteCount++
        }
        
        // Update the minimum recolors
        if whiteCount < minRecolors {
            minRecolors = whiteCount
        }
    }
    
    return minRecolors
}
```

## Complexity Analysis

- **Time**: O(n) - We traverse the string once with the sliding window
- **Space**: O(1) - We only use a few variables regardless of the input size

## Link

[LeetCode 2379 Minimum Recolors to Get K Consecutive Black Blocks](https://leetcode.com/problems/minimum-recolors-to-get-k-consecutive-black-blocks/)