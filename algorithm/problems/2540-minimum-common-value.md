# 2540 Minimum Common Value

## Problem Description

You are given two integer arrays `nums1` and `nums2` sorted in non-decreasing order.

Return the minimum integer that appears in both arrays. If there is no common integer, return -1.

### Example 1:
```
Input: nums1 = [1,2,3], nums2 = [2,4]
Output: 2
Explanation: The minimum common value is 2.
```

### Example 2:
```
Input: nums1 = [1,3,5], nums2 = [2,4,6]
Output: -1
Explanation: There is no common value.
```

## Approach

This problem can be solved using a two-pointer approach:

1. Use two pointers, one for each array, starting at the beginning of both arrays.
2. Compare the elements at the current positions of the pointers:
   - If they are equal, we found a common value.
   - If the element in `nums1` is smaller, advance the pointer for `nums1`.
   - Otherwise, advance the pointer for `nums2`.
3. The first common value found is the minimum common value.

## Solution Code

```go
func getCommon(nums1 []int, nums2 []int) int {
    i, j := 0, 0
    n1, n2 := len(nums1), len(nums2)
    
    for i < n1 && j < n2 {
        if nums1[i] == nums2[j] {
            return nums1[i]
        } else if nums1[i] < nums2[j] {
            i++
        } else {
            j++
        }
    }
    
    return -1
}
```

## Complexity Analysis

- **Time**: O(n1 + n2) - We traverse both arrays at most once
- **Space**: O(1) - We only use a few pointers regardless of the input size

## Link

[LeetCode 2540 Minimum Common Value](https://leetcode.com/problems/minimum-common-value/)