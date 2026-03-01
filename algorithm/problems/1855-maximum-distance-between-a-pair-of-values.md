# 1855 Maximum Distance Between a Pair of Values

## Problem Description

You are given two non-increasing 0-indexed integer arrays `nums1` and `nums2`.

A pair of indices `(i, j)` is valid if there exists `i` and `j` such that:
- `i <= j`
- `nums1[i] <= nums2[j]`

The distance of the pair is `j - i`.

Return the maximum distance of any valid pair `(i, j)`. If there are no valid pairs, return `-1`.

### Example 1:
```
Input: nums1 = [55,30,5,4,3], nums2 = [100,20,10,10,5]
Output: 2
Explanation: The maximum valid pair is (0, 2), with distance 2.
```

### Example 2:
```
Input: nums1 = [2,2,2], nums2 = [10,10,1]
Output: 1
Explanation: The maximum valid pair is (1, 2), with distance 1.
```

### Example 3:
```
Input: nums1 = [30,29,19,5], nums2 = [25,25,25,25,25]
Output: 2
Explanation: The maximum valid pair is (2, 4), with distance 2.
```

## Two Pointers Approach

This problem can be efficiently solved using the two-pointer technique. Since both arrays are sorted in non-increasing order, we can use two pointers to find the maximum valid distance.

### Algorithm Steps:

1. Initialize two pointers: `i = 0` for `nums1` and `j = 0` for `nums2`
2. Initialize `maxDistance = -1`
3. While both pointers are within their respective array bounds:
   - If `nums1[i] <= nums2[j]`, we have a valid pair:
     - Update `maxDistance` with `j - i` if it's larger
     - Increment `j` to try to find a larger distance
   - Otherwise, increment `i` to find a smaller value in `nums1`
4. Return `maxDistance`

## Complexity

- **Time**: O(n + m) - where n and m are the lengths of the two arrays
- **Space**: O(1) - constant space for the two pointers and result

## Solution Code

```go
package main

func maxDistance(nums1 []int, nums2 []int) int {
    i, j := 0, 0
    maxDistance := -1
    
    for i < len(nums1) && j < len(nums2) {
        if nums1[i] <= nums2[j] {
            // Valid pair found
            if j-i > maxDistance {
                maxDistance = j - i
            }
            j++
        } else {
            // nums1[i] is too large, move to the next smaller element
            i++
        }
    }
    
    return maxDistance
}
```

## Alternative Approach (Binary Search)

An alternative approach is to iterate through `nums1` and for each element, use binary search in `nums2` to find the farthest valid index.

## Alternative Solution Code

```go
package main

func maxDistance(nums1 []int, nums2 []int) int {
    maxDistance := -1
    
    for i := 0; i < len(nums1); i++ {
        // Binary search in nums2 for the farthest j >= i with nums2[j] >= nums1[i]
        left, right := i, len(nums2)-1
        validJ := -1
        
        for left <= right {
            mid := left + (right-left)/2
            if nums2[mid] >= nums1[i] {
                validJ = mid
                left = mid + 1
            } else {
                right = mid - 1
            }
        }
        
        if validJ != -1 {
            if validJ-i > maxDistance {
                maxDistance = validJ - i
            }
        }
    }
    
    return maxDistance
}
```

## Link

[LeetCode 1855 Maximum Distance Between a Pair of Values](https://leetcode.com/problems/maximum-distance-between-a-pair-of-values/)