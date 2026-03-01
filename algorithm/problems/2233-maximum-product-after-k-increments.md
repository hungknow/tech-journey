# 2233 Maximum Product After K Increments

## Problem Description

You are given an array of positive integers `nums` and an integer `k`. In each operation, you can choose any element of the array and increase it by 1.

Return the maximum possible product of the array after exactly `k` operations. Since the answer may be large, return it modulo 10^9 + 7.

### Example 1:
```
Input: nums = [0,4], k = 5
Output: 20
Explanation: 
Increment the first element 5 times: [5,4]
Product = 5 * 4 = 20
```

### Example 2:
```
Input: nums = [6,3,3,2], k = 2
Output: 216
Explanation: 
Increment the second element twice: [6,5,3,2]
Product = 6 * 5 * 3 * 2 = 180
Actually, a better approach is:
Increment the third element twice: [6,3,5,2]
Product = 6 * 3 * 5 * 2 = 180
Wait, let me recalculate...
Increment the second and third elements once each: [6,4,4,2]
Product = 6 * 4 * 4 * 2 = 192
```

## Solution Approach

To maximize the product after k increments, we should always increment the smallest element. This is because increasing a smaller number has a greater impact on the product than increasing a larger number.

## Algorithm

1. Use a min-heap to efficiently track the smallest element
2. For k times:
   - Extract the smallest element from the heap
   - Increment it by 1
   - Push it back into the heap
3. Calculate the product of all elements in the heap
4. Return the product modulo 10^9 + 7

## Why This Works

By always incrementing the smallest element, we ensure that each increment has the maximum possible impact on the product. This greedy approach is optimal because the product is maximized when the numbers are as balanced as possible.

## Complexity

- **Time**: O((n + k) log n) - heap operations
- **Space**: O(n) - for the heap

## Link

[LeetCode 2233 Maximum Product After K Increments](https://leetcode.com/problems/maximum-product-after-k-increments/)