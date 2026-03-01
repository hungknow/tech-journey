# 2024 Maximize the Confusion of an Exam

## Problem Description

A teacher is writing a test with `n` true/false questions, with 'T' representing true and 'F' representing false. He wants to confuse the students by maximizing the number of consecutive answers with the same value (either all 'T' or all 'F').

You are given a string `answerKey`, where `answerKey[i]` is the original answer to the i-th question. Additionally, you are given an integer `k`, the maximum number of times you may perform the following operation:

Change the answer key for any question to 'T' or 'F' (i.e., set `answerKey[i]` to 'T' or 'F').

Return the maximum number of consecutive 'T's or 'F's in the answer key after performing the operation at most `k` times.

### Example 1:
```
Input: answerKey = "TTFF", k = 2
Output: 4
Explanation: We can change both 'F's to 'T's to make the answer key "TTTT".
There are 4 consecutive 'T's.
```

### Example 2:
```
Input: answerKey = "TFFT", k = 1
Output: 3
Explanation: We can change the first 'T' to 'F' to make the answer key "FFFT".
There are 3 consecutive 'F's.
```

## Approach

This problem can be solved using a sliding window approach:

1. We need to find the maximum number of consecutive 'T's or 'F's after changing at most `k` characters.
2. Use a sliding window to maintain a subarray with at most `k` characters that need to be changed.
3. First, find the maximum window for 'T's (counting the number of 'F's in the window).
4. Then, find the maximum window for 'F's (counting the number of 'T's in the window).
5. The answer is the maximum of these two values.

## Solution Code

```go
func maxConsecutiveAnswers(answerKey string, k int) int {
    n := len(answerKey)
    
    // Helper function to find the maximum window with at most k different characters
    maxWindow := func(target byte) int {
        left := 0
        maxLen := 0
        diffCount := 0
        
        for right := 0; right < n; right++ {
            if answerKey[right] != target {
                diffCount++
            }
            
            // If we have more than k different characters, shrink the window
            for diffCount > k {
                if answerKey[left] != target {
                    diffCount--
                }
                left++
            }
            
            // Update the maximum window length
            if right-left+1 > maxLen {
                maxLen = right - left + 1
            }
        }
        
        return maxLen
    }
    
    // Find the maximum window for 'T' and 'F'
    return max(maxWindow('T'), maxWindow('F'))
}

func max(a, b int) int {
    if a > b {
        return a
    }
    return b
}
```

## Complexity Analysis

- **Time**: O(n) - We traverse the string twice, once for each target character
- **Space**: O(1) - We only use a few variables regardless of the input size

## Link

[LeetCode 2024 Maximize the Confusion of an Exam](https://leetcode.com/problems/maximize-the-confusion-of-an-exam/)