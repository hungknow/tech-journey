# 1215 Stepping Numbers

## Problem Description

A stepping number is an integer such that all of its adjacent digits have an absolute difference of 1.

Given two integers `low` and `high`, return all stepping numbers in the range `[low, high]` in sorted order.

### Example 1:
```
Input: low = 0, high = 21
Output: [0,1,2,3,4,5,6,7,8,9,10,12,21]
```

### Example 2:
```
Input: low = 10, high = 15
Output: [10,12]
```

## Approach

This problem can be solved using BFS to generate stepping numbers:

1. **BFS Generation**:
   - Start with single-digit numbers (0-9) as the initial queue
   - For each number, generate next stepping numbers by appending valid digits
   - A digit is valid if the absolute difference with the last digit is 1

2. **Digit Generation**:
   - For each current number, find its last digit
   - Calculate possible next digits: lastDigit ± 1
   - Append valid digits to form new stepping numbers

3. **Range Filtering**: Collect numbers within the specified range

## Solution Code

```go
func countSteppingNumbers(low int, high int) []int {
    result := []int{}
    
    // BFS setup - start with single digit numbers (0-9)
    queue := []int{}
    for i := 0; i <= 9; i++ {
        queue = append(queue, i)
    }
    
    for len(queue) > 0 {
        current := queue[0]
        queue = queue[1:]
        
        // Check if current is within range
        if current >= low && current <= high {
            result = append(result, current)
        }
        
        // If current is 0, skip (can't generate next numbers)
        if current == 0 {
            continue
        }
        
        // If current exceeds high, skip generating next numbers
        if current > high/10 {
            continue
        }
        
        lastDigit := current % 10
        
        // Generate next stepping numbers
        if lastDigit > 0 {
            nextNum := current * 10 + (lastDigit - 1)
            if nextNum <= high {
                queue = append(queue, nextNum)
            }
        }
        
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
  - Each number generates at most 2 next numbers
  - The number of stepping numbers up to high is logarithmic
- **Space**: O(log(high)) for the queue and result

## Link

[LeetCode 1215 Stepping Numbers](https://leetcode.com/problems/stepping-numbers/)