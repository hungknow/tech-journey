# 0828 Count Unique Characters of All Substrings of a Given String

## Problem Description

Let `s` be a string of lowercase English letters. A string is unique if it does not contain any repeated characters.

Return the sum of the number of unique characters of all substrings of `s`.

### Example 1:
```
Input: s = "ABC"
Output: 10
Explanation: All substrings are: "A","B","C","AB","BC","ABC".
Each substring contains only unique characters.
Sum of lengths of all substrings is 1 + 1 + 1 + 2 + 2 + 3 = 10.
```

### Example 2:
```
Input: s = "ABA"
Output: 8
Explanation: All substrings are: "A","B","A","AB","BA","ABA".
The unique characters in each substring are:
"A" -> "A", "B" -> "B", "A" -> "A", "AB" -> "A,B", "BA" -> "B,A", "ABA" -> "A,B".
Sum of unique characters in all substrings is 1 + 1 + 1 + 2 + 2 + 2 = 8.
```

## Approach

This problem can be solved using a contribution-based approach. For each character in the string, we calculate how many substrings it contributes to as a unique character.

For each character at index `i`:
1. Find the previous occurrence of the same character (let's call it `prev`).
2. Find the next occurrence of the same character (let's call it `next`).
3. The number of substrings where this character is unique is: `(i - prev) * (next - i)`

We sum this contribution for all characters in the string to get the final answer.

## Solution Code

```go
func uniqueLetterString(s string) int {
    n := len(s)
    // Create a map to store all positions of each character
    charPositions := make(map[byte][]int)
    
    for i := 0; i < n; i++ {
        char := s[i]
        charPositions[char] = append(charPositions[char], i)
    }
    
    result := 0
    
    // For each character in the string
    for i := 0; i < n; i++ {
        char := s[i]
        positions := charPositions[char]
        
        // Find the index of current position in the positions array
        var currIndex int
        for idx, pos := range positions {
            if pos == i {
                currIndex = idx
                break
            }
        }
        
        // Calculate previous and next occurrence
        var prev, next int
        if currIndex == 0 {
            prev = -1
        } else {
            prev = positions[currIndex-1]
        }
        
        if currIndex == len(positions)-1 {
            next = n
        } else {
            next = positions[currIndex+1]
        }
        
        // Calculate contribution
        contribution := (i - prev) * (next - i)
        result += contribution
    }
    
    return result
}
```

## Complexity Analysis

- **Time**: O(n) - We traverse the string and for each character, we do constant time operations
- **Space**: O(n) - We store positions of each character, which in the worst case is O(n)

## Link

[LeetCode 0828 Count Unique Characters of All Substrings of a Given String](https://leetcode.com/problems/count-unique-characters-of-all-substrings-of-a-given-string/)