# 2234 Maximum Total Beauty of the Gardens

## Problem Description

You are given `n` gardens numbered from `0` to `n-1`. Each garden has a beauty value.

You want to plant `n` flowers in these gardens. The i-th flower will be planted in the i-th garden.

Each flower can be of any type. You have `m` types of flowers, numbered from `0` to `m-1`.

If you plant a flower of type `x` in garden `i`, the beauty of this garden becomes `beauty[i] + x`.

The total beauty is the sum of the beauty of all gardens.

Return the maximum possible total beauty.

### Example 1:
```
Input: beauty = [1,2,3,4,5], m = 3
Output: 15
Explanation: Plant flowers of type 2 in all gardens.
Total beauty = (1+2) + (2+2) + (3+2) + (4+2) + (5+2) = 15.
```

### Example 2:
```
Input: beauty = [10,10,10,10], m = 2
Output: 42
Explanation: Plant flowers of type 1 in all gardens.
Total beauty = (10+1) + (10+1) + (10+1) + (10+1) = 42.
```

## Approach

This problem can be solved using a greedy approach:

1. To maximize the total beauty, we should plant the flower with the highest type value (which is `m-1`) in all gardens.
2. The total beauty is simply the sum of all garden beauties plus `n * (m-1)`.

## Solution Code

```go
func maximumBeauty(beauty []int, m int) int64 {
    n := len(beauty)
    totalBeauty := int64(0)
    
    // Sum all garden beauties
    for _, b := range beauty {
        totalBeauty += int64(b)
    }
    
    // Add the maximum flower type value (m-1) for each garden
    totalBeauty += int64(n * (m - 1))
    
    return totalBeauty
}
```

## Complexity Analysis

- **Time**: O(n) - We traverse the array once to sum the beauties
- **Space**: O(1) - We only use a few variables regardless of the input size

## Link

[LeetCode 2234 Maximum Total Beauty of the Gardens](https://leetcode.com/problems/maximum-total-beauty-of-the-gardens/)