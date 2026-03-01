# 1248 Count Number of Nice Subarrays

## Problem Description

Given an array of integers `nums` and an integer `k`, a subarray is called nice if there are exactly `k` odd numbers in it.

Return the number of nice subarrays.

### Example 1:
```
Input: nums = [1,1,2,1,1], k = 3
Output: 2
Explanation: The only subarrays with 3 odd numbers are [1,1,2,1] and [1,2,1,1].
```

### Example 2:
```
Input: nums = [2,4,6], k = 1
Output: 0
Explanation: There is no odd number in the array.
```

### Example 3:
```
Input: nums = [2,2,2,1,2,2,1,2,2,2,1,2,2], k = 2
Output: 16
```

## Approach

This problem can be solved using a sliding window approach combined with counting the number of even numbers between odd numbers:

1. First, convert the array to a binary array where 1 represents an odd number and 0 represents an even number.
2. Find the positions of all 1's (odd numbers) in the array.
3. For each consecutive group of `k` odd numbers, calculate the number of subarrays that can be formed:
   - Count the number of 0's (even numbers) before the first odd number in the group.
   - Count the number of 0's (even numbers) after the last odd number in the group.
   - The number of subarrays for this group is `(leftZeros + 1) * (rightZeros + 1)`.

## Solution Code

```go
func numberOfSubarrays(nums []int, k int) int {
    // Convert to binary array (1 for odd, 0 for even)
    n := len(nums)
    oddIndices := []int{-1} // Add a sentinel at the beginning
    
    for i := 0; i < n; i++ {
        if nums[i]%2 == 1 {
            oddIndices = append(oddIndices, i)
        }
    }
    oddIndices = append(oddIndices, n) // Add a sentinel at the end
    
    count := 0
    m := len(oddIndices)
    
    // For each group of k consecutive odd numbers
    for i := 1; i + k < m; i++ {
        leftZeros := oddIndices[i] - oddIndices[i-1] - 1
        rightZeros := oddIndices[i+k] - oddIndices[i+k-1] - 1
        
        // Number of subarrays for this group
        count += (leftZeros + 1) * (rightZeros + 1)
    }
    
    return count
}
```

## Complexity Analysis

- **Time**: O(n) - We traverse the array once to find odd numbers
- **Space**: O(m) - We store the indices of odd numbers, where m is the number of odd numbers

## Link

[LeetCode 1248 Count Number of Nice Subarrays](https://leetcode.com/problems/count-number-of-nice-subarrays/)