# 2040 Kth Smallest Product of Two Sorted Arrays

## Problem Description

Given two sorted integer arrays `nums1` and `nums2` and an integer `k`, return the k-th smallest product of `nums1[i] * nums2[j]` where `0 <= i < nums1.length` and `0 <= j < nums2.length`.

### Example 1:
```
Input: nums1 = [2,5], nums2 = [3,4], k = 2
Output: 8
Explanation: The products are [2*3=6, 2*4=8, 5*3=15, 5*4=20].
The 2nd smallest product is 8.
```

### Example 2:
```
Input: nums1 = [-4,-2,0,3], nums2 = [2,4], k = 6
Output: 0
Explanation: The products are [-8,-4,0,0,0,0,6,12].
The 6th smallest product is 0.
```

## Approach

This problem can be solved using binary search combined with a two-pointer approach:

1. First, understand that the products can be negative, zero, or positive.
2. Count how many products are less than or equal to a given value `mid`.
3. Use binary search to find the k-th smallest product.
4. For counting, we need to handle negative, zero, and positive cases separately.

## Solution Code

```go
func kthSmallestProduct(nums1 []int, nums2 []int, k int64) int64 {
    n1, n2 := len(nums1), len(nums2)
    
    // Helper function to count products <= target
    countProducts := func(target int64) int64 {
        count := int64(0)
        
        for i := 0; i < n1; i++ {
            num1 := nums1[i]
            
            if num1 == 0 {
                if target >= 0 {
                    count += int64(n2)
                }
            } else if num1 > 0 {
                // For positive num1, find the largest num2 such that num1 * num2 <= target
                maxNum2 := target / int64(num1)
                left, right := 0, n2-1
                pos := -1
                
                for left <= right {
                    mid := (left + right) / 2
                    if int64(nums2[mid]) <= maxNum2 {
                        pos = mid
                        left = mid + 1
                    } else {
                        right = mid - 1
                    }
                }
                
                count += int64(pos + 1)
            } else {
                // For negative num1, find the smallest num2 such that num1 * num2 <= target
                minNum2 := target / int64(num1)
                left, right := 0, n2-1
                pos := n2
                
                for left <= right {
                    mid := (left + right) / 2
                    if int64(nums2[mid]) >= minNum2 {
                        pos = mid
                        right = mid - 1
                    } else {
                        left = mid + 1
                    }
                }
                
                count += int64(n2 - pos)
            }
        }
        
        return count
    }
    
    // Binary search for the k-th smallest product
    left := int64(-1000000000) * 1000000000
    right := int64(1000000000) * 1000000000
    
    for left < right {
        mid := left + (right-left)/2
        
        if countProducts(mid) >= k {
            right = mid
        } else {
            left = mid + 1
        }
    }
    
    return left
}
```

## Complexity Analysis

- **Time**: O(n1 * log n2 * log(max_product)) - For each binary search step, we count products using binary search
- **Space**: O(1) - We only use a few variables regardless of the input size

## Link

[LeetCode 2040 Kth Smallest Product of Two Sorted Arrays](https://leetcode.com/problems/kth-smallest-product-of-two-sorted-arrays/)