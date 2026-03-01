# 2570 Merge Two 2D Arrays by Summing Values

## Problem Description

You are given two 2D integer arrays `nums1` and `nums2`. Each array contains unique values and is sorted by the first column.

For each value `v` that appears in both arrays, the merged array should contain the sum of the counts of `v` in both arrays.

Return the merged array sorted by the first column.

### Example 1:
```
Input: nums1 = [[1,2],[3,4]], nums2 = [[1,4],[5,6]]
Output: [[1,6],[3,4],[5,6]]
Explanation: The value 1 appears once in nums1 and once in nums2, so its count is 2.
The value 3 appears once in nums1 and 0 times in nums2, so its count is 1.
The value 4 appears once in nums1 and once in nums2, so its count is 2.
The value 5 appears 0 times in nums1 and once in nums2, so its count is 1.
The value 6 appears 0 times in nums1 and once in nums2, so its count is 1.
```

### Example 2:
```
Input: nums1 = [[2,4],[3,5]], nums2 = [[1,2],[3,4]]
Output: [[1,2],[2,4],[3,5]]
Explanation: The value 2 appears once in nums1 and once in nums2, so its count is 2.
The value 3 appears once in nums1 and once in nums2, so its count is 2.
The value 4 appears once in nums1 and once in nums2, so its count is 2.
The value 5 appears once in nums1 and 0 times in nums2, so its count is 1.
```

## Approach

This problem can be solved using a two-pointer approach:

1. Use two pointers to traverse both arrays simultaneously.
2. For each pair of elements pointed to by the pointers:
   - If the values are equal, add their counts and advance both pointers.
   - If the value in `nums1` is smaller, advance the pointer for `nums1`.
   - Otherwise, advance the pointer for `nums2`.
3. For each value that appears in both arrays, add a row with the value and the sum of counts.

## Solution Code

```go
func mergeArrays(nums1 [][]int, nums2 [][]int) [][]int {
    i, j := 0, 0
    n1, n2 := len(nums1), len(nums2)
    var result [][]int
    
    for i < n1 && j < n2 {
        val1, count1 := nums1[i][0], nums1[i][1]
        val2, count2 := nums2[j][0], nums2[j][1]
        
        if val1 == val2 {
            result = append(result, []int{val1, count1 + count2})
            i++
            j++
        } else if val1 < val2 {
            i++
        } else {
            j++
        }
    }
    
    return result
}
```

## Complexity Analysis

- **Time**: O(n1 + n2) - We traverse both arrays at most once
- **Space**: O(min(n1, n2)) - We store the merged array

## Link

[LeetCode 2570 Merge Two 2D Arrays by Summing Values](https://leetcode.com/problems/merge-two-2d-arrays-by-summing-values/)