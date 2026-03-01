# 1539 Kth Missing Positive Number

## Problem Description

Given an array `arr` of positive integers sorted in a strictly increasing order, and an integer `k`.

Return the `kth` positive integer that is missing from this array.

### Example 1:
```
Input: arr = [2,3,4,7,11], k = 5
Output: 9
Explanation: The missing positive integers are [1,5,6,8,9,10,12,13,...]. The 5th missing positive integer is 9.
```

### Example 2:
```
Input: arr = [1,2,3,4], k = 2
Output: 6
Explanation: The missing positive integers are [5,6,7,...]. The 2nd missing positive integer is 6.
```

## The Twist

Finding the **kth missing positive number** efficiently. This involves using binary search to locate the position where the kth missing number would be, by comparing the expected count of numbers with the actual count.

## Algorithm

### Binary Search Approach:
1. For any index `i` in the array, the number of missing positive integers before `arr[i]` is `arr[i] - (i + 1)`
2. Use binary search to find the smallest index `i` such that the number of missing numbers before `arr[i]` is at least `k`
3. If all elements have fewer than `k` missing numbers, the answer is `arr[len(arr)-1] + (k - missingCount)`
4. Otherwise, the answer is `arr[i-1] + (k - missingCountAtPrev)`

The key insight is that we can calculate how many numbers are missing before any position in the array, allowing us to use binary search to efficiently locate the kth missing number.

## Complexity

- **Time**: O(log n) - binary search operations
- **Space**: O(1) - constant space

## Solution Code

```go
package main

import "fmt"

func findKthPositive(arr []int, k int) int {
    left := 0
    right := len(arr) - 1
    
    // Binary search for the position where kth missing number would be
    for left <= right {
        mid := left + (right-left)/2
        
        // Calculate how many numbers are missing before arr[mid]
        missing := arr[mid] - (mid + 1)
        
        if missing < k {
            left = mid + 1
        } else {
            right = mid - 1
        }
    }
    
    // If all elements have fewer than k missing numbers
    if left == len(arr) {
        return arr[len(arr)-1] + (k - (arr[len(arr)-1] - len(arr)))
    }
    
    // Otherwise, the answer is between arr[right] and arr[left]
    if right >= 0 {
        return arr[right] + (k - (arr[right] - (right + 1)))
    }
    
    // If right is -1, all numbers from 1 to k are missing
    return k
}
```

## Link

[LeetCode 1539 Kth Missing Positive Number](https://leetcode.com/problems/kth-missing-positive-number/)