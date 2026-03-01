# 2779 Maximum Beauty of an Array After Applying Operation

## Problem Description

You are given an integer array `nums` and an integer `k`. You can apply the following operation any number of times:

Choose any element in the array and increase its value by 1.

Return the maximum possible beauty of the array after applying the operation exactly `k` times.

The beauty of an array is defined as the sum of the array elements.

### Example 1:
```
Input: nums = [4,3,1,2], k = 2
Output: 11
Explanation: Apply the operation to element at index 2 twice: [4,3,3,3]
The beauty is 4+3+3+3 = 13.
```

### Example 2:
```
Input: nums = [1,2,3,4,5], k = 3
Output: 15
Explanation: Apply the operation to element at index 2 three times: [1,2,4,5]
The beauty is 1+2+4+5 = 12.
```

## Approach

This problem can be solved using a greedy approach:

1. Since we want to maximize the sum of the array, we should always apply the operation to the largest element.
2. Find the maximum element in the array.
3. Apply the operation `k` times to this element.
4. Calculate the new sum of the array.

## Solution Code

```go
func maximumBeauty(nums []int, k int) int64 {
    n := len(nums)
    if n == 0 {
        return 0
    }
    
    // Find the maximum element
    maxIndex := 0
    for i := 1; i < n; i++ {
        if nums[i] > nums[maxIndex] {
            maxIndex = i
        }
    }
    
    // Apply the operation k times to the maximum element
    nums[maxIndex] += k
    
    // Calculate the sum of the array
    sum := int64(0)
    for _, num := range nums {
        sum += int64(num)
    }
    
    return sum
}
```

## Complexity Analysis

- **Time**: O(n) - We traverse the array twice (once to find the maximum, once to calculate the sum)
- **Space**: O(1) - We only use a few variables regardless of the input size

## Link

[LeetCode 2779 Maximum Beauty of an Array After Applying Operation](https://leetcode.com/problems/maximum-beauty-of-an-array-after-applying-operation/)