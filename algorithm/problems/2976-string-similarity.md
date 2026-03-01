# 2976 String Similarity

## Problem Description

You are given two strings `s1` and `s2`.

A string `s1` is similar to `s2` if they are equal after sorting both strings.

Return `true` if `s1` is similar to `s2`, otherwise return `false`.

### Example 1:
```
Input: s1 = "ab", s2 = "ba"
Output: true
Explanation: After sorting both strings, they become "ab" and "ba", which are equal.
```

### Example 2:
```
Input: s1 = "abc", s2 = "def"
Output: false
Explanation: After sorting both strings, they become "abc" and "def", which are not equal.
```

## Approach

This problem can be solved using sorting:

1. Convert both strings to byte slices.
2. Sort both slices.
3. Compare the sorted slices element by element.

## Solution Code

```go
func areSimilar(s1 string, s2 string) bool {
    // Convert strings to byte slices
    bytes1 := []byte(s1)
    bytes2 := []byte(s2)
    
    // Sort both slices
    sort.Slice(bytes1)
    sort.Slice(bytes2)
    
    // Compare the sorted slices
    if len(bytes1) != len(bytes2) {
        return false
    }
    
    for i := 0; i < len(bytes1); i++ {
        if bytes1[i] != bytes2[i] {
            return false
        }
    }
    
    return true
}
```

## Complexity Analysis

- **Time**: O(n log n) - Sorting dominates the time complexity
- **Space**: O(n) - We store the byte slices

## Link

[LeetCode 2976 String Similarity](https://leetcode.com/problems/string-similarity/)