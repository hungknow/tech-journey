# 1291 Sequential Digits

## Problem Description

An integer has sequential digits if and only if each digit in the number is one more than the previous digit.

Return a sorted list of all the integers in the range `[low, high]` that have sequential digits.

### Example 1:
```
Input: low = 100, high = 300
Output: [123,234]
```

### Example 2:
```
Input: low = 1000, high = 13000
Output: [1234,2345,3456,4567,5678,6789,12345]
```

## Approach

This problem can be solved using BFS to generate sequential digit numbers:

1. **BFS Generation**:
   - Start with single-digit numbers (1-9) as the initial queue
   - For each number, generate next sequential numbers by appending the next digit
   - A digit is valid if it's exactly one more than the last digit

2. **Digit Generation**:
   - For each current number, find its last digit
   - Calculate the next digit: lastDigit + 1
   - Append the next digit if it's ≤ 9

3. **Range Filtering**: Collect numbers within the specified range

## Solution Code

```go
func sequentialDigits(low int, high int) []int {
    result := []int{}
    
    // BFS setup - start with single digit numbers (1-9)
    queue := []int{}
    for i := 1; i <= 9; i++ {
        queue = append(queue, i)
    }
    
    for len(queue) > 0 {
        current := queue[0]
        queue = queue[1:]
        
        // Check if current is within range
        if current >= low && current <= high {
            result = append(result, current)
        }
        
        // Generate next sequential number
        lastDigit := current % 10
        if lastDigit < 9 {
            nextNum := current * 10 + (lastDigit + 1)
            if nextNum <= high {
                queue = append(queue, nextNum)
            }
        }
    }
    
    return result
}
```

## Complexity Analysis

- **Time**: O(log(high)) approximately
  - Each number generates at most 1 next number
  - The number of sequential digit numbers up to high is logarithmic
- **Space**: O(log(high)) for the queue and result

## Link

[LeetCode 1291 Sequential Digits](https://leetcode.com/problems/sequential-digits/)