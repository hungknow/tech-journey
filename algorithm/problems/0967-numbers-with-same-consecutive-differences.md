# 0967 Numbers With Same Consecutive Differences

## Problem Description

Return all non-negative integers of length `n` such that the absolute difference between every two consecutive digits is `k`.

Note that every number in the answer must not have leading zeros. For example, `01` has one leading zero and is invalid.

### Example 1:
```
Input: n = 3, k = 7
Output: [181,292,707,818,929]
```

### Example 2:
```
Input: n = 2, k = 1
Output: [10,12,21,23,32,34,43,45,54,56,65,67,76,78,87,89,98]
```

## Approach

This problem can be solved using BFS to build numbers digit by digit:

1. **BFS Construction**:
   - Start with single-digit numbers (1-9) as the initial queue
   - For each number, generate next numbers by appending valid digits
   - A digit is valid if the absolute difference with the last digit is k

2. **Digit Generation**:
   - For each current number, find its last digit
   - Calculate possible next digits: lastDigit ± k
   - Append valid digits to form new numbers

3. **Result Collection**: When numbers reach length n, add them to the result

## Solution Code

```go
func numsSameConsecDiff(n int, k int) []int {
    if n == 1 {
        return []int{0, 1, 2, 3, 4, 5, 6, 7, 8, 9}
    }
    
    // BFS setup - start with single digit numbers (1-9)
    queue := []int{}
    for i := 1; i <= 9; i++ {
        queue = append(queue, i)
    }
    
    for level := 1; level < n; level++ {
        levelSize := len(queue)
        
        for i := 0; i < levelSize; i++ {
            current := queue[0]
            queue = queue[1:]
            
            lastDigit := current % 10
            
            // Generate next digits
            nextDigits := []int{}
            
            if k == 0 {
                nextDigits = append(nextDigits, lastDigit)
            } else {
                if lastDigit + k <= 9 {
                    nextDigits = append(nextDigits, lastDigit + k)
                }
                if lastDigit - k >= 0 {
                    nextDigits = append(nextDigits, lastDigit - k)
                }
            }
            
            // Create new numbers
            for _, nextDigit := range nextDigits {
                newNum := current * 10 + nextDigit
                queue = append(queue, newNum)
            }
        }
    }
    
    return queue
}
```

## Complexity Analysis

- **Time**: O(2^n) in the worst case
  - Each digit position can have up to 2 choices (lastDigit ± k)
  - There are O(2^n) possible numbers of length n
- **Space**: O(2^n) for the queue and result

## Link

[LeetCode 0967 Numbers With Same Consecutive Differences](https://leetcode.com/problems/numbers-with-same-consecutive-differences/)