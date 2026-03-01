# 2841 Maximum Sum of Almost Unique Subarray

## Problem Description

You are given an integer array `nums` and an integer `k`.

A subarray is almost unique if at most one element appears more than once.

Return the maximum sum of an almost unique subarray of size `k`.

### Example 1:
```
Input: nums = [1,2,2,3,4,5], k = 3
Output: 9
Explanation: The subarray [2,3,4] is almost unique and has the maximum sum of 9.
```

### Example 2:
```
Input: nums = [1,2,2,3,3,3], k = 3
Output: 6
Explanation: The subarray [2,3,3] is almost unique and has the maximum sum of 8.
```

## Approach

This problem can be solved using a sliding window approach:

1. Use a sliding window of size `k` to maintain a subarray.
2. Use a hash map to count the frequency of each element in the current window.
3. Expand the window to the right, adding the current element to the map.
4. If the current element's count exceeds 1, shrink the window from the left until the count is at most 1.
5. For each valid window, calculate the sum of its elements.
6. Keep track of the maximum sum encountered for windows that are almost unique.

## Solution Code

```go
func maxSumAlmostUnique(nums []int, k int) int64 {
    n := len(nums)
    if n < k {
        return 0
    }
    
    left := 0
    maxSum := int64(0)
    
    // Initialize the first window
    freq := make(map[int]int)
    for i := 0; i < k; i++ {
        freq[nums[i]]++
    }
    
    // Calculate the sum for the first window
    currentSum := int64(0)
    for i := 0; i < k; i++ {
        currentSum += int64(nums[i])
    }
    maxSum = currentSum
    
    // Slide the window
    for right := k; right < n; right++ {
        // Remove the element leaving the window
        freq[nums[right-k]]--
        if freq[nums[right-k]] == 0 {
            delete(freq, nums[right-k])
        }
        
        // Add the new element
        freq[nums[right]]++
        if freq[nums[right]] > 1 {
            // Shrink from the left until the count is at most 1
            for freq[nums[left]] > 1 {
                freq[nums[left]]--
                if freq[nums[left]] == 0 {
                    delete(freq, nums[left])
                }
                left++
            }
        }
        
        // Calculate the sum for the current window
        currentSum := int64(0)
        for i := left; i <= right; i++ {
            currentSum += int64(nums[i])
        }
        
        // Update the maximum sum
        if currentSum > maxSum {
            maxSum = currentSum
        }
    }
    
    return maxSum
}
```

## Complexity Analysis

- **Time**: O(n * k) - For each window, we might check up to k elements
- **Space**: O(k) - We store the frequency of at most k elements in the current window

## Link

[LeetCode 2841 Maximum Sum of Almost Unique Subarray](https://leetcode.com/problems/maximum-sum-of-almost-unique-subarray/)