# 1750 Minimum Length of String After Deleting Similar Ends

## Problem Description

Given a string `s` consisting only of characters `'a'`, `'b'`, and `'c'`. You can apply the following operation any number of times:

Select a non-empty prefix of the string where all characters are the same and delete it.

Select a non-empty suffix of the string where all characters are the same and delete it.

Return the minimum possible length of `s` after performing the above operations any number of times.

### Example 1:
```
Input: s = "ca"
Output: 2
Explanation: You can't delete any characters, so the length remains 2.
```

### Example 2:
```
Input: s = "cabaabac"
Output: 0
Explanation: Delete prefix "c" and suffix "c" to get "abaabac".
Delete prefix "a" and suffix "c" to get "abaaba".
Delete prefix "a" and suffix "a" to get "abaab".
Delete prefix "a" and suffix "b" to get "abaa".
Delete prefix "a" and suffix "a" to get "ab".
Delete prefix "a" and suffix "b" to get "a".
Delete prefix "a" and suffix "a" to get "".
```

### Example 3:
```
Input: s = "aabccabba"
Output: 3
Explanation: Delete prefix "aa" and suffix "a" to get "bccabb".
Delete prefix "b" and suffix "b" to get "ccab".
Delete prefix "c" and suffix "c" to get "a".
```

## Approach

This problem can be solved using a two-pointer approach:

1. Use two pointers, one starting from the beginning (`left`) and one from the end (`right`) of the string.
2. Move `left` to the right as long as characters are the same as `s[0]`.
3. Move `right` to the left as long as characters are the same as `s[n-1]`.
4. If the characters at `left` and `right` are different, we can't delete any more characters, and the remaining length is `right - left + 1`.
5. If they're the same, we can delete the current prefix and suffix, and continue the process.

## Solution Code

```go
func minimumLength(s string) int {
    n := len(s)
    left, right := 0, n-1
    
    for left < right && s[left] == s[right] {
        currentChar := s[left]
        
        // Move left pointer as long as characters are the same
        for left <= right && s[left] == currentChar {
            left++
        }
        
        // Move right pointer as long as characters are the same
        for left <= right && s[right] == currentChar {
            right--
        }
    }
    
    return right - left + 1
}
```

## Complexity Analysis

- **Time**: O(n) - Each character is visited at most twice (once by each pointer)
- **Space**: O(1) - We only use a few pointers regardless of the input size

## Link

[LeetCode 1750 Minimum Length of String After Deleting Similar Ends](https://leetcode.com/problems/minimum-length-of-string-after-deleting-similar-ends/)