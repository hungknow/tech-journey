# 2938 Separate Black and White Balls

## Problem Description

There are `n` balls on a table, where the `i-th` ball is colored either black or white. You are given a binary string `s` of length `n`, where `s[i] = '0'` represents a white ball and `s[i] = '1'` represents a black ball.

In one step, you can choose two adjacent balls of different colors and swap them. Return the minimum number of steps required to group all the black balls to the right and all the white balls to the left.

### Example 1:
```
Input: s = "101"
Output: 1
Explanation: We can swap the first and second balls to get "011", which groups all black balls to the right.
```

### Example 2:
```
Input: s = "100"
Output: 2
Explanation: We need to swap the first ball with the second ball, then with the third ball to get "001".
```

### Example 3:
```
Input: s = "0111"
Output: 0
Explanation: All black balls are already to the right of all white balls.
```

## Solution

The problem asks us to find the minimum number of swaps needed to move all 1's (black balls) to the right of all 0's (white balls). This is a classic two-pointer problem.

### Approach

1. We need to count the number of 0's that appear after each 1 in the string.
2. For each 1, we need to count how many 0's come after it, as these represent the number of swaps needed for that 1 to reach its final position.
3. We can use a two-pointer approach where we iterate through the string and keep track of the number of 0's seen so far.

A more efficient approach is to:
1. Count the total number of 0's in the string (let's call it `zeroCount`).
2. For each position `i`, if `s[i]` is '1', it needs to be moved past all the 0's that come after it.
3. We can keep track of the number of 0's we've encountered so far and use it to calculate the swaps needed.

### Code

```go
func minimumSteps(s string) int64 {
    steps := int64(0)
    zeroCount := 0
    
    // Iterate through the string from left to right
    for i := 0; i < len(s); i++ {
        if s[i] == '0' {
            zeroCount++
        } else {
            // For each '1', it needs to be moved past all '0's that come after it
            // We'll count these '0's as we encounter them
            steps += int64(zeroCount)
        }
    }
    
    return steps
}
```

Wait, this approach is not correct. Let me reconsider.

The correct approach is:
1. Count the number of 0's that each 1 needs to pass through.
2. For each 1, count the number of 0's to its right.
3. The total number of swaps is the sum of these counts.

Here's the correct implementation:

```go
func minimumSteps(s string) int64 {
    steps := int64(0)
    zeroCount := 0
    
    // Count the total number of 0's
    for _, c := range s {
        if c == '0' {
            zeroCount++
        }
    }
    
    // For each 1, count how many 0's come after it
    zerosAfter := zeroCount
    for _, c := range s {
        if c == '0' {
            zerosAfter--
        } else {
            steps += int64(zerosAfter)
        }
    }
    
    return steps
}
```

Actually, there's an even simpler approach. We can iterate from right to left and count the number of 1's we've seen. For each 0, the number of swaps needed is equal to the number of 1's to its right.

```go
func minimumSteps(s string) int64 {
    steps := int64(0)
    oneCount := 0
    
    // Iterate from right to left
    for i := len(s) - 1; i >= 0; i-- {
        if s[i] == '1' {
            oneCount++
        } else {
            // For each 0, it needs to be swapped past all 1's to its right
            steps += int64(oneCount)
        }
    }
    
    return steps
}
```

### Complexity Analysis

- **Time Complexity**: O(n) - We iterate through the string once
- **Space Complexity**: O(1) - We only use constant extra space

## Link

[LeetCode 2938 Separate Black and White Balls](https://leetcode.com/problems/separate-black-and-white-balls/)