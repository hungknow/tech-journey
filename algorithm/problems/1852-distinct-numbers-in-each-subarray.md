# 1852 Distinct Numbers in Each Subarray

## Problem Description

Given an integer array `nums` and an integer `k`, return the number of distinct numbers in each subarray of size `k`.

### Example 1:
```
Input: nums = [1,2,3,2,2,1,4,5], k = 3
Output: [3,2,3,2,3,3]
Explanation: The subarrays of size 3 are:
[1,2,3] -> 3 distinct numbers
[2,3,2] -> 2 distinct numbers
[3,2,2] -> 2 distinct numbers
[2,2,1] -> 2 distinct numbers
[2,1,4] -> 3 distinct numbers
[1,4,5] -> 3 distinct numbers
```

### Example 2:
```
Input: nums = [1,1,1,1,2,3,4,5,6], k = 5
Output: [1,2,3,4,5]
```

## Approach

This problem can be solved using a sliding window approach combined with a hash map to count frequencies:

1. Use a sliding window of size `k` to maintain the current subarray.
2. Use a hash map to count the frequency of each number in the current window.
3. For each position, add the number of distinct keys in the hash map to the result.
4. Slide the window one position at a time:
   - Decrement the count of the element leaving the window.
   - If the count becomes zero, remove it from the map.
   - Increment the count of the new element entering the window.

## Solution Code

```go
func distinctNumbers(nums []int, k int) []int {
    n := len(nums)
    if n < k {
        return []int{}
    }
    
    result := make([]int, 0, n-k+1)
    frequency := make(map[int]int)
    
    // Initialize the first window
    for i := 0; i < k; i++ {
        frequency[nums[i]]++
    }
    result = append(result, len(frequency))
    
    // Slide the window
    for i := k; i < n; i++ {
        // Remove the element leaving the window
        frequency[nums[i-k]]--
        if frequency[nums[i-k]] == 0 {
            delete(frequency, nums[i-k])
        }
        
        // Add the new element
        frequency[nums[i]]++
        
        // Add the number of distinct elements to the result
        result = append(result, len(frequency))
    }
    
    return result
}
```

## Complexity Analysis

- **Time**: O(n) - Each element is added to and removed from the hash map at most once
- **Space**: O(k) - The hash map stores at most `k` distinct elements

## Link

[LeetCode 1852 Distinct Numbers in Each Subarray](https://leetcode.com/problems/distinct-numbers-in-each-subarray/)