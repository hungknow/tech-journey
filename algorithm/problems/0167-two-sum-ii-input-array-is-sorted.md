# 0167 Two Sum II - Input array is sorted

## Problem Description

Given a 1-indexed array of integers `numbers` that is already sorted in non-decreasing order, find two numbers such that they add up to a specific target number. Let these two numbers be `numbers[index1]` and `numbers[index2]` where `1 <= index1 < index2 <= numbers.length`.

Return the indices of the two numbers, `index1` and `index2`, added by one as an integer array `[index1, index2]` of length 2.

The tests are generated such that there is exactly one solution. You may not use the same element twice.

Your solution must use only constant extra space.

### Example 1:
```
Input: numbers = [2,7,11,15], target = 9
Output: [1,2]
Explanation: The sum of 2 and 7 is 9. Therefore, index1 = 1, index2 = 2. We return [1, 2].
```

### Example 2:
```
Input: numbers = [2,3,4], target = 6
Output: [1,3]
Explanation: The sum of 2 and 4 is 6. Therefore index1 = 1, index2 = 3. We return [1, 3].
```

### Example 3:
```
Input: numbers = [-1,0], target = -1
Output: [1,2]
Explanation: The sum of -1 and 0 is -1. Therefore index1 = 1, index2 = 2. We return [1, 2].
```

## Two Pointers Approach

Since the array is sorted, we can efficiently solve this problem using the two-pointer technique. We start with one pointer at the beginning and one at the end of the array.

### Algorithm Steps:

1. Initialize two pointers: `left = 0` and `right = len(numbers) - 1`
2. While `left < right`:
   - Calculate the sum of the elements at the two pointers
   - If the sum equals the target, return the indices (adjusted by +1 for 1-indexing)
   - If the sum is less than the target, increment the left pointer to increase the sum
   - If the sum is greater than the target, decrement the right pointer to decrease the sum
3. Since the problem guarantees exactly one solution, we will always find it

## Complexity

- **Time**: O(n) - we traverse the array at most once with two pointers
- **Space**: O(1) - constant space for the two pointers and result array

## Solution Code

```go
package main

func twoSum(numbers []int, target int) []int {
    left, right := 0, len(numbers)-1
    
    for left < right {
        sum := numbers[left] + numbers[right]
        
        if sum == target {
            // Return 1-indexed positions
            return []int{left + 1, right + 1}
        } else if sum < target {
            left++
        } else {
            right--
        }
    }
    
    // According to the problem statement, we should never reach here
    // as there is always exactly one solution
    return []int{}
}
```

## Alternative Approach (Binary Search)

An alternative approach is to fix one element and use binary search to find the complement. However, this would be O(n log n) time, which is less efficient than the two-pointer approach.

## Alternative Solution Code

```go
package main

func twoSum(numbers []int, target int) []int {
    for i := 0; i < len(numbers); i++ {
        complement := target - numbers[i]
        
        // Binary search for the complement in the remaining array
        left, right := i+1, len(numbers)-1
        for left <= right {
            mid := left + (right-left)/2
            if numbers[mid] == complement {
                return []int{i + 1, mid + 1}
            } else if numbers[mid] < complement {
                left = mid + 1
            } else {
                right = mid - 1
            }
        }
    }
    
    // According to the problem statement, we should never reach here
    return []int{}
}
```

## Link

[LeetCode 0167 Two Sum II - Input array is sorted](https://leetcode.com/problems/two-sum-ii-input-array-is-sorted/)