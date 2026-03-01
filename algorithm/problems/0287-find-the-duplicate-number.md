# 0287 Find the Duplicate Number

## Problem Description

Given an array of integers `nums` containing `n + 1` integers where each integer is in the range `[1, n]` inclusive.

There is only one repeated number in `nums`, return this repeated number.

You must solve the problem without modifying the array `nums` and uses only constant extra space.

### Example 1:
```
Input: nums = [1,3,4,2,2]
Output: 2
```

### Example 2:
```
Input: nums = [3,1,3,4,2]
Output: 3
```

## Approach

This problem can be solved using Floyd's Tortoise and Hare algorithm, which is typically used for cycle detection in linked lists. Here's how we can apply it to this problem:

1. Treat the array as a linked list where the value at each index points to another index.
2. Use two pointers, slow and fast. The slow pointer moves one step at a time, while the fast pointer moves two steps.
3. If there's a duplicate, these pointers will eventually meet inside the cycle.
4. Once they meet, reset one pointer to the beginning and move both at the same speed until they meet again. The meeting point will be the duplicate number.

## Solution Code

```go
func findDuplicate(nums []int) int {
    // Phase 1: Find the intersection point of the two runners.
    slow, fast := nums[0], nums[0]
    
    for {
        slow = nums[slow]
        fast = nums[nums[fast]]
        
        if slow == fast {
            break
        }
    }
    
    // Phase 2: Find the "entrance" to the cycle.
    slow = nums[0]
    for slow != fast {
        slow = nums[slow]
        fast = nums[fast]
    }
    
    return slow
}
```

## Complexity Analysis

- **Time**: O(n) - We traverse the array a constant number of times
- **Space**: O(1) - We only use a few pointers regardless of the input size

## Link

[LeetCode 0287 Find the Duplicate Number](https://leetcode.com/problems/find-the-duplicate-number/)