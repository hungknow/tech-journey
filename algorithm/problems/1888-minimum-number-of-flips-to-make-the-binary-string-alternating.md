# 1888 Minimum Number of Flips to Make the Binary String Alternating

## Problem Description

You are given a binary string `s`. You can flip any character in the string (i.e., change '0' to '1' or '1' to '0').

Return the minimum number of flips to make the string alternating.

A string is alternating if no two adjacent characters are the same.

### Example 1:
```
Input: s = "001"
Output: 1
Explanation: Flip the last character to get "010", which is alternating.
```

### Example 2:
```
Input: s = "0100010"
Output: 2
Explanation: Flip the second and sixth characters to get "0101010", which is alternating.
```

## Approach

This problem can be solved using a sliding window approach:

1. There are two possible alternating patterns for a string of length `n`:
   - Pattern 1: Starts with '0' and alternates (e.g., "010101...")
   - Pattern 2: Starts with '1' and alternates (e.g., "101010...")
2. For each position, count how many characters don't match each pattern.
3. The answer is the minimum of the two counts.

## Solution Code

```go
func minFlips(s string) int {
    n := len(s)
    flips0 := 0 // Flips needed to match pattern starting with '0'
    flips1 := 0 // Flips needed to match pattern starting with '1'
    
    for i := 0; i < n; i++ {
        expectedChar0 := '0'
        expectedChar1 := '1'
        
        if i%2 == 1 {
            expectedChar0, expectedChar1 = '1', '0'
        }
        
        if byte(expectedChar0) != s[i] {
            flips0++
        }
        if byte(expectedChar1) != s[i] {
            flips1++
        }
    }
    
    return min(flips0, flips1)
}

func min(a, b int) int {
    if a < b {
        return a
    }
    return b
}
```

## Complexity Analysis

- **Time**: O(n) - We traverse the string once
- **Space**: O(1) - We only use a few variables regardless of the input size

## Link

[LeetCode 1888 Minimum Number of Flips to Make the Binary String Alternating](https://leetcode.com/problems/minimum-number-of-flips-to-make-the-binary-string-alternating/)