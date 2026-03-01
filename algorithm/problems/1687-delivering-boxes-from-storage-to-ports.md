# 1687 Delivering Boxes from Storage to Ports

## Problem Description

You are given `boxes`, an array of size `n`, where `boxes[i] = [port_i, box_i]`. Each box has a port number `port_i` and a weight `box_i`.

You need to deliver all boxes in order from the storage to the port. The delivery rules are:

1. You can deliver boxes in any order, but you must deliver them in the same order as they appear in `boxes`.
2. For each delivery, you can deliver one or more consecutive boxes.
3. For each delivery, you must go to the storage, pick up the boxes, and deliver them to the port.
4. The cost of a delivery is the number of boxes delivered plus the number of trips between the storage and the port.

Return the minimum cost to deliver all boxes.

### Example 1:
```
Input: boxes = [[1,4],[1,2],[2,1],[2,2],[3,1]]
Output: 7
Explanation: 
- Deliver boxes [1,4] and [1,2] to port 1 (cost = 2 + 1 = 3)
- Deliver boxes [2,1] and [2,2] to port 2 (cost = 2 + 1 = 3)
- Deliver box [3,1] to port 3 (cost = 1 + 1 = 2)
Total cost = 3 + 3 + 2 = 8
But we can do better by delivering [1,4], [1,2], and [2,1] together (cost = 3 + 1 = 4)
and [2,2] and [3,1] together (cost = 2 + 1 = 3), for a total of 7.
```

### Example 2:
```
Input: boxes = [[1,1],[2,2],[3,3],[4,4],[5,5]]
Output: 10
Explanation: Deliver each box separately (cost = 1 + 1 = 2 for each box, total = 10).
```

## Approach

This problem can be solved using dynamic programming combined with a sliding window:

1. Let `dp[i]` be the minimum cost to deliver the first `i` boxes.
2. For each position `i`, consider all possible previous positions `j` where we could start a new delivery.
3. Use a sliding window to efficiently calculate the cost of delivering boxes from `j+1` to `i`.
4. The transition is: `dp[i] = min(dp[j] + cost(j+1, i))` for all `j < i`.

## Solution Code

```go
func boxDelivering(boxes [][]int, portsCount int, maxBoxes int, maxWeight int) int {
    n := len(boxes)
    dp := make([]int, n+1)
    dp[0] = 0
    
    // Prefix sums for weights
    weightPrefix := make([]int, n+1)
    for i := 0; i < n; i++ {
        weightPrefix[i+1] = weightPrefix[i] + boxes[i][1]
    }
    
    for i := 1; i <= n; i++ {
        dp[i] = 1 << 30 // Initialize with a large value
        
        left := i - 1
        currentWeight := 0
        currentTrips := 2 // At least one trip to port and one back
        
        // Try all possible starting positions for the last delivery
        for j := i - 1; j >= 0; j-- {
            currentWeight += boxes[j][1]
            
            // Check constraints
            if i-j > maxBoxes || currentWeight > maxWeight {
                break
            }
            
            // Update trips count
            if j > 0 && boxes[j][0] != boxes[j-1][0] {
                currentTrips++
            }
            
            // Update dp[i]
            dp[i] = min(dp[i], dp[j]+currentTrips)
        }
    }
    
    return dp[n]
}

func min(a, b int) int {
    if a < b {
        return a
    }
    return b
}
```

## Complexity Analysis

- **Time**: O(n^2) - For each position, we consider all possible previous positions
- **Space**: O(n) - We store the dp array and prefix sums

## Link

[LeetCode 1687 Delivering Boxes from Storage to Ports](https://leetcode.com/problems/delivering-boxes-from-storage-to-ports/)