# 1509 Minimum Difference Between Largest and Smallest Value in Three Moves

## Problem Description

Given an integer array `nums`, you can perform at most three moves on the array. In each move, you can choose any element and change it to any value.

Return the minimum difference between the largest and smallest values of the array after performing at most three moves.

### Example 1:
```
Input: nums = [5,3,2,4]
Output: 0
Explanation: We can change the array to [2,2,2,2] in three moves.
```

### Example 2:
```
Input: nums = [1,5,0,10,14]
Output: 9
Explanation: Change the array to [1,5,5,5,14] in three moves.
```

## Solution Approach

To minimize the difference between the largest and smallest values after at most three moves, we should consider changing either the three largest elements, the three smallest elements, or a combination of both.

## Algorithm

1. If the array has 4 or fewer elements, we can make all elements equal, so return 0.
2. Sort the array.
3. Consider the following scenarios (after sorting):
   - Change the three largest elements to match the 4th largest: difference = nums[n-4] - nums[0]
   - Change the two largest and one smallest: difference = nums[n-3] - nums[1]
   - Change one largest and two smallest: difference = nums[n-2] - nums[2]
   - Change the three smallest elements to match the 4th smallest: difference = nums[n-1] - nums[3]
4. Return the minimum of these four differences.

## Why This Works

After sorting, the optimal strategy will always involve changing either the largest elements, the smallest elements, or a combination of both. By considering these four scenarios, we cover all possible optimal solutions.

## Complexity

- **Time**: O(n log n) - dominated by sorting
- **Space**: O(1) - we can sort in-place (or O(n) if using extra space for sorting)

## Link

[LeetCode 1509 Minimum Difference Between Largest and Smallest Value in Three Moves](https://leetcode.com/problems/minimum-difference-between-largest-and-smallest-value-in-three-moves/)