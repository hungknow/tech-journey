# 1423 Maximum Points You Can Obtain from Cards

## Problem Description

There are `n` cards lined up in a row, and each card has an associated number of points. The points are given in the integer array `cardPoints`.

In one step, you can take one card from the beginning or from the end of the row. You have to take exactly `k` cards.

Your score is the sum of the points of the cards you have taken.

Return the maximum score you can obtain.

### Example 1:
```
Input: cardPoints = [1,2,3,4,5,6,1], k = 3
Output: 12
Explanation: After the first step, your score will always be 1. However, choosing the rightmost card first will maximize your score. The optimal strategy is to take the three cards from the end, giving a final score of 1 + 6 + 5 = 12.
```

### Example 2:
```
Input: cardPoints = [2,2,2], k = 2
Output: 4
Explanation: Regardless of which two cards you take, your score will always be 4.
```

### Example 3:
```
Input: cardPoints = [9,7,7,9,7,7,9], k = 7
Output: 55
Explanation: You have to take all the cards, and your score is the sum of all the points.
```

## Approach

This problem can be solved using a sliding window approach:

1. Instead of directly selecting `k` cards from the ends, think of it as selecting `n-k` cards to leave in the middle.
2. Find the minimum sum of any subarray of length `n-k`.
3. The maximum score will be the total sum of all cards minus this minimum subarray sum.

## Solution Code

```go
func maxScore(cardPoints []int, k int) int {
    n := len(cardPoints)
    totalSum := 0
    
    // Calculate total sum of all cards
    for _, points := range cardPoints {
        totalSum += points
    }
    
    // If we need to take all cards
    if k >= n {
        return totalSum
    }
    
    // Find the minimum sum of a subarray of length n-k
    windowSize := n - k
    currentSum := 0
    
    // Calculate sum of first window
    for i := 0; i < windowSize; i++ {
        currentSum += cardPoints[i]
    }
    
    minSum := currentSum
    
    // Slide the window
    for i := windowSize; i < n; i++ {
        currentSum += cardPoints[i] - cardPoints[i-windowSize]
        minSum = min(minSum, currentSum)
    }
    
    return totalSum - minSum
}

func min(a, b int) int {
    if a < b {
        return a
    }
    return b
}
```

## Complexity Analysis

- **Time**: O(n) - We traverse the array once to calculate the total sum and once more with the sliding window
- **Space**: O(1) - We only use a few variables regardless of the input size

## Link

[LeetCode 1423 Maximum Points You Can Obtain from Cards](https://leetcode.com/problems/maximum-points-you-can-obtain-from-cards/)