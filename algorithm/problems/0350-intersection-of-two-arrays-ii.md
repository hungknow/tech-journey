# 0350 Intersection of Two Arrays II

## Problem Description

Given two integer arrays `nums1` and `nums2`, return an array of their intersection. Each element in the result must appear as many times as it shows in both arrays and the result can be in any order.

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

### Example 3:
```
Input: nums1 = [1,2,2,1], nums2 = [1,1]
Output: [1,1,2,1]
```

## Two Pointers Approach with Frequency Map

This problem can be solved efficiently using a frequency map to track occurrences. We iterate through one array and count frequencies, then check the second array against these frequencies.

### Algorithm Steps:

1. Create a frequency map for elements in `nums1`
2. Initialize an empty result array
3. Count occurrences of each element in `nums1` and store in the frequency map
4. For each element in `nums2`:
   - If the element exists in the frequency map with a positive count:
     - Add it to the result as many times as the minimum count
     - Decrement the count in the frequency map
5. Return the result array

## Complexity

- **Time**: O(n + m) - we iterate through both arrays once
- **Space**: O(min(n, m)) - space for the frequency map and result

## Solution Code

```go
package main

func intersect(nums1 []int, nums2 []int) []int {
    // Create frequency map for nums1
    freq := make(map[int]int)
    for _, num := range nums1 {
        freq[num]++
    }
    
    result := make([]int, 0)
    
    // Check each element in nums2
    for _, num := range nums2 {
        if count, exists := freq[num]; exists && count > 0 {
            // Add the element to result as many times as it appears in nums2
            for i := 0; i < count; i++ {
                result = append(result, num)
            }
            // Decrement the count
            freq[num]--
        }
    }
    
    return result
}
```

## Alternative Approach (Sorting + Two Pointers)

An alternative approach is to sort both arrays and use two pointers to find common elements.

## Alternative Solution Code

```go
package main

func intersect(nums1 []int, nums2 []int) []int {
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
            // Skip duplicates in both arrays
            if i == 0 || nums1[i-1] != nums1[i] {
                result = append(result, nums1[i])
            }
            // Skip duplicates in nums2
            for j > 0 && nums2[j-1] == nums2[j] {
                j--
            }
            // Move both pointers
            i++
            j++
        }
    }
    
    return result
}
```

## Link

[LeetCode 0350 Intersection of Two Arrays II](https://leetcode.com/problems/intersection-of-two-arrays-ii/)