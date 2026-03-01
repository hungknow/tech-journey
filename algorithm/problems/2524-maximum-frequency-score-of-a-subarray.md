# 2524 Maximum Frequency Score of a Subarray

## Problem Description

You are given an integer array `nums` and an integer `k`. The frequency score of a subarray is defined as the sum of the frequencies of the elements in the subarray.

Return the maximum frequency score of any subarray of size `k`.

### Example 1:
```
Input: nums = [1,2,3,4,5], k = 3
Output: 3
Explanation: The subarray [1,2,3] has frequency score 1+1+1 = 3.
```

### Example 2:
```
Input: nums = [1,1,1,1,1], k = 2
Output: 2
Explanation: Any subarray of size 2 has frequency score 1+1 = 2.
```

## Approach

This problem can be solved using a sliding window approach:

1. Use a sliding window of size `k` to maintain a subarray.
2. Use a hash map to count the frequency of each element in the current window.
3. For each window, calculate the frequency score by summing the frequencies.
4. Keep track of the maximum frequency score encountered.

## Solution Code

```go
func maxFrequencyScore(nums []int, k int) int {
    n := len(nums)
    if n < k {
        return 0
    }
    
    freq := make(map[int]int)
    maxScore := 0
    
    // Initialize the first window
    for i := 0; i < k; i++ {
        freq[nums[i]]++
    }
    
    // Calculate the score for the first window
    score := 0
    for _, count := range freq {
        score += count
    }
    maxScore = score
    
    // Slide the window
    for i := k; i < n; i++ {
        // Remove the leftmost element
        freq[nums[i-k]]--
        
        // Add the new element
        freq[nums[i]]++
        
        // Calculate the score for the current window
        score := 0
        for _, count := range freq {
            score += count
        }
        
        if score > maxScore {
            maxScore = score
        }
    }
    
    return maxScore
}
```

## Complexity Analysis

- **Time**: O(n * m) - For each window, we sum frequencies of all unique elements, where m is the number of unique elements
- **Space**: O(m) - We store the frequency of each unique element in the current window

## Link

[LeetCode 2524 Maximum Frequency Score of a Subarray](https://leetcode.com/problems/maximum-frequency-score-of-a-subarray/)