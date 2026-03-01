# 1316 Distinct Echo Substrings

## Problem Description

Return the number of distinct echo substrings of a given string `s`.

A substring is a sequence of consecutive characters from the string. An echo substring is a substring that, when concatenated with itself, is also a substring of the original string.

In other words, a substring `echo` is an echo substring if `echo + echo` is a substring of `s`.

### Example 1:
```
Input: s = "abcabcabc"
Output: 3
Explanation: The echo substrings are "abc", "bc", and "c".
```

### Example 2:
```
Input: s = "leetcode"
Output: 2
Explanation: The echo substrings are "e" and "t".
```

## Approach

This problem can be solved using a sliding window approach combined with a hash set to store distinct echo substrings:

1. For each possible length `l` from 1 to `n/2`, where `n` is the length of the string:
   - Use a sliding window to check all substrings of length `l`.
   - For each substring `s[i:i+l]`, check if the next `l` characters are the same.
   - If they are the same, add the substring to a set of distinct echo substrings.
2. Return the size of the set.

## Solution Code

```go
func distinctEchoSubstrings(s string) int {
    n := len(s)
    distinctSubstrings := make(map[string]bool)
    
    for l := 1; l <= n/2; l++ {
        for i := 0; i <= n-2*l; i++ {
            // Check if s[i:i+l] == s[i+l:i+2l]
            if s[i:i+l] == s[i+l:i+2*l] {
                distinctSubstrings[s[i:i+l]] = true
            }
        }
    }
    
    return len(distinctSubstrings)
}
```

## Complexity Analysis

- **Time**: O(n^2) - We check all possible substrings
- **Space**: O(n^2) - In the worst case, we store all possible substrings

## Link

[LeetCode 1316 Distinct Echo Substrings](https://leetcode.com/problems/distinct-echo-substrings/)