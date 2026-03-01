# 0844 Backspace String Compare

## Problem Description

Given two strings `s` and `t`, return `true` if they are equal when both are typed into empty text editors.

`'#'` means a backspace character.

### Example 1:
```
Input: s = "ab#c", t = "ad#c"
Output: true
Explanation: Both s and t become "ac".
```

### Example 2:
```
Input: s = "ab##", t = "c#d#"
Output: true
Explanation: Both s and t become "".
```

### Example 3:
```
Input: s = "a#c", t = "b"
Output: false
Explanation: s becomes "c" while t becomes "b".
```

## Two Pointers Approach (Reverse Traversal)

This problem can be efficiently solved using two pointers that traverse the strings from right to left. We need to handle backspaces by skipping characters.

### Algorithm Steps:

1. Initialize two pointers `i = len(s) - 1` and `j = len(t) - 1`
2. While `i >= 0` or `j >= 0`:
   - Find the next valid character in `s`:
     - Count backspaces while moving `i` left
     - Skip that many characters
   - Find the next valid character in `t`:
     - Count backspaces while moving `j` left
     - Skip that many characters
   - Compare the characters at the current positions
   - If they don't match, return false
   - If one string is exhausted but the other isn't, return false
3. If we've traversed both strings completely, return true

## Complexity

- **Time**: O(n + m) - where n and m are the lengths of the strings
- **Space**: O(1) - constant space for pointers and counters

## Solution Code

```go
package main

func backspaceCompare(s string, t string) bool {
    i, j := len(s)-1, len(t)-1
    
    for i >= 0 || j >= 0 {
        // Find next valid character in s
        skipS := 0
        for i >= 0 {
            if s[i] == '#' {
                skipS++
                i--
            } else if skipS > 0 {
                skipS--
                i--
            } else {
                break
            }
        }
        
        // Find next valid character in t
        skipT := 0
        for j >= 0 {
            if t[j] == '#' {
                skipT++
                j--
            } else if skipT > 0 {
                skipT--
                j--
            } else {
                break
            }
        }
        
        // Compare characters
        if i >= 0 && j >= 0 {
            if s[i] != t[j] {
                return false
            }
        } else if i >= 0 || j >= 0 {
            // One string is exhausted but the other isn't
            return false
        }
        
        i--
        j--
    }
    
    return true
}
```

## Alternative Approach (Stack)

An alternative approach is to simulate the typing process using stacks.

## Alternative Solution Code

```go
package main

func backspaceCompare(s string, t string) bool {
    return processString(s) == processString(t)
}

func processString(str string) string {
    stack := make([]byte, 0)
    
    for i := 0; i < len(str); i++ {
        if str[i] == '#' {
            if len(stack) > 0 {
                stack = stack[:len(stack)-1]
            }
        } else {
            stack = append(stack, str[i])
        }
    }
    
    return string(stack)
}
```

## Link

[LeetCode 0844 Backspace String Compare](https://leetcode.com/problems/backspace-string-compare/)