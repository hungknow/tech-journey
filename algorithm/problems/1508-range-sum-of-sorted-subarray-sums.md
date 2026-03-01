# 1508 Range Sum of Sorted Subarray Sums

## Problem Description

Given the array `nums` consisting of `n` positive integers. You computed the sum of all non-empty continuous subarrays from the array and then sorted the sums in non-decreasing order, creating a new array of `n * (n + 1) / 2` numbers.

Return the sum of the numbers from index `left` to index `right` (indexed from 1) in the new array. Since the answer can be a huge number, return it modulo `10^9 + 7`.

### Example 1:
```
Input: nums = [1,2,3,4], n = 4, left = 1, right = 5
Output: 13
Explanation: All subarray sums are: [1,3,6,10,2,5,9,3,7,4].
Sorted in non-decreasing order: [1,2,3,3,4,5,6,7,9,10].
The sum from index 1 to 5 is 1 + 2 + 3 + 3 + 4 = 13.
```

### Example 2:
```
Input: nums = [1,2,3,4], n = 4, left = 3, right = 4
Output: 6
Explanation: The sorted subarray sums are [1,2,3,3,4,5,6,7,9,10].
The sum from index 3 to 4 is 3 + 3 = 6.
```

## Approach

This problem can be solved using a binary search approach combined with a sliding window:

1. First, understand that the subarray sums range from the minimum single element to the sum of all elements.
2. For a given value `x`, we can count how many subarray sums are less than or equal to `x` using a sliding window approach.
3. Use binary search to find the smallest value `x` such that at least `left` subarray sums are less than or equal to `x`.
4. Similarly, find the smallest value `y` such that at least `right` subarray sums are less than or equal to `y`.
5. Calculate the sum of all subarray sums less than `x` and the sum of all subarray sums less than or equal to `y`.
6. The final answer is the difference between these sums, adjusted for the exact range.

## Solution Code

```go
func rangeSum(nums []int, n int, left int, right int) int {
    const MOD = 1000000007
    
    // Helper function to count subarrays with sum <= x and their total sum
    countAndSum := func(x int) (int, int) {
        count := 0
        total := 0
        currentSum := 0
        left := 0
        
        for right := 0; right < n; right++ {
            currentSum += nums[right]
            
            for currentSum > x {
                currentSum -= nums[left]
                left++
            }
            
            count += right - left + 1
            total += currentSum * (right - left + 1)
        }
        
        return count, total
    }
    
    // Helper function to find the k-th smallest subarray sum
    findKth := func(k int) int {
        low := 0
        high := 0
        for _, num := range nums {
            high += num
        }
        
        for low < high {
            mid := (low + high) / 2
            count, _ := countAndSum(mid)
            
            if count < k {
                low = mid + 1
            } else {
                high = mid
            }
        }
        
        return low
    }
    
    // Find the left-th and right-th smallest subarray sums
    leftSum := findKth(left)
    rightSum := findKth(right)
    
    // Count subarrays with sum < leftSum and sum <= rightSum
    leftCount, leftTotal := countAndSum(leftSum - 1)
    rightCount, rightTotal := countAndSum(rightSum)
    
    // Adjust for the exact range
    result := (rightTotal - leftTotal) - (rightCount - leftCount) * leftSum
    
    return (result + MOD) % MOD
}
```

## Complexity Analysis

- **Time**: O(n log S), where S is the sum of all elements in the array
- **Space**: O(1) - We only use a few variables regardless of the input size

## Link

[LeetCode 1508 Range Sum of Sorted Subarray Sums](https://leetcode.com/problems/range-sum-of-sorted-subarray-sums/)