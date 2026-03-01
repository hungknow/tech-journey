# 2465 Number of Distinct Averages

## Problem Description

You are given an integer array `nums`. A pair of indices `(i, j)` is called a distinct pair if `i != j` and `nums[i] != nums[j]`.

The average of a pair `(i, j)` is `(nums[i] + nums[j]) / 2`.

Return the number of distinct averages of all distinct pairs in `nums`.

### Example 1:
```
Input: nums = [1,2,3,4,5]
Output: 2
Explanation: The distinct pairs are (1,5) and (2,4), with averages 3 and 3.
```

### Example 2:
```
Input: nums = [1,1,1,1,1]
Output: 0
Explanation: No distinct pairs exist.
```

## Approach

This problem can be solved using a two-pointer approach:

1. First, sort the array in ascending order.
2. Use two pointers, one starting from the beginning (`left`) and one from the end (`right`) of the array.
3. For each pair of elements pointed to by `left` and `right`:
   - If they are different, calculate their average and add it to a set.
   - Move the pointers inward.
4. The size of the set is the number of distinct averages.

## Solution Code

```go
func distinctAverages(nums []int) int {
    n := len(nums)
    if n < 2 {
        return 0
    }
    
    // Sort the array
    sort.Ints(nums)
    
    averages := make(map[float64]bool)
    left, right := 0, n-1
    
    for left < right {
        if nums[left] != nums[right] {
            avg := float64(nums[left]+nums[right]) / 2.0
            averages[avg] = true
        }
        left++
        right--
    }
    
    return len(averages)
}
```

## Complexity Analysis

- **Time**: O(n log n) - Sorting dominates the time complexity
- **Space**: O(n) - In the worst case, we store n/2 distinct averages

## Link

[LeetCode 2465 Number of Distinct Averages](https://leetcode.com/problems/number-of-distinct-averages/)