# 2067 Number of Equal Count Substrings

## Problem Description

You are given a 0-indexed binary string `s`. A substring is called equal count if the number of 0's in the substring is equal to the number of 1's in the substring.

Return the number of equal count substrings in `s`.

A substring is a contiguous sequence of characters within a string.

### Example 1:
```
Input: s = "01"
Output: 2
Explanation: The equal count substrings are "01" and "1".
```

### Example 2:
```
Input: s = "0011"
Output: 4
Explanation: The equal count substrings are "0011", "01", "0011", "11".
```

### Example 3:
```
Input: s = "010101"
Output: 9
Explanation: All substrings of length 2 are equal count substrings.
```

## Approach

This problem can be solved using a sliding window approach:

1. For each possible length of substring (from 1 to n), check all substrings of that length.
2. For each substring, count the number of 0's and 1's.
3. If the counts are equal, increment the result.
4. To optimize, we can use prefix sums to quickly calculate the count of 0's and 1's in any substring.

## Solution Code

```go
func equalCountSubstrings(s string) int {
    n := len(s)
    result := 0
    
    // Prefix sums for 0's and 1's
    prefix0 := make([]int, n+1)
    prefix1 := make([]int, n+1)
    
    for i := 0; i < n; i++ {
        prefix0[i+1] = prefix0[i]
        prefix1[i+1] = prefix1[i]
        
        if s[i] == '0' {
            prefix0[i+1]++
        } else {
            prefix1[i+1]++
        }
    }
    
    // Check all substrings
    for i := 0; i < n; i++ {
        for j := i; j < n; j++ {
            count0 := prefix0[j+1] - prefix0[i]
            count1 := prefix1[j+1] - prefix1[i]
            
            if count0 == count1 {
                result++
            }
        }
    }
    
    return result
}
```

## Complexity Analysis

- **Time**: O(n^2) - We check all possible substrings
- **Space**: O(n) - We store the prefix sums

## Link

[LeetCode 2067 Number of Equal Count Substrings](https://leetcode.com/problems/number-of-equal-count-substrings/)