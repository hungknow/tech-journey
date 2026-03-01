# 1521 Find a Value of a Mysterious Function Closest to Target

## Problem Description

Winston was given the following mysterious function:

```
func func(arr []int, l int, r int) int {
    result := arr[l]
    for i := l + 1; i <= r; i++ {
        result = result & arr[i]
    }
    return result
}
```

Winston is given an array `arr` and an integer `target`. He wants to find the value `func(arr, l, r)` that is closest to `target`. If there are multiple values that are equally close, return the smallest one.

Return the value closest to `target`.

### Example 1:
```
Input: arr = [9,12,3,7,15], target = 5
Output: 3
Explanation: All possible values are:
- func(arr, 0, 0) = 9
- func(arr, 0, 1) = 9 & 12 = 8
- func(arr, 0, 2) = 9 & 12 & 3 = 0
- func(arr, 0, 3) = 9 & 12 & 3 & 7 = 0
- func(arr, 0, 4) = 9 & 12 & 3 & 7 & 15 = 0
- func(arr, 1, 1) = 12
- func(arr, 1, 2) = 12 & 3 = 0
- func(arr, 1, 3) = 12 & 3 & 7 = 0
- func(arr, 1, 4) = 12 & 3 & 7 & 15 = 0
- func(arr, 2, 2) = 3
- func(arr, 2, 3) = 3 & 7 = 3
- func(arr, 2, 4) = 3 & 7 & 15 = 3
- func(arr, 3, 3) = 7
- func(arr, 3, 4) = 7 & 15 = 7
- func(arr, 4, 4) = 15

The value closest to 5 is 3.
```

### Example 2:
```
Input: arr = [1000000,1000000,1000000], target = 1
Output: 999999
Explanation: All possible values are 1000000 and 999999.
The value closest to 1 is 999999.
```

## Approach

This problem can be solved using a sliding window approach combined with the properties of the AND operation:

1. The AND operation is monotonic decreasing - as we include more elements in the AND operation, the result can only stay the same or decrease.
2. For each starting position, we can expand the window to the right and keep track of all possible AND results.
3. Use a set to avoid duplicate values for efficiency.
4. For each position, update the set of possible AND values by AND-ing with the current element.
5. Check each value against the target and keep track of the closest one.

## Solution Code

```go
func closestToTarget(arr []int, target int) int {
    n := len(arr)
    closest := arr[0]
    
    // Set to store all possible AND values ending at current position
    possibleValues := make(map[int]bool)
    
    for i := 0; i < n; i++ {
        // Create a new set for the current position
        newValues := make(map[int]bool)
        newValues[arr[i]] = true
        
        // AND with all previous possible values
        for val := range possibleValues {
            newValues[val&arr[i]] = true
        }
        
        // Update possible values
        possibleValues = newValues
        
        // Check each value against the target
        for val := range possibleValues {
            if abs(val-target) < abs(closest-target) || 
               (abs(val-target) == abs(closest-target) && val < closest) {
                closest = val
            }
        }
    }
    
    return closest
}

func abs(x int) int {
    if x < 0 {
        return -x
    }
    return x
}
```

## Complexity Analysis

- **Time**: O(n * log(max_value)) - For each position, we maintain at most log(max_value) distinct AND values
- **Space**: O(log(max_value)) - We store at most log(max_value) distinct AND values

## Link

[LeetCode 1521 Find a Value of a Mysterious Function Closest to Target](https://leetcode.com/problems/find-a-value-of-a-mysterious-function-closest-to-target/)