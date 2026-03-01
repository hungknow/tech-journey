# 0344 Reverse String

## Problem Description

Write a function that reverses a string. The input string is given as an array of characters `s`.

### Example 1:
```
Input: s = ["h","e","l","l","o"]
Output: ["o","l","l","e","h"]
```

### Example 2:
```
Input: s = ["H","a","n","n","a","h"]
Output: ["h","a","n","n","a","H"]
```

## Two Pointers Approach

This problem can be solved using the two-pointer technique. We use two pointers starting from the beginning and end of the string/array, swapping elements as we move toward the center.

### Algorithm Steps:

1. Initialize `left = 0` and `right = len(s) - 1`
2. While `left < right`:
   - Swap `s[left]` and `s[right]`
   - Increment `left`
   - Decrement `right`
3. Return the reversed string/array

## Complexity

- **Time**: O(n) - we traverse the string/array once
- **Space**: O(1) - constant space for pointers

## Solution Code

```go
package main

func reverseString(s []byte) []byte {
    left := 0
    right := len(s) - 1
    
    // Convert to a mutable slice if it's not already
    result := make([]byte, len(s))
    copy(result, s)
    
    for left < right {
        // Swap characters at left and right
        result[left], result[right] = result[right], result[left]
        left++
        right--
    }
    
    return result
}

// Alternative solution for string input
func reverseString(s string) string {
    // Convert string to rune slice to handle Unicode properly
    runes := []rune(s)
    left := 0
    right := len(runes) - 1
    
    for left < right {
        runes[left], runes[right] = runes[right], runes[left]
        left++
        right--
    }
    
    return string(runes)
}
```

## In-place Reversal

If we're allowed to modify the input array in place, we can use the same two-pointer approach without extra space.

## In-place Solution Code

```go
package main

func reverseString(s []byte) []byte {
    left := 0
    right := len(s) - 1
    
    for left < right {
        s[left], s[right] = s[right], s[left]
        left++
        right--
    }
    
    return s
}
```

## Link

[LeetCode 0344 Reverse String](https://leetcode.com/problems/reverse-string/)