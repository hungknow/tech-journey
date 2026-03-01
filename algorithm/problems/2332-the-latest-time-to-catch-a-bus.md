# 2332 The Latest Time to Catch a Bus

## Problem Description

You are given a 0-indexed integer array `buses` where `buses[i] = [departureTime_i, arrivalTime_i]` represents the departure and arrival times of the i-th bus.

You are also given an integer `passengerTime`, the time you arrive at the bus station.

Return the latest time you can arrive at the bus station to catch a bus. If you cannot catch any bus, return -1.

### Example 1:
```
Input: buses = [[10,20],[30,40]], passengerTime = 25
Output: 25
Explanation: You can catch the second bus at time 30.
```

### Example 2:
```
Input: buses = [[20,30],[10,10]], passengerTime = 20
Output: 20
Explanation: You can catch the first bus at time 20.
```

## Approach

This problem can be solved using a two-pointer approach:

1. Sort the buses by departure time.
2. Use binary search to find the first bus with departure time greater than or equal to `passengerTime`.
3. If such a bus exists, return `passengerTime` (you can arrive exactly at that time).
4. If no such bus exists, check if you can catch the last bus by arriving at its departure time.

## Solution Code

```go
func latestTimeCatchTheBus(buses [][]int, passengerTime int) int {
    // Sort buses by departure time
    sort.Slice(buses, func(i, j int) bool {
        return buses[i][0] < buses[j][0]
    })
    
    n := len(buses)
    
    // Binary search for the first bus with departure time >= passengerTime
    left, right := 0, n
    for left < right {
        mid := (left + right) / 2
        if buses[mid][0] < passengerTime {
            left = mid + 1
        } else {
            right = mid
        }
    }
    
    // If we found a bus with departure time >= passengerTime
    if left < n {
        return passengerTime
    }
    
    // Check if we can catch the last bus
    if n > 0 && buses[n-1][0] >= passengerTime {
        return buses[n-1][0]
    }
    
    return -1
}
```

## Complexity Analysis

- **Time**: O(n log n) - Sorting dominates the time complexity
- **Space**: O(1) - We only use a few pointers regardless of the input size

## Link

[LeetCode 2332 The Latest Time to Catch a Bus](https://leetcode.com/problems/the-latest-time-to-catch-a-bus/)