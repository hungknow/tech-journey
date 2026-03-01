# 2763 Sum of Imbalance Numbers of All Subarrays

## Problem Description

You are given an integer array `nums`. The imbalance number of a subarray is defined as the number of indices `i` in the subarray such that `nums[i]` is greater than all elements to its right.

Return the sum of the imbalance numbers of all subarrays.

### Example 1:
```
Input: nums = [2,4,1,3,5]
Output: 3
Explanation: The subarrays and their imbalance numbers are:
[2] -> 0
[4] -> 0
[1] -> 0
[3] -> 0
[5] -> 0
[2,4] -> 1 (2 is greater than 4)
[4,1] -> 1 (4 is greater than 1)
[1,3] -> 1 (1 is greater than 3)
[3,5] -> 1 (3 is greater than 5)
[2,4,1] -> 2 (2 and 4 are greater than 1)
[4,1,3] -> 2 (4 and 1 are greater than 3)
[1,3,5] -> 2 (1 and 3 are greater than 5)
[2,4,1,3] -> 3 (2, 4, and 1 are greater than 3)
Total imbalance numbers: 0+0+0+0+0+1+1+1+1+2+2+3 = 10
```

### Example 2:
```
Input: nums = [1,2,3]
Output: 0
Explanation: No element is greater than any other element in any subarray.
```

## Approach

This problem can be solved using a sliding window approach:

1. For each possible subarray, calculate its imbalance number.
2. Use a sliding window to efficiently calculate the imbalance number for each subarray.
3. Sum these values for all subarrays.

## Solution Code

```go
func sumImbalanceNumbers(nums []int) int64 {
    n := len(nums)
    result := int64(0)
    
    // For each possible subarray
    for i := 0; i < n; i++ {
        for j := i; j < n; j++ {
            imbalance := 0
            
            // Calculate imbalance number for subarray nums[i:j+1]
            for k := i; k <= j; k++ {
                isGreater := true
                for l := i; l <= j; l++ {
                    if l != k && nums[l] > nums[k] {
                        isGreater = false
                        break
                    }
                }
                
                if isGreater {
                    imbalance++
                }
            }
            
            result += int64(imbalance)
        }
    }
    
    return result
}
```

## Complexity Analysis

- **Time**: O(n^3) - For each subarray, we check all elements in it
- **Space**: O(1) - We only use a few variables regardless of the input size

## Link

[LeetCode 2763 Sum of Imbalance Numbers of All Subarrays](https://leetcode.com/problems/sum-of-imbalance-numbers-of-all-subarrays/)