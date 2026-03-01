# 2090 K Radius Subarray Averages

## Problem Description

You are given a 0-indexed integer array `nums` and an integer `k`.

For each index `i` (0 <= i < nums.length), we want to find the average of all elements in the subarray that starts at index `i-k` and ends at index `i+k` (inclusive). If there are less than `k` elements before or after the index `i`, then the average is -1.

Return an array `avgs` where `avgs[i]` is the average of the subarray centered at index `i`.

### Example 1:
```
Input: nums = [7,4,3,9,1,8,5,2,6], k = 3
Output: [-1,-1,-1,5,4,4,-1,-1,-1]
```

### Example 2:
```
Input: nums = [100000], k = 0
Output: [100000]
```

### Example 3:
```
Input: nums = [8], k = 100000
Output: [-1]
```

## Approach

This problem can be solved using a sliding window approach combined with prefix sums:

1. First, calculate the prefix sum array to efficiently compute the sum of any subarray.
2. For each index `i`, check if we have at least `k` elements on both sides.
3. If we do, calculate the average of the subarray from `i-k` to `i+k` using the prefix sums.
4. If not, set the average to -1.

## Solution Code

```go
func getAverages(nums []int, k int) []int {
    n := len(nums)
    result := make([]int, n)
    
    // Initialize all values to -1
    for i := 0; i < n; i++ {
        result[i] = -1
    }
    
    // If k is 0, each element is its own average
    if k == 0 {
        return nums
    }
    
    // Calculate prefix sums
    prefix := make([]int64, n+1)
    for i := 0; i < n; i++ {
        prefix[i+1] = prefix[i] + int64(nums[i])
    }
    
    // Calculate averages for valid positions
    for i := k; i < n-k; i++ {
        left := i - k
        right := i + k
        
        sum := prefix[right+1] - prefix[left]
        avg := sum / int64(2*k+1)
        result[i] = int(avg)
    }
    
    return result
}
```

## Complexity Analysis

- **Time**: O(n) - We traverse the array twice (once for prefix sums and once for averages)
- **Space**: O(n) - We store the prefix sums and the result array

## Link

[LeetCode 2090 K Radius Subarray Averages](https://leetcode.com/problems/k-radius-subarray-averages/)