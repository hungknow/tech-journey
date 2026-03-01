# 0349 Intersection of Two Arrays

## Problem Description

Given two integer arrays `nums1` and `nums2`, return an array of their intersection. Each element in the result must be unique.

### Example 1:
```
Input: nums1 = [1,2,2,1], nums2 = [2,2]
Output: [2]
```

### Example 2:
```
Input: nums1 = [4,9,5], nums2 = [9,4,9,4,9,4]
Output: [4,9]
```

## Two Pointers Approach

This problem can be solved efficiently using the two-pointer technique after sorting both arrays. We use two pointers to traverse both arrays simultaneously.

### Algorithm Steps:

1. Sort both input arrays
2. Initialize two pointers `i = 0` and `j = 0`, and an empty result array
3. While both pointers are within their respective array bounds:
   - If `nums1[i] < nums2[j]`, increment `i`
   - If `nums1[i] > nums2[j]`, increment `j`
   - If `nums1[i] == nums2[j]`, add to result and increment both pointers
   - If `nums1[i] < nums2[j]`, increment `i` to catch up
4. Return the result array

## Complexity

- **Time**: O(m log m + n log m) - sorting takes O(n log n) and O(m log m)
- **Space**: O(min(n, m)) - space for the sorted arrays and result

## Solution Code

```go
package main

func intersection(nums1 []int, nums2 []int) []int {
    // Sort both arrays
    sort.Ints(nums1)
    sort.Ints(nums2)
    
    i, j := 0, 0
    result := make([]int, 0)
    
    for i < len(nums1) && j < len(nums2) {
        if nums1[i] < nums2[j] {
            i++
        } else if nums1[i] > nums2[j] {
            j++
        } else {
            // Found a common element
            // Skip duplicates in nums1
            if len(result) == 0 || result[len(result)-1] != nums1[i] {
                result = append(result, nums1[i])
            }
            // Move both pointers
            i++
            j++
        }
    }
    
    return result
}
```

## Alternative Approach (Using Hash Set)

An alternative approach is to use a hash set to store elements of one array and check for existence in the other array.

## Alternative Solution Code

```go
package main

func intersection(nums1 []int, nums2 []int) []int {
    // Create a hash set from nums1
    set1 := make(map[int]bool)
    for _, num := range nums1 {
        set1[num] = true
    }
    
    result := make([]int, 0)
    
    // Check each element in nums2 if it exists in set1
    for _, num := range nums2 {
        if set1[num] {
            result = append(result, num)
            // Remove from set to avoid duplicates in result
            delete(set1, num)
        }
    }
    
    return result
}
```

## Link

[LeetCode 0349 Intersection of Two Arrays](https://leetcode.com/problems/intersection-of-two-arrays/)