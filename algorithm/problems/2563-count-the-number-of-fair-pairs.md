# 2563 Count the Number of Fair Pairs

## Problem Description

You are given an integer array `nums` and an integer `k`.

A pair `(i, j)` is fair if:
- `0 <= i < j < len(nums)`
- `|nums[i] - nums[j]| <= k`

Return the number of fair pairs.

### Example 1:
```
Input: nums = [0,1,2,3,4], k = 1
Output: 5
Explanation: The fair pairs are (0,1), (1,2), (2,3), (3,4), (4,5).
```

### Example 2:
```
Input: nums = [1,3,5,7], k = 2
Output: 3
Explanation: The fair pairs are (1,3), (3,5), (5,7).
```

## Approach

This problem can be solved using a two-pointer approach combined with sorting:

1. Sort the array in ascending order.
2. Use two pointers, one starting from the beginning (`left`) and one from the end (`right`) of the sorted array.
3. For each pair of elements pointed to by `left` and `right`:
   - If the difference is within `k`, count this pair and move both pointers inward.
   - If the difference is too large, move the pointer pointing to the smaller element inward.
4. Continue until the pointers meet.

## Solution Code

```go
func countFairPairs(nums []int, k int) int64 {
    n := len(nums)
    if n < 2 {
        return 0
    }
    
    // Sort the array
    sort.Ints(nums)
    
    left, right := 0, n-1
    result := int64(0)
    
    for left < right {
        diff := nums[right] - nums[left]
        
        if diff <= k {
            // All pairs between left and right are fair
            count := right - left
            result += int64(count)
            
            // Move both pointers inward
            left++
            right--
        } else {
            // Move the pointer pointing to the smaller element
            if nums[left] < nums[right] {
                left++
            } else {
                right--
            }
        }
    }
    
    return result
}
```

## Complexity Analysis

- **Time**: O(n log n) - Sorting dominates the time complexity
- **Space**: O(1) - We only use a few pointers regardless of the input size

## Link

[LeetCode 2563 Count the Number of Fair Pairs](https://leetcode.com/problems/count-the-number-of-fair-pairs/)