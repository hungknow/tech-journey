# 2134 Minimum Swaps to Group All 1's Together II

## Problem Description

A swap is defined as taking two distinct positions in an array and swapping the values in them.

A circular array is defined as an array where we consider the first element and the last element to be adjacent.

Given a binary circular array `nums`, return the minimum number of swaps required to group all 1's present in the array together at any location.

### Example 1:
```
Input: nums = [0,1,0,1,1,0,0]
Output: 1
Explanation: There are 3 ones in the array. We can group them together by swapping the element at index 2 with the element at index 5.
```

### Example 2:
```
Input: nums = [0,1,1,1,0,0,1,1,0]
Output: 2
Explanation: There are 5 ones in the array. We can group them together by swapping the elements at indices 5 and 6.
```

### Example 3:
```
Input: nums = [1,1,0,0,1]
Output: 0
Explanation: All the 1's are already grouped together.
```

## Approach

This problem can be solved using a sliding window approach:

1. First, count the total number of 1's in the array. Let's call this `countOnes`.
2. If `countOnes` is 0 or 1, no swaps are needed, return 0.
3. Since the array is circular, we can concatenate the array with itself to handle the circular nature.
4. Use a sliding window of size `countOnes` to find the window with the maximum number of 1's.
5. The minimum number of swaps needed is `countOnes - maxOnesInWindow`, where `maxOnesInWindow` is the maximum number of 1's found in any window of size `countOnes`.

## Solution Code

```go
func minSwaps(nums []int) int {
    n := len(nums)
    
    // Count total number of 1's
    countOnes := 0
    for _, num := range nums {
        countOnes += num
    }
    
    // If there are 0 or 1 ones, no swaps needed
    if countOnes <= 1 {
        return 0
    }
    
    // Create a circular array by concatenating with itself
    circular := make([]int, 2*n)
    for i := 0; i < 2*n; i++ {
        circular[i] = nums[i%n]
    }
    
    // Initialize sliding window
    maxOnesInWindow := 0
    currentOnes := 0
    
    // Count 1's in the first window
    for i := 0; i < countOnes; i++ {
        currentOnes += circular[i]
    }
    maxOnesInWindow = currentOnes
    
    // Slide the window
    for i := countOnes; i < 2*n; i++ {
        // Update the window sum
        currentOnes += circular[i] - circular[i-countOnes]
        
        // Update the maximum number of 1's in a window
        if currentOnes > maxOnesInWindow {
            maxOnesInWindow = currentOnes
        }
    }
    
    // Minimum swaps needed is total ones minus maximum ones in any window
    return countOnes - maxOnesInWindow
}
```

## Complexity Analysis

- **Time**: O(n) - We traverse the array once with the sliding window
- **Space**: O(n) - We create a circular array of size 2n

## Link

[LeetCode 2134 Minimum Swaps to Group All 1's Together II](https://leetcode.com/problems/minimum-swaps-to-group-all-1s-together-ii/)