# 0854 K-Similar Strings

## Problem Description

Strings `s1` and `s2` are k-similar if we can obtain `s2` from `s1` by swapping exactly `k` pairs of characters in `s1`.

Given two anagrams `s1` and `s2`, return the smallest `k` for which `s1` and `s2` are k-similar.

### Example 1:
```
Input: s1 = "ab", s2 = "ba"
Output: 1
```

### Example 2:
```
Input: s1 = "abc", s2 = "bca"
Output: 2
```

## Approach

This problem can be solved using BFS to find the minimum number of swaps:

1. **State Space**:
   - Each state is a string that can be obtained by swapping characters
   - From each state, we can generate next states by swapping mismatched characters

2. **BFS Traversal**:
   - Start BFS from `s1`
   - For each state, find the first position where it differs from `s2`
   - Generate next states by swapping the character at this position with any matching character

3. **Optimization**: Only swap characters that match the target character at the current position

## Solution Code

```go
func kSimilarity(s1 string, s2 string) int {
    if s1 == s2 {
        return 0
    }
    
    // BFS setup
    queue := []string{s1}
    visited := make(map[string]bool)
    visited[s1] = true
    swaps := 0
    
    for len(queue) > 0 {
        levelSize := len(queue)
        
        for i := 0; i < levelSize; i++ {
            current := queue[0]
            queue = queue[1:]
            
            // Check if we reached the target
            if current == s2 {
                return swaps
            }
            
            // Find first position where current differs from s2
            pos := 0
            for pos < len(current) && current[pos] == s2[pos] {
                pos++
            }
            
            // Generate next states by swapping
            for j := pos + 1; j < len(current); j++ {
                if current[j] == s2[pos] && current[j] != s2[j] {
                    // Swap characters at pos and j
                    next := []byte(current)
                    next[pos], next[j] = next[j], next[pos]
                    nextStr := string(next)
                    
                    if !visited[nextStr] {
                        visited[nextStr] = true
                        queue = append(queue, nextStr)
                    }
                }
            }
        }
        
        swaps++
    }
    
    return -1
}
```

## Complexity Analysis

- **Time**: O(n * n!) where n is the length of the strings
  - In the worst case, we might explore all possible permutations
  - Each state generation takes O(n) time
- **Space**: O(n * n!) for the visited set and queue

## Link

[LeetCode 0854 K-Similar Strings](https://leetcode.com/problems/k-similar-strings/)