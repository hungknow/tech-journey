# 2107 Number of Unique Flavors After Sharing K Candies

## Problem Description

You have `n` candies with different flavors. The candies are arranged in a row and are labeled from `0` to `n-1` from left to right.

You want to share exactly `k` candies with your friend. You will give your friend the `k` consecutive candies starting from index `l` (0 <= l <= n-k).

Return the number of different flavors your friend and you will have after sharing the candies.

### Example 1:
```
Input: candies = [1,2,2,3,4,3], k = 3
Output: 3
Explanation: If you give your friend candies [2,2,3], you will have [1,4,3].
The unique flavors are [1,2,3,4], which is 4 flavors.
But if you give your friend candies [2,3,4], you will have [1,2,3].
The unique flavors are [1,2,3,4], which is 4 flavors.
The maximum number of unique flavors is 4.
```

### Example 2:
```
Input: candies = [2,2,2,2,3,3], k = 2
Output: 2
Explanation: No matter which 2 consecutive candies you give your friend, you will always have 2 unique flavors.
```

## Approach

This problem can be solved using a sliding window approach combined with a hash set:

1. First, count the frequency of each flavor in the entire array.
2. Use a sliding window of size `k` to simulate giving `k` consecutive candies to your friend.
3. For each window, calculate the number of unique flavors:
   - The flavors your friend has are the unique flavors in the window.
   - The flavors you have are the unique flavors not in the window.
4. Keep track of the maximum number of unique flavors.

## Solution Code

```go
func shareCandies(candies []int, k int) int {
    n := len(candies)
    
    // Count frequency of each flavor in the entire array
    totalFreq := make(map[int]int)
    for _, candy := range candies {
        totalFreq[candy]++
    }
    
    // Sliding window to simulate giving k consecutive candies
    windowFreq := make(map[int]int)
    maxUnique := 0
    
    // Initialize the first window
    for i := 0; i < k; i++ {
        windowFreq[candies[i]]++
    }
    
    // Calculate unique flavors for the first window
    uniqueFlavors := len(windowFreq)
    for flavor := range totalFreq {
        if windowFreq[flavor] == 0 {
            uniqueFlavors++
        }
    }
    maxUnique = uniqueFlavors
    
    // Slide the window
    for i := k; i < n; i++ {
        // Remove the leftmost candy from the window
        leftCandy := candies[i-k]
        windowFreq[leftCandy]--
        if windowFreq[leftCandy] == 0 {
            delete(windowFreq, leftCandy)
        }
        
        // Add the new candy to the window
        rightCandy := candies[i]
        windowFreq[rightCandy]++
        
        // Calculate unique flavors for the current window
        uniqueFlavors := len(windowFreq)
        for flavor := range totalFreq {
            if windowFreq[flavor] == 0 {
                uniqueFlavors++
            }
        }
        
        if uniqueFlavors > maxUnique {
            maxUnique = uniqueFlavors
        }
    }
    
    return maxUnique
}
```

## Complexity Analysis

- **Time**: O(n * m) - For each window position, we check all unique flavors, where m is the number of unique flavors
- **Space**: O(m) - We store the frequency of each flavor

## Link

[LeetCode 2107 Number of Unique Flavors After Sharing K Candies](https://leetcode.com/problems/number-of-unique-flavors-after-sharing-k-candies/)