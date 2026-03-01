# 1658 Minimum Operations to Reduce X to Zero

## Problem Description

You are given an integer array `nums` and an integer `x`. In one operation, you can either remove the leftmost or the rightmost element from the array and subtract its value from `x`. Note that modifying the array will change the values of the elements for future operations.

Return the minimum number of operations to reduce `x` to exactly `0` if it is possible, otherwise return `-1`.

### Example 1:
```
Input: nums = [1,1,4,2,3], x = 5
Output: 2
Explanation: The optimal solution is to remove the rightmost element twice.
```

### Example 2:
```
Input: nums = [5,6,7,8,9], x = 4
Output: -1
```

### Example 3:
```
Input: nums = [3,2,20,1,1,3], x = 10
Output: 5
Explanation: The optimal solution is to remove the leftmost element twice and the rightmost element three times.
```

## Two Pointers Approach (Sliding Window)

This problem can be efficiently solved by transforming it into finding the longest subarray with sum equal to `total_sum - x`. We use a sliding window approach with two pointers.

### Algorithm Steps:

1. Calculate the total sum of the array
2. If `total_sum == x`, return `len(nums)` (we need to remove all elements)
3. If `total_sum < x`, return `-1` (not possible)
4. Initialize two pointers `left = 0` and `right = 0`, and a variable `current_sum = 0`
5. Initialize `max_length = -1` to track the longest subarray with sum `total_sum - x`
6. Slide the window:
   - Add `nums[right]` to `current_sum`
   - While `current_sum > total_sum - x`, remove `nums[left]` from `current_sum` and increment `left`
   - If `current_sum == total_sum - x`, update `max_length`
   - Increment `right`
7. If `max_length == -1`, return `-1`
8. Otherwise, return `len(nums) - max_length`

## Complexity

- **Time**: O(n) - we traverse the array once with two pointers
- **Space**: O(1) - constant space for pointers and variables

## Solution Code

```go
package main

func minOperations(nums []int, x int) int {
    totalSum := 0
    for _, num := range nums {
        totalSum += num
    }
    
    // If we need to remove all elements
    if totalSum == x {
        return len(nums)
    }
    
    // If it's impossible
    if totalSum < x {
        return -1
    }
    
    target := totalSum - x
    left := 0
    currentSum := 0
    maxLength := -1
    
    for right := 0; right < len(nums); right++ {
        currentSum += nums[right]
        
        // Shrink the window if sum exceeds target
        for left <= right && currentSum > target {
            currentSum -= nums[left]
            left++
        }
        
        // Check if we found the target sum
        if currentSum == target {
            if right-left+1 > maxLength {
                maxLength = right - left + 1
            }
        }
    }
    
    if maxLength == -1 {
        return -1
    }
    
    return len(nums) - maxLength
}
```

## Alternative Approach (Prefix Sum + Hash Map)

An alternative approach is to use a prefix sum with a hash map to find the longest subarray with sum equal to `total_sum - x`.

## Alternative Solution Code

```go
package main

func minOperations(nums []int, x int) int {
    totalSum := 0
    for _, num := range nums {
        totalSum += num
    }
    
    // If we need to remove all elements
    if totalSum == x {
        return len(nums)
    }
    
    // If it's impossible
    if totalSum < x {
        return -1
    }
    
    target := totalSum - x
    prefixSum := 0
    maxLength := -1
    prefixMap := make(map[int]int)
    prefixMap[0] = -1  // Initialize for subarrays starting from index 0
    
    for i, num := range nums {
        prefixSum += num
        
        // Check if we've seen prefixSum - target before
        if val, exists := prefixMap[prefixSum-target]; exists {
            if i-val > maxLength {
                maxLength = i - val
            }
        }
        
        // Store the current prefix sum
        prefixMap[prefixSum] = i
    }
    
    if maxLength == -1 {
        return -1
    }
    
    return len(nums) - maxLength
}
```

## Link

[LeetCode 1658 Minimum Operations to Reduce X to Zero](https://leetcode.com/problems/minimum-operations-to-reduce-x-to-zero/)