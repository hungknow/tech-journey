# 2516 Take K of Each Character From Left and Right

## Problem Description

You are given a string `s` and an integer `k`. You need to take exactly `k` characters from the left and `k` characters from the right of the string.

Return the minimum number of characters you need to take to make the string empty.

### Example 1:
```
Input: s = "abcde", k = 1
Output: 5
Explanation: You need to take 'a', 'b', 'c', 'd', 'e' to make the string empty.
```

### Example 2:
```
Input: s = "aabaaa", k = 2
Output: 3
Explanation: You can take 'a' and 'a' from the left, and 'a' and 'a' from the right.
```

## Approach

This problem can be solved using a two-pointer approach:

1. Use two pointers, one starting from the beginning (`left`) and one from the end (`right`) of the string.
2. Count the frequency of each character.
3. For each character, the number of times we need to take it is `ceil(freq[char] / k)`.
4. Sum these values for all characters to get the total number of operations needed.

## Solution Code

```go
func takeCharacters(s string, k int) int {
    freq := make(map[byte]int)
    for i := 0; i < len(s); i++ {
        freq[s[i]]++
    }
    
    result := 0
    for _, count := range freq {
        // Calculate the number of times we need to take this character
        times := (count + k - 1) / k
        result += times
    }
    
    return result
}
```

## Complexity Analysis

- **Time**: O(n) - We traverse the string once
- **Space**: O(1) - We only use a constant amount of extra space for the character frequencies

## Link

[LeetCode 2516 Take K of Each Character From Left and Right](https://leetcode.com/problems/take-k-of-each-character-from-left-and-right/)